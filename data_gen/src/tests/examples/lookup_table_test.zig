const std = @import("std");
const constraints = @import("data_gen").constraints;
const generators = @import("data_gen").generators;

// --- Generated 256-entry u8 → u8 Lookup Table ---

const gamma_table = blk: {
    const gen = struct {
        fn f(comptime i: usize) u8 {
            const normalized = @as(u32, @intCast(i));
            return @intCast((normalized * normalized) / 255);
        }
    }.f;
    const table = generators.generateArray(u8, 256, gen);

    if (table[0] != 0)
        @compileError("gamma table must start at 0");
    if (table[255] != 255)
        @compileError("gamma table must end at 255");

    break :blk table;
};

test "gamma table has 256 entries" {
    comptime {
        try std.testing.expectEqual(256, gamma_table.len);
        try std.testing.expectEqual(0, gamma_table[0]);
        try std.testing.expectEqual(255, gamma_table[255]);
    }
}

test "gamma table is monotonically non-decreasing" {
    comptime {
        for (1..gamma_table.len) |i| {
            try std.testing.expect(gamma_table[i] >= gamma_table[i - 1]);
        }
    }
}

// --- Enum-to-Value Mapping ---

const Priority = enum(u8) { critical, high, normal, low, background };

const PriorityConfig = struct {
    priority: Priority,
    weight: u16,
    max_queue_depth: u8,
};

fn validatePriorityMap(comptime map: []const PriorityConfig) void {
    const all_priorities = [_]Priority{ .critical, .high, .normal, .low, .background };

    if (map.len != all_priorities.len)
        @compileError("priority map must have exactly one entry per priority");

    for (all_priorities) |expected| {
        var found = false;
        for (map) |entry| {
            if (entry.priority == expected) {
                found = true;
                break;
            }
        }
        if (!found)
            @compileError("missing entry for a priority level");
    }

    for (0..map.len) |i| {
        for (i + 1..map.len) |j| {
            if (map[i].priority == map[j].priority)
                @compileError("duplicate priority entry");
        }
    }

    for (map) |entry| {
        constraints.nonZero(u16, entry.weight);
        constraints.nonZero(u8, entry.max_queue_depth);
    }
}

const priority_config = blk: {
    const map = [_]PriorityConfig{
        .{ .priority = .critical, .weight = 1000, .max_queue_depth = 4 },
        .{ .priority = .high, .weight = 500, .max_queue_depth = 8 },
        .{ .priority = .normal, .weight = 100, .max_queue_depth = 16 },
        .{ .priority = .low, .weight = 25, .max_queue_depth = 32 },
        .{ .priority = .background, .weight = 5, .max_queue_depth = 64 },
    };
    validatePriorityMap(&map);
    break :blk map;
};

test "priority map covers all priorities" {
    comptime {
        try std.testing.expectEqual(5, priority_config.len);
    }
}

test "priority weights are descending" {
    comptime {
        try std.testing.expect(priority_config[0].weight > priority_config[1].weight);
        try std.testing.expect(priority_config[1].weight > priority_config[2].weight);
        try std.testing.expect(priority_config[2].weight > priority_config[3].weight);
        try std.testing.expect(priority_config[3].weight > priority_config[4].weight);
    }
}

// --- Interpolation Table ---

const InterpPoint = struct {
    x: i32,
    y: i32,
};

fn validateInterpTable(comptime table: []const InterpPoint) void {
    constraints.lenInRange(3, 128, table.len);

    var xs: [table.len]i32 = undefined;
    for (table, 0..) |pt, i| {
        xs[i] = pt.x;
        constraints.inRange(i32, -10000, 10000, pt.y);
    }
    constraints.isSorted(i32, &xs);
    constraints.noDuplicates(i32, &xs);
}

const pressure_curve = blk: {
    const table = [_]InterpPoint{
        .{ .x = 0, .y = 0 },
        .{ .x = 100, .y = 150 },
        .{ .x = 200, .y = 380 },
        .{ .x = 300, .y = 700 },
        .{ .x = 400, .y = 1100 },
        .{ .x = 500, .y = 1600 },
        .{ .x = 600, .y = 2200 },
        .{ .x = 700, .y = 2900 },
        .{ .x = 800, .y = 3700 },
        .{ .x = 900, .y = 4600 },
        .{ .x = 1000, .y = 5600 },
    };
    validateInterpTable(&table);
    break :blk table;
};

test "pressure curve is sorted with unique x values" {
    comptime {
        try std.testing.expectEqual(11, pressure_curve.len);
        for (1..pressure_curve.len) |i| {
            try std.testing.expect(pressure_curve[i].x > pressure_curve[i - 1].x);
        }
    }
}

// --- Generated Lookup Table Using lookupTable ---

const dac_lut = generators.lookupTable(u16, u16, 0, 100, 10, struct {
    fn f(comptime x: u16) u16 {
        return x * 40 + 100;
    }
}.f);

test "DAC lookup table generated correctly" {
    comptime {
        try std.testing.expectEqual(11, dac_lut.len);
        try std.testing.expectEqual(0, dac_lut[0].input);
        try std.testing.expectEqual(100, dac_lut[0].output);
        try std.testing.expectEqual(100, dac_lut[10].input);
        try std.testing.expectEqual(4100, dac_lut[10].output);
    }
}

// --- Multi-segment Piecewise Mapping ---

const Segment = struct {
    start_x: i16,
    end_x: i16,
    start_y: i16,
    end_y: i16,
};

fn validatePiecewise(comptime segments: []const Segment) void {
    if (segments.len == 0)
        @compileError("piecewise map needs at least one segment");

    for (segments) |seg| {
        constraints.lessThan(i16, seg.start_x, seg.end_x);
    }

    for (1..segments.len) |i| {
        if (segments[i].start_x != segments[i - 1].end_x)
            @compileError("segments must be contiguous (start_x must equal previous end_x)");
        if (segments[i].start_y != segments[i - 1].end_y)
            @compileError("segments must be continuous (start_y must equal previous end_y)");
    }
}

const motor_torque_map = blk: {
    const segs = [_]Segment{
        .{ .start_x = 0, .end_x = 500, .start_y = 0, .end_y = 100 },
        .{ .start_x = 500, .end_x = 2000, .start_y = 100, .end_y = 100 },
        .{ .start_x = 2000, .end_x = 5000, .start_y = 100, .end_y = 30 },
    };
    validatePiecewise(&segs);
    break :blk segs;
};

test "motor torque map is contiguous and continuous" {
    comptime {
        try std.testing.expectEqual(3, motor_torque_map.len);
        try std.testing.expectEqual(0, motor_torque_map[0].start_x);
        try std.testing.expectEqual(5000, motor_torque_map[2].end_x);
    }
}
