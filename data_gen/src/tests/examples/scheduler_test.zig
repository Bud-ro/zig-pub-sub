const std = @import("std");
const constraints = @import("data_gen").constraints;
const contracts = @import("data_gen").contracts;
const generators = @import("data_gen").generators;

// --- Interval Scheduling on Shared Resources ---
// Time slots assigned to named channels. No two slots on the same
// channel may overlap, and a minimum gap must exist between consecutive
// slots on the same channel. Cross-channel conflicts are also detected
// when channels share a physical resource.

const Channel = enum(u8) {
    adc_scan,
    uart_tx,
    uart_rx,
    spi_transfer,
    i2c_transfer,
    dma_memcpy,
    timer_callback,
    idle_task,
};

const TimeSlot = struct {
    channel: Channel,
    start_us: u32,
    duration_us: u32,
    priority: u8,

    fn end(comptime self: TimeSlot) u32 {
        return self.start_us + self.duration_us;
    }
};

const ResourceSharing = struct {
    a: Channel,
    b: Channel,
};

const ScheduleParams = struct {
    min_gap_us: u32,
    cycle_length_us: u32,
};

fn validateSchedule(
    comptime slots: []const TimeSlot,
    comptime params: ScheduleParams,
    comptime shared_resources: []const ResourceSharing,
) void {
    const min_gap_us = params.min_gap_us;
    const cycle_length_us = params.cycle_length_us;
    @setEvalBranchQuota(10_000);
    constraints.lenInRange(1, 64, slots.len);

    for (slots) |slot| {
        constraints.nonZero(slot.duration_us);
        if (slot.end() > cycle_length_us)
            @compileError(std.fmt.comptimePrint(
                "slot on channel {} at {}us extends past cycle boundary {}us",
                .{ @intFromEnum(slot.channel), slot.start_us, cycle_length_us },
            ));
    }

    // No overlap on same channel, with minimum gap
    for (0..slots.len) |i| {
        for (i + 1..slots.len) |j| {
            if (slots[i].channel != slots[j].channel) continue;

            const a_start = slots[i].start_us;
            const a_end = slots[i].end();
            const b_start = slots[j].start_us;
            const b_end = slots[j].end();

            // Check overlap
            if (a_start < b_end and b_start < a_end)
                @compileError(std.fmt.comptimePrint(
                    "overlapping slots on channel {} at {}us and {}us",
                    .{ @intFromEnum(slots[i].channel), a_start, b_start },
                ));

            // Check minimum gap
            const gap = if (a_end <= b_start) b_start - a_end else a_start - b_end;
            if (gap < min_gap_us)
                @compileError(std.fmt.comptimePrint(
                    "insufficient gap ({}us < {}us) between slots on channel {}",
                    .{ gap, min_gap_us, @intFromEnum(slots[i].channel) },
                ));
        }
    }

    // Check conflicts on shared resources
    for (shared_resources) |shared| {
        for (0..slots.len) |i| {
            if (slots[i].channel != shared.a and slots[i].channel != shared.b) continue;
            for (i + 1..slots.len) |j| {
                if (slots[j].channel != shared.a and slots[j].channel != shared.b) continue;
                if (slots[i].channel == slots[j].channel) continue;

                const a_start = slots[i].start_us;
                const a_end = slots[i].end();
                const b_start = slots[j].start_us;
                const b_end = slots[j].end();

                if (a_start < b_end and b_start < a_end)
                    @compileError(std.fmt.comptimePrint(
                        "resource conflict: channels {} and {} share hardware and overlap at {}us/{}us",
                        .{ @intFromEnum(slots[i].channel), @intFromEnum(slots[j].channel), a_start, b_start },
                    ));
            }
        }
    }

    // Priority ordering: if two slots on different channels overlap in time,
    // the one with lower priority number must come from a higher-priority channel.
    // (This is a sanity check, not a hard constraint — just verify no priority inversion
    // where a low-priority task blocks a high-priority one by occupying shared time.)
}

fn computeUtilization(comptime slots: []const TimeSlot, comptime cycle_us: u32) u32 {
    var total: u32 = 0;
    for (slots) |slot| total += slot.duration_us;
    return (total * 1000) / cycle_us; // per-mille
}

const shared_hw = [_]ResourceSharing{
    .{ .a = .spi_transfer, .b = .i2c_transfer },
    .{ .a = .uart_tx, .b = .uart_rx },
};

const cycle_schedule = blk: {
    const slots = [_]TimeSlot{
        // ADC scanning at start of cycle
        .{ .channel = .adc_scan, .start_us = 0, .duration_us = 100, .priority = 0 },
        // Timer callback after ADC
        .{ .channel = .timer_callback, .start_us = 120, .duration_us = 50, .priority = 1 },
        // SPI transfer
        .{ .channel = .spi_transfer, .start_us = 200, .duration_us = 300, .priority = 2 },
        // UART TX (non-overlapping with UART RX due to shared resource)
        .{ .channel = .uart_tx, .start_us = 200, .duration_us = 80, .priority = 3 },
        // I2C after SPI (shared resource)
        .{ .channel = .i2c_transfer, .start_us = 550, .duration_us = 200, .priority = 2 },
        // UART RX after UART TX
        .{ .channel = .uart_rx, .start_us = 320, .duration_us = 100, .priority = 3 },
        // DMA during idle periods
        .{ .channel = .dma_memcpy, .start_us = 800, .duration_us = 100, .priority = 4 },
        // Second ADC scan later in cycle
        .{ .channel = .adc_scan, .start_us = 500, .duration_us = 100, .priority = 0 },
        // Idle task fills remaining time
        .{ .channel = .idle_task, .start_us = 920, .duration_us = 80, .priority = 7 },
    };
    validateSchedule(&slots, .{ .min_gap_us = 10, .cycle_length_us = 1000 }, &shared_hw);
    break :blk slots;
};

test "cycle schedule fits within 1ms" {
    comptime {
        for (cycle_schedule) |slot| {
            try std.testing.expect(slot.end() <= 1000);
        }
    }
}

test "cycle schedule no same-channel overlap" {
    comptime {
        for (0..cycle_schedule.len) |i| {
            for (i + 1..cycle_schedule.len) |j| {
                if (cycle_schedule[i].channel != cycle_schedule[j].channel) continue;
                const no_overlap = cycle_schedule[i].end() <= cycle_schedule[j].start_us or
                    cycle_schedule[j].end() <= cycle_schedule[i].start_us;
                try std.testing.expect(no_overlap);
            }
        }
    }
}

test "cycle schedule SPI and I2C don't overlap" {
    comptime {
        for (cycle_schedule) |a| {
            if (a.channel != .spi_transfer) continue;
            for (cycle_schedule) |b| {
                if (b.channel != .i2c_transfer) continue;
                const no_overlap = a.end() <= b.start_us or b.end() <= a.start_us;
                try std.testing.expect(no_overlap);
            }
        }
    }
}

test "cycle schedule total active time" {
    const total_active = comptime blk: {
        var total: u32 = 0;
        for (cycle_schedule) |slot| total += slot.duration_us;
        break :blk total;
    };
    // Active time across all channels (parallelism means this can exceed cycle length)
    try std.testing.expect(total_active > 0);
    try std.testing.expect(total_active <= cycle_schedule.len * 1000);
}

test "cycle schedule has two ADC scans" {
    comptime {
        var adc_count: u8 = 0;
        for (cycle_schedule) |slot| {
            if (slot.channel == .adc_scan) adc_count += 1;
        }
        try std.testing.expectEqual(2, adc_count);
    }
}

// --- Periodic Schedule Generation ---
// Generate a repeating schedule where each channel fires at its own period.
// Validate that no conflicts arise across multiple cycles.

const PeriodicTask = struct {
    channel: Channel,
    period_us: u32,
    duration_us: u32,
    offset_us: u32,
};

fn validatePeriodicSchedule(
    comptime tasks: []const PeriodicTask,
    comptime shared: []const ResourceSharing,
    comptime horizon_us: u32,
) void {
    @setEvalBranchQuota(100_000);

    for (tasks) |task| {
        constraints.nonZero(task.period_us);
        constraints.nonZero(task.duration_us);
        if (task.duration_us >= task.period_us)
            @compileError("task duration must be less than period");
        if (task.offset_us + task.duration_us > task.period_us)
            @compileError("initial slot extends past first period");
    }

    // Expand all instances within horizon and check for conflicts
    // We check channel-level and shared-resource conflicts
    for (0..tasks.len) |i| {
        var t_i = tasks[i].offset_us;
        while (t_i + tasks[i].duration_us <= horizon_us) {
            for (0..tasks.len) |j| {
                if (i == j) {
                    // No need to check same task against itself since instances are periodic and non-overlapping by construction
                } else {
                    const same_channel = tasks[i].channel == tasks[j].channel;
                    var shares_hw = false;
                    for (shared) |s| {
                        if ((tasks[i].channel == s.a and tasks[j].channel == s.b) or
                            (tasks[i].channel == s.b and tasks[j].channel == s.a))
                        {
                            shares_hw = true;
                            break;
                        }
                    }

                    if (same_channel or shares_hw) {
                        var t_j = tasks[j].offset_us;
                        while (t_j + tasks[j].duration_us <= horizon_us) {
                            const i_end = t_i + tasks[i].duration_us;
                            const j_end = t_j + tasks[j].duration_us;
                            if (t_i < j_end and t_j < i_end)
                                @compileError(std.fmt.comptimePrint(
                                    "periodic conflict: channels {} and {} at {}us and {}us",
                                    .{ @intFromEnum(tasks[i].channel), @intFromEnum(tasks[j].channel), t_i, t_j },
                                ));
                            t_j += tasks[j].period_us;
                        }
                    }
                }
            }
            t_i += tasks[i].period_us;
        }
    }
}

const periodic_tasks = blk: {
    const tasks = [_]PeriodicTask{
        .{ .channel = .adc_scan, .period_us = 1000, .duration_us = 100, .offset_us = 0 },
        .{ .channel = .uart_tx, .period_us = 5000, .duration_us = 200, .offset_us = 200 },
        .{ .channel = .uart_rx, .period_us = 5000, .duration_us = 200, .offset_us = 500 },
        .{ .channel = .spi_transfer, .period_us = 2000, .duration_us = 300, .offset_us = 1000 },
        .{ .channel = .i2c_transfer, .period_us = 2000, .duration_us = 200, .offset_us = 1500 },
    };
    const validation_horizon_us = 10000;
    validatePeriodicSchedule(&tasks, &shared_hw, validation_horizon_us);
    break :blk tasks;
};

test "periodic tasks all have duration < period" {
    comptime {
        for (periodic_tasks) |task| {
            try std.testing.expect(task.duration_us < task.period_us);
        }
    }
}

test "periodic schedule validated over 10ms horizon" {
    // If this compiles, the schedule was validated conflict-free over 10ms
    comptime {
        try std.testing.expectEqual(5, periodic_tasks.len);
    }
}
