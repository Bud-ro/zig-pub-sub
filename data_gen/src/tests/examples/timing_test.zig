const std = @import("std");
const contract = @import("data_gen").contract;

// --- Sample Rate Configuration ---

const SampleRateConfig = struct {
    rate_hz: u32,
    oversample_factor: u8,
    averaging_window: u16,

    pub fn contractValidate(comptime self: SampleRateConfig) ?[]const u8 {
        if (self.rate_hz != 100 and self.rate_hz != 200 and self.rate_hz != 500 and
            self.rate_hz != 1000 and self.rate_hz != 2000 and self.rate_hz != 5000 and self.rate_hz != 10000)
            return "rate_hz must be one of 100, 200, 500, 1000, 2000, 5000, 10000";
        if (self.oversample_factor == 0 or (self.oversample_factor & (self.oversample_factor - 1)) != 0)
            return "oversample_factor must be a power of two";
        if (self.oversample_factor < 1 or self.oversample_factor > 64) return "oversample_factor out of range [1, 64]";
        if (self.averaging_window < 1 or self.averaging_window > 1024) return "averaging_window out of range [1, 1024]";
        if (self.averaging_window > self.rate_hz)
            return "averaging window cannot exceed sample rate";
        return null;
    }

    pub fn generate(comptime self: SampleRateConfig) SampleRateConfig {
        contract.assertValid(self);
        return self;
    }

    /// Effective rate including oversampling.
    pub fn effectiveRate(comptime self: SampleRateConfig) u32 {
        return self.rate_hz * self.oversample_factor;
    }
};

test "sample rate 1kHz with 4x oversample" {
    comptime {
        const cfg = SampleRateConfig.generate(.{ .rate_hz = 1000, .oversample_factor = 4, .averaging_window = 100 });
        try std.testing.expectEqual(4000, cfg.effectiveRate());
    }
}

test "sample rate all standard rates valid" {
    comptime {
        const rates = [_]u32{ 100, 200, 500, 1000, 2000, 5000, 10000 };
        for (rates) |rate| {
            _ = SampleRateConfig.generate(.{ .rate_hz = rate, .oversample_factor = 1, .averaging_window = 1 });
        }
    }
}

// --- Timeout / Debounce Configuration ---

const TimingConfig = struct {
    timeout_ms: u32,
    debounce_ms: u16,
    periodic_interval_ms: u32,
    retry_delay_ms: u16,
    max_retries: u8,

    pub fn contractValidate(comptime self: TimingConfig) ?[]const u8 {
        if (self.timeout_ms < 10 or self.timeout_ms > 30_000) return "timeout_ms out of range [10, 30000]";
        if (self.debounce_ms < 1 or self.debounce_ms > 500) return "debounce_ms out of range [1, 500]";
        if (self.periodic_interval_ms < 1 or self.periodic_interval_ms > 60_000) return "periodic_interval_ms out of range [1, 60000]";
        if (self.retry_delay_ms < 10 or self.retry_delay_ms > 5000) return "retry_delay_ms out of range [10, 5000]";
        if (self.max_retries > 10) return "max_retries out of range [0, 10]";

        if (self.timeout_ms <= self.debounce_ms) return "timeout_ms must be greater than debounce_ms";

        if (self.periodic_interval_ms < 2 * @as(u32, self.debounce_ms))
            return "periodic_interval_ms must be at least 2x debounce_ms";

        if (self.max_retries > 0) {
            const total_retry_time = @as(u32, self.retry_delay_ms) * self.max_retries;
            if (total_retry_time > self.timeout_ms)
                return "total retry time exceeds timeout";
        }
        return null;
    }

    pub fn generate(comptime self: TimingConfig) TimingConfig {
        contract.assertValid(self);
        return self;
    }
};

test "timing config standard polling" {
    comptime {
        const cfg = TimingConfig.generate(.{
            .timeout_ms = 5000,
            .debounce_ms = 50,
            .periodic_interval_ms = 200,
            .retry_delay_ms = 500,
            .max_retries = 3,
        });
        try std.testing.expectEqual(5000, cfg.timeout_ms);
        try std.testing.expectEqual(50, cfg.debounce_ms);
    }
}

test "timing config no retries" {
    comptime {
        _ = TimingConfig.generate(.{
            .timeout_ms = 1000,
            .debounce_ms = 10,
            .periodic_interval_ms = 100,
            .retry_delay_ms = 100,
            .max_retries = 0,
        });
    }
}

test "timing config aggressive debounce" {
    comptime {
        _ = TimingConfig.generate(.{
            .timeout_ms = 10000,
            .debounce_ms = 500,
            .periodic_interval_ms = 1000,
            .retry_delay_ms = 1000,
            .max_retries = 5,
        });
    }
}

// --- Tick-based Timer System ---

const TickConfig = struct {
    tick_period_us: u32,
    ticks_per_ms: u32,

    pub fn contractValidate(comptime self: TickConfig) ?[]const u8 {
        if (self.tick_period_us == 0) return "tick_period_us must not be zero";
        if (self.ticks_per_ms == 0) return "ticks_per_ms must not be zero";
        if (self.tick_period_us * self.ticks_per_ms != 1000)
            return "tick_period_us * ticks_per_ms must equal 1000 (1ms)";
        return null;
    }

    pub fn generate(comptime self: TickConfig) TickConfig {
        contract.assertValid(self);
        return self;
    }
};

test "tick config 1ms tick" {
    comptime {
        _ = TickConfig.generate(.{ .tick_period_us = 1000, .ticks_per_ms = 1 });
    }
}

test "tick config 500us tick" {
    comptime {
        _ = TickConfig.generate(.{ .tick_period_us = 500, .ticks_per_ms = 2 });
    }
}

test "tick config 250us tick" {
    comptime {
        _ = TickConfig.generate(.{ .tick_period_us = 250, .ticks_per_ms = 4 });
    }
}

test "tick config 125us tick" {
    comptime {
        _ = TickConfig.generate(.{ .tick_period_us = 125, .ticks_per_ms = 8 });
    }
}

// --- PWM Timer Configuration ---

const PwmConfig = struct {
    frequency_hz: u32,
    resolution_bits: u8,
    dead_time_ns: u16,

    pub fn contractValidate(comptime self: PwmConfig) ?[]const u8 {
        if (self.frequency_hz < 1_000 or self.frequency_hz > 1_000_000) return "frequency_hz out of range [1000, 1000000]";
        if (self.resolution_bits < 8 or self.resolution_bits > 16) return "resolution_bits out of range [8, 16]";
        if (self.dead_time_ns > 5000) return "dead_time_ns out of range [0, 5000]";

        const max_count: u32 = @as(u32, 1) << self.resolution_bits;
        const period_ns: u32 = 1_000_000_000 / self.frequency_hz;
        const step_ns = period_ns / max_count;
        if (self.dead_time_ns > 0 and self.dead_time_ns < step_ns)
            return "dead time is smaller than one PWM step — it would have no effect";
        return null;
    }

    pub fn generate(comptime self: PwmConfig) PwmConfig {
        contract.assertValid(self);
        return self;
    }
};

test "PWM config 20kHz 10-bit" {
    comptime {
        const cfg = PwmConfig.generate(.{ .frequency_hz = 20_000, .resolution_bits = 10, .dead_time_ns = 500 });
        try std.testing.expectEqual(20_000, cfg.frequency_hz);
    }
}

test "PWM config 1MHz 8-bit no dead time" {
    comptime {
        _ = PwmConfig.generate(.{ .frequency_hz = 1_000_000, .resolution_bits = 8, .dead_time_ns = 0 });
    }
}

// --- Composed: Timing Profile ---

const TimingProfile = struct {
    name_id: u8,
    sample_rate: SampleRateConfig,
    timing: TimingConfig,
    tick: TickConfig,

    pub fn contractValidate(comptime self: TimingProfile) ?[]const u8 {
        const sample_period_ms = 1000 / self.sample_rate.rate_hz;
        if (self.timing.periodic_interval_ms % sample_period_ms != 0)
            return "periodic interval must be aligned to sample period";
        return null;
    }
};

test "timing profile with aligned intervals" {
    comptime {
        contract.assertValid(TimingProfile{
            .name_id = 1,
            .sample_rate = SampleRateConfig.generate(.{ .rate_hz = 1000, .oversample_factor = 1, .averaging_window = 50 }),
            .timing = TimingConfig.generate(.{
                .timeout_ms = 5000,
                .debounce_ms = 50,
                .periodic_interval_ms = 200,
                .retry_delay_ms = 500,
                .max_retries = 3,
            }),
            .tick = TickConfig.generate(.{ .tick_period_us = 1000, .ticks_per_ms = 1 }),
        });
    }
}
