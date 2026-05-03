const std = @import("std");
const constraint = @import("data_gen").constraint;
const contract = @import("data_gen").contract;
const generator = @import("data_gen").generator;

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

    pub fn validate(comptime self: BaseMotorConfig) ?[]const u8 {
        if (self.rated_voltage_mv < 3000 or self.rated_voltage_mv > 48000) return "rated_voltage_mv out of range [3000, 48000]";
        if (self.max_current_ma < 100 or self.max_current_ma > 50000) return "max_current_ma out of range [100, 50000]";
        if (self.pwm_frequency_hz < 1000 or self.pwm_frequency_hz > 100000) return "pwm_frequency_hz out of range [1000, 100000]";
        if (self.dead_time_ns > 5000) return "dead_time_ns out of range [0, 5000]";
        if (self.pole_pairs < 1 or self.pole_pairs > 8) return "pole_pairs must be in range [1, 8]";
        if (self.max_rpm < 100 or self.max_rpm > 30000) return "max_rpm out of range [100, 30000]";

        // Dead time must be meaningful relative to PWM period
        const period_ns: u32 = 1_000_000_000 / self.pwm_frequency_hz;
        if (self.dead_time_ns > 0 and @as(u32, self.dead_time_ns) * 100 > period_ns)
            return "dead time exceeds 1% of PWM period";
        return null;
    }
};

// Small BLDC variant (drone motor): tighter voltage/current, high RPM
const SmallBldcConfig = struct {
    base: BaseMotorConfig,
    kv_rating: u16, // RPM per volt
    max_throttle_pct: u8,

    pub fn validate(comptime self: SmallBldcConfig) ?[]const u8 {
        if (self.base.rated_voltage_mv < 11000 or self.base.rated_voltage_mv > 25200)
            return "rated_voltage_mv out of range [11000, 25200] for SmallBldc";
        if (self.base.max_current_ma < 100 or self.base.max_current_ma > 30000)
            return "max_current_ma out of range [100, 30000] for SmallBldc";
        if (self.base.max_rpm < 5000 or self.base.max_rpm > 30000)
            return "max_rpm out of range [5000, 30000] for SmallBldc";

        if (self.kv_rating < 100 or self.kv_rating > 3000) return "kv_rating out of range [100, 3000]";
        if (self.max_throttle_pct < 50 or self.max_throttle_pct > 100) return "max_throttle_pct out of range [50, 100]";

        // KV * voltage should approximate max RPM
        const estimated_rpm = @as(u32, self.kv_rating) * self.base.rated_voltage_mv / 1000;
        const rpm_diff = if (estimated_rpm > self.base.max_rpm)
            estimated_rpm - self.base.max_rpm
        else
            self.base.max_rpm - estimated_rpm;

        if (rpm_diff > self.base.max_rpm / 4)
            return std.fmt.comptimePrint(
                "KV*voltage={} RPM is more than 25% off from max_rpm={}",
                .{ estimated_rpm, self.base.max_rpm },
            );
        return null;
    }
};

// Industrial servo variant: lower RPM, higher precision
const ServoConfig = struct {
    base: BaseMotorConfig,
    encoder_ppr: u16,
    position_loop_hz: u16,

    pub fn validate(comptime self: ServoConfig) ?[]const u8 {
        if (self.base.rated_voltage_mv < 24000 or self.base.rated_voltage_mv > 48000)
            return "rated_voltage_mv out of range [24000, 48000] for Servo";
        if (self.base.max_rpm < 100 or self.base.max_rpm > 10000)
            return "max_rpm out of range [100, 10000] for Servo";
        if (self.encoder_ppr == 0 or (self.encoder_ppr & (self.encoder_ppr - 1)) != 0)
            return "encoder_ppr must be a power of two";
        if (self.encoder_ppr < 256 or self.encoder_ppr > 16384) return "encoder_ppr out of range [256, 16384]";
        if (self.position_loop_hz < 1000 or self.position_loop_hz > 20000) return "position_loop_hz out of range [1000, 20000]";

        // Position loop must run fast enough relative to max RPM
        // At max RPM, encoder produces ppr * rpm/60 pulses/sec
        // Loop must sample at least 1% of the encoder pulse rate
        const pulses_per_sec = @as(u32, self.encoder_ppr) * self.base.max_rpm / 60;
        if (self.position_loop_hz < pulses_per_sec / 100)
            return "position loop too slow for encoder resolution at max RPM";
        return null;
    }
};

const drone_motor = contract.validated(SmallBldcConfig{
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

const cnc_servo = contract.validated(ServoConfig{
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
        contract.assertValid(drone_motor);
        contract.assertValid(drone_motor.base);
    }
}

test "cnc servo passes both base and variant validation" {
    comptime {
        contract.assertValid(cnc_servo);
        contract.assertValid(cnc_servo.base);
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

    pub fn validate(comptime self: AlarmLevel) ?[]const u8 {
        if (constraint.nonZero(self.threshold)) |err| return err;
        if (constraint.inRange(@as(u8, 1), @as(u8, 8), self.severity)) |err| return err;
        if (constraint.nonZero(self.debounce_ms)) |err| return err;
        return null;
    }
};

const AlarmLevels = struct {
    levels: [8]AlarmLevel,

    pub fn validate(comptime self: AlarmLevels) ?[]const u8 {
        // Running constraint: each level > 120% of previous
        for (1..self.levels.len) |i| {
            if (self.levels[i].threshold * 100 <= self.levels[i - 1].threshold * 120)
                return "each alarm level must be at least 20% above the previous";
        }

        // Global constraint: total span <= 30x first value
        if (self.levels[self.levels.len - 1].threshold > self.levels[0].threshold * 30)
            return "alarm span exceeds 30x the base threshold";

        // Severity must be strictly increasing
        for (1..self.levels.len) |i| {
            if (self.levels[i].severity <= self.levels[i - 1].severity)
                return "severity must increase with threshold";
        }

        // Debounce must decrease (higher severity = faster response)
        for (1..self.levels.len) |i| {
            if (self.levels[i].debounce_ms >= self.levels[i - 1].debounce_ms)
                return "debounce must decrease with severity";
        }

        return null;
    }
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
    const levels = generator.generateArray(AlarmLevel, 8, gen);

    const wrapper = contract.validated(AlarmLevels{ .levels = levels });
    break :blk wrapper.levels;
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

    pub fn validate(comptime self: ProductVariant) ?[]const u8 {
        if (constraint.lenInRange(0, 6, self.features.len)) |err| return err;
        if (constraint.nonZero(self.price_cents)) |err| return err;

        // No duplicate features within a variant
        for (0..self.features.len) |fi| {
            for (fi + 1..self.features.len) |fj| {
                if (self.features[fi] == self.features[fj])
                    return std.fmt.comptimePrint(
                        "SKU {} has duplicate feature",
                        .{self.sku_id},
                    );
            }
        }
        return null;
    }
};

const ProductLine = struct {
    variants: []const ProductVariant,

    pub fn validate(comptime self: ProductLine) ?[]const u8 {
        @setEvalBranchQuota(5000);
        if (constraint.lenInRange(2, 16, self.variants.len)) |err| return err;

        var skus: [self.variants.len]u16 = undefined;
        for (self.variants, 0..) |v, i| {
            skus[i] = v.sku_id;
        }
        if (constraint.noDuplicates(u16, &skus)) |err| return err;

        // No two variants can have identical feature sets
        for (0..self.variants.len) |i| {
            for (i + 1..self.variants.len) |j| {
                if (self.variants[i].features.len == self.variants[j].features.len) {
                    var all_match = true;
                    for (self.variants[i].features) |fi| {
                        var found = false;
                        for (self.variants[j].features) |fj| {
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
                        return std.fmt.comptimePrint(
                            "SKUs {} and {} have identical feature sets",
                            .{ self.variants[i].sku_id, self.variants[j].sku_id },
                        );
                }
            }
        }

        // More features should cost more (loose check: no variant with strictly
        // more features should cost less)
        for (0..self.variants.len) |i| {
            for (i + 1..self.variants.len) |j| {
                if (self.variants[i].features.len > self.variants[j].features.len and
                    self.variants[i].price_cents < self.variants[j].price_cents)
                    return std.fmt.comptimePrint(
                        "SKU {} has more features but costs less than SKU {}",
                        .{ self.variants[i].sku_id, self.variants[j].sku_id },
                    );
                if (self.variants[j].features.len > self.variants[i].features.len and
                    self.variants[j].price_cents < self.variants[i].price_cents)
                    return std.fmt.comptimePrint(
                        "SKU {} has more features but costs less than SKU {}",
                        .{ self.variants[j].sku_id, self.variants[i].sku_id },
                    );
            }
        }
        return null;
    }
};

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
    const validated = contract.validated(ProductLine{ .variants = &variants });
    break :blk validated.variants;
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
