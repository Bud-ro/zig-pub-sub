const std = @import("std");
const constraint = @import("data_gen").constraint;
const contract = @import("data_gen").contract;

// --- Rate-Monotonic Task Scheduling ---
// Tasks with periods and priorities. Rate-monotonic: shorter period = higher priority.
// CPU utilization must stay below the schedulability bound.

const TaskDef = struct {
    id: u8,
    period_ms: u16,
    wcet_us: u32,
    priority: u8,
    stack_size: u16,

    pub fn contractValidate(comptime self: TaskDef) ?[]const u8 {
        if (constraint.nonZero(self.period_ms)) |err| return err;
        if (constraint.nonZero(self.wcet_us)) |err| return err;
        if (constraint.isPowerOfTwo(self.stack_size)) |err| return err;
        if (constraint.inRange(64, 8192, self.stack_size)) |err| return err;

        if (self.wcet_us >= @as(u32, self.period_ms) * 1000)
            return std.fmt.comptimePrint(
                "task {} WCET ({}us) exceeds period ({}ms)",
                .{ self.id, self.wcet_us, self.period_ms },
            );
        return null;
    }
};

fn ValidatedTaskSet(comptime len: usize) type {
    return struct {
        tasks: [len]TaskDef,

        pub fn contractValidate(comptime self: @This()) ?[]const u8 {
            @setEvalBranchQuota(5000);
            if (constraint.lenInRange(1, 32, self.tasks.len)) |err| return err;

            var ids: [len]u8 = undefined;
            var priorities: [len]u8 = undefined;
            for (self.tasks, 0..) |task, i| {
                ids[i] = task.id;
                priorities[i] = task.priority;
            }
            if (constraint.noDuplicates(u8, &ids)) |err| return err;
            if (constraint.noDuplicates(u8, &priorities)) |err| return err;

            // Rate-monotonic: shorter period must have higher priority (lower number)
            for (0..self.tasks.len) |i| {
                for (i + 1..self.tasks.len) |j| {
                    if (self.tasks[i].period_ms < self.tasks[j].period_ms and self.tasks[i].priority > self.tasks[j].priority)
                        return std.fmt.comptimePrint(
                            "RM violation: task {} (period {}ms) has lower priority than task {} (period {}ms)",
                            .{ self.tasks[i].id, self.tasks[i].period_ms, self.tasks[j].id, self.tasks[j].period_ms },
                        );
                    if (self.tasks[i].period_ms > self.tasks[j].period_ms and self.tasks[i].priority < self.tasks[j].priority)
                        return std.fmt.comptimePrint(
                            "RM violation: task {} (period {}ms) has higher priority than task {} (period {}ms)",
                            .{ self.tasks[i].id, self.tasks[i].period_ms, self.tasks[j].id, self.tasks[j].period_ms },
                        );
                }
            }

            // CPU utilization check: sum(wcet/period) must be < 1.0
            // We compute in parts-per-thousand to avoid floating point
            var utilization_ppt: u32 = 0;
            for (self.tasks) |task| {
                utilization_ppt += (task.wcet_us * 1000) / (@as(u32, task.period_ms) * 1000);
            }
            if (utilization_ppt >= 1000)
                return std.fmt.comptimePrint(
                    "CPU utilization {}‰ exceeds 1000‰ (100%)",
                    .{utilization_ppt},
                );

            // Liu & Layland bound for N tasks: N * (2^(1/N) - 1)
            // For practical purposes, warn if utilization > 700 (70%) for > 3 tasks
            if (self.tasks.len > 3 and utilization_ppt > 700)
                return std.fmt.comptimePrint(
                    "CPU utilization {}‰ exceeds practical RM bound for {} tasks",
                    .{ utilization_ppt, self.tasks.len },
                );

            return null;
        }
    };
}

const task_set = blk: {
    const tasks = [_]TaskDef{
        .{ .id = 1, .period_ms = 1, .wcet_us = 50, .priority = 0, .stack_size = 256 },
        .{ .id = 2, .period_ms = 5, .wcet_us = 200, .priority = 1, .stack_size = 512 },
        .{ .id = 3, .period_ms = 10, .wcet_us = 500, .priority = 2, .stack_size = 512 },
        .{ .id = 4, .period_ms = 50, .wcet_us = 2000, .priority = 3, .stack_size = 1024 },
        .{ .id = 5, .period_ms = 100, .wcet_us = 5000, .priority = 4, .stack_size = 2048 },
        .{ .id = 6, .period_ms = 1000, .wcet_us = 10000, .priority = 5, .stack_size = 4096 },
    };
    break :blk contract.validated(ValidatedTaskSet(tasks.len){ .tasks = tasks }).tasks;
};

test "task set follows rate-monotonic priority assignment" {
    comptime {
        try std.testing.expectEqual(6, task_set.len);
        for (1..task_set.len) |i| {
            try std.testing.expect(task_set[i].period_ms > task_set[i - 1].period_ms);
            try std.testing.expect(task_set[i].priority > task_set[i - 1].priority);
        }
    }
}

test "task set WCET never exceeds period" {
    comptime {
        for (task_set) |task| {
            try std.testing.expect(task.wcet_us < @as(u32, task.period_ms) * 1000);
        }
    }
}

test "task set stack sizes are powers of two" {
    comptime {
        for (task_set) |task| {
            try std.testing.expect(task.stack_size > 0);
            try std.testing.expectEqual(0, task.stack_size & (task.stack_size - 1));
        }
    }
}

// --- Memory Partition Table ---
// Memory regions that must not overlap, must be aligned, and must tile the address space.

const MemRegion = struct {
    name_id: u8,
    start_addr: u32,
    size: u32,
    readable: bool,
    writable: bool,
    executable: bool,
    cacheable: bool,

    pub fn contractValidate(comptime self: MemRegion) ?[]const u8 {
        if (constraint.nonZero(self.size)) |err| return err;
        if (constraint.isPowerOfTwo(self.size)) |err| return err;

        if (self.start_addr % self.size != 0)
            return std.fmt.comptimePrint(
                "region {} at 0x{x:0>8} is not aligned to its size 0x{x}",
                .{ self.name_id, self.start_addr, self.size },
            );

        if (self.executable and self.writable)
            return std.fmt.comptimePrint(
                "region {} is both writable and executable (W^X violation)",
                .{self.name_id},
            );

        if (!self.readable and !self.writable)
            return std.fmt.comptimePrint(
                "region {} has no read or write access",
                .{self.name_id},
            );
        return null;
    }
};

fn ValidatedMemoryMap(comptime len: usize) type {
    return struct {
        regions: [len]MemRegion,

        pub fn contractValidate(comptime self: @This()) ?[]const u8 {
            @setEvalBranchQuota(5000);
            if (constraint.lenInRange(1, 32, self.regions.len)) |err| return err;

            var ids: [len]u8 = undefined;
            for (self.regions, 0..) |region, i| {
                ids[i] = region.name_id;
            }
            if (constraint.noDuplicates(u8, &ids)) |err| return err;

            for (0..self.regions.len) |i| {
                for (i + 1..self.regions.len) |j| {
                    const a_end = self.regions[i].start_addr + self.regions[i].size;
                    const b_end = self.regions[j].start_addr + self.regions[j].size;
                    if (self.regions[i].start_addr < b_end and self.regions[j].start_addr < a_end)
                        return std.fmt.comptimePrint(
                            "memory regions {} and {} overlap",
                            .{ self.regions[i].name_id, self.regions[j].name_id },
                        );
                }
            }
            return null;
        }
    };
}

const memory_map = blk: {
    const regions = [_]MemRegion{
        .{ .name_id = 0, .start_addr = 0x00000000, .size = 0x00010000, .readable = true, .writable = false, .executable = true, .cacheable = true },
        .{ .name_id = 1, .start_addr = 0x20000000, .size = 0x00010000, .readable = true, .writable = true, .executable = false, .cacheable = true },
        .{ .name_id = 2, .start_addr = 0x20010000, .size = 0x00008000, .readable = true, .writable = true, .executable = false, .cacheable = false },
        .{ .name_id = 3, .start_addr = 0x40000000, .size = 0x00001000, .readable = true, .writable = true, .executable = false, .cacheable = false },
        .{ .name_id = 4, .start_addr = 0x40001000, .size = 0x00001000, .readable = true, .writable = true, .executable = false, .cacheable = false },
        .{ .name_id = 5, .start_addr = 0x40002000, .size = 0x00001000, .readable = true, .writable = false, .executable = false, .cacheable = false },
        .{ .name_id = 6, .start_addr = 0xE0000000, .size = 0x00100000, .readable = true, .writable = true, .executable = false, .cacheable = false },
    };
    break :blk contract.validated(ValidatedMemoryMap(regions.len){ .regions = regions }).regions;
};

test "memory map regions do not overlap" {
    comptime {
        try std.testing.expectEqual(7, memory_map.len);
        for (0..memory_map.len) |i| {
            for (i + 1..memory_map.len) |j| {
                const a_end = memory_map[i].start_addr + memory_map[i].size;
                const b_end = memory_map[j].start_addr + memory_map[j].size;
                try std.testing.expect(a_end <= memory_map[j].start_addr or b_end <= memory_map[i].start_addr);
            }
        }
    }
}

test "memory map respects W^X" {
    comptime {
        for (memory_map) |region| {
            try std.testing.expect(!(region.writable and region.executable));
        }
    }
}

test "memory map all regions are naturally aligned" {
    comptime {
        for (memory_map) |region| {
            try std.testing.expectEqual(0, region.start_addr % region.size);
        }
    }
}

// --- Interrupt Vector Table ---

const IrqEntry = struct {
    vector: u8,
    priority: u8,
    handler_task_id: u8,
    preempts_below_priority: u8,

    pub fn contractValidate(comptime self: IrqEntry) ?[]const u8 {
        if (constraint.inRange(0, 15, self.priority)) |err| return err;

        if (self.preempts_below_priority > self.priority)
            return "preemption threshold cannot exceed own priority";
        return null;
    }
};

fn ValidatedIrqTable(comptime len: usize, comptime task_set_len: usize) type {
    return struct {
        entries: [len]IrqEntry,
        task_set_ref: [task_set_len]TaskDef,

        pub fn contractValidate(comptime self: @This()) ?[]const u8 {
            if (constraint.lenInRange(1, 64, self.entries.len)) |err| return err;

            var vectors: [len]u8 = undefined;
            for (self.entries, 0..) |entry, i| {
                vectors[i] = entry.vector;

                // Handler task must exist in the task set
                var found = false;
                for (self.task_set_ref) |task| {
                    if (task.id == entry.handler_task_id) {
                        found = true;
                        break;
                    }
                }
                if (!found)
                    return std.fmt.comptimePrint(
                        "IRQ vector {} references unknown task {}",
                        .{ entry.vector, entry.handler_task_id },
                    );
            }
            if (constraint.noDuplicates(u8, &vectors)) |err| return err;
            return null;
        }
    };
}

const irq_table = blk: {
    const entries = [_]IrqEntry{
        .{ .vector = 0, .priority = 0, .handler_task_id = 1, .preempts_below_priority = 0 },
        .{ .vector = 1, .priority = 2, .handler_task_id = 2, .preempts_below_priority = 1 },
        .{ .vector = 5, .priority = 5, .handler_task_id = 3, .preempts_below_priority = 3 },
        .{ .vector = 10, .priority = 8, .handler_task_id = 5, .preempts_below_priority = 5 },
    };
    break :blk contract.validated(ValidatedIrqTable(entries.len, task_set.len){ .entries = entries, .task_set_ref = task_set }).entries;
};

test "IRQ table has unique vectors" {
    comptime {
        try std.testing.expectEqual(4, irq_table.len);
        var vectors: [irq_table.len]u8 = undefined;
        for (irq_table, 0..) |entry, i| vectors[i] = entry.vector;
        for (0..vectors.len) |i| {
            for (i + 1..vectors.len) |j| {
                try std.testing.expect(vectors[i] != vectors[j]);
            }
        }
    }
}

test "IRQ handlers reference valid tasks" {
    comptime {
        for (irq_table) |entry| {
            var found = false;
            for (task_set) |task| {
                if (task.id == entry.handler_task_id) {
                    found = true;
                    break;
                }
            }
            try std.testing.expect(found);
        }
    }
}
