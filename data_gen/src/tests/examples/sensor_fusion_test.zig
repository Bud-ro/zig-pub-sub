const std = @import("std");
const constraint = @import("data_gen").constraint;
const contract = @import("data_gen").contract;
const generator = @import("data_gen").generator;

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

    pub fn validate(comptime self: SensorWeight) ?[]const u8 {
        if (constraint.nonZero(self.weight_per1024)) |err| return err;
        if (constraint.nonZero(self.update_rate_hz)) |err| return err;
        return null;
    }
};

const FusionConfig = struct {
    sensors: [5]SensorWeight,

    pub fn validate(comptime self: FusionConfig) ?[]const u8 {
        const sensors = &self.sensors;
        if (constraint.lenInRange(2, 8, sensors.len)) |err| return err;

        // Weights must sum to 1024 (representing 1.0)
        var weight_sum: u32 = 0;
        for (sensors) |s| {
            weight_sum += s.weight_per1024;
        }
        if (weight_sum != 1024)
            return std.fmt.comptimePrint(
                "fusion weights sum to {} but must equal 1024 (1.0)",
                .{weight_sum},
            );

        // No duplicate sensor types
        for (0..sensors.len) |i| {
            for (i + 1..sensors.len) |j| {
                if (sensors[i].sensor == sensors[j].sensor)
                    return "duplicate sensor type in fusion";
            }
        }

        // Weighted noise variance: sum(weight_i^2 * variance_i) / 1024^2
        // Must be below a threshold (1000 = 1.0 in our fixed-point)
        var weighted_noise: u64 = 0;
        for (sensors) |s| {
            weighted_noise += @as(u64, s.weight_per1024) * s.weight_per1024 * s.noise_variance_x1000 / (1024 * 1024);
        }
        if (weighted_noise > 500)
            return std.fmt.comptimePrint(
                "fused noise variance {} exceeds threshold 500",
                .{weighted_noise},
            );

        // Higher-weight sensors must have lower latency (otherwise the fusion
        // is dominated by stale data)
        for (0..sensors.len) |i| {
            for (i + 1..sensors.len) |j| {
                if (sensors[i].weight_per1024 > sensors[j].weight_per1024 and
                    sensors[i].latency_us > sensors[j].latency_us * 2)
                    return std.fmt.comptimePrint(
                        "sensor {} has higher weight but >2x the latency of sensor {}",
                        .{ @intFromEnum(sensors[i].sensor), @intFromEnum(sensors[j].sensor) },
                    );
            }
        }

        return null;
    }
};

const imu_fusion = blk: {
    const config = contract.validated(FusionConfig{ .sensors = .{
        .{ .sensor = .accelerometer, .weight_per1024 = 400, .noise_variance_x1000 = 200, .update_rate_hz = 1000, .latency_us = 100 },
        .{ .sensor = .gyroscope, .weight_per1024 = 350, .noise_variance_x1000 = 150, .update_rate_hz = 1000, .latency_us = 100 },
        .{ .sensor = .magnetometer, .weight_per1024 = 150, .noise_variance_x1000 = 800, .update_rate_hz = 100, .latency_us = 2000 },
        .{ .sensor = .barometer, .weight_per1024 = 100, .noise_variance_x1000 = 500, .update_rate_hz = 50, .latency_us = 5000 },
        .{ .sensor = .gps, .weight_per1024 = 24, .noise_variance_x1000 = 3000, .update_rate_hz = 10, .latency_us = 50000 },
    } });
    break :blk config.sensors;
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

// --- Filter Stage Validation ---

const FilterStage = struct {
    order: u8,
    cutoff_hz: u16,
    sample_rate_hz: u16,
    gain_x100: u16,

    pub fn validate(comptime self: FilterStage) ?[]const u8 {
        if (self.order < 1 or self.order > 8) return "order out of range [1, 8]";
        if (self.cutoff_hz == 0) return "cutoff_hz must not be zero";
        if (self.sample_rate_hz == 0) return "sample_rate_hz must not be zero";

        // Nyquist: cutoff must be less than half the sample rate
        if (self.cutoff_hz >= self.sample_rate_hz / 2)
            return std.fmt.comptimePrint(
                "cutoff {}Hz violates Nyquist for sample rate {}Hz",
                .{ self.cutoff_hz, self.sample_rate_hz },
            );

        // Higher order filters need more headroom
        if (self.order > 4 and self.cutoff_hz > self.sample_rate_hz / 4)
            return "high-order filters (>4) need cutoff < fs/4 for stability";

        if (self.gain_x100 < 50 or self.gain_x100 > 200) return "gain_x100 out of range [50, 200]";
        return null;
    }
};

test "well-configured filter passes validation" {
    comptime {
        contract.assertValid(FilterStage{
            .order = 4,
            .cutoff_hz = 1000,
            .sample_rate_hz = 8000,
            .gain_x100 = 100,
        });
    }
}

test "high-order filter with low cutoff passes validation" {
    comptime {
        contract.assertValid(FilterStage{
            .order = 8,
            .cutoff_hz = 500,
            .sample_rate_hz = 8000,
            .gain_x100 = 100,
        });
    }
}

const MeasurementPhase = enum(u8) { zero_cal, span_cal, warmup, measure, cooldown };

const MeasurementStep = struct {
    phase: MeasurementPhase,
    duration_ms: u16,
    target_value: i16,
    tolerance_pct: u8,

    pub fn validate(comptime self: MeasurementStep) ?[]const u8 {
        if (constraint.nonZero(self.duration_ms)) |err| return err;
        if (constraint.inRange(1, 50, self.tolerance_pct)) |err| return err;

        switch (self.phase) {
            .zero_cal => {
                if (self.target_value != 0)
                    return "zero calibration target must be 0";
            },
            .span_cal => {
                if (constraint.nonZero(self.target_value)) |err| return err;
            },
            .warmup => {
                if (constraint.inRange(1000, 30000, self.duration_ms)) |err| return err;
            },
            .measure => {
                if (constraint.inRange(1, 10, self.tolerance_pct)) |err| return err;
            },
            .cooldown => {
                if (constraint.inRange(500, 10000, self.duration_ms)) |err| return err;
            },
        }
        return null;
    }
};

const MeasurementSequence = struct {
    steps: [7]MeasurementStep,

    pub fn validate(comptime self: MeasurementSequence) ?[]const u8 {
        if (self.steps[0].phase != .zero_cal)
            return "measurement sequence must start with zero calibration";
        return null;
    }
};

const measurement_sequence = blk: {
    const seq = contract.validated(MeasurementSequence{ .steps = .{
        .{ .phase = .zero_cal, .duration_ms = 500, .target_value = 0, .tolerance_pct = 5 },
        .{ .phase = .span_cal, .duration_ms = 500, .target_value = 1000, .tolerance_pct = 10 },
        .{ .phase = .warmup, .duration_ms = 5000, .target_value = 0, .tolerance_pct = 50 },
        .{ .phase = .measure, .duration_ms = 2000, .target_value = 500, .tolerance_pct = 2 },
        .{ .phase = .measure, .duration_ms = 2000, .target_value = 750, .tolerance_pct = 3 },
        .{ .phase = .measure, .duration_ms = 2000, .target_value = 250, .tolerance_pct = 5 },
        .{ .phase = .cooldown, .duration_ms = 3000, .target_value = 0, .tolerance_pct = 20 },
    } });
    break :blk seq.steps;
};

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

// --- Sensor linearization via generateArray ---

const TempLutEntry = struct { input: i16, output: i16 };

const temp_lut = generator.generateArray(TempLutEntry, 17, struct {
    fn f(comptime i: usize) TempLutEntry {
        const raw: i16 = -40 + @as(i16, @intCast(i)) * 10;
        return .{ .input = raw, .output = raw + @divTrunc(raw * raw, 1000) };
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
        try std.testing.expectEqual(0, temp_lut[4].output);
        try std.testing.expectEqual(110, temp_lut[14].output);
    }
}
