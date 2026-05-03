const std = @import("std");
const constraint = @import("data_gen").constraint;
const contract = @import("data_gen").contract;

// --- Multi-Dimensional Resource Budgeting ---
// Each module consumes CPU, RAM, flash, and power simultaneously.
// The total across all modules must stay within the system budget
// for every dimension.

const ResourceProfile = struct {
    cpu_pct_x10: u16, // CPU usage in tenths of a percent
    ram_bytes: u32,
    flash_bytes: u32,
    power_uw: u32,
};

const ModuleDef = struct {
    name_id: u8,
    priority: u8,
    resources: ResourceProfile,
    can_be_disabled: bool,

    pub fn contractValidate(comptime self: ModuleDef) ?[]const u8 {
        if (constraint.inRange(0, 1000, self.resources.cpu_pct_x10)) |err| return err;
        if (self.priority == 0 and self.can_be_disabled)
            return std.fmt.comptimePrint(
                "critical module {} (priority 0) must not be disableable",
                .{self.name_id},
            );
        return null;
    }
};

const SystemBudget = struct {
    max_cpu_pct_x10: u16,
    max_ram_bytes: u32,
    max_flash_bytes: u32,
    max_power_uw: u32,
};

fn ValidatedModuleSystem(comptime len: usize) type {
    return struct {
        modules: [len]ModuleDef,
        budget: SystemBudget,

        pub fn contractValidate(comptime self: @This()) ?[]const u8 {
            @setEvalBranchQuota(5000);
            if (constraint.lenInRange(1, 32, self.modules.len)) |err| return err;

            var ids: [len]u8 = undefined;
            var total_cpu: u32 = 0;
            var total_ram: u32 = 0;
            var total_flash: u32 = 0;
            var total_power: u32 = 0;

            for (self.modules, 0..) |m, i| {
                ids[i] = m.name_id;
                total_cpu += m.resources.cpu_pct_x10;
                total_ram += m.resources.ram_bytes;
                total_flash += m.resources.flash_bytes;
                total_power += m.resources.power_uw;
            }
            if (constraint.noDuplicates(u8, &ids)) |err| return err;

            if (total_cpu > self.budget.max_cpu_pct_x10)
                return std.fmt.comptimePrint(
                    "CPU usage {}‰ exceeds budget {}‰",
                    .{ total_cpu, self.budget.max_cpu_pct_x10 },
                );
            if (total_ram > self.budget.max_ram_bytes)
                return std.fmt.comptimePrint(
                    "RAM usage {} bytes exceeds budget {} bytes",
                    .{ total_ram, self.budget.max_ram_bytes },
                );
            if (total_flash > self.budget.max_flash_bytes)
                return std.fmt.comptimePrint(
                    "Flash usage {} bytes exceeds budget {} bytes",
                    .{ total_flash, self.budget.max_flash_bytes },
                );
            if (total_power > self.budget.max_power_uw)
                return std.fmt.comptimePrint(
                    "Power usage {}uW exceeds budget {}uW",
                    .{ total_power, self.budget.max_power_uw },
                );

            return null;
        }
    };
}

fn computeHeadroom(
    comptime modules: []const ModuleDef,
    comptime budget: SystemBudget,
) ResourceProfile {
    var total = ResourceProfile{
        .cpu_pct_x10 = 0,
        .ram_bytes = 0,
        .flash_bytes = 0,
        .power_uw = 0,
    };
    for (modules) |m| {
        total.cpu_pct_x10 += m.resources.cpu_pct_x10;
        total.ram_bytes += m.resources.ram_bytes;
        total.flash_bytes += m.resources.flash_bytes;
        total.power_uw += m.resources.power_uw;
    }
    return .{
        .cpu_pct_x10 = budget.max_cpu_pct_x10 - total.cpu_pct_x10,
        .ram_bytes = budget.max_ram_bytes - total.ram_bytes,
        .flash_bytes = budget.max_flash_bytes - total.flash_bytes,
        .power_uw = budget.max_power_uw - total.power_uw,
    };
}

const system_budget = SystemBudget{
    .max_cpu_pct_x10 = 800, // 80%
    .max_ram_bytes = 65536,
    .max_flash_bytes = 262144,
    .max_power_uw = 50000,
};

const system_modules = blk: {
    const modules = [_]ModuleDef{
        .{ .name_id = 0, .priority = 0, .can_be_disabled = false, .resources = .{
            .cpu_pct_x10 = 50,
            .ram_bytes = 4096,
            .flash_bytes = 16384,
            .power_uw = 2000,
        } },
        .{ .name_id = 1, .priority = 0, .can_be_disabled = false, .resources = .{
            .cpu_pct_x10 = 100,
            .ram_bytes = 8192,
            .flash_bytes = 32768,
            .power_uw = 5000,
        } },
        .{ .name_id = 2, .priority = 1, .can_be_disabled = true, .resources = .{
            .cpu_pct_x10 = 200,
            .ram_bytes = 16384,
            .flash_bytes = 65536,
            .power_uw = 12000,
        } },
        .{ .name_id = 3, .priority = 2, .can_be_disabled = true, .resources = .{
            .cpu_pct_x10 = 150,
            .ram_bytes = 8192,
            .flash_bytes = 49152,
            .power_uw = 8000,
        } },
        .{ .name_id = 4, .priority = 3, .can_be_disabled = true, .resources = .{
            .cpu_pct_x10 = 80,
            .ram_bytes = 4096,
            .flash_bytes = 32768,
            .power_uw = 4000,
        } },
        .{ .name_id = 5, .priority = 1, .can_be_disabled = true, .resources = .{
            .cpu_pct_x10 = 120,
            .ram_bytes = 12288,
            .flash_bytes = 40960,
            .power_uw = 10000,
        } },
    };
    break :blk contract.validated(ValidatedModuleSystem(modules.len){ .modules = modules, .budget = system_budget }).modules;
};

test "system modules fit within all budget dimensions" {
    comptime {
        var total_cpu: u32 = 0;
        var total_ram: u32 = 0;
        var total_flash: u32 = 0;
        var total_power: u32 = 0;
        for (system_modules) |m| {
            total_cpu += m.resources.cpu_pct_x10;
            total_ram += m.resources.ram_bytes;
            total_flash += m.resources.flash_bytes;
            total_power += m.resources.power_uw;
        }
        try std.testing.expect(total_cpu <= system_budget.max_cpu_pct_x10);
        try std.testing.expect(total_ram <= system_budget.max_ram_bytes);
        try std.testing.expect(total_flash <= system_budget.max_flash_bytes);
        try std.testing.expect(total_power <= system_budget.max_power_uw);
    }
}

test "resource headroom is positive in all dimensions" {
    comptime {
        const headroom = computeHeadroom(&system_modules, system_budget);
        try std.testing.expect(headroom.cpu_pct_x10 > 0);
        try std.testing.expect(headroom.ram_bytes > 0);
        try std.testing.expect(headroom.flash_bytes > 0);
        try std.testing.expect(headroom.power_uw > 0);
    }
}

test "critical modules are not disableable" {
    comptime {
        for (system_modules) |m| {
            if (m.priority == 0) {
                try std.testing.expect(!m.can_be_disabled);
            }
        }
    }
}

// --- Display Layout Tiling ---
// Rectangular UI regions that must tile a screen area without
// overlapping or leaving gaps.

const Rect = struct {
    x: u16,
    y: u16,
    w: u16,
    h: u16,

    pub fn contractValidate(comptime self: Rect) ?[]const u8 {
        if (constraint.nonZero(self.w)) |err| return err;
        if (constraint.nonZero(self.h)) |err| return err;
        return null;
    }
};

fn ValidatedTiling(comptime len: usize, comptime screen_w: u16, comptime screen_h: u16) type {
    return struct {
        rects: [len]Rect,

        pub fn contractValidate(comptime self: @This()) ?[]const u8 {
            @setEvalBranchQuota(10_000);
            if (constraint.lenInRange(1, 32, self.rects.len)) |err| return err;

            // All rects within screen bounds
            for (self.rects) |r| {
                if (r.x + r.w > screen_w)
                    return std.fmt.comptimePrint(
                        "rect at ({},{}) with size {}x{} exceeds screen width {}",
                        .{ r.x, r.y, r.w, r.h, screen_w },
                    );
                if (r.y + r.h > screen_h)
                    return std.fmt.comptimePrint(
                        "rect at ({},{}) with size {}x{} exceeds screen height {}",
                        .{ r.x, r.y, r.w, r.h, screen_h },
                    );
            }

            // No overlaps
            for (0..self.rects.len) |i| {
                for (i + 1..self.rects.len) |j| {
                    const a = self.rects[i];
                    const b = self.rects[j];
                    if (a.x < b.x + b.w and b.x < a.x + a.w and
                        a.y < b.y + b.h and b.y < a.y + a.h)
                        return std.fmt.comptimePrint(
                            "rects at ({},{}) and ({},{}) overlap",
                            .{ a.x, a.y, b.x, b.y },
                        );
                }
            }

            // Total area must equal screen area (complete tiling, no gaps)
            var total_area: u32 = 0;
            for (self.rects) |r| {
                total_area += @as(u32, r.w) * r.h;
            }
            const screen_area: u32 = @as(u32, screen_w) * screen_h;
            if (total_area != screen_area)
                return std.fmt.comptimePrint(
                    "total rect area {} does not equal screen area {} (gaps exist)",
                    .{ total_area, screen_area },
                );

            return null;
        }
    };
}

const dashboard_layout = blk: {
    // 320x240 screen tiled by 6 widgets
    const rects = [_]Rect{
        .{ .x = 0, .y = 0, .w = 160, .h = 120 },
        .{ .x = 160, .y = 0, .w = 160, .h = 120 },
        .{ .x = 0, .y = 120, .w = 80, .h = 120 },
        .{ .x = 80, .y = 120, .w = 80, .h = 120 },
        .{ .x = 160, .y = 120, .w = 80, .h = 120 },
        .{ .x = 240, .y = 120, .w = 80, .h = 120 },
    };
    break :blk contract.validated(ValidatedTiling(rects.len, 320, 240){ .rects = rects }).rects;
};

test "dashboard layout tiles 320x240 completely" {
    comptime {
        try std.testing.expectEqual(6, dashboard_layout.len);
        var total: u32 = 0;
        for (dashboard_layout) |r| total += @as(u32, r.w) * r.h;
        try std.testing.expectEqual(320 * 240, total);
    }
}

test "dashboard layout no overlaps" {
    comptime {
        for (0..dashboard_layout.len) |i| {
            for (i + 1..dashboard_layout.len) |j| {
                const a = dashboard_layout[i];
                const b = dashboard_layout[j];
                const no_overlap = a.x + a.w <= b.x or b.x + b.w <= a.x or
                    a.y + a.h <= b.y or b.y + b.h <= a.y;
                try std.testing.expect(no_overlap);
            }
        }
    }
}

test "dashboard layout all rects within screen bounds" {
    comptime {
        for (dashboard_layout) |r| {
            try std.testing.expect(r.x + r.w <= 320);
            try std.testing.expect(r.y + r.h <= 240);
        }
    }
}
