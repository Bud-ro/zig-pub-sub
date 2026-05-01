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

    pub fn generate(comptime major: u8, comptime minor: u8, comptime patch: u16) AppVersion {
        const self = AppVersion{ .major = major, .minor = minor, .patch = patch };
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
        const v = AppVersion.generate(1, 2, 345);
        try std.testing.expectEqual(@as(u32, 0x01020159), v.toU32());
    }
}

test "application version boundary values" {
    comptime {
        _ = AppVersion.generate(0, 0, 0);
        _ = AppVersion.generate(99, 99, 65535);
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

    pub fn generate(
        comptime port: u16,
        comptime mtu: u16,
        comptime max_conn: u16,
        comptime keepalive: u16,
    ) NetworkConfig {
        const self = NetworkConfig{
            .port = port,
            .mtu = mtu,
            .max_connections = max_conn,
            .keepalive_seconds = keepalive,
        };
        self.validate();
        return self;
    }
};

test "network config with power-of-two MTU" {
    comptime {
        const cfg = NetworkConfig.generate(8080, 1024, 128, 30);
        try std.testing.expectEqual(8080, cfg.port);
        try std.testing.expectEqual(1024, cfg.mtu);
    }
}

test "network config various valid MTU sizes" {
    comptime {
        _ = NetworkConfig.generate(80, 64, 1, 1);
        _ = NetworkConfig.generate(443, 128, 512, 3600);
        _ = NetworkConfig.generate(9999, 256, 1024, 60);
        _ = NetworkConfig.generate(1234, 512, 100, 120);
        _ = NetworkConfig.generate(5000, 4096, 50, 300);
        _ = NetworkConfig.generate(6000, 8192, 10, 900);
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
        contracts.assertValid(FeatureFlags, .{
            .debug_logging = true,
            .release_optimized = false,
            .profiling = true,
            .assertions_enabled = true,
        });
    }
}

test "feature flags release configuration" {
    comptime {
        contracts.assertValid(FeatureFlags, .{
            .debug_logging = false,
            .release_optimized = true,
            .profiling = false,
            .assertions_enabled = false,
        });
    }
}

test "feature flags minimal configuration" {
    comptime {
        contracts.assertValid(FeatureFlags, .{
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
        contracts.assertValid(SensorThresholds, .{
            .critical_low = -40,
            .warning_low = -10,
            .warning_high = 80,
            .critical_high = 100,
        });
    }
}

test "sensor thresholds negative-only range" {
    comptime {
        contracts.assertValid(SensorThresholds, .{
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
        contracts.assertValid(SystemConfig, .{
            .version = AppVersion.generate(2, 1, 0),
            .network = NetworkConfig.generate(8080, 1024, 64, 30),
            .flags = .{
                .debug_logging = true,
                .release_optimized = false,
                .profiling = true,
                .assertions_enabled = true,
            },
            .thresholds = .{
                .critical_low = -40,
                .warning_low = -10,
                .warning_high = 80,
                .critical_high = 100,
            },
        });
    }
}
