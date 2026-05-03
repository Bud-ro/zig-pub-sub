const std = @import("std");
const contracts = @import("data_gen").contracts;

// --- CAN Bus Bit Timing ---
// CAN bit timing is computed from clock prescaler, propagation segment,
// phase segment 1, and phase segment 2. These must satisfy:
//   bit_time = (1 + prop_seg + phase_seg1 + phase_seg2) time quanta
//   baud_rate = clock_hz / (prescaler * bit_time)
//   sample_point% = (1 + prop_seg + phase_seg1) / bit_time * 100
//   SJW <= min(phase_seg1, phase_seg2)

const CanBitTiming = struct {
    prescaler: u16,
    prop_seg: u8,
    phase_seg1: u8,
    phase_seg2: u8,
    sjw: u8,

    pub fn validate(comptime self: CanBitTiming) ?[]const u8 {
        if (self.prescaler < 1 or self.prescaler > 1024) return "prescaler out of range [1, 1024]";
        if (self.prop_seg < 1 or self.prop_seg > 8) return "prop_seg out of range [1, 8]";
        if (self.phase_seg1 < 1 or self.phase_seg1 > 8) return "phase_seg1 out of range [1, 8]";
        if (self.phase_seg2 < 1 or self.phase_seg2 > 8) return "phase_seg2 out of range [1, 8]";
        if (self.sjw < 1 or self.sjw > 4) return "sjw out of range [1, 4]";

        if (self.sjw > self.phase_seg1 or self.sjw > self.phase_seg2)
            return "SJW must not exceed the smaller of phase_seg1 and phase_seg2";

        if (self.phase_seg2 < self.sjw)
            return "phase_seg2 must be >= SJW for proper resynchronization";
        return null;
    }

    pub fn bitTime(comptime self: CanBitTiming) u16 {
        return 1 + @as(u16, self.prop_seg) + self.phase_seg1 + self.phase_seg2;
    }

    pub fn baudRate(comptime self: CanBitTiming, comptime clock_hz: u32) u32 {
        return clock_hz / (@as(u32, self.prescaler) * self.bitTime());
    }

    pub fn samplePointPct(comptime self: CanBitTiming) u8 {
        const before_sample = 1 + @as(u16, self.prop_seg) + self.phase_seg1;
        return @intCast(before_sample * 100 / self.bitTime());
    }
};

const CanNodeConfig = struct {
    node_id: u8,
    timing: CanBitTiming,
    clock_hz: u32,
    silent_mode: bool,
    loopback: bool,

    pub fn validate(comptime self: CanNodeConfig) ?[]const u8 {
        if (self.clock_hz == 0) return "clock_hz must not be zero";

        const baud = self.timing.baudRate(self.clock_hz);
        if (baud != 125_000 and baud != 250_000 and baud != 500_000 and baud != 1_000_000)
            return "baud rate must be one of 125000, 250000, 500000, 1000000";

        const sp = self.timing.samplePointPct();
        if (sp < 75 or sp > 90) return "sample point out of range [75, 90]";

        if (self.silent_mode and self.loopback)
            return "silent mode and loopback are mutually exclusive";
        return null;
    }
};

fn CanNetwork(comptime N: usize) type {
    return struct {
        nodes: [N]CanNodeConfig,

        pub fn validate(comptime self: @This()) ?[]const u8 {
            if (N < 2 or N > 16)
                return std.fmt.comptimePrint("length {} is outside [2, 16]", .{N});

            var ids: [N]u8 = undefined;
            for (self.nodes, 0..) |node, i| {
                if (contracts.check(node, std.fmt.comptimePrint(".nodes[{}]", .{i}))) |err| return err;
                ids[i] = node.node_id;
            }

            // Check for duplicate node IDs
            for (0..N) |i| {
                for (i + 1..N) |j| {
                    if (ids[i] == ids[j]) {
                        return std.fmt.comptimePrint("duplicate value at indices {} and {}", .{ i, j });
                    }
                }
            }

            // All nodes must operate at the same baud rate
            const reference_baud = self.nodes[0].timing.baudRate(self.nodes[0].clock_hz);
            for (self.nodes[1..]) |node| {
                const baud = node.timing.baudRate(node.clock_hz);
                if (baud != reference_baud)
                    return std.fmt.comptimePrint(
                        "node {} baud rate {} doesn't match network baud rate {}",
                        .{ node.node_id, baud, reference_baud },
                    );
            }

            return null;
        }
    };
}

const can_network = blk: {
    // Two nodes with different clocks but same baud rate
    const nodes = [_]CanNodeConfig{
        .{
            .node_id = 1,
            .clock_hz = 48_000_000,
            .silent_mode = false,
            .loopback = false,
            .timing = .{
                .prescaler = 6,
                .prop_seg = 5,
                .phase_seg1 = 6,
                .phase_seg2 = 4,
                .sjw = 4,
            },
        },
        .{
            .node_id = 2,
            .clock_hz = 80_000_000,
            .silent_mode = false,
            .loopback = false,
            .timing = .{
                .prescaler = 10,
                .prop_seg = 5,
                .phase_seg1 = 6,
                .phase_seg2 = 4,
                .sjw = 4,
            },
        },
        .{
            .node_id = 3,
            .clock_hz = 16_000_000,
            .silent_mode = false,
            .loopback = false,
            .timing = .{
                .prescaler = 2,
                .prop_seg = 5,
                .phase_seg1 = 6,
                .phase_seg2 = 4,
                .sjw = 4,
            },
        },
    };
    break :blk (contracts.validated(CanNetwork(3){ .nodes = nodes })).nodes;
};

test "CAN network all nodes at 500kbps" {
    comptime {
        for (can_network) |node| {
            try std.testing.expectEqual(500_000, node.timing.baudRate(node.clock_hz));
        }
    }
}

test "CAN network sample points in valid range" {
    comptime {
        for (can_network) |node| {
            const sp = node.timing.samplePointPct();
            try std.testing.expect(sp >= 75 and sp <= 90);
        }
    }
}

test "CAN network has 3 nodes with unique IDs" {
    comptime {
        try std.testing.expectEqual(3, can_network.len);
    }
}

// --- CAN Message Filter Configuration ---
// Hardware acceptance filters with ID + mask pairs.
// Filters must not have redundant overlaps.

const CanFilter = struct {
    filter_id: u8,
    can_id: u16,
    mask: u16,
    is_extended: bool,
    fifo: u1,

    pub fn validate(comptime self: CanFilter) ?[]const u8 {
        if (!self.is_extended) {
            if (self.can_id > 0x7FF)
                return "standard CAN ID must be <= 0x7FF";
            if (self.mask > 0x7FF)
                return "standard CAN mask must be <= 0x7FF";
        }
        return null;
    }
};

fn CanFilterBank(comptime N: usize) type {
    return struct {
        filters: [N]CanFilter,

        pub fn validate(comptime self: @This()) ?[]const u8 {
            @setEvalBranchQuota(5000);

            if (N < 1 or N > 28)
                return std.fmt.comptimePrint("length {} is outside [1, 28]", .{N});

            var fids: [N]u8 = undefined;
            for (self.filters, 0..) |f, i| {
                if (contracts.check(f, std.fmt.comptimePrint(".filters[{}]", .{i}))) |err| return err;
                fids[i] = f.filter_id;
            }

            // Check for duplicate filter IDs
            for (0..N) |i| {
                for (i + 1..N) |j| {
                    if (fids[i] == fids[j]) {
                        return std.fmt.comptimePrint("duplicate value at indices {} and {}", .{ i, j });
                    }
                }
            }

            // Check for fully redundant filters (one filter's acceptance set is a subset of another's)
            for (0..N) |i| {
                for (i + 1..N) |j| {
                    if (self.filters[i].is_extended != self.filters[j].is_extended) continue;
                    const a_id = self.filters[i].can_id;
                    const a_mask = self.filters[i].mask;
                    const b_id = self.filters[j].can_id;
                    const b_mask = self.filters[j].mask;

                    // If B's mask is a superset of A's mask and they match on B's bits,
                    // then B is redundant (A already catches everything B would)
                    if ((a_mask & b_mask) == b_mask and (a_id & b_mask) == (b_id & b_mask))
                        return std.fmt.comptimePrint(
                            "filter {} is redundant with filter {} (superset acceptance)",
                            .{ self.filters[j].filter_id, self.filters[i].filter_id },
                        );
                    if ((b_mask & a_mask) == a_mask and (b_id & a_mask) == (a_id & a_mask))
                        return std.fmt.comptimePrint(
                            "filter {} is redundant with filter {} (superset acceptance)",
                            .{ self.filters[i].filter_id, self.filters[j].filter_id },
                        );
                }
            }

            return null;
        }
    };
}

const can_filters = blk: {
    const filters = [_]CanFilter{
        .{ .filter_id = 0, .can_id = 0x100, .mask = 0x7F0, .is_extended = false, .fifo = 0 },
        .{ .filter_id = 1, .can_id = 0x200, .mask = 0x7F0, .is_extended = false, .fifo = 0 },
        .{ .filter_id = 2, .can_id = 0x300, .mask = 0x7FF, .is_extended = false, .fifo = 1 },
        .{ .filter_id = 3, .can_id = 0x400, .mask = 0x700, .is_extended = false, .fifo = 1 },
    };
    break :blk (contracts.validated(CanFilterBank(4){ .filters = filters })).filters;
};

test "CAN filters have no redundant entries" {
    comptime {
        try std.testing.expectEqual(4, can_filters.len);
    }
}

test "CAN filters standard IDs are within range" {
    comptime {
        for (can_filters) |f| {
            if (!f.is_extended) {
                try std.testing.expect(f.can_id <= 0x7FF);
                try std.testing.expect(f.mask <= 0x7FF);
            }
        }
    }
}
