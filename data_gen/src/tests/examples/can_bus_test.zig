const std = @import("std");
const constraints = @import("data_gen").constraints;
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

    pub fn validate(comptime self: CanBitTiming) void {
        constraints.inRange(1, 1024, self.prescaler);
        constraints.inRange(1, 8, self.prop_seg);
        constraints.inRange(1, 8, self.phase_seg1);
        constraints.inRange(1, 8, self.phase_seg2);
        constraints.inRange(1, 4, self.sjw);

        if (self.sjw > self.phase_seg1 or self.sjw > self.phase_seg2)
            @compileError("SJW must not exceed the smaller of phase_seg1 and phase_seg2");

        if (self.phase_seg2 < self.sjw)
            @compileError("phase_seg2 must be >= SJW for proper resynchronization");
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

    pub fn validate(comptime self: CanNodeConfig) void {
        self.timing.validate();
        constraints.nonZero(self.clock_hz);

        const baud = self.timing.baudRate(self.clock_hz);
        constraints.oneOf(&.{ 125_000, 250_000, 500_000, 1_000_000 }, baud);

        const sp = self.timing.samplePointPct();
        constraints.inRange(75, 90, sp);

        if (self.silent_mode and self.loopback)
            @compileError("silent mode and loopback are mutually exclusive");
    }
};

fn validateCanNetwork(comptime nodes: []const CanNodeConfig) void {
    constraints.lenInRange(2, 16, nodes.len);

    var ids: [nodes.len]u8 = undefined;
    for (nodes, 0..) |node, i| {
        node.validate();
        ids[i] = node.node_id;
    }
    constraints.noDuplicates(u8, &ids);

    // All nodes must operate at the same baud rate
    const reference_baud = nodes[0].timing.baudRate(nodes[0].clock_hz);
    for (nodes[1..]) |node| {
        const baud = node.timing.baudRate(node.clock_hz);
        if (baud != reference_baud)
            @compileError(std.fmt.comptimePrint(
                "node {} baud rate {} doesn't match network baud rate {}",
                .{ node.node_id, baud, reference_baud },
            ));
    }
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
    validateCanNetwork(&nodes);
    break :blk nodes;
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
};

fn validateCanFilters(comptime filters: []const CanFilter) void {
    @setEvalBranchQuota(5000);
    constraints.lenInRange(1, 28, filters.len);

    var fids: [filters.len]u8 = undefined;
    for (filters, 0..) |f, i| {
        fids[i] = f.filter_id;
        if (!f.is_extended) {
            if (f.can_id > 0x7FF)
                @compileError("standard CAN ID must be <= 0x7FF");
            if (f.mask > 0x7FF)
                @compileError("standard CAN mask must be <= 0x7FF");
        }
    }
    constraints.noDuplicates(u8, &fids);

    // Check for fully redundant filters (one filter's acceptance set is a subset of another's)
    for (0..filters.len) |i| {
        for (i + 1..filters.len) |j| {
            if (filters[i].is_extended != filters[j].is_extended) continue;
            const a_id = filters[i].can_id;
            const a_mask = filters[i].mask;
            const b_id = filters[j].can_id;
            const b_mask = filters[j].mask;

            // If B's mask is a superset of A's mask and they match on B's bits,
            // then B is redundant (A already catches everything B would)
            if ((a_mask & b_mask) == b_mask and (a_id & b_mask) == (b_id & b_mask))
                @compileError(std.fmt.comptimePrint(
                    "filter {} is redundant with filter {} (superset acceptance)",
                    .{ filters[j].filter_id, filters[i].filter_id },
                ));
            if ((b_mask & a_mask) == a_mask and (b_id & a_mask) == (a_id & a_mask))
                @compileError(std.fmt.comptimePrint(
                    "filter {} is redundant with filter {} (superset acceptance)",
                    .{ filters[i].filter_id, filters[j].filter_id },
                ));
        }
    }
}

const can_filters = blk: {
    const filters = [_]CanFilter{
        .{ .filter_id = 0, .can_id = 0x100, .mask = 0x7F0, .is_extended = false, .fifo = 0 },
        .{ .filter_id = 1, .can_id = 0x200, .mask = 0x7F0, .is_extended = false, .fifo = 0 },
        .{ .filter_id = 2, .can_id = 0x300, .mask = 0x7FF, .is_extended = false, .fifo = 1 },
        .{ .filter_id = 3, .can_id = 0x400, .mask = 0x700, .is_extended = false, .fifo = 1 },
    };
    validateCanFilters(&filters);
    break :blk filters;
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
