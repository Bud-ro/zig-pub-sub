const std = @import("std");
const constraint = @import("data_gen").constraint;
const contract = @import("data_gen").contract;

// --- Three-Level Power Budget: System → Subsystem → Component ---

const Component = struct {
    name_id: u8,
    power_mw: u32,
    voltage_mv: u16,
    active: bool,

    pub fn validate(comptime self: Component) ?[]const u8 {
        if (self.power_mw > 5000) return "power_mw out of range [0, 5000]";
        if (self.voltage_mv != 1800 and self.voltage_mv != 3300 and self.voltage_mv != 5000 and self.voltage_mv != 12000)
            return "voltage_mv must be one of 1800, 3300, 5000, 12000";
        if (!self.active and self.power_mw != 0)
            return "inactive component must have zero power";
        return null;
    }
};

const Subsystem = struct {
    name_id: u8,
    components: [4]Component,
    max_power_mw: u32,
    voltage_mv: u16,

    pub fn validate(comptime self: Subsystem) ?[]const u8 {
        if (self.max_power_mw > 15000) return "max_power_mw out of range [0, 15000]";

        var total_power: u32 = 0;
        for (self.components) |comp| {
            total_power += comp.power_mw;

            if (comp.voltage_mv > self.voltage_mv)
                return "component voltage exceeds subsystem supply";
        }

        if (total_power > self.max_power_mw)
            return std.fmt.comptimePrint(
                "subsystem component power {} exceeds budget {}",
                .{ total_power, self.max_power_mw },
            );
        return null;
    }
};

const System = struct {
    subsystems: [3]Subsystem,
    power_budget_mw: u32,
    name_id: u8,

    pub fn validate(comptime self: System) ?[]const u8 {
        if (self.power_budget_mw > 50000) return "power_budget_mw out of range [0, 50000]";

        var total_power: u32 = 0;
        var sub_ids: [3]u8 = undefined;
        for (self.subsystems, 0..) |sub, i| {
            total_power += sub.max_power_mw;
            sub_ids[i] = sub.name_id;
        }

        if (constraint.noDuplicates(u8, &sub_ids)) |err| return err;

        if (total_power > self.power_budget_mw)
            return std.fmt.comptimePrint(
                "system power {} exceeds budget {}",
                .{ total_power, self.power_budget_mw },
            );
        return null;
    }
};

const embedded_system = contract.validated(System{
    .name_id = 0,
    .power_budget_mw = 25000,
    .subsystems = .{
        .{
            .name_id = 1,
            .voltage_mv = 5000,
            .max_power_mw = 10000,
            .components = .{
                .{ .name_id = 10, .power_mw = 3000, .voltage_mv = 5000, .active = true },
                .{ .name_id = 11, .power_mw = 2500, .voltage_mv = 3300, .active = true },
                .{ .name_id = 12, .power_mw = 1500, .voltage_mv = 3300, .active = true },
                .{ .name_id = 13, .power_mw = 0, .voltage_mv = 1800, .active = false },
            },
        },
        .{
            .name_id = 2,
            .voltage_mv = 3300,
            .max_power_mw = 8000,
            .components = .{
                .{ .name_id = 20, .power_mw = 2000, .voltage_mv = 3300, .active = true },
                .{ .name_id = 21, .power_mw = 2000, .voltage_mv = 3300, .active = true },
                .{ .name_id = 22, .power_mw = 1000, .voltage_mv = 1800, .active = true },
                .{ .name_id = 23, .power_mw = 500, .voltage_mv = 1800, .active = true },
            },
        },
        .{
            .name_id = 3,
            .voltage_mv = 12000,
            .max_power_mw = 5000,
            .components = .{
                .{ .name_id = 30, .power_mw = 4000, .voltage_mv = 12000, .active = true },
                .{ .name_id = 31, .power_mw = 500, .voltage_mv = 5000, .active = true },
                .{ .name_id = 32, .power_mw = 0, .voltage_mv = 3300, .active = false },
                .{ .name_id = 33, .power_mw = 0, .voltage_mv = 1800, .active = false },
            },
        },
    },
});

test "embedded system passes full three-level validation" {
    comptime {
        try std.testing.expectEqual(3, embedded_system.subsystems.len);
        var total: u32 = 0;
        for (embedded_system.subsystems) |sub| {
            total += sub.max_power_mw;
        }
        try std.testing.expect(total <= embedded_system.power_budget_mw);
    }
}

test "embedded system component IDs are unique within subsystems" {
    comptime {
        for (embedded_system.subsystems) |sub| {
            const wrapper: SubsystemComponentIds = .{ .subsystem = sub };
            if (wrapper.validate()) |err| @compileError(err);
        }
    }
}

const SubsystemComponentIds = struct {
    subsystem: Subsystem,

    pub fn validate(comptime self: SubsystemComponentIds) ?[]const u8 {
        var ids: [4]u8 = undefined;
        for (self.subsystem.components, 0..) |comp, i| {
            ids[i] = comp.name_id;
        }
        if (constraint.noDuplicates(u8, &ids)) |err| return err;
        return null;
    }
};

// --- Index-Referenced Data (tasks referencing dependencies by index) ---

const Task = struct {
    id: u8,
    duration_hours: u8,
    dependency_idx: ?u8,
};

fn TaskGraph(comptime n: usize) type {
    return struct {
        tasks: [n]Task,

        pub fn validate(comptime self: @This()) ?[]const u8 {
            if (constraint.lenInRange(1, 64, self.tasks.len)) |err| return err;

            var ids: [self.tasks.len]u8 = undefined;
            for (self.tasks, 0..) |task, i| {
                ids[i] = task.id;
                if (constraint.nonZero(task.duration_hours)) |err| return err;
                if (constraint.inRange(1, 100, task.duration_hours)) |err| return err;

                if (task.dependency_idx) |dep_idx| {
                    if (dep_idx >= self.tasks.len)
                        return std.fmt.comptimePrint(
                            "task {} references dependency index {} but only {} tasks exist",
                            .{ task.id, dep_idx, self.tasks.len },
                        );
                    if (dep_idx >= i)
                        return "dependency must reference an earlier task (no forward or self references)";
                }
            }
            if (constraint.noDuplicates(u8, &ids)) |err| return err;
            return null;
        }
    };
}

const project_tasks = blk: {
    const tasks = [_]Task{
        .{ .id = 1, .duration_hours = 8, .dependency_idx = null },
        .{ .id = 2, .duration_hours = 4, .dependency_idx = null },
        .{ .id = 3, .duration_hours = 16, .dependency_idx = 0 },
        .{ .id = 4, .duration_hours = 8, .dependency_idx = 0 },
        .{ .id = 5, .duration_hours = 24, .dependency_idx = 2 },
        .{ .id = 6, .duration_hours = 4, .dependency_idx = 4 },
        .{ .id = 7, .duration_hours = 12, .dependency_idx = 5 },
    };
    const wrapper: TaskGraph(tasks.len) = .{ .tasks = tasks };
    if (wrapper.validate()) |err| @compileError(err);
    break :blk tasks;
};

test "task graph has valid dependency indices" {
    comptime {
        for (project_tasks) |task| {
            if (task.dependency_idx) |idx| {
                try std.testing.expect(idx < project_tasks.len);
            }
        }
    }
}

test "task graph has unique IDs" {
    comptime {
        const wrapper: TaskGraph(project_tasks.len) = .{ .tasks = project_tasks };
        if (wrapper.validate()) |err| @compileError(err);
    }
}

// --- ERD-like Type Registry with Size Constraints ---

const ErdType = enum(u8) { u8_type, u16_type, u32_type, bool_type, struct_type };

const ErdSpec = struct {
    erd_number: u16,
    erd_type: ErdType,
    size_bytes: u8,
    max_subs: u8,
};

fn ErdRegistry(comptime n: usize) type {
    return struct {
        specs: [n]ErdSpec,

        pub fn validate(comptime self: @This()) ?[]const u8 {
            if (constraint.lenInRange(1, 256, self.specs.len)) |err| return err;

            var numbers: [self.specs.len]u16 = undefined;
            for (self.specs, 0..) |spec, i| {
                numbers[i] = spec.erd_number;

                const expected_size: u8 = switch (spec.erd_type) {
                    .u8_type => 1,
                    .u16_type => 2,
                    .u32_type => 4,
                    .bool_type => 1,
                    .struct_type => spec.size_bytes,
                };
                if (spec.erd_type != .struct_type and spec.size_bytes != expected_size)
                    return "size_bytes doesn't match type";

                if (constraint.inRange(0, 16, spec.max_subs)) |err| return err;
            }
            if (constraint.noDuplicates(u16, &numbers)) |err| return err;
            return null;
        }
    };
}

const erd_registry = blk: {
    const specs = [_]ErdSpec{
        .{ .erd_number = 0x0000, .erd_type = .u32_type, .size_bytes = 4, .max_subs = 0 },
        .{ .erd_number = 0x0001, .erd_type = .bool_type, .size_bytes = 1, .max_subs = 3 },
        .{ .erd_number = 0x0002, .erd_type = .u16_type, .size_bytes = 2, .max_subs = 1 },
        .{ .erd_number = 0x0003, .erd_type = .struct_type, .size_bytes = 4, .max_subs = 0 },
        .{ .erd_number = 0x0004, .erd_type = .struct_type, .size_bytes = 8, .max_subs = 0 },
        .{ .erd_number = 0x0005, .erd_type = .u8_type, .size_bytes = 1, .max_subs = 2 },
    };
    const wrapper: ErdRegistry(specs.len) = .{ .specs = specs };
    if (wrapper.validate()) |err| @compileError(err);
    break :blk specs;
};

test "ERD registry has unique numbers" {
    comptime {
        const wrapper: ErdRegistry(erd_registry.len) = .{ .specs = erd_registry };
        if (wrapper.validate()) |err| @compileError(err);
    }
}

test "ERD registry sizes match types" {
    comptime {
        for (erd_registry) |spec| {
            switch (spec.erd_type) {
                .u8_type => try std.testing.expectEqual(1, spec.size_bytes),
                .u16_type => try std.testing.expectEqual(2, spec.size_bytes),
                .u32_type => try std.testing.expectEqual(4, spec.size_bytes),
                .bool_type => try std.testing.expectEqual(1, spec.size_bytes),
                .struct_type => {},
            }
        }
    }
}
