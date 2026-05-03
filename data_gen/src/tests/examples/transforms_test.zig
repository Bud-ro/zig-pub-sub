const std = @import("std");
const constraint = @import("data_gen").constraint;
const contract = @import("data_gen").contract;
const transform = @import("data_gen").transform;

// --- ADC Voltage Scaling ---
// User specifies voltage thresholds in volts. The system stores them
// as raw ADC counts. Transform handles the conversion and errors if
// the voltage isn't achievable at the given resolution.

const AdcScaling = struct {
    reference_mv: u16,
    resolution_bits: u8,

    pub fn voltsToCount(comptime self: AdcScaling, comptime volts: comptime_float) u16 {
        const mv = volts * 1000.0;
        const counts_per_mv = @as(comptime_float, @floatFromInt((@as(u32, 1) << self.resolution_bits) - 1)) /
            @as(comptime_float, @floatFromInt(self.reference_mv));
        const result = mv * counts_per_mv;
        const truncated = @as(comptime_int, @intFromFloat(@round(result)));

        const max_count = (@as(u32, 1) << self.resolution_bits) - 1;
        if (truncated < 0 or truncated > max_count) {
            @compileError(std.fmt.comptimePrint(
                "{d}V is outside ADC range [0, {d}V]",
                .{ volts, @as(comptime_float, @floatFromInt(self.reference_mv)) / 1000.0 },
            ));
        }
        return @intCast(truncated);
    }
};

const adc_12bit_3v3 = AdcScaling{ .reference_mv = 3300, .resolution_bits = 12 };

test "ADC 3.3V reference, 12-bit: voltage to counts" {
    comptime {
        try std.testing.expectEqual(0, adc_12bit_3v3.voltsToCount(0.0));
        try std.testing.expectEqual(4095, adc_12bit_3v3.voltsToCount(3.3));
        try std.testing.expectEqual(2048, adc_12bit_3v3.voltsToCount(1.65));
        try std.testing.expectEqual(1241, adc_12bit_3v3.voltsToCount(1.0));
    }
}

// --- Temperature Sensor Calibration ---
// User specifies temperature thresholds in °C. The system stores them as
// 10-bit ADC counts via a known transfer function.

const TempSensor = struct {
    offset_c: comptime_float,
    scale_mv_per_c: comptime_float,
    adc: AdcScaling,

    pub fn celsiusToCount(comptime self: TempSensor, comptime temp_c: comptime_float) u16 {
        const mv = (temp_c - self.offset_c) * self.scale_mv_per_c;
        const volts = mv / 1000.0;
        return self.adc.voltsToCount(volts);
    }
};

const lm35_sensor = TempSensor{
    .offset_c = 0.0,
    .scale_mv_per_c = 10.0,
    .adc = AdcScaling{ .reference_mv = 3300, .resolution_bits = 10 },
};

test "LM35 temperature to ADC count" {
    comptime {
        try std.testing.expectEqual(0, lm35_sensor.celsiusToCount(0.0));
        try std.testing.expectEqual(310, lm35_sensor.celsiusToCount(100.0));
    }
}

// --- Motor Control: User specifies RPM, system stores as timer ticks ---

const MotorTimingConfig = struct {
    tick_hz: comptime_float,
    poles: u8,

    pub fn rpmToTicks(comptime self: MotorTimingConfig, comptime rpm: comptime_float) u16 {
        const electrical_hz = rpm * @as(comptime_float, @floatFromInt(self.poles)) / 120.0;
        return @intCast(@as(comptime_int, @intFromFloat(self.tick_hz / electrical_hz)));
    }
};

const motor_timing = MotorTimingConfig{ .tick_hz = 100_000.0, .poles = 8 };

test "motor RPM to tick period" {
    comptime {
        try std.testing.expectEqual(2000, motor_timing.rpmToTicks(750.0));
        try std.testing.expectEqual(1000, motor_timing.rpmToTicks(1500.0));
        try std.testing.expectEqual(200, motor_timing.rpmToTicks(7500.0));
    }
}

// --- Filter Coefficients from Cutoff Frequency ---
// IIR single-pole filter: alpha = dt / (RC + dt)
// User specifies cutoff frequency and sample rate. System stores alpha as Q0.16.

const FilterCoeffs = struct {
    alpha: u16,
    one_minus_alpha: u16,
};

const IirParams = struct {
    cutoff_hz: comptime_float,
    sample_hz: comptime_float,
};

fn iirCoeffsFromCutoff(comptime p: IirParams) FilterCoeffs {
    if (p.cutoff_hz >= p.sample_hz / 2.0)
        @compileError("cutoff must be below Nyquist (sample_rate / 2)");

    const dt = 1.0 / p.sample_hz;
    const rc = 1.0 / (2.0 * 3.14159265358979 * p.cutoff_hz);
    const alpha_f = dt / (rc + dt);

    const alpha = transform.scaledNearest(u16, 65536, alpha_f);
    const one_minus_alpha = 65536 - @as(u32, alpha);

    return FilterCoeffs{
        .alpha = alpha,
        .one_minus_alpha = @intCast(one_minus_alpha),
    };
}

test "IIR filter coefficients from cutoff frequency" {
    comptime {
        const coeffs = iirCoeffsFromCutoff(.{ .cutoff_hz = 100.0, .sample_hz = 1000.0 });
        try std.testing.expect(coeffs.alpha > 0);
        try std.testing.expect(coeffs.one_minus_alpha > 0);
        try std.testing.expectEqual(65536, @as(u32, coeffs.alpha) + coeffs.one_minus_alpha);
    }
}

test "lower cutoff gives smaller alpha" {
    comptime {
        const low = iirCoeffsFromCutoff(.{ .cutoff_hz = 10.0, .sample_hz = 1000.0 });
        const high = iirCoeffsFromCutoff(.{ .cutoff_hz = 100.0, .sample_hz = 1000.0 });
        try std.testing.expect(low.alpha < high.alpha);
    }
}

// --- PWM Duty Cycle: User specifies percentage, system stores as compare value ---

const PwmChannel = struct {
    timer_period: u16,

    pub fn dutyPercent(comptime self: PwmChannel, comptime pct: comptime_float) u16 {
        return transform.percentOf(u16, self.timer_period, pct);
    }
};

test "PWM duty cycle from percentage" {
    comptime {
        const pwm = PwmChannel{ .timer_period = 1000 };
        try std.testing.expectEqual(500, pwm.dutyPercent(50.0));
        try std.testing.expectEqual(250, pwm.dutyPercent(25.0));
        try std.testing.expectEqual(1000, pwm.dutyPercent(100.0));
        try std.testing.expectEqual(0, pwm.dutyPercent(0.0));
    }
}

test "PWM duty cycle high resolution timer" {
    comptime {
        const pwm = PwmChannel{ .timer_period = 65535 };
        try std.testing.expectEqual(32768, pwm.dutyPercent(50.0));
    }
}

// --- Voltage Divider: User specifies desired voltage, system computes DAC output ---

fn dacOutputForVdiv(
    comptime target_v: comptime_float,
    comptime r_top: comptime_float,
    comptime r_bottom: comptime_float,
    comptime dac_ref_v: comptime_float,
    comptime dac_bits: u8,
) u16 {
    const dac_voltage = target_v * (r_top + r_bottom) / r_bottom;
    if (dac_voltage > dac_ref_v) {
        @compileError(std.fmt.comptimePrint(
            "target {d}V requires DAC output {d}V which exceeds reference {d}V",
            .{ target_v, dac_voltage, dac_ref_v },
        ));
    }
    const max_count = (@as(u32, 1) << dac_bits) - 1;
    const count_f = dac_voltage / dac_ref_v * @as(comptime_float, @floatFromInt(max_count));
    return @intCast(@as(comptime_int, @intFromFloat(@round(count_f))));
}

test "voltage divider DAC output" {
    comptime {
        const count = dacOutputForVdiv(1.25, 10000.0, 10000.0, 3.3, 12);
        try std.testing.expectEqual(3102, count);
    }
}

// --- Composed: Sensor Configuration with Human-Readable Units ---

const SensorConfig = struct {
    alarm_low_counts: u16,
    alarm_high_counts: u16,
    sample_ticks: u16,
    filter_alpha: u16,
    filter_beta: u16,

    pub fn validate(comptime self: SensorConfig) ?[]const u8 {
        if (self.alarm_low_counts >= self.alarm_high_counts) return "alarm_low_counts must be less than alarm_high_counts";
        if (self.sample_ticks == 0) return "sample_ticks must not be zero";
        const sum = @as(u32, self.filter_alpha) + self.filter_beta;
        if (sum != 65536)
            return std.fmt.comptimePrint(
                "filter coefficients must sum to 65536, got {}",
                .{sum},
            );
        return null;
    }
};

const SensorParams = struct {
    alarm_low_v: comptime_float,
    alarm_high_v: comptime_float,
    sample_rate_hz: comptime_float,
    filter_cutoff_hz: comptime_float,
    tick_hz: comptime_float = 100_000.0,
};

fn makeSensorConfig(comptime p: SensorParams) SensorConfig {
    const adc = adc_12bit_3v3;
    const coeffs = iirCoeffsFromCutoff(.{ .cutoff_hz = p.filter_cutoff_hz, .sample_hz = p.sample_rate_hz });
    const config = SensorConfig{
        .alarm_low_counts = adc.voltsToCount(p.alarm_low_v),
        .alarm_high_counts = adc.voltsToCount(p.alarm_high_v),
        .sample_ticks = @intCast(@as(comptime_int, @intFromFloat(p.tick_hz / p.sample_rate_hz))),
        .filter_alpha = coeffs.alpha,
        .filter_beta = coeffs.one_minus_alpha,
    };
    contract.assertValid(config);
    return config;
}

test "full sensor config from human-readable units" {
    comptime {
        const cfg = makeSensorConfig(.{
            .alarm_low_v = 0.5,
            .alarm_high_v = 2.5,
            .sample_rate_hz = 1000.0,
            .filter_cutoff_hz = 50.0,
        });
        try std.testing.expect(cfg.alarm_low_counts < cfg.alarm_high_counts);
        try std.testing.expectEqual(100, cfg.sample_ticks);
        try std.testing.expectEqual(65536, @as(u32, cfg.filter_alpha) + cfg.filter_beta);
    }
}
