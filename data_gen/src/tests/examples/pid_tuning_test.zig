const std = @import("std");
const constraints = @import("data_gen").constraints;
const contracts = @import("data_gen").contracts;

// --- PID Controller Tuning ---
// Coefficients with stability constraints: anti-windup limits,
// output clamping, derivative filtering, and gain relationships.

const PidConfig = struct {
    kp_num: u16,
    kp_den: u16,
    ki_num: u16,
    ki_den: u16,
    kd_num: u16,
    kd_den: u16,
    output_min: i16,
    output_max: i16,
    integral_limit: u16,
    derivative_filter_coeff: u8,
    sample_period_ms: u16,

    pub fn validate(comptime self: PidConfig) void {
        constraints.nonZero(u16, self.kp_den);
        constraints.nonZero(u16, self.ki_den);
        constraints.nonZero(u16, self.kd_den);
        constraints.nonZero(u16, self.sample_period_ms);

        constraints.lessThan(i16, self.output_min, self.output_max);

        const kd_x100: u32 = @as(u32, self.kd_num) * 100 / self.kd_den;
        if (kd_x100 > 500 and self.derivative_filter_coeff < 50)
            @compileError("high derivative gain (Kd > 5.0) requires derivative_filter_coeff >= 50 for stability");

        const output_range: u32 = @intCast(@as(i32, self.output_max) - self.output_min);
        if (self.integral_limit > output_range)
            @compileError("integral_limit exceeds output range — anti-windup is ineffective");

        const ki_x1000: u32 = @as(u32, self.ki_num) * 1000 / self.ki_den;
        const kp_x1000: u32 = @as(u32, self.kp_num) * 1000 / self.kp_den;
        const ki_contribution = ki_x1000 * self.sample_period_ms / 1000;
        if (kp_x1000 > 0 and ki_contribution > kp_x1000 * 10)
            @compileError("Ki contribution per sample exceeds 10x Kp — likely unstable");

        constraints.inRange(u16, 1, 10000, self.sample_period_ms);
    }

    pub fn generate(comptime self: PidConfig) PidConfig {
        self.validate();
        return self;
    }
};

test "PID conservative tuning" {
    comptime {
        const cfg = PidConfig.generate(.{
            .kp_num = 10,
            .kp_den = 10,
            .ki_num = 1,
            .ki_den = 10,
            .kd_num = 5,
            .kd_den = 10,
            .output_min = -1000,
            .output_max = 1000,
            .integral_limit = 500,
            .derivative_filter_coeff = 100,
            .sample_period_ms = 10,
        });
        try std.testing.expectEqual(10, cfg.sample_period_ms);
    }
}

test "PID aggressive proportional" {
    comptime {
        _ = PidConfig.generate(.{
            .kp_num = 50,
            .kp_den = 1,
            .ki_num = 1,
            .ki_den = 100,
            .kd_num = 1,
            .kd_den = 1,
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
        _ = PidConfig.generate(.{
            .kp_num = 20,
            .kp_den = 1,
            .ki_num = 0,
            .ki_den = 1,
            .kd_num = 0,
            .kd_den = 1,
            .output_min = -500,
            .output_max = 500,
            .integral_limit = 100,
            .derivative_filter_coeff = 0,
            .sample_period_ms = 50,
        });
    }
}

test "PID PI controller (no derivative)" {
    comptime {
        _ = PidConfig.generate(.{
            .kp_num = 5,
            .kp_den = 1,
            .ki_num = 1,
            .ki_den = 2,
            .kd_num = 0,
            .kd_den = 1,
            .output_min = -1000,
            .output_max = 1000,
            .integral_limit = 500,
            .derivative_filter_coeff = 0,
            .sample_period_ms = 20,
        });
    }
}

// --- Cascaded PID: Inner/Outer Loop ---

const CascadedPid = struct {
    inner: PidConfig,
    outer: PidConfig,
    inner_setpoint_min: i16,
    inner_setpoint_max: i16,

    pub fn validate(comptime self: CascadedPid) void {
        self.inner.validate();
        self.outer.validate();

        if (self.outer.sample_period_ms <= self.inner.sample_period_ms)
            @compileError("outer loop must run slower than inner loop");

        if (self.outer.sample_period_ms % self.inner.sample_period_ms != 0)
            @compileError("outer loop period must be a multiple of inner loop period");

        if (self.outer.output_min < self.inner_setpoint_min or
            self.outer.output_max > self.inner_setpoint_max)
            @compileError("outer loop output range must fit within inner loop setpoint range");

        constraints.lessThan(i16, self.inner_setpoint_min, self.inner_setpoint_max);
    }
};

test "cascaded PID: speed/current control" {
    comptime {
        contracts.assertValid(CascadedPid, CascadedPid{
            .inner = PidConfig.generate(.{
                .kp_num = 10,
                .kp_den = 1,
                .ki_num = 2,
                .ki_den = 1,
                .kd_num = 0,
                .kd_den = 1,
                .output_min = -1000,
                .output_max = 1000,
                .integral_limit = 500,
                .derivative_filter_coeff = 0,
                .sample_period_ms = 1,
            }),
            .outer = PidConfig.generate(.{
                .kp_num = 5,
                .kp_den = 1,
                .ki_num = 1,
                .ki_den = 2,
                .kd_num = 1,
                .kd_den = 1,
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
};

fn validateMultiZone(comptime zones: []const ZoneConfig) void {
    constraints.lenInRange(1, 16, zones.len);

    var ids: [zones.len]u8 = undefined;
    for (zones, 0..) |zone, i| {
        zone.pid.validate();
        ids[i] = zone.zone_id;
        constraints.nonZero(u16, zone.deadband);

        if (zone.setpoint < zone.pid.output_min or zone.setpoint > zone.pid.output_max)
            @compileError(std.fmt.comptimePrint(
                "zone {} setpoint {} is outside controller output range",
                .{ zone.zone_id, zone.setpoint },
            ));
    }
    constraints.noDuplicates(u8, &ids);

    for (1..zones.len) |i| {
        if (zones[i].pid.sample_period_ms != zones[0].pid.sample_period_ms)
            @compileError("all zones must use the same sample period");
    }
}

test "multi-zone temperature control" {
    comptime {
        const base_pid = PidConfig.generate(.{
            .kp_num = 8,
            .kp_den = 1,
            .ki_num = 1,
            .ki_den = 4,
            .kd_num = 2,
            .kd_den = 1,
            .output_min = -500,
            .output_max = 500,
            .integral_limit = 200,
            .derivative_filter_coeff = 60,
            .sample_period_ms = 100,
        });

        validateMultiZone(&.{
            .{ .zone_id = 0, .pid = base_pid, .setpoint = 220, .deadband = 5 },
            .{ .zone_id = 1, .pid = base_pid, .setpoint = 180, .deadband = 5 },
            .{ .zone_id = 2, .pid = base_pid, .setpoint = 250, .deadband = 10 },
            .{ .zone_id = 3, .pid = base_pid, .setpoint = -100, .deadband = 3 },
        });
    }
}
