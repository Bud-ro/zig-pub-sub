const std = @import("std");
const constraints = @import("data_gen").constraints;
const contracts = @import("data_gen").contracts;
const generators = @import("data_gen").generators;

// --- Rate-Monotonic Task Scheduling ---
// Tasks with periods and priorities. Rate-monotonic: shorter period = higher priority.
// CPU utilization must stay below the schedulability bound.

const TaskDef = struct {
    id: u8,
    period_ms: u16,
    wcet_us: u32,
    priority: u8,
    stack_size: u16,
};

fn validateRateMonotonic(comptime tasks: []const TaskDef) void {
    @setEvalBranchQuota(5000);
    constraints.lenInRange(1, 32, tasks.len);

    var ids: [tasks.len]u8 = undefined;
    var priorities: [tasks.len]u8 = undefined;
    for (tasks, 0..) |task, i| {
        ids[i] = task.id;
        priorities[i] = task.priority;
        constraints.nonZero(u16, task.period_ms);
        constraints.nonZero(u32, task.wcet_us);
        constraints.isPowerOfTwo(task.stack_size);
        constraints.inRange(u16, 64, 8192, task.stack_size);

        if (task.wcet_us >= @as(u32, task.period_ms) * 1000)
            @compileError(std.fmt.comptimePrint(
                "task {} WCET ({}us) exceeds period ({}ms)",
                .{ task.id, task.wcet_us, task.period_ms },
            ));
    }
    constraints.noDuplicates(u8, &ids);
    constraints.noDuplicates(u8, &priorities);

    // Rate-monotonic: shorter period must have higher priority (lower number)
    for (0..tasks.len) |i| {
        for (i + 1..tasks.len) |j| {
            if (tasks[i].period_ms < tasks[j].period_ms and tasks[i].priority > tasks[j].priority)
                @compileError(std.fmt.comptimePrint(
                    "RM violation: task {} (period {}ms) has lower priority than task {} (period {}ms)",
                    .{ tasks[i].id, tasks[i].period_ms, tasks[j].id, tasks[j].period_ms },
                ));
            if (tasks[i].period_ms > tasks[j].period_ms and tasks[i].priority < tasks[j].priority)
                @compileError(std.fmt.comptimePrint(
                    "RM violation: task {} (period {}ms) has higher priority than task {} (period {}ms)",
                    .{ tasks[i].id, tasks[i].period_ms, tasks[j].id, tasks[j].period_ms },
                ));
        }
    }

    // CPU utilization check: sum(wcet/period) must be < 1.0
    // We compute in parts-per-thousand to avoid floating point
    var utilization_ppt: u32 = 0;
    for (tasks) |task| {
        utilization_ppt += (task.wcet_us * 1000) / (@as(u32, task.period_ms) * 1000);
    }
    if (utilization_ppt >= 1000)
        @compileError(std.fmt.comptimePrint(
            "CPU utilization {}‰ exceeds 1000‰ (100%)",
            .{utilization_ppt},
        ));

    // Liu & Layland bound for N tasks: N * (2^(1/N) - 1)
    // For practical purposes, warn if utilization > 700 (70%) for > 3 tasks
    if (tasks.len > 3 and utilization_ppt > 700)
        @compileError(std.fmt.comptimePrint(
            "CPU utilization {}‰ exceeds practical RM bound for {} tasks",
            .{ utilization_ppt, tasks.len },
        ));
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
    validateRateMonotonic(&tasks);
    break :blk tasks;
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
};

fn validateMemoryMap(comptime regions: []const MemRegion) void {
    @setEvalBranchQuota(5000);
    constraints.lenInRange(1, 32, regions.len);

    var ids: [regions.len]u8 = undefined;
    for (regions, 0..) |region, i| {
        ids[i] = region.name_id;
        constraints.nonZero(u32, region.size);
        constraints.isPowerOfTwo(region.size);

        if (region.start_addr % region.size != 0)
            @compileError(std.fmt.comptimePrint(
                "region {} at 0x{x:0>8} is not aligned to its size 0x{x}",
                .{ region.name_id, region.start_addr, region.size },
            ));

        if (region.executable and region.writable)
            @compileError(std.fmt.comptimePrint(
                "region {} is both writable and executable (W^X violation)",
                .{region.name_id},
            ));

        if (!region.readable and !region.writable)
            @compileError(std.fmt.comptimePrint(
                "region {} has no read or write access",
                .{region.name_id},
            ));
    }
    constraints.noDuplicates(u8, &ids);

    for (0..regions.len) |i| {
        for (i + 1..regions.len) |j| {
            const a_end = regions[i].start_addr + regions[i].size;
            const b_end = regions[j].start_addr + regions[j].size;
            if (regions[i].start_addr < b_end and regions[j].start_addr < a_end)
                @compileError(std.fmt.comptimePrint(
                    "memory regions {} and {} overlap",
                    .{ regions[i].name_id, regions[j].name_id },
                ));
        }
    }
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
    validateMemoryMap(&regions);
    break :blk regions;
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
};

fn validateIrqTable(comptime entries: []const IrqEntry, comptime task_set_ref: []const TaskDef) void {
    constraints.lenInRange(1, 64, entries.len);

    var vectors: [entries.len]u8 = undefined;
    for (entries, 0..) |entry, i| {
        vectors[i] = entry.vector;
        constraints.inRange(u8, 0, 15, entry.priority);

        if (entry.preempts_below_priority > entry.priority)
            @compileError("preemption threshold cannot exceed own priority");

        // Handler task must exist in the task set
        var found = false;
        for (task_set_ref) |task| {
            if (task.id == entry.handler_task_id) {
                found = true;
                break;
            }
        }
        if (!found)
            @compileError(std.fmt.comptimePrint(
                "IRQ vector {} references unknown task {}",
                .{ entry.vector, entry.handler_task_id },
            ));
    }
    constraints.noDuplicates(u8, &vectors);
}

const irq_table = blk: {
    const entries = [_]IrqEntry{
        .{ .vector = 0, .priority = 0, .handler_task_id = 1, .preempts_below_priority = 0 },
        .{ .vector = 1, .priority = 2, .handler_task_id = 2, .preempts_below_priority = 1 },
        .{ .vector = 5, .priority = 5, .handler_task_id = 3, .preempts_below_priority = 3 },
        .{ .vector = 10, .priority = 8, .handler_task_id = 5, .preempts_below_priority = 5 },
    };
    validateIrqTable(&entries, &task_set);
    break :blk entries;
};

test "IRQ table has unique vectors" {
    comptime {
        try std.testing.expectEqual(4, irq_table.len);
        var vectors: [irq_table.len]u8 = undefined;
        for (irq_table, 0..) |entry, i| vectors[i] = entry.vector;
        constraints.noDuplicates(u8, &vectors);
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
