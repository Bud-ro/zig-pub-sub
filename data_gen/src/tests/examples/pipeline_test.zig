const std = @import("std");
const constraints = @import("data_gen").constraints;
const contracts = @import("data_gen").contracts;
const generators = @import("data_gen").generators;

// --- Data Processing Pipeline (DAG) ---
// Processing stages connected in a directed acyclic graph.
// Each stage has an input type and output type (represented as type IDs).
// Connected stages must have matching types at their connection points.

const DataType = enum(u8) {
    raw_adc,
    filtered_signal,
    rms_value,
    peak_value,
    fft_spectrum,
    alarm_flags,
    scaled_engineering,
    temperature_c,
    packed_report,
};

const StageKind = enum(u8) {
    source,
    filter,
    transform,
    combine,
    sink,
};

const PipelineStage = struct {
    id: u8,
    kind: StageKind,
    input_types: []const DataType,
    output_type: DataType,
    processing_budget_us: u16,
};

const PipelineConnection = struct {
    from_stage: u8,
    to_stage: u8,
    data_type: DataType,
};

fn validatePipeline(
    comptime stages: []const PipelineStage,
    comptime connections: []const PipelineConnection,
) void {
    @setEvalBranchQuota(10_000);
    constraints.lenInRange(2, 32, stages.len);
    constraints.lenInRange(1, 64, connections.len);

    // Unique stage IDs
    var stage_ids: [stages.len]u8 = undefined;
    for (stages, 0..) |stage, i| {
        stage_ids[i] = stage.id;
        constraints.nonZero(u16, stage.processing_budget_us);

        if (stage.kind == .source and stage.input_types.len != 0)
            @compileError(std.fmt.comptimePrint(
                "source stage {} must have no inputs",
                .{stage.id},
            ));

        if (stage.kind != .source and stage.input_types.len == 0)
            @compileError(std.fmt.comptimePrint(
                "non-source stage {} must have at least one input",
                .{stage.id},
            ));

        if (stage.kind == .combine and stage.input_types.len < 2)
            @compileError(std.fmt.comptimePrint(
                "combine stage {} must have at least 2 inputs",
                .{stage.id},
            ));
    }
    constraints.noDuplicates(u8, &stage_ids);

    // Validate connections
    for (connections) |conn| {
        // Both stages must exist
        var from_stage: ?PipelineStage = null;
        var to_stage: ?PipelineStage = null;
        for (stages) |s| {
            if (s.id == conn.from_stage) from_stage = s;
            if (s.id == conn.to_stage) to_stage = s;
        }

        if (from_stage == null)
            @compileError(std.fmt.comptimePrint("connection references unknown source stage {}", .{conn.from_stage}));
        if (to_stage == null)
            @compileError(std.fmt.comptimePrint("connection references unknown destination stage {}", .{conn.to_stage}));

        // Output type of source must match the connection's data type
        if (from_stage.?.output_type != conn.data_type)
            @compileError(std.fmt.comptimePrint(
                "stage {} outputs {} but connection expects {}",
                .{ conn.from_stage, @intFromEnum(from_stage.?.output_type), @intFromEnum(conn.data_type) },
            ));

        // Connection data type must be one of the destination's accepted input types
        var type_accepted = false;
        for (to_stage.?.input_types) |t| {
            if (t == conn.data_type) {
                type_accepted = true;
                break;
            }
        }
        if (!type_accepted)
            @compileError(std.fmt.comptimePrint(
                "stage {} does not accept type {} as input",
                .{ conn.to_stage, @intFromEnum(conn.data_type) },
            ));

        // No self-loops
        if (conn.from_stage == conn.to_stage)
            @compileError("self-loop detected in pipeline");
    }

    // Sinks must have no outgoing connections
    for (stages) |stage| {
        if (stage.kind == .sink) {
            for (connections) |conn| {
                if (conn.from_stage == stage.id)
                    @compileError(std.fmt.comptimePrint(
                        "sink stage {} must not have outgoing connections",
                        .{stage.id},
                    ));
            }
        }
    }

    // Sources must have no incoming connections
    for (stages) |stage| {
        if (stage.kind == .source) {
            for (connections) |conn| {
                if (conn.to_stage == stage.id)
                    @compileError(std.fmt.comptimePrint(
                        "source stage {} must not have incoming connections",
                        .{stage.id},
                    ));
            }
        }
    }

    // DAG check: no cycles. Use topological ordering — for each stage, verify
    // that all ancestors (reached by following connections backwards) don't include itself.
    for (stages) |start| {
        var visited = [_]bool{false} ** 256;
        var stack = [_]u8{0} ** 32;
        stack[0] = start.id;
        var stack_len: u8 = 1;

        while (stack_len > 0) {
            stack_len -= 1;
            const current = stack[stack_len];

            for (connections) |conn| {
                if (conn.from_stage == current) {
                    if (conn.to_stage == start.id)
                        @compileError(std.fmt.comptimePrint(
                            "cycle detected involving stage {}",
                            .{start.id},
                        ));
                    if (!visited[conn.to_stage]) {
                        visited[conn.to_stage] = true;
                        stack[stack_len] = conn.to_stage;
                        stack_len += 1;
                    }
                }
            }
        }
    }
}

/// Compute total processing budget for the critical path (longest chain).
fn criticalPathBudget(
    comptime stages: []const PipelineStage,
    comptime connections: []const PipelineConnection,
) u32 {
    @setEvalBranchQuota(10_000);
    var max_budget: u32 = 0;

    for (stages) |stage| {
        if (stage.kind != .source) continue;
        // BFS from each source, tracking cumulative budget
        var queue_id = [_]u8{0} ** 32;
        var queue_budget = [_]u32{0} ** 32;
        queue_id[0] = stage.id;
        queue_budget[0] = stage.processing_budget_us;
        var q_len: u8 = 1;
        var q_idx: u8 = 0;

        while (q_idx < q_len) {
            const current_id = queue_id[q_idx];
            const current_budget = queue_budget[q_idx];
            q_idx += 1;

            if (current_budget > max_budget)
                max_budget = current_budget;

            for (connections) |conn| {
                if (conn.from_stage == current_id) {
                    for (stages) |s| {
                        if (s.id == conn.to_stage) {
                            queue_id[q_len] = conn.to_stage;
                            queue_budget[q_len] = current_budget + s.processing_budget_us;
                            q_len += 1;
                            break;
                        }
                    }
                }
            }
        }
    }

    return max_budget;
}

const dsp_stages = [_]PipelineStage{
    .{ .id = 0, .kind = .source, .input_types = &.{}, .output_type = .raw_adc, .processing_budget_us = 10 },
    .{ .id = 1, .kind = .filter, .input_types = &.{.raw_adc}, .output_type = .filtered_signal, .processing_budget_us = 50 },
    .{ .id = 2, .kind = .transform, .input_types = &.{.filtered_signal}, .output_type = .rms_value, .processing_budget_us = 30 },
    .{ .id = 3, .kind = .transform, .input_types = &.{.filtered_signal}, .output_type = .peak_value, .processing_budget_us = 20 },
    .{ .id = 4, .kind = .transform, .input_types = &.{.filtered_signal}, .output_type = .fft_spectrum, .processing_budget_us = 200 },
    .{ .id = 5, .kind = .transform, .input_types = &.{.filtered_signal}, .output_type = .scaled_engineering, .processing_budget_us = 15 },
    .{ .id = 6, .kind = .transform, .input_types = &.{.scaled_engineering}, .output_type = .temperature_c, .processing_budget_us = 10 },
    .{ .id = 7, .kind = .combine, .input_types = &.{ .rms_value, .peak_value, .temperature_c }, .output_type = .alarm_flags, .processing_budget_us = 25 },
    .{ .id = 8, .kind = .combine, .input_types = &.{ .alarm_flags, .fft_spectrum }, .output_type = .packed_report, .processing_budget_us = 40 },
    .{ .id = 9, .kind = .sink, .input_types = &.{.packed_report}, .output_type = .packed_report, .processing_budget_us = 5 },
};

const dsp_connections = blk: {
    const conns = [_]PipelineConnection{
        .{ .from_stage = 0, .to_stage = 1, .data_type = .raw_adc },
        .{ .from_stage = 1, .to_stage = 2, .data_type = .filtered_signal },
        .{ .from_stage = 1, .to_stage = 3, .data_type = .filtered_signal },
        .{ .from_stage = 1, .to_stage = 4, .data_type = .filtered_signal },
        .{ .from_stage = 1, .to_stage = 5, .data_type = .filtered_signal },
        .{ .from_stage = 5, .to_stage = 6, .data_type = .scaled_engineering },
        .{ .from_stage = 2, .to_stage = 7, .data_type = .rms_value },
        .{ .from_stage = 3, .to_stage = 7, .data_type = .peak_value },
        .{ .from_stage = 6, .to_stage = 7, .data_type = .temperature_c },
        .{ .from_stage = 7, .to_stage = 8, .data_type = .alarm_flags },
        .{ .from_stage = 4, .to_stage = 8, .data_type = .fft_spectrum },
        .{ .from_stage = 8, .to_stage = 9, .data_type = .packed_report },
    };
    validatePipeline(&dsp_stages, &conns);
    break :blk conns;
};

test "DSP pipeline has 10 stages and 12 connections" {
    comptime {
        try std.testing.expectEqual(10, dsp_stages.len);
        try std.testing.expectEqual(12, dsp_connections.len);
    }
}

test "DSP pipeline fan-out from filter stage" {
    comptime {
        var fan_out: u8 = 0;
        for (dsp_connections) |conn| {
            if (conn.from_stage == 1) fan_out += 1;
        }
        try std.testing.expectEqual(4, fan_out);
    }
}

test "DSP pipeline fan-in at alarm combine stage" {
    comptime {
        var fan_in: u8 = 0;
        for (dsp_connections) |conn| {
            if (conn.to_stage == 7) fan_in += 1;
        }
        try std.testing.expectEqual(3, fan_in);
    }
}

test "DSP pipeline critical path budget" {
    comptime {
        const budget = criticalPathBudget(&dsp_stages, &dsp_connections);
        // Critical path: source(10) → filter(50) → fft(200) → report(40) → sink(5) = 305
        try std.testing.expectEqual(305, budget);
    }
}

test "DSP pipeline critical path fits in 1ms sample period" {
    comptime {
        const budget = criticalPathBudget(&dsp_stages, &dsp_connections);
        try std.testing.expect(budget < 1000);
    }
}
