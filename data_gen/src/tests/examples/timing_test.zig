const std = @import("std");
const constraints = @import("data_gen").constraints;
const contracts = @import("data_gen").contracts;

// --- Sample Rate Configuration ---

const SampleRateConfig = struct {
    rate_hz: u32,
    oversample_factor: u8,
    averaging_window: u16,

    pub fn validate(comptime self: SampleRateConfig) void {
        constraints.oneOf(u32, &.{ 100, 200, 500, 1000, 2000, 5000, 10000 }, self.rate_hz);
        constraints.isPowerOfTwo(self.oversample_factor);
        constraints.inRange(u8, 1, 64, self.oversample_factor);
        constraints.inRange(u16, 1, 1024, self.averaging_window);
        if (self.averaging_window > self.rate_hz)
            @compileError("averaging window cannot exceed sample rate");
    }

    pub fn generate(comptime self: SampleRateConfig) SampleRateConfig {
        self.validate();
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

    pub fn validate(comptime self: TimingConfig) void {
        constraints.inRange(u32, 10, 30_000, self.timeout_ms);
        constraints.inRange(u16, 1, 500, self.debounce_ms);
        constraints.inRange(u32, 1, 60_000, self.periodic_interval_ms);
        constraints.inRange(u16, 10, 5000, self.retry_delay_ms);
        constraints.inRange(u8, 0, 10, self.max_retries);

        constraints.greaterThan(u32, self.timeout_ms, self.debounce_ms);

        if (self.periodic_interval_ms < 2 * @as(u32, self.debounce_ms))
            @compileError("periodic_interval_ms must be at least 2x debounce_ms");

        if (self.max_retries > 0) {
            const total_retry_time = @as(u32, self.retry_delay_ms) * self.max_retries;
            if (total_retry_time > self.timeout_ms)
                @compileError("total retry time exceeds timeout");
        }
    }

    pub fn generate(comptime self: TimingConfig) TimingConfig {
        self.validate();
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

    pub fn validate(comptime self: TickConfig) void {
        constraints.nonZero(u32, self.tick_period_us);
        constraints.nonZero(u32, self.ticks_per_ms);
        if (self.tick_period_us * self.ticks_per_ms != 1000)
            @compileError("tick_period_us * ticks_per_ms must equal 1000 (1ms)");
    }

    pub fn generate(comptime self: TickConfig) TickConfig {
        self.validate();
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

    pub fn validate(comptime self: PwmConfig) void {
        constraints.inRange(u32, 1_000, 1_000_000, self.frequency_hz);
        constraints.inRange(u8, 8, 16, self.resolution_bits);
        constraints.inRange(u16, 0, 5000, self.dead_time_ns);

        const max_count: u32 = @as(u32, 1) << self.resolution_bits;
        const period_ns: u32 = 1_000_000_000 / self.frequency_hz;
        const step_ns = period_ns / max_count;
        if (self.dead_time_ns > 0 and self.dead_time_ns < step_ns)
            @compileError("dead time is smaller than one PWM step — it would have no effect");
    }

    pub fn generate(comptime self: PwmConfig) PwmConfig {
        self.validate();
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

    pub fn validate(comptime self: TimingProfile) void {
        self.sample_rate.validate();
        self.timing.validate();
        self.tick.validate();

        const sample_period_ms = 1000 / self.sample_rate.rate_hz;
        if (self.timing.periodic_interval_ms % sample_period_ms != 0)
            @compileError("periodic interval must be aligned to sample period");
    }
};

test "timing profile with aligned intervals" {
    comptime {
        contracts.assertValid(TimingProfile, TimingProfile{
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
