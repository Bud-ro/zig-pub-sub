const std = @import("std");
const constraints = @import("data_gen").constraints;
const contracts = @import("data_gen").contracts;
const generators = @import("data_gen").generators;
const data_testing = @import("data_gen").testing;

// --- Sensor Fusion Pipeline ---
// Multiple sensors feed into a fusion algorithm. Each sensor has
// calibration data, a weight in the fusion, and a noise model.
// Weights must sum to 1.0 (represented as parts-per-1024).
// Noise budgets propagate through the fusion: the combined noise
// must be below a threshold.

const SensorType = enum(u8) { accelerometer, gyroscope, magnetometer, barometer, gps };

const SensorWeight = struct {
    sensor: SensorType,
    weight_per1024: u16,
    noise_variance_x1000: u32,
    update_rate_hz: u16,
    latency_us: u32,
};

fn validateFusionWeights(comptime sensors: []const SensorWeight) void {
    constraints.lenInRange(2, 8, sensors.len);

    // Weights must sum to 1024 (representing 1.0)
    var weight_sum: u32 = 0;
    for (sensors) |s| {
        constraints.nonZero(u16, s.weight_per1024);
        constraints.nonZero(u16, s.update_rate_hz);
        weight_sum += s.weight_per1024;
    }
    if (weight_sum != 1024)
        @compileError(std.fmt.comptimePrint(
            "fusion weights sum to {} but must equal 1024 (1.0)",
            .{weight_sum},
        ));

    // No duplicate sensor types
    for (0..sensors.len) |i| {
        for (i + 1..sensors.len) |j| {
            if (sensors[i].sensor == sensors[j].sensor)
                @compileError("duplicate sensor type in fusion");
        }
    }

    // Weighted noise variance: sum(weight_i^2 * variance_i) / 1024^2
    // Must be below a threshold (1000 = 1.0 in our fixed-point)
    var weighted_noise: u64 = 0;
    for (sensors) |s| {
        weighted_noise += @as(u64, s.weight_per1024) * s.weight_per1024 * s.noise_variance_x1000 / (1024 * 1024);
    }
    if (weighted_noise > 500)
        @compileError(std.fmt.comptimePrint(
            "fused noise variance {} exceeds threshold 500",
            .{weighted_noise},
        ));

    // Higher-weight sensors must have lower latency (otherwise the fusion
    // is dominated by stale data)
    for (0..sensors.len) |i| {
        for (i + 1..sensors.len) |j| {
            if (sensors[i].weight_per1024 > sensors[j].weight_per1024 and
                sensors[i].latency_us > sensors[j].latency_us * 2)
                @compileError(std.fmt.comptimePrint(
                    "sensor {} has higher weight but >2x the latency of sensor {}",
                    .{ @intFromEnum(sensors[i].sensor), @intFromEnum(sensors[j].sensor) },
                ));
        }
    }
}

const imu_fusion = blk: {
    const sensors = [_]SensorWeight{
        .{ .sensor = .accelerometer, .weight_per1024 = 400, .noise_variance_x1000 = 200, .update_rate_hz = 1000, .latency_us = 100 },
        .{ .sensor = .gyroscope, .weight_per1024 = 350, .noise_variance_x1000 = 150, .update_rate_hz = 1000, .latency_us = 100 },
        .{ .sensor = .magnetometer, .weight_per1024 = 150, .noise_variance_x1000 = 800, .update_rate_hz = 100, .latency_us = 2000 },
        .{ .sensor = .barometer, .weight_per1024 = 100, .noise_variance_x1000 = 500, .update_rate_hz = 50, .latency_us = 5000 },
        .{ .sensor = .gps, .weight_per1024 = 24, .noise_variance_x1000 = 3000, .update_rate_hz = 10, .latency_us = 50000 },
    };
    validateFusionWeights(&sensors);
    break :blk sensors;
};

test "fusion weights sum to 1024" {
    comptime {
        var sum: u32 = 0;
        for (imu_fusion) |s| sum += s.weight_per1024;
        try std.testing.expectEqual(1024, sum);
    }
}

test "fusion has 5 unique sensor types" {
    comptime {
        try std.testing.expectEqual(5, imu_fusion.len);
    }
}

// --- Using expectValid from the testing module ---

const FilterStage = struct {
    order: u8,
    cutoff_hz: u16,
    sample_rate_hz: u16,
    gain_x100: u16,

    pub fn validate(comptime self: FilterStage) void {
        constraints.inRange(u8, 1, 8, self.order);
        constraints.nonZero(u16, self.cutoff_hz);
        constraints.nonZero(u16, self.sample_rate_hz);

        // Nyquist: cutoff must be less than half the sample rate
        if (self.cutoff_hz >= self.sample_rate_hz / 2)
            @compileError(std.fmt.comptimePrint(
                "cutoff {}Hz violates Nyquist for sample rate {}Hz",
                .{ self.cutoff_hz, self.sample_rate_hz },
            ));

        // Higher order filters need more headroom
        if (self.order > 4 and self.cutoff_hz > self.sample_rate_hz / 4)
            @compileError("high-order filters (>4) need cutoff < fs/4 for stability");

        constraints.inRange(u16, 50, 200, self.gain_x100);
    }
};

test "expectValid accepts well-configured filter" {
    comptime {
        data_testing.expectValid(FilterStage, .{
            .order = 4,
            .cutoff_hz = 1000,
            .sample_rate_hz = 8000,
            .gain_x100 = 100,
        });
    }
}

test "expectValid accepts high-order filter with low cutoff" {
    comptime {
        data_testing.expectValid(FilterStage, .{
            .order = 8,
            .cutoff_hz = 500,
            .sample_rate_hz = 8000,
            .gain_x100 = 100,
        });
    }
}

// --- Using structDiff from the testing module ---

const SensorConfig = struct {
    channel: u8,
    gain: u8,
    offset: i8,
    enabled: bool,
};

test "structDiff shows identical structs" {
    comptime {
        const a = SensorConfig{ .channel = 0, .gain = 4, .offset = -2, .enabled = true };
        const diff = data_testing.structDiff(SensorConfig, a, a);
        try std.testing.expect(std.mem.eql(u8, diff, "(identical)"));
    }
}

test "structDiff shows field differences" {
    comptime {
        const a = SensorConfig{ .channel = 0, .gain = 4, .offset = -2, .enabled = true };
        const b = SensorConfig{ .channel = 0, .gain = 8, .offset = -2, .enabled = false };
        const diff = data_testing.structDiff(SensorConfig, a, b);
        try std.testing.expect(diff.len > 0);
        try std.testing.expect(!std.mem.eql(u8, diff, "(identical)"));
    }
}

// --- Using validatedSequence with complex domain logic ---

const MeasurementPhase = enum(u8) { zero_cal, span_cal, warmup, measure, cooldown };

const MeasurementStep = struct {
    phase: MeasurementPhase,
    duration_ms: u16,
    target_value: i16,
    tolerance_pct: u8,
};

fn validateMeasurementStep(comptime step: MeasurementStep, comptime idx: usize) void {
    constraints.nonZero(u16, step.duration_ms);
    constraints.inRange(u8, 1, 50, step.tolerance_pct);

    if (idx == 0 and step.phase != .zero_cal)
        @compileError("measurement sequence must start with zero calibration");

    switch (step.phase) {
        .zero_cal => {
            if (step.target_value != 0)
                @compileError("zero calibration target must be 0");
        },
        .span_cal => {
            constraints.nonZero(i16, step.target_value);
        },
        .warmup => {
            constraints.inRange(u16, 1000, 30000, step.duration_ms);
        },
        .measure => {
            constraints.inRange(u8, 1, 10, step.tolerance_pct);
        },
        .cooldown => {
            constraints.inRange(u16, 500, 10000, step.duration_ms);
        },
    }
}

const measurement_sequence = generators.validatedSequence(MeasurementStep, &.{
    .{ .phase = .zero_cal, .duration_ms = 500, .target_value = 0, .tolerance_pct = 5 },
    .{ .phase = .span_cal, .duration_ms = 500, .target_value = 1000, .tolerance_pct = 10 },
    .{ .phase = .warmup, .duration_ms = 5000, .target_value = 0, .tolerance_pct = 50 },
    .{ .phase = .measure, .duration_ms = 2000, .target_value = 500, .tolerance_pct = 2 },
    .{ .phase = .measure, .duration_ms = 2000, .target_value = 750, .tolerance_pct = 3 },
    .{ .phase = .measure, .duration_ms = 2000, .target_value = 250, .tolerance_pct = 5 },
    .{ .phase = .cooldown, .duration_ms = 3000, .target_value = 0, .tolerance_pct = 20 },
}, validateMeasurementStep);

test "measurement sequence starts with zero cal" {
    comptime {
        try std.testing.expectEqual(MeasurementPhase.zero_cal, measurement_sequence[0].phase);
        try std.testing.expectEqual(0, measurement_sequence[0].target_value);
    }
}

test "measurement sequence has 7 steps" {
    comptime {
        try std.testing.expectEqual(7, measurement_sequence.len);
    }
}

test "measurement phase tolerances are tight for measure steps" {
    comptime {
        for (measurement_sequence) |step| {
            if (step.phase == .measure) {
                try std.testing.expect(step.tolerance_pct <= 10);
            }
        }
    }
}

// --- Using lookupTable for sensor linearization ---

const temp_lut = generators.lookupTable(i16, i16, -40, 120, 10, struct {
    fn f(comptime raw: i16) i16 {
        // Simulated NTC thermistor nonlinearity: T_actual ≈ raw + raw²/1000
        return raw + @divTrunc(raw * raw, 1000);
    }
}.f);

test "temperature LUT covers -40 to 120" {
    comptime {
        try std.testing.expectEqual(17, temp_lut.len);
        try std.testing.expectEqual(-40, temp_lut[0].input);
        try std.testing.expectEqual(120, temp_lut[16].input);
    }
}

test "temperature LUT output includes nonlinearity correction" {
    comptime {
        // At 0, raw²/1000 = 0, so output = 0
        try std.testing.expectEqual(0, temp_lut[4].output);
        // At 100, raw²/1000 = 10, so output = 110
        try std.testing.expectEqual(110, temp_lut[14].output);
    }
}

// --- Using unfold for Fibonacci-like sensor threshold ramp ---

const FibThreshold = struct {
    level: u8,
    threshold: u32,
    hysteresis: u16,
};

const threshold_ramp = generators.unfold(FibThreshold, 8, .{
    .level = 0,
    .threshold = 100,
    .hysteresis = 10,
}, struct {
    fn f(comptime prev: FibThreshold, comptime i: usize) FibThreshold {
        return .{
            .level = @intCast(i),
            .threshold = prev.threshold * 2,
            .hysteresis = @intCast(prev.hysteresis + 5),
        };
    }
}.f);

test "threshold ramp doubles each level" {
    comptime {
        try std.testing.expectEqual(8, threshold_ramp.len);
        try std.testing.expectEqual(100, threshold_ramp[0].threshold);
        try std.testing.expectEqual(200, threshold_ramp[1].threshold);
        try std.testing.expectEqual(400, threshold_ramp[2].threshold);
        try std.testing.expectEqual(12800, threshold_ramp[7].threshold);
    }
}

test "threshold ramp hysteresis increases linearly" {
    comptime {
        try std.testing.expectEqual(10, threshold_ramp[0].hysteresis);
        try std.testing.expectEqual(15, threshold_ramp[1].hysteresis);
        try std.testing.expectEqual(45, threshold_ramp[7].hysteresis);
    }
}
