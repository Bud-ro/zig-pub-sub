const std = @import("std");
const constraints = @import("data_gen").constraints;
const contracts = @import("data_gen").contracts;

// --- Application Version ---

const AppVersion = struct {
    major: u8,
    minor: u8,
    patch: u16,

    pub fn validate(comptime self: AppVersion) void {
        constraints.inRange(u8, 0, 99, self.major);
        constraints.inRange(u8, 0, 99, self.minor);
    }

    pub fn generate(comptime self: AppVersion) AppVersion {
        self.validate();
        return self;
    }

    pub fn toU32(comptime self: AppVersion) u32 {
        return @as(u32, self.major) << 24 |
            @as(u32, self.minor) << 16 |
            @as(u32, self.patch);
    }
};

test "application version packs into u32" {
    comptime {
        const v = AppVersion.generate(.{ .major = 1, .minor = 2, .patch = 345 });
        try std.testing.expectEqual(@as(u32, 0x01020159), v.toU32());
    }
}

test "application version boundary values" {
    comptime {
        _ = AppVersion.generate(.{ .major = 0, .minor = 0, .patch = 0 });
        _ = AppVersion.generate(.{ .major = 99, .minor = 99, .patch = 65535 });
    }
}

// --- Network Configuration ---

const NetworkConfig = struct {
    port: u16,
    mtu: u16,
    max_connections: u16,
    keepalive_seconds: u16,

    pub fn validate(comptime self: NetworkConfig) void {
        constraints.inRange(u16, 1, 65535, self.port);
        constraints.isPowerOfTwo(self.mtu);
        constraints.inRange(u16, 64, 9000, self.mtu);
        constraints.inRange(u16, 1, 1024, self.max_connections);
        constraints.nonZero(u16, self.keepalive_seconds);
        constraints.inRange(u16, 1, 3600, self.keepalive_seconds);
    }

    pub fn generate(comptime self: NetworkConfig) NetworkConfig {
        self.validate();
        return self;
    }
};

test "network config with power-of-two MTU" {
    comptime {
        const cfg = NetworkConfig.generate(.{ .port = 8080, .mtu = 1024, .max_connections = 128, .keepalive_seconds = 30 });
        try std.testing.expectEqual(8080, cfg.port);
        try std.testing.expectEqual(1024, cfg.mtu);
    }
}

test "network config various valid MTU sizes" {
    comptime {
        _ = NetworkConfig.generate(.{ .port = 80, .mtu = 64, .max_connections = 1, .keepalive_seconds = 1 });
        _ = NetworkConfig.generate(.{ .port = 443, .mtu = 128, .max_connections = 512, .keepalive_seconds = 3600 });
        _ = NetworkConfig.generate(.{ .port = 9999, .mtu = 256, .max_connections = 1024, .keepalive_seconds = 60 });
        _ = NetworkConfig.generate(.{ .port = 1234, .mtu = 512, .max_connections = 100, .keepalive_seconds = 120 });
        _ = NetworkConfig.generate(.{ .port = 5000, .mtu = 4096, .max_connections = 50, .keepalive_seconds = 300 });
        _ = NetworkConfig.generate(.{ .port = 6000, .mtu = 8192, .max_connections = 10, .keepalive_seconds = 900 });
    }
}

// --- Feature Flags with Mutual Exclusion ---

const FeatureFlags = struct {
    debug_logging: bool,
    release_optimized: bool,
    profiling: bool,
    assertions_enabled: bool,

    pub fn validate(comptime self: FeatureFlags) void {
        if (self.debug_logging and self.release_optimized)
            @compileError("debug_logging and release_optimized are mutually exclusive");
        if (self.release_optimized and self.assertions_enabled)
            @compileError("release_optimized disables assertions");
        if (self.profiling and !self.debug_logging)
            @compileError("profiling requires debug_logging");
    }
};

test "feature flags debug configuration" {
    comptime {
        contracts.assertValid(FeatureFlags, FeatureFlags{
            .debug_logging = true,
            .release_optimized = false,
            .profiling = true,
            .assertions_enabled = true,
        });
    }
}

test "feature flags release configuration" {
    comptime {
        contracts.assertValid(FeatureFlags, FeatureFlags{
            .debug_logging = false,
            .release_optimized = true,
            .profiling = false,
            .assertions_enabled = false,
        });
    }
}

test "feature flags minimal configuration" {
    comptime {
        contracts.assertValid(FeatureFlags, FeatureFlags{
            .debug_logging = false,
            .release_optimized = false,
            .profiling = false,
            .assertions_enabled = true,
        });
    }
}

// --- Sensor Thresholds ---

const SensorThresholds = struct {
    warning_low: i16,
    critical_low: i16,
    warning_high: i16,
    critical_high: i16,

    pub fn validate(comptime self: SensorThresholds) void {
        constraints.lessThan(i16, self.critical_low, self.warning_low);
        constraints.lessThan(i16, self.warning_low, self.warning_high);
        constraints.lessThan(i16, self.warning_high, self.critical_high);
        constraints.inRange(i16, -200, 200, self.critical_low);
        constraints.inRange(i16, -200, 200, self.critical_high);
    }
};

test "sensor thresholds with ordered bands" {
    comptime {
        contracts.assertValid(SensorThresholds, SensorThresholds{
            .critical_low = -40,
            .warning_low = -10,
            .warning_high = 80,
            .critical_high = 100,
        });
    }
}

test "sensor thresholds negative-only range" {
    comptime {
        contracts.assertValid(SensorThresholds, SensorThresholds{
            .critical_low = -200,
            .warning_low = -150,
            .warning_high = -50,
            .critical_high = -10,
        });
    }
}

// --- Multiple configs composed together ---

const SystemConfig = struct {
    version: AppVersion,
    network: NetworkConfig,
    flags: FeatureFlags,
    thresholds: SensorThresholds,

    pub fn validate(comptime self: SystemConfig) void {
        self.version.validate();
        self.network.validate();
        self.flags.validate();
        self.thresholds.validate();

        if (self.flags.debug_logging and self.network.max_connections > 64)
            @compileError("debug mode limits connections to 64");
    }
};

test "full system config composition" {
    comptime {
        contracts.assertValid(SystemConfig, SystemConfig{
            .version = AppVersion.generate(.{ .major = 2, .minor = 1, .patch = 0 }),
            .network = NetworkConfig.generate(.{ .port = 8080, .mtu = 1024, .max_connections = 64, .keepalive_seconds = 30 }),
            .flags = FeatureFlags{
                .debug_logging = true,
                .release_optimized = false,
                .profiling = true,
                .assertions_enabled = true,
            },
            .thresholds = SensorThresholds{
                .critical_low = -40,
                .warning_low = -10,
                .warning_high = 80,
                .critical_high = 100,
            },
        });
    }
}
