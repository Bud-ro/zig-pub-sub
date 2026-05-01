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

    pub fn generate(
        comptime rate: u32,
        comptime oversample: u8,
        comptime window: u16,
    ) SampleRateConfig {
        const self = SampleRateConfig{
            .rate_hz = rate,
            .oversample_factor = oversample,
            .averaging_window = window,
        };
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
        const cfg = SampleRateConfig.generate(1000, 4, 100);
        try std.testing.expectEqual(4000, cfg.effectiveRate());
    }
}

test "sample rate all standard rates valid" {
    comptime {
        const rates = [_]u32{ 100, 200, 500, 1000, 2000, 5000, 10000 };
        for (rates) |rate| {
            _ = SampleRateConfig.generate(rate, 1, 1);
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

    pub fn generate(
        comptime timeout: u32,
        comptime debounce: u16,
        comptime interval: u32,
        comptime retry_delay: u16,
        comptime max_retries: u8,
    ) TimingConfig {
        const self = TimingConfig{
            .timeout_ms = timeout,
            .debounce_ms = debounce,
            .periodic_interval_ms = interval,
            .retry_delay_ms = retry_delay,
            .max_retries = max_retries,
        };
        self.validate();
        return self;
    }
};

test "timing config standard polling" {
    comptime {
        const cfg = TimingConfig.generate(5000, 50, 200, 500, 3);
        try std.testing.expectEqual(5000, cfg.timeout_ms);
        try std.testing.expectEqual(50, cfg.debounce_ms);
    }
}

test "timing config no retries" {
    comptime {
        _ = TimingConfig.generate(1000, 10, 100, 100, 0);
    }
}

test "timing config aggressive debounce" {
    comptime {
        _ = TimingConfig.generate(10000, 500, 1000, 1000, 5);
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

    pub fn generate(comptime period_us: u32, comptime ticks: u32) TickConfig {
        const self = TickConfig{ .tick_period_us = period_us, .ticks_per_ms = ticks };
        self.validate();
        return self;
    }
};

test "tick config 1ms tick" {
    comptime {
        _ = TickConfig.generate(1000, 1);
    }
}

test "tick config 500us tick" {
    comptime {
        _ = TickConfig.generate(500, 2);
    }
}

test "tick config 250us tick" {
    comptime {
        _ = TickConfig.generate(250, 4);
    }
}

test "tick config 125us tick" {
    comptime {
        _ = TickConfig.generate(125, 8);
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

    pub fn generate(comptime freq: u32, comptime bits: u8, comptime dead: u16) PwmConfig {
        const self = PwmConfig{ .frequency_hz = freq, .resolution_bits = bits, .dead_time_ns = dead };
        self.validate();
        return self;
    }
};

test "PWM config 20kHz 10-bit" {
    comptime {
        const cfg = PwmConfig.generate(20_000, 10, 500);
        try std.testing.expectEqual(20_000, cfg.frequency_hz);
    }
}

test "PWM config 1MHz 8-bit no dead time" {
    comptime {
        _ = PwmConfig.generate(1_000_000, 8, 0);
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
        contracts.assertValid(TimingProfile, .{
            .name_id = 1,
            .sample_rate = SampleRateConfig.generate(1000, 1, 50),
            .timing = TimingConfig.generate(5000, 50, 200, 500, 3),
            .tick = TickConfig.generate(1000, 1),
        });
    }
}
