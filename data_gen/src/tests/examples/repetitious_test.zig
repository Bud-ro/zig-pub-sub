const std = @import("std");
const contract = @import("data_gen").contract;
const generator = @import("data_gen").generator;

// --- 128-entry Calibration Table ---

const CalEntry = struct {
    raw: u16,
    calibrated: u16,

    pub fn validate(comptime self: CalEntry) ?[]const u8 {
        if (self.raw > 65535) return "raw out of range [0, 65535]";
        if (self.calibrated > 65535) return "calibrated out of range [0, 65535]";
        return null;
    }
};

const large_cal_table = blk: {
    const gen = struct {
        fn f(comptime i: usize) CalEntry {
            const raw: u16 = @intCast(i * 32);
            const offset: u16 = @intCast(i / 8);
            const entry = CalEntry{ .raw = raw, .calibrated = raw + offset };
            contract.assertValid(entry);
            return entry;
        }
    }.f;
    @setEvalBranchQuota(5000);
    const table = generator.generateArray(CalEntry, 128, gen);

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

const SineEntry = struct {
    value: i16,

    pub fn validate(comptime self: SineEntry) ?[]const u8 {
        if (self.value < -512 or self.value > 512) return "sine value out of range [-512, 512]";
        return null;
    }
};

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
    const table = generator.generateArray(i16, 256, gen);

    for (table) |v| {
        const entry = SineEntry{ .value = v };
        if (entry.validate()) |err| @compileError(err);
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

// --- Batch of Validated Configs ---

const MotorConfig = struct {
    id: u8,
    max_rpm: u16,
    rated_current_ma: u16,
    pole_pairs: u8,

    pub fn validate(comptime self: MotorConfig) ?[]const u8 {
        if (self.max_rpm < 100 or self.max_rpm > 30000) return "max_rpm out of range [100, 30000]";
        if (self.rated_current_ma < 100 or self.rated_current_ma > 50000) return "rated_current_ma out of range [100, 50000]";
        if (self.pole_pairs != 1 and self.pole_pairs != 2 and self.pole_pairs != 3 and
            self.pole_pairs != 4 and self.pole_pairs != 6 and self.pole_pairs != 8)
            return "pole_pairs must be one of 1, 2, 3, 4, 6, 8";
        return null;
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
            contract.assertValid(cfg);
            return cfg;
        }
    }.f;
    break :blk generator.generateArray(MotorConfig, 16, gen);
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

const ramp_table = generator.generateArray(i32, 11, struct {
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
