const std = @import("std");
const constraint = @import("data_gen").constraint;
const contract = @import("data_gen").contract;

// --- WiFi State Machine ---

const WifiState = enum(u8) { disconnected, scanning, connecting, connected, error_state };
const WifiEvent = enum(u8) { scan_request, network_found, auth_success, auth_failure, timeout, disconnect, reset };

const Transition = struct {
    from: WifiState,
    event: WifiEvent,
    to: WifiState,
    timeout_ms: u32,

    pub fn contractValidate(comptime self: Transition) ?[]const u8 {
        if (constraint.inRange(0, 60_000, self.timeout_ms)) |err| return err;

        if (self.from == self.to and self.event != .reset)
            return "self-transitions only allowed on reset events";

        return null;
    }
};

const TransitionTable = struct {
    transitions: []const Transition,

    pub fn contractValidate(comptime self: TransitionTable) ?[]const u8 {
        if (self.transitions.len == 0)
            return "transition table cannot be empty";

        for (self.transitions) |t| {
            if (t.contractValidate()) |err| return err;
        }

        for (0..self.transitions.len) |i| {
            for (i + 1..self.transitions.len) |j| {
                if (self.transitions[i].from == self.transitions[j].from and self.transitions[i].event == self.transitions[j].event)
                    return "duplicate (from, event) pair — transition must be deterministic";
            }
        }

        const all_states = [_]WifiState{ .disconnected, .scanning, .connecting, .connected, .error_state };
        for (all_states) |state| {
            if (state == .disconnected) continue;
            var reachable = false;
            for (self.transitions) |t| {
                if (t.to == state) {
                    reachable = true;
                    break;
                }
            }
            if (!reachable)
                return std.fmt.comptimePrint("state {} is unreachable", .{@intFromEnum(state)});
        }

        return null;
    }
};

const wifi_transitions = blk: {
    const table = [_]Transition{
        .{ .from = .disconnected, .event = .scan_request, .to = .scanning, .timeout_ms = 0 },
        .{ .from = .scanning, .event = .network_found, .to = .connecting, .timeout_ms = 10000 },
        .{ .from = .scanning, .event = .timeout, .to = .disconnected, .timeout_ms = 0 },
        .{ .from = .connecting, .event = .auth_success, .to = .connected, .timeout_ms = 5000 },
        .{ .from = .connecting, .event = .auth_failure, .to = .error_state, .timeout_ms = 0 },
        .{ .from = .connecting, .event = .timeout, .to = .disconnected, .timeout_ms = 0 },
        .{ .from = .connected, .event = .disconnect, .to = .disconnected, .timeout_ms = 0 },
        .{ .from = .error_state, .event = .reset, .to = .disconnected, .timeout_ms = 1000 },
    };
    contract.assertValid(TransitionTable{ .transitions = &table });
    break :blk table;
};

test "wifi transition table is deterministic" {
    comptime {
        try std.testing.expectEqual(8, wifi_transitions.len);
    }
}

test "wifi transition table starts from disconnected" {
    comptime {
        try std.testing.expectEqual(WifiState.disconnected, wifi_transitions[0].from);
    }
}

// --- Motor Control State Machine ---

const MotorState = enum(u8) { idle, starting, running, braking, fault };
const MotorEvent = enum(u8) { start_cmd, running_speed_reached, stop_cmd, overcurrent, fault_cleared };

const MotorTransition = struct {
    from: MotorState,
    event: MotorEvent,
    to: MotorState,
    action_code: u8,

    pub fn contractValidate(comptime self: MotorTransition) ?[]const u8 {
        if (self.from == .fault and self.event != .fault_cleared)
            return "fault state can only transition on fault_cleared";
        return null;
    }
};

const MotorFSM = struct {
    transitions: []const MotorTransition,

    pub fn contractValidate(comptime self: MotorFSM) ?[]const u8 {
        for (0..self.transitions.len) |i| {
            for (i + 1..self.transitions.len) |j| {
                if (self.transitions[i].from == self.transitions[j].from and self.transitions[i].event == self.transitions[j].event)
                    return "non-deterministic motor FSM";
            }
        }

        for (self.transitions) |t| {
            if (t.contractValidate()) |err| return err;
        }

        return null;
    }
};

const motor_fsm = blk: {
    const table = [_]MotorTransition{
        .{ .from = .idle, .event = .start_cmd, .to = .starting, .action_code = 0x01 },
        .{ .from = .starting, .event = .running_speed_reached, .to = .running, .action_code = 0x02 },
        .{ .from = .starting, .event = .overcurrent, .to = .fault, .action_code = 0xF0 },
        .{ .from = .running, .event = .stop_cmd, .to = .braking, .action_code = 0x03 },
        .{ .from = .running, .event = .overcurrent, .to = .fault, .action_code = 0xF0 },
        .{ .from = .braking, .event = .running_speed_reached, .to = .idle, .action_code = 0x04 },
        .{ .from = .braking, .event = .overcurrent, .to = .fault, .action_code = 0xF0 },
        .{ .from = .fault, .event = .fault_cleared, .to = .idle, .action_code = 0xFF },
    };
    contract.assertValid(MotorFSM{ .transitions = &table });
    break :blk table;
};

test "motor FSM has 8 transitions" {
    comptime {
        try std.testing.expectEqual(8, motor_fsm.len);
    }
}

test "motor FSM fault state only transitions on fault_cleared" {
    comptime {
        for (motor_fsm) |t| {
            if (t.from == .fault) {
                try std.testing.expectEqual(MotorEvent.fault_cleared, t.event);
            }
        }
    }
}

// --- State Machine with Timed Phases ---

const PhaseState = enum(u8) { init, warmup, active, cooldown, shutdown };

const PhaseTiming = struct {
    state: PhaseState,
    min_duration_ms: u32,
    max_duration_ms: u32,
    next_state: PhaseState,

    pub fn contractValidate(comptime self: PhaseTiming) ?[]const u8 {
        if (self.min_duration_ms >= self.max_duration_ms) return "min_duration_ms must be less than max_duration_ms";
        if (self.state == self.next_state)
            return "phase must transition to a different state";
        return null;
    }
};

const PhaseSequence = struct {
    phases: []const PhaseTiming,

    pub fn contractValidate(comptime self: PhaseSequence) ?[]const u8 {
        if (self.phases[0].state != .init)
            return "must start with init phase";

        if (self.phases[self.phases.len - 1].next_state != .shutdown)
            return "must end transitioning to shutdown";

        for (self.phases) |p| {
            if (p.contractValidate()) |err| return err;
        }

        for (1..self.phases.len) |i| {
            if (self.phases[i].state != self.phases[i - 1].next_state)
                return "phase chain is broken — next_state doesn't match next phase's state";
        }

        return null;
    }
};

const operation_phases = blk: {
    const phases = [_]PhaseTiming{
        .{ .state = .init, .min_duration_ms = 100, .max_duration_ms = 500, .next_state = .warmup },
        .{ .state = .warmup, .min_duration_ms = 1000, .max_duration_ms = 5000, .next_state = .active },
        .{ .state = .active, .min_duration_ms = 5000, .max_duration_ms = 60000, .next_state = .cooldown },
        .{ .state = .cooldown, .min_duration_ms = 2000, .max_duration_ms = 10000, .next_state = .shutdown },
    };
    contract.assertValid(PhaseSequence{ .phases = &phases });
    break :blk phases;
};

test "operation phases form a valid chain" {
    comptime {
        try std.testing.expectEqual(4, operation_phases.len);
        try std.testing.expectEqual(PhaseState.init, operation_phases[0].state);
        try std.testing.expectEqual(PhaseState.shutdown, operation_phases[operation_phases.len - 1].next_state);

        for (1..operation_phases.len) |i| {
            try std.testing.expectEqual(operation_phases[i].state, operation_phases[i - 1].next_state);
        }
    }
}
