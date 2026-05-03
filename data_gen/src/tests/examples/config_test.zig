const std = @import("std");
const contract = @import("data_gen").contract;

// --- Application Version ---

const AppVersion = struct {
    major: u8,
    minor: u8,
    patch: u16,

    pub fn contractValidate(comptime self: AppVersion) ?[]const u8 {
        if (self.major > 99) return "major exceeds 99";
        if (self.minor > 99) return "minor exceeds 99";
        return null;
    }

    pub fn toU32(comptime self: AppVersion) u32 {
        return @as(u32, self.major) << 24 |
            @as(u32, self.minor) << 16 |
            @as(u32, self.patch);
    }
};

test "application version packs into u32" {
    comptime {
        const v = contract.validated(AppVersion{ .major = 1, .minor = 2, .patch = 345 });
        try std.testing.expectEqual(@as(u32, 0x01020159), v.toU32());
    }
}

test "application version boundary values" {
    comptime {
        contract.assertValid(AppVersion{ .major = 0, .minor = 0, .patch = 0 });
        contract.assertValid(AppVersion{ .major = 99, .minor = 99, .patch = 65535 });
    }
}

// --- Network Configuration ---

const NetworkConfig = struct {
    port: u16,
    mtu: u16,
    max_connections: u16,
    keepalive_seconds: u16,

    pub fn contractValidate(comptime self: NetworkConfig) ?[]const u8 {
        if (self.port == 0) return "port must not be zero";
        if (self.mtu == 0 or (self.mtu & (self.mtu - 1)) != 0) return "mtu must be a power of two";
        if (self.mtu < 64 or self.mtu > 9000) return "mtu out of range [64, 9000]";
        if (self.max_connections == 0 or self.max_connections > 1024) return "max_connections out of range [1, 1024]";
        if (self.keepalive_seconds == 0 or self.keepalive_seconds > 3600) return "keepalive_seconds out of range [1, 3600]";
        return null;
    }
};

test "network config with power-of-two MTU" {
    comptime {
        const cfg = contract.validated(NetworkConfig{ .port = 8080, .mtu = 1024, .max_connections = 128, .keepalive_seconds = 30 });
        try std.testing.expectEqual(8080, cfg.port);
    }
}

// --- Feature Flags with Mutual Exclusion ---

const FeatureFlags = struct {
    debug_logging: bool,
    release_optimized: bool,
    profiling: bool,
    assertions_enabled: bool,

    pub fn contractValidate(comptime self: FeatureFlags) ?[]const u8 {
        if (self.debug_logging and self.release_optimized)
            return "debug_logging and release_optimized are mutually exclusive";
        if (self.release_optimized and self.assertions_enabled)
            return "release_optimized disables assertions";
        if (self.profiling and !self.debug_logging)
            return "profiling requires debug_logging";
        return null;
    }
};

test "feature flags" {
    comptime {
        contract.assertValid(FeatureFlags{ .debug_logging = true, .release_optimized = false, .profiling = true, .assertions_enabled = true });
        contract.assertValid(FeatureFlags{ .debug_logging = false, .release_optimized = true, .profiling = false, .assertions_enabled = false });
    }
}

// --- Sensor Thresholds ---

const SensorThresholds = struct {
    warning_low: i16,
    critical_low: i16,
    warning_high: i16,
    critical_high: i16,

    pub fn contractValidate(comptime self: SensorThresholds) ?[]const u8 {
        if (self.critical_low >= self.warning_low) return "critical_low must be < warning_low";
        if (self.warning_low >= self.warning_high) return "warning_low must be < warning_high";
        if (self.warning_high >= self.critical_high) return "warning_high must be < critical_high";
        if (self.critical_low < -200 or self.critical_low > 200) return "critical_low out of [-200, 200]";
        if (self.critical_high < -200 or self.critical_high > 200) return "critical_high out of [-200, 200]";
        return null;
    }
};

test "sensor thresholds" {
    comptime {
        contract.assertValid(SensorThresholds{ .critical_low = -40, .warning_low = -10, .warning_high = 80, .critical_high = 100 });
    }
}

// --- Composed system config — recursive validation validates all children ---

const SystemConfig = struct {
    version: AppVersion,
    network: NetworkConfig,
    flags: FeatureFlags,
    thresholds: SensorThresholds,

    pub fn contractValidate(comptime self: SystemConfig) ?[]const u8 {
        if (self.flags.debug_logging and self.network.max_connections > 64)
            return "debug mode limits connections to 64";
        return null;
    }
};

test "system config — children validated automatically via recursion" {
    comptime {
        contract.assertValid(SystemConfig{
            .version = .{ .major = 2, .minor = 1, .patch = 0 },
            .network = .{ .port = 8080, .mtu = 1024, .max_connections = 64, .keepalive_seconds = 30 },
            .flags = .{ .debug_logging = true, .release_optimized = false, .profiling = true, .assertions_enabled = true },
            .thresholds = .{ .critical_low = -40, .warning_low = -10, .warning_high = 80, .critical_high = 100 },
        });
    }
}
