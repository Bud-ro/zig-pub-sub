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

        // Derivative filter coefficient [0..255] where 0 = no filtering, 255 = maximum smoothing
        // High derivative gain with no filtering is unstable
        const kd_x100: u32 = @as(u32, self.kd_num) * 100 / self.kd_den;
        if (kd_x100 > 500 and self.derivative_filter_coeff < 50)
            @compileError("high derivative gain (Kd > 5.0) requires derivative_filter_coeff >= 50 for stability");

        // Anti-windup: integral limit must be less than output range
        const output_range: u32 = @intCast(@as(i32, self.output_max) - self.output_min);
        if (self.integral_limit > output_range)
            @compileError("integral_limit exceeds output range — anti-windup is ineffective");

        // Ki should not dominate: Ki * sample_period should be reasonable relative to Kp
        const ki_x1000: u32 = @as(u32, self.ki_num) * 1000 / self.ki_den;
        const kp_x1000: u32 = @as(u32, self.kp_num) * 1000 / self.kp_den;
        const ki_contribution = ki_x1000 * self.sample_period_ms / 1000;
        if (kp_x1000 > 0 and ki_contribution > kp_x1000 * 10)
            @compileError("Ki contribution per sample exceeds 10x Kp — likely unstable");

        constraints.inRange(u16, 1, 10000, self.sample_period_ms);
    }

    pub fn generate(
        comptime kp: [2]u16,
        comptime ki: [2]u16,
        comptime kd: [2]u16,
        comptime out_range: [2]i16,
        comptime ilimit: u16,
        comptime df: u8,
        comptime period: u16,
    ) PidConfig {
        const self = PidConfig{
            .kp_num = kp[0],
            .kp_den = kp[1],
            .ki_num = ki[0],
            .ki_den = ki[1],
            .kd_num = kd[0],
            .kd_den = kd[1],
            .output_min = out_range[0],
            .output_max = out_range[1],
            .integral_limit = ilimit,
            .derivative_filter_coeff = df,
            .sample_period_ms = period,
        };
        self.validate();
        return self;
    }
};

test "PID conservative tuning" {
    comptime {
        const cfg = PidConfig.generate(
            .{ 10, 10 }, // Kp = 1.0
            .{ 1, 10 }, // Ki = 0.1
            .{ 5, 10 }, // Kd = 0.5
            .{ -1000, 1000 },
            500,
            100,
            10, // 10ms
        );
        try std.testing.expectEqual(10, cfg.sample_period_ms);
    }
}

test "PID aggressive proportional" {
    comptime {
        _ = PidConfig.generate(
            .{ 50, 1 }, // Kp = 50
            .{ 1, 100 }, // Ki = 0.01
            .{ 1, 1 }, // Kd = 1.0
            .{ -32000, 32000 },
            10000,
            80,
            100,
        );
    }
}

test "PID P-only controller" {
    comptime {
        _ = PidConfig.generate(
            .{ 20, 1 }, // Kp = 20
            .{ 0, 1 }, // Ki = 0
            .{ 0, 1 }, // Kd = 0
            .{ -500, 500 },
            100,
            0,
            50,
        );
    }
}

test "PID PI controller (no derivative)" {
    comptime {
        _ = PidConfig.generate(
            .{ 5, 1 }, // Kp = 5
            .{ 1, 2 }, // Ki = 0.5
            .{ 0, 1 }, // Kd = 0
            .{ -1000, 1000 },
            500,
            0,
            20,
        );
    }
}

// --- Cascaded PID: Inner/Outer Loop ---
// The outer loop must run slower than the inner loop.
// The outer loop's output range must fit within the inner loop's setpoint range.

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
        contracts.assertValid(CascadedPid, .{
            .inner = PidConfig.generate(
                .{ 10, 1 },
                .{ 2, 1 },
                .{ 0, 1 },
                .{ -1000, 1000 },
                500,
                0,
                1, // 1ms inner loop
            ),
            .outer = PidConfig.generate(
                .{ 5, 1 },
                .{ 1, 2 },
                .{ 1, 1 },
                .{ -500, 500 },
                300,
                50,
                10, // 10ms outer loop
            ),
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

    // All zones must share the same sample period for synchronous control
    for (1..zones.len) |i| {
        if (zones[i].pid.sample_period_ms != zones[0].pid.sample_period_ms)
            @compileError("all zones must use the same sample period");
    }
}

test "multi-zone temperature control" {
    comptime {
        const base_pid = PidConfig.generate(
            .{ 8, 1 },
            .{ 1, 4 },
            .{ 2, 1 },
            .{ -500, 500 },
            200,
            60,
            100,
        );

        validateMultiZone(&.{
            .{ .zone_id = 0, .pid = base_pid, .setpoint = 220, .deadband = 5 },
            .{ .zone_id = 1, .pid = base_pid, .setpoint = 180, .deadband = 5 },
            .{ .zone_id = 2, .pid = base_pid, .setpoint = 250, .deadband = 10 },
            .{ .zone_id = 3, .pid = base_pid, .setpoint = -100, .deadband = 3 },
        });
    }
}
