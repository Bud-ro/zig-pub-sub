const std = @import("std");
const constraints = @import("data_gen").constraints;
const contracts = @import("data_gen").contracts;
const generators = @import("data_gen").generators;

// --- Variant Configurations with Tightening Constraints ---
// A base hardware config defines broad acceptable ranges.
// Product variants tighten those ranges for their specific needs.
// The variant validate calls the base validate first, then adds
// stricter rules — exercising constraint composition/inheritance.

const BaseMotorConfig = struct {
    rated_voltage_mv: u16,
    max_current_ma: u16,
    pwm_frequency_hz: u32,
    dead_time_ns: u16,
    pole_pairs: u8,
    max_rpm: u16,

    pub fn validate(comptime self: BaseMotorConfig) void {
        constraints.inRange(3000, 48000, self.rated_voltage_mv);
        constraints.inRange(100, 50000, self.max_current_ma);
        constraints.inRange(1000, 100000, self.pwm_frequency_hz);
        constraints.inRange(0, 5000, self.dead_time_ns);
        constraints.oneOf(&.{ 1, 2, 3, 4, 5, 6, 7, 8 }, self.pole_pairs);
        constraints.inRange(100, 30000, self.max_rpm);

        // Dead time must be meaningful relative to PWM period
        const period_ns: u32 = 1_000_000_000 / self.pwm_frequency_hz;
        if (self.dead_time_ns > 0 and @as(u32, self.dead_time_ns) * 100 > period_ns)
            @compileError("dead time exceeds 1% of PWM period");
    }
};

// Small BLDC variant (drone motor): tighter voltage/current, high RPM
const SmallBldcConfig = struct {
    base: BaseMotorConfig,
    kv_rating: u16, // RPM per volt
    max_throttle_pct: u8,

    pub fn validate(comptime self: SmallBldcConfig) void {
        self.base.validate();

        constraints.inRange(11000, 25200, self.base.rated_voltage_mv);
        constraints.inRange(100, 30000, self.base.max_current_ma);
        constraints.inRange(5000, 30000, self.base.max_rpm);

        constraints.inRange(100, 3000, self.kv_rating);
        constraints.inRange(50, 100, self.max_throttle_pct);

        // KV * voltage should approximate max RPM
        const estimated_rpm = @as(u32, self.kv_rating) * self.base.rated_voltage_mv / 1000;
        const rpm_diff = if (estimated_rpm > self.base.max_rpm)
            estimated_rpm - self.base.max_rpm
        else
            self.base.max_rpm - estimated_rpm;

        if (rpm_diff > self.base.max_rpm / 4)
            @compileError(std.fmt.comptimePrint(
                "KV*voltage={} RPM is more than 25% off from max_rpm={}",
                .{ estimated_rpm, self.base.max_rpm },
            ));
    }
};

// Industrial servo variant: lower RPM, higher precision
const ServoConfig = struct {
    base: BaseMotorConfig,
    encoder_ppr: u16,
    position_loop_hz: u16,

    pub fn validate(comptime self: ServoConfig) void {
        self.base.validate();

        constraints.inRange(24000, 48000, self.base.rated_voltage_mv);
        constraints.inRange(100, 10000, self.base.max_rpm);
        constraints.isPowerOfTwo(self.encoder_ppr);
        constraints.inRange(256, 16384, self.encoder_ppr);
        constraints.inRange(1000, 20000, self.position_loop_hz);

        // Position loop must run fast enough relative to max RPM
        // At max RPM, encoder produces ppr * rpm/60 pulses/sec
        // Loop must sample at least 10x per encoder pulse
        const pulses_per_sec = @as(u32, self.encoder_ppr) * self.base.max_rpm / 60;
        if (self.position_loop_hz < pulses_per_sec / 100)
            @compileError("position loop too slow for encoder resolution at max RPM");
    }
};

const drone_motor = contracts.validated(SmallBldcConfig, SmallBldcConfig{
    .base = .{
        .rated_voltage_mv = 14800,
        .max_current_ma = 20000,
        .pwm_frequency_hz = 48000,
        .dead_time_ns = 100,
        .pole_pairs = 7,
        .max_rpm = 25000,
    },
    .kv_rating = 1550,
    .max_throttle_pct = 100,
});

const cnc_servo = contracts.validated(ServoConfig, ServoConfig{
    .base = .{
        .rated_voltage_mv = 48000,
        .max_current_ma = 5000,
        .pwm_frequency_hz = 20000,
        .dead_time_ns = 500,
        .pole_pairs = 4,
        .max_rpm = 3000,
    },
    .encoder_ppr = 4096,
    .position_loop_hz = 10000,
});

test "drone motor passes both base and variant validation" {
    comptime {
        contracts.assertValid(SmallBldcConfig, drone_motor);
        contracts.assertValid(BaseMotorConfig, drone_motor.base);
    }
}

test "cnc servo passes both base and variant validation" {
    comptime {
        contracts.assertValid(ServoConfig, cnc_servo);
        contracts.assertValid(BaseMotorConfig, cnc_servo.base);
    }
}

// --- Generated Array with Running Constraint ---
// Each element depends on a global property of all preceding elements.
// Alarm thresholds where each must be at least 20% above the previous,
// and the total span (max - min) must not exceed 10x the first value.

const AlarmLevel = struct {
    threshold: u32,
    severity: u8,
    debounce_ms: u16,
};

const alarm_levels = blk: {
    const gen = struct {
        fn f(comptime i: usize) AlarmLevel {
            const base: u32 = 100;
            // Each level is 50% above the previous
            var threshold: u32 = base;
            for (0..i) |_| {
                threshold = threshold * 3 / 2;
            }
            return .{
                .threshold = threshold,
                .severity = @intCast(i + 1),
                .debounce_ms = @intCast(500 - i * 50),
            };
        }
    }.f;
    const levels = generators.generateArray(AlarmLevel, 8, gen);

    // Running constraint: each level > 120% of previous
    for (1..levels.len) |i| {
        if (levels[i].threshold * 100 <= levels[i - 1].threshold * 120)
            @compileError("each alarm level must be at least 20% above the previous");
    }

    // Global constraint: total span <= 10x first value
    if (levels[levels.len - 1].threshold > levels[0].threshold * 30)
        @compileError("alarm span exceeds 30x the base threshold");

    // Severity must be strictly increasing
    for (1..levels.len) |i| {
        if (levels[i].severity <= levels[i - 1].severity)
            @compileError("severity must increase with threshold");
    }

    // Debounce must decrease (higher severity = faster response)
    for (1..levels.len) |i| {
        if (levels[i].debounce_ms >= levels[i - 1].debounce_ms)
            @compileError("debounce must decrease with severity");
    }

    break :blk levels;
};

test "alarm levels are exponentially spaced" {
    comptime {
        try std.testing.expectEqual(8, alarm_levels.len);
        try std.testing.expectEqual(100, alarm_levels[0].threshold);
        for (1..alarm_levels.len) |i| {
            try std.testing.expect(alarm_levels[i].threshold > alarm_levels[i - 1].threshold);
        }
    }
}

test "alarm severity increases with threshold" {
    comptime {
        for (1..alarm_levels.len) |i| {
            try std.testing.expect(alarm_levels[i].severity > alarm_levels[i - 1].severity);
        }
    }
}

test "alarm debounce decreases with severity" {
    comptime {
        for (1..alarm_levels.len) |i| {
            try std.testing.expect(alarm_levels[i].debounce_ms < alarm_levels[i - 1].debounce_ms);
        }
    }
}

// --- Product Configuration Matrix ---
// Multiple product variants share a common base, each with
// a feature set. Validate that all variants are internally
// consistent and that no two variants have identical feature sets.

const Feature = enum(u8) { wifi, bluetooth, lte, gps, nfc, zigbee };

const ProductVariant = struct {
    sku_id: u16,
    motor: BaseMotorConfig,
    features: []const Feature,
    price_cents: u32,
};

fn validateProductLine(comptime variants: []const ProductVariant) void {
    @setEvalBranchQuota(5000);
    constraints.lenInRange(2, 16, variants.len);

    var skus: [variants.len]u16 = undefined;
    for (variants, 0..) |v, i| {
        skus[i] = v.sku_id;
        v.motor.validate();
        constraints.lenInRange(0, 6, v.features.len);
        constraints.nonZero(v.price_cents);

        // No duplicate features within a variant
        for (0..v.features.len) |fi| {
            for (fi + 1..v.features.len) |fj| {
                if (v.features[fi] == v.features[fj])
                    @compileError(std.fmt.comptimePrint(
                        "SKU {} has duplicate feature",
                        .{v.sku_id},
                    ));
            }
        }
    }
    constraints.noDuplicates(u16, &skus);

    // No two variants can have identical feature sets
    for (0..variants.len) |i| {
        for (i + 1..variants.len) |j| {
            if (variants[i].features.len == variants[j].features.len) {
                var all_match = true;
                for (variants[i].features) |fi| {
                    var found = false;
                    for (variants[j].features) |fj| {
                        if (fi == fj) {
                            found = true;
                            break;
                        }
                    }
                    if (!found) {
                        all_match = false;
                        break;
                    }
                }
                if (all_match)
                    @compileError(std.fmt.comptimePrint(
                        "SKUs {} and {} have identical feature sets",
                        .{ variants[i].sku_id, variants[j].sku_id },
                    ));
            }
        }
    }

    // More features should cost more (loose check: no variant with strictly
    // more features should cost less)
    for (0..variants.len) |i| {
        for (i + 1..variants.len) |j| {
            if (variants[i].features.len > variants[j].features.len and
                variants[i].price_cents < variants[j].price_cents)
                @compileError(std.fmt.comptimePrint(
                    "SKU {} has more features but costs less than SKU {}",
                    .{ variants[i].sku_id, variants[j].sku_id },
                ));
            if (variants[j].features.len > variants[i].features.len and
                variants[j].price_cents < variants[i].price_cents)
                @compileError(std.fmt.comptimePrint(
                    "SKU {} has more features but costs less than SKU {}",
                    .{ variants[j].sku_id, variants[i].sku_id },
                ));
        }
    }
}

const base_motor = BaseMotorConfig{
    .rated_voltage_mv = 24000,
    .max_current_ma = 5000,
    .pwm_frequency_hz = 20000,
    .dead_time_ns = 500,
    .pole_pairs = 4,
    .max_rpm = 3000,
};

const product_line = blk: {
    const variants = [_]ProductVariant{
        .{ .sku_id = 1001, .motor = base_motor, .features = &.{.wifi}, .price_cents = 9900 },
        .{ .sku_id = 1002, .motor = base_motor, .features = &.{ .wifi, .bluetooth }, .price_cents = 12900 },
        .{ .sku_id = 1003, .motor = base_motor, .features = &.{ .wifi, .bluetooth, .gps }, .price_cents = 17900 },
        .{ .sku_id = 1004, .motor = base_motor, .features = &.{ .wifi, .bluetooth, .lte, .gps }, .price_cents = 24900 },
        .{ .sku_id = 1005, .motor = base_motor, .features = &.{ .wifi, .bluetooth, .lte, .gps, .nfc, .zigbee }, .price_cents = 34900 },
    };
    validateProductLine(&variants);
    break :blk variants;
};

test "product line has unique SKUs" {
    comptime {
        try std.testing.expectEqual(5, product_line.len);
    }
}

test "product line price increases with features" {
    comptime {
        for (1..product_line.len) |i| {
            try std.testing.expect(product_line[i].price_cents > product_line[i - 1].price_cents);
            try std.testing.expect(product_line[i].features.len > product_line[i - 1].features.len);
        }
    }
}
