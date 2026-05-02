const std = @import("std");
const constraints = @import("data_gen").constraints;
const contracts = @import("data_gen").contracts;
const generators = @import("data_gen").generators;

// --- Firmware Image Header with Computed Integrity ---
// The header contains a checksum field whose value MUST equal
// the XOR of all other fields. This is a generative constraint:
// the value is derived, not just bounded.

const ImageType = enum(u8) { bootloader, application, factory_test, recovery };

const FirmwareHeader = struct {
    magic: u32,
    version_major: u8,
    version_minor: u8,
    version_patch: u16,
    image_type: ImageType,
    image_size: u32,
    entry_point: u32,
    load_address: u32,
    min_hw_rev: u8,
    flags: u8,
    reserved: u16,
    checksum: u32,

    fn computeChecksum(comptime self: FirmwareHeader) u32 {
        return self.magic ^
            (@as(u32, self.version_major) << 24 | @as(u32, self.version_minor) << 16 | @as(u32, self.version_patch)) ^
            @as(u32, @intFromEnum(self.image_type)) ^
            self.image_size ^
            self.entry_point ^
            self.load_address ^
            (@as(u32, self.min_hw_rev) << 24 | @as(u32, self.flags) << 16 | @as(u32, self.reserved));
    }

    pub fn validate(comptime self: FirmwareHeader) void {
        if (self.magic != 0xDEAD_BEEF)
            @compileError("invalid magic number");

        constraints.inRange(0, 99, self.version_major);
        constraints.inRange(0, 99, self.version_minor);
        constraints.nonZero(self.image_size);
        if (self.entry_point < self.load_address)
            @compileError("entry point must be within the loaded image (>= load_address)");

        if (self.entry_point >= self.load_address + self.image_size)
            @compileError("entry point must be within the loaded image (< load_address + image_size)");

        if (self.image_type == .bootloader and self.load_address != 0x00000000)
            @compileError("bootloader must load at address 0x00000000");

        if (self.image_type == .application and self.load_address < 0x00008000)
            @compileError("application must load above bootloader (>= 0x8000)");

        // Integrity: checksum must match computed value
        const expected = self.computeChecksum();
        if (self.checksum != expected)
            @compileError(std.fmt.comptimePrint(
                "checksum 0x{x:0>8} does not match computed 0x{x:0>8}",
                .{ self.checksum, expected },
            ));
    }

    /// Construct a header with the checksum auto-computed.
    pub fn generate(comptime partial: FirmwareHeader) FirmwareHeader {
        var result = partial;
        result.checksum = partial.computeChecksum();
        result.validate();
        return result;
    }
};

const app_header = FirmwareHeader.generate(.{
    .magic = 0xDEAD_BEEF,
    .version_major = 2,
    .version_minor = 5,
    .version_patch = 1024,
    .image_type = .application,
    .image_size = 131072,
    .entry_point = 0x00008100,
    .load_address = 0x00008000,
    .min_hw_rev = 3,
    .flags = 0x01,
    .reserved = 0,
    .checksum = 0, // will be overwritten by generate
});

const boot_header = FirmwareHeader.generate(.{
    .magic = 0xDEAD_BEEF,
    .version_major = 1,
    .version_minor = 0,
    .version_patch = 1,
    .image_type = .bootloader,
    .image_size = 32768,
    .entry_point = 0x00000000,
    .load_address = 0x00000000,
    .min_hw_rev = 1,
    .flags = 0x00,
    .reserved = 0,
    .checksum = 0,
});

test "app header checksum matches computed" {
    comptime {
        try std.testing.expectEqual(app_header.checksum, app_header.computeChecksum());
    }
}

test "boot header loads at address zero" {
    comptime {
        try std.testing.expectEqual(0, boot_header.load_address);
        try std.testing.expectEqual(0, boot_header.entry_point);
    }
}

test "app header entry point is within image bounds" {
    comptime {
        try std.testing.expect(app_header.entry_point >= app_header.load_address);
        try std.testing.expect(app_header.entry_point < app_header.load_address + app_header.image_size);
    }
}

// --- Module Dependency Graph with Boolean Implication ---
// Modules that can be enabled/disabled, where enabling one
// may require enabling others (implication chains).
// Also: mutual exclusion between certain modules.

const ModuleId = enum(u8) {
    core,
    hal,
    uart_driver,
    spi_driver,
    filesystem,
    logging,
    network,
    http_server,
    ota_update,
    debug_console,
};

const ModuleConfig = struct {
    module: ModuleId,
    enabled: bool,
};

const ModuleRule = struct {
    // If `subject` is enabled, `requirement` must also be enabled
    subject: ModuleId,
    requirement: ModuleId,
};

const ExclusionRule = struct {
    a: ModuleId,
    b: ModuleId,
};

fn validateModuleDeps(
    comptime configs: []const ModuleConfig,
    comptime rules: []const ModuleRule,
    comptime exclusions: []const ExclusionRule,
) void {
    @setEvalBranchQuota(10_000);

    // Every ModuleId must appear exactly once
    const all_modules = [_]ModuleId{
        .core,    .hal,     .uart_driver, .spi_driver, .filesystem,
        .logging, .network, .http_server, .ota_update, .debug_console,
    };
    for (all_modules) |expected| {
        var count: u8 = 0;
        for (configs) |c| {
            if (c.module == expected) count += 1;
        }
        if (count != 1)
            @compileError(std.fmt.comptimePrint(
                "module {} must appear exactly once",
                .{@intFromEnum(expected)},
            ));
    }

    // Core must always be enabled
    for (configs) |c| {
        if (c.module == .core and !c.enabled)
            @compileError("core module must always be enabled");
    }

    // Implication rules: if subject is enabled, requirement must be too
    for (rules) |rule| {
        var subject_enabled = false;
        var requirement_enabled = false;
        for (configs) |c| {
            if (c.module == rule.subject) subject_enabled = c.enabled;
            if (c.module == rule.requirement) requirement_enabled = c.enabled;
        }
        if (subject_enabled and !requirement_enabled)
            @compileError(std.fmt.comptimePrint(
                "module {} requires module {} to be enabled",
                .{ @intFromEnum(rule.subject), @intFromEnum(rule.requirement) },
            ));
    }

    // Mutual exclusion: both cannot be enabled
    for (exclusions) |excl| {
        var a_enabled = false;
        var b_enabled = false;
        for (configs) |c| {
            if (c.module == excl.a) a_enabled = c.enabled;
            if (c.module == excl.b) b_enabled = c.enabled;
        }
        if (a_enabled and b_enabled)
            @compileError(std.fmt.comptimePrint(
                "modules {} and {} are mutually exclusive",
                .{ @intFromEnum(excl.a), @intFromEnum(excl.b) },
            ));
    }

    // Transitive closure check: follow implication chains
    // If A requires B and B requires C, then enabling A with C disabled is invalid.
    // (This is already caught by the direct check above, but let's verify
    // that no circular dependencies exist in the rules themselves.)
    for (rules) |start| {
        var current = start.requirement;
        var depth: u8 = 0;
        while (depth < rules.len) : (depth += 1) {
            if (current == start.subject)
                @compileError(std.fmt.comptimePrint(
                    "circular dependency involving module {}",
                    .{@intFromEnum(start.subject)},
                ));
            var found_next = false;
            for (rules) |r| {
                if (r.subject == current) {
                    current = r.requirement;
                    found_next = true;
                    break;
                }
            }
            if (!found_next) break;
        }
    }
}

const dep_rules = [_]ModuleRule{
    .{ .subject = .hal, .requirement = .core },
    .{ .subject = .uart_driver, .requirement = .hal },
    .{ .subject = .spi_driver, .requirement = .hal },
    .{ .subject = .filesystem, .requirement = .spi_driver },
    .{ .subject = .logging, .requirement = .uart_driver },
    .{ .subject = .network, .requirement = .spi_driver },
    .{ .subject = .http_server, .requirement = .network },
    .{ .subject = .ota_update, .requirement = .http_server },
    .{ .subject = .ota_update, .requirement = .filesystem },
    .{ .subject = .debug_console, .requirement = .uart_driver },
    .{ .subject = .debug_console, .requirement = .logging },
};

const exclusion_rules = [_]ExclusionRule{
    .{ .a = .debug_console, .b = .ota_update },
};

const production_config = blk: {
    const cfg = [_]ModuleConfig{
        .{ .module = .core, .enabled = true },
        .{ .module = .hal, .enabled = true },
        .{ .module = .uart_driver, .enabled = true },
        .{ .module = .spi_driver, .enabled = true },
        .{ .module = .filesystem, .enabled = true },
        .{ .module = .logging, .enabled = true },
        .{ .module = .network, .enabled = true },
        .{ .module = .http_server, .enabled = true },
        .{ .module = .ota_update, .enabled = true },
        .{ .module = .debug_console, .enabled = false },
    };
    validateModuleDeps(&cfg, &dep_rules, &exclusion_rules);
    break :blk cfg;
};

const debug_config = blk: {
    const cfg = [_]ModuleConfig{
        .{ .module = .core, .enabled = true },
        .{ .module = .hal, .enabled = true },
        .{ .module = .uart_driver, .enabled = true },
        .{ .module = .spi_driver, .enabled = false },
        .{ .module = .filesystem, .enabled = false },
        .{ .module = .logging, .enabled = true },
        .{ .module = .network, .enabled = false },
        .{ .module = .http_server, .enabled = false },
        .{ .module = .ota_update, .enabled = false },
        .{ .module = .debug_console, .enabled = true },
    };
    validateModuleDeps(&cfg, &dep_rules, &exclusion_rules);
    break :blk cfg;
};

test "production config enables OTA but not debug console" {
    comptime {
        for (production_config) |c| {
            if (c.module == .ota_update) try std.testing.expect(c.enabled);
            if (c.module == .debug_console) try std.testing.expect(!c.enabled);
        }
    }
}

test "debug config enables debug console but not OTA" {
    comptime {
        for (debug_config) |c| {
            if (c.module == .debug_console) try std.testing.expect(c.enabled);
            if (c.module == .ota_update) try std.testing.expect(!c.enabled);
        }
    }
}

test "both configs have core enabled" {
    comptime {
        for (production_config) |c| {
            if (c.module == .core) try std.testing.expect(c.enabled);
        }
        for (debug_config) |c| {
            if (c.module == .core) try std.testing.expect(c.enabled);
        }
    }
}
