const std = @import("std");
const constraints = @import("data_gen").constraints;
const contracts = @import("data_gen").contracts;
const generators = @import("data_gen").generators;

// --- 128-entry Calibration Table ---

const CalEntry = struct {
    raw: u16,
    calibrated: u16,
};

const large_cal_table = blk: {
    const gen = struct {
        fn f(comptime i: usize) CalEntry {
            const raw: u16 = @intCast(i * 32);
            const offset: u16 = @intCast(i / 8);
            return .{ .raw = raw, .calibrated = raw + offset };
        }
    }.f;
    const table = generators.generateArray(CalEntry, 128, gen);

    for (table) |entry| {
        constraints.inRange(u16, 0, 65535, entry.raw);
        constraints.inRange(u16, 0, 65535, entry.calibrated);
    }

    for (1..table.len) |i| {
        if (table[i].raw <= table[i - 1].raw)
            @compileError("raw values must be strictly increasing");
    }

    break :blk table;
};

test "128-entry cal table dimensions" {
    comptime {
        try std.testing.expectEqual(128, large_cal_table.len);
    }
}

test "128-entry cal table is monotonic" {
    comptime {
        for (1..large_cal_table.len) |i| {
            try std.testing.expect(large_cal_table[i].raw > large_cal_table[i - 1].raw);
        }
    }
}

test "128-entry cal table first and last" {
    comptime {
        try std.testing.expectEqual(0, large_cal_table[0].raw);
        try std.testing.expectEqual(0, large_cal_table[0].calibrated);
        try std.testing.expectEqual(4064, large_cal_table[127].raw);
    }
}

// --- 64 Identical Timer Configs ---

const TimerEntry = struct {
    period_ms: u16,
    is_periodic: bool,
    callback_id: u8,
};

const timer_defaults = [_]TimerEntry{.{
    .period_ms = 100,
    .is_periodic = true,
    .callback_id = 0,
}} ** 64;

test "64 repeated timer configs are identical" {
    comptime {
        try std.testing.expectEqual(64, timer_defaults.len);
        for (timer_defaults) |entry| {
            try std.testing.expectEqual(100, entry.period_ms);
            try std.testing.expectEqual(true, entry.is_periodic);
            try std.testing.expectEqual(0, entry.callback_id);
        }
    }
}

// --- 256-entry Lookup Table ---

const sin_approx_table = blk: {
    @setEvalBranchQuota(10_000);
    const gen = struct {
        fn f(comptime i: usize) i16 {
            const quarter = 64;
            const phase = i % (quarter * 4);
            if (phase < quarter) {
                return @intCast(phase * 512 / quarter);
            } else if (phase < quarter * 2) {
                return @intCast((quarter * 2 - phase) * 512 / quarter);
            } else if (phase < quarter * 3) {
                return -@as(i16, @intCast((phase - quarter * 2) * 512 / quarter));
            } else {
                return -@as(i16, @intCast((quarter * 4 - phase) * 512 / quarter));
            }
        }
    }.f;
    const table = generators.generateArray(i16, 256, gen);

    for (table) |v| {
        constraints.inRange(i16, -512, 512, v);
    }

    if (table[0] != 0)
        @compileError("sine table must start at zero");

    break :blk table;
};

test "256-entry sine table dimensions" {
    comptime {
        try std.testing.expectEqual(256, sin_approx_table.len);
    }
}

test "256-entry sine table starts at zero" {
    comptime {
        try std.testing.expectEqual(0, sin_approx_table[0]);
    }
}

test "256-entry sine table values in range" {
    comptime {
        for (sin_approx_table) |v| {
            try std.testing.expect(v >= -512 and v <= 512);
        }
    }
}

// --- 100 Sensor Configs via Unfold ---

const SensorConfig = struct {
    channel: u8,
    sample_rate_hz: u16,
    gain: u8,
};

const sensor_array = blk: {
    @setEvalBranchQuota(20_000);
    const gen = struct {
        fn f(comptime i: usize) SensorConfig {
            var rate: u16 = 1000;
            var gain: u8 = 1;
            for (0..i) |_| {
                rate = if (rate < 5000) rate + 50 else 1000;
                gain = (gain % 8) + 1;
            }
            return .{
                .channel = @intCast(i),
                .sample_rate_hz = rate,
                .gain = gain,
            };
        }
    }.f;
    const arr = generators.generateArray(SensorConfig, 100, gen);

    for (arr) |cfg| {
        constraints.inRange(u16, 1000, 5050, cfg.sample_rate_hz);
        constraints.inRange(u8, 1, 8, cfg.gain);
    }

    break :blk arr;
};

test "100 sensor configs generated with stateful logic" {
    comptime {
        try std.testing.expectEqual(100, sensor_array.len);
        try std.testing.expectEqual(0, sensor_array[0].channel);
        try std.testing.expectEqual(1000, sensor_array[0].sample_rate_hz);
    }
}

test "100 sensor configs have unique channels" {
    comptime {
        for (0..sensor_array.len) |i| {
            try std.testing.expectEqual(@as(u8, @intCast(i)), sensor_array[i].channel);
        }
    }
}

test "100 sensor configs all in range" {
    comptime {
        for (sensor_array) |cfg| {
            try std.testing.expect(cfg.sample_rate_hz >= 1000 and cfg.sample_rate_hz <= 5050);
            try std.testing.expect(cfg.gain >= 1 and cfg.gain <= 8);
        }
    }
}

// --- Batch of Validated Configs ---

const MotorConfig = struct {
    id: u8,
    max_rpm: u16,
    rated_current_ma: u16,
    pole_pairs: u8,

    pub fn validate(comptime self: MotorConfig) void {
        constraints.inRange(u16, 100, 30000, self.max_rpm);
        constraints.inRange(u16, 100, 50000, self.rated_current_ma);
        constraints.oneOf(u8, &.{ 1, 2, 3, 4, 6, 8 }, self.pole_pairs);
    }
};

const motor_fleet = blk: {
    const gen = struct {
        fn f(comptime i: usize) MotorConfig {
            const cfg = MotorConfig{
                .id = @intCast(i),
                .max_rpm = @intCast(1000 + i * 500),
                .rated_current_ma = @intCast(500 + i * 200),
                .pole_pairs = blk: {
                    const pairs = [_]u8{ 2, 4, 6, 8, 2, 4, 6, 8, 2, 4, 6, 8, 2, 4, 6, 8 };
                    break :blk pairs[i % 16];
                },
            };
            cfg.validate();
            return cfg;
        }
    }.f;
    break :blk generators.generateArray(MotorConfig, 16, gen);
};

test "16 motor configs all validated" {
    comptime {
        try std.testing.expectEqual(16, motor_fleet.len);
        for (motor_fleet, 0..) |cfg, i| {
            try std.testing.expectEqual(@as(u8, @intCast(i)), cfg.id);
        }
    }
}

test "motor fleet RPM increases with index" {
    comptime {
        for (1..motor_fleet.len) |i| {
            try std.testing.expect(motor_fleet[i].max_rpm > motor_fleet[i - 1].max_rpm);
        }
    }
}

// --- Linear ramp table ---

const ramp_table = generators.generateArray(i32, 11, struct {
    fn f(comptime i: usize) i32 {
        return @intCast(i * 100);
    }
}.f);

test "linear ramp table has correct endpoints" {
    comptime {
        try std.testing.expectEqual(11, ramp_table.len);
        try std.testing.expectEqual(0, ramp_table[0]);
        try std.testing.expectEqual(1000, ramp_table[10]);
        try std.testing.expectEqual(500, ramp_table[5]);
    }
}
