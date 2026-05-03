const std = @import("std");
const constraints = @import("data_gen").constraints;
const contracts = @import("data_gen").contracts;
const transforms = @import("data_gen").transforms;

// --- PID Controller Tuning ---
// Users specify gains as floating-point values. The library transforms
// them to Q8.8 fixed-point for the embedded implementation. If a value
// isn't exactly representable, the user gets a compile error suggesting
// the nearest representable values.

const PidGains = struct {
    kp: u16,
    ki: u16,
    kd: u16,

    pub fn fromFloats(comptime kp: comptime_float, comptime ki: comptime_float, comptime kd: comptime_float) PidGains {
        return .{
            .kp = transforms.fixedPoint(u16, 8, kp),
            .ki = transforms.fixedPoint(u16, 8, ki),
            .kd = transforms.fixedPoint(u16, 8, kd),
        };
    }
};

const PidConfig = struct {
    gains: PidGains,
    output_min: i16,
    output_max: i16,
    integral_limit: u16,
    derivative_filter_coeff: u8,
    sample_period_ms: u16,

    pub fn validate(comptime self: PidConfig) ?[]const u8 {
        if (self.sample_period_ms == 0) return "sample_period_ms must not be zero";
        if (self.output_min >= self.output_max) return "output_min must be less than output_max";

        const kd_x100: u32 = @as(u32, self.gains.kd) * 100 / 256;
        if (kd_x100 > 500 and self.derivative_filter_coeff < 50)
            return "high derivative gain (Kd > 5.0) requires derivative_filter_coeff >= 50 for stability";

        const output_range: u32 = @intCast(@as(i32, self.output_max) - self.output_min);
        if (self.integral_limit > output_range)
            return "integral_limit exceeds output range — anti-windup is ineffective";

        const ki_contribution = @as(u32, self.gains.ki) * self.sample_period_ms / 256000;
        const kp_normalized = @as(u32, self.gains.kp) * 1000 / 256;
        if (kp_normalized > 0 and ki_contribution > kp_normalized * 10)
            return "Ki contribution per sample exceeds 10x Kp — likely unstable";

        if (self.sample_period_ms < 1 or self.sample_period_ms > 10000) return "sample_period_ms out of range [1, 10000]";
        return null;
    }

    pub const Params = struct {
        kp: comptime_float,
        ki: comptime_float,
        kd: comptime_float,
        output_min: i16,
        output_max: i16,
        integral_limit: u16,
        derivative_filter_coeff: u8 = 0,
        sample_period_ms: u16,
    };

    pub fn init(comptime p: Params) PidConfig {
        const self = PidConfig{
            .gains = PidGains.fromFloats(p.kp, p.ki, p.kd),
            .output_min = p.output_min,
            .output_max = p.output_max,
            .integral_limit = p.integral_limit,
            .derivative_filter_coeff = p.derivative_filter_coeff,
            .sample_period_ms = p.sample_period_ms,
        };
        contracts.assertValid(self);
        return self;
    }
};

test "PID conservative tuning — gains as floats" {
    comptime {
        const cfg = PidConfig.init(.{
            .kp = 1.0,
            .ki = 0.25,
            .kd = 0.5,
            .output_min = -1000,
            .output_max = 1000,
            .integral_limit = 500,
            .derivative_filter_coeff = 100,
            .sample_period_ms = 10,
        });
        try std.testing.expectEqual(256, cfg.gains.kp);
        try std.testing.expectEqual(64, cfg.gains.ki);
        try std.testing.expectEqual(128, cfg.gains.kd);
    }
}

test "PID aggressive proportional" {
    comptime {
        _ = PidConfig.init(.{
            .kp = 50.0,
            .ki = 0.0,
            .kd = 1.0,
            .output_min = -32000,
            .output_max = 32000,
            .integral_limit = 10000,
            .derivative_filter_coeff = 80,
            .sample_period_ms = 100,
        });
    }
}

test "PID P-only controller" {
    comptime {
        _ = PidConfig.init(.{
            .kp = 20.0,
            .ki = 0.0,
            .kd = 0.0,
            .output_min = -500,
            .output_max = 500,
            .integral_limit = 100,
            .sample_period_ms = 50,
        });
    }
}

test "PID fractional gains (representable in Q8.8)" {
    comptime {
        const cfg = PidConfig.init(.{
            .kp = 0.5,
            .ki = 0.125,
            .kd = 0.0625,
            .output_min = -1000,
            .output_max = 1000,
            .integral_limit = 500,
            .sample_period_ms = 20,
        });
        try std.testing.expectEqual(128, cfg.gains.kp);
        try std.testing.expectEqual(32, cfg.gains.ki);
        try std.testing.expectEqual(16, cfg.gains.kd);
    }
}

// --- Cascaded PID: Inner/Outer Loop ---

const CascadedPid = struct {
    inner: PidConfig,
    outer: PidConfig,
    inner_setpoint_min: i16,
    inner_setpoint_max: i16,

    pub fn validate(comptime self: CascadedPid) ?[]const u8 {
        if (self.outer.sample_period_ms <= self.inner.sample_period_ms)
            return "outer loop must run slower than inner loop";

        if (self.outer.sample_period_ms % self.inner.sample_period_ms != 0)
            return "outer loop period must be a multiple of inner loop period";

        if (self.outer.output_min < self.inner_setpoint_min or
            self.outer.output_max > self.inner_setpoint_max)
            return "outer loop output range must fit within inner loop setpoint range";

        if (self.inner_setpoint_min >= self.inner_setpoint_max) return "inner_setpoint_min must be less than inner_setpoint_max";
        return null;
    }
};

test "cascaded PID: speed/current control" {
    comptime {
        contracts.assertValid(CascadedPid{
            .inner = PidConfig.init(.{
                .kp = 10.0,
                .ki = 2.0,
                .kd = 0.0,
                .output_min = -1000,
                .output_max = 1000,
                .integral_limit = 500,
                .sample_period_ms = 1,
            }),
            .outer = PidConfig.init(.{
                .kp = 5.0,
                .ki = 0.5,
                .kd = 1.0,
                .output_min = -500,
                .output_max = 500,
                .integral_limit = 300,
                .derivative_filter_coeff = 50,
                .sample_period_ms = 10,
            }),
            .inner_setpoint_min = -1000,
            .inner_setpoint_max = 1000,
        });
    }
}

// --- Multiple Control Zones ---

const ZoneConfig = struct {
    zone_id: u8,
    pid: PidConfig,
    setpoint: i16,
    deadband: u16,

    pub fn validate(comptime self: ZoneConfig) ?[]const u8 {
        if (self.deadband == 0) return "value must not be zero";

        if (self.setpoint < self.pid.output_min or self.setpoint > self.pid.output_max)
            return std.fmt.comptimePrint(
                "zone {} setpoint {} is outside controller output range",
                .{ self.zone_id, self.setpoint },
            );

        return null;
    }
};

const MultiZone = struct {
    zones: []const ZoneConfig,

    pub fn validate(comptime self: MultiZone) ?[]const u8 {
        if (constraints.lenInRange(1, 16, self.zones.len)) |err| return err;

        var ids: [self.zones.len]u8 = undefined;
        for (self.zones, 0..) |zone, i| {
            ids[i] = zone.zone_id;
        }
        if (constraints.noDuplicates(u8, &ids)) |err| return err;

        for (1..self.zones.len) |i| {
            if (self.zones[i].pid.sample_period_ms != self.zones[0].pid.sample_period_ms)
                return "all zones must use the same sample period";
        }

        return null;
    }
};

test "multi-zone temperature control" {
    comptime {
        const base_pid = PidConfig.init(.{
            .kp = 8.0,
            .ki = 0.25,
            .kd = 2.0,
            .output_min = -500,
            .output_max = 500,
            .integral_limit = 200,
            .derivative_filter_coeff = 60,
            .sample_period_ms = 100,
        });

        contracts.assertValid(MultiZone{ .zones = &.{
            .{ .zone_id = 0, .pid = base_pid, .setpoint = 220, .deadband = 5 },
            .{ .zone_id = 1, .pid = base_pid, .setpoint = 180, .deadband = 5 },
            .{ .zone_id = 2, .pid = base_pid, .setpoint = 250, .deadband = 10 },
            .{ .zone_id = 3, .pid = base_pid, .setpoint = -100, .deadband = 3 },
        } });
    }
}
