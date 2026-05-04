const std = @import("std");

const FuncRange = struct {
    start: usize,
    name: []const u8,
};

fn isFuncLabel(raw_line: []const u8) ?[]const u8 {
    if (raw_line.len == 0 or raw_line[0] == ' ' or raw_line[0] == '\t') return null;
    const colon = std.mem.indexOfScalar(u8, raw_line, ':') orelse return null;
    const after = std.mem.trim(u8, raw_line[colon + 1 ..], " \t\r");
    if (after.len != 0) return null;
    const name = raw_line[0..colon];
    if (name.len == 0 or name[0] == '.') return null;
    return name;
}

fn isExportedFunc(name: []const u8) bool {
    return std.mem.startsWith(u8, name, "codegen_");
}

fn isDirective(line: []const u8) bool {
    const prefixes = [_][]const u8{
        ".loc\t",  ".cfi_",   ".Ltmp",  ".Lfunc",
        ".file",   ".size\t", ".globl", ".p2align",
        ".type\t",
    };
    for (prefixes) |prefix| {
        if (std.mem.startsWith(u8, line, prefix)) return true;
    }
    return false;
}

fn findBranchTarget(text: []const u8) ?struct { label: []const u8, rest: []const u8 } {
    var i: usize = 0;
    while (i + 4 < text.len) : (i += 1) {
        if (!std.mem.eql(u8, text[i .. i + 4], ".LBB")) continue;
        const start = i;
        i += 4;
        const d1 = i;
        while (i < text.len and std.ascii.isDigit(text[i])) : (i += 1) {}
        if (i == d1) continue;
        if (i >= text.len or text[i] != '_') continue;
        i += 1;
        const d2 = i;
        while (i < text.len and std.ascii.isDigit(text[i])) : (i += 1) {}
        if (i == d2) continue;
        return .{ .label = text[start..i], .rest = text[i..] };
    }
    return null;
}

fn extractCallTarget(line: []const u8) ?[]const u8 {
    const trimmed = std.mem.trim(u8, line, " \t\r");
    const target_str = blk: {
        if (trimmed.len >= 5 and std.mem.eql(u8, trimmed[0..4], "call") and
            (trimmed[4] == '\t' or trimmed[4] == ' '))
            break :blk std.mem.trim(u8, trimmed[4..], " \t");
        if (trimmed.len >= 4 and std.mem.eql(u8, trimmed[0..3], "jmp") and
            (trimmed[3] == '\t' or trimmed[3] == ' '))
            break :blk std.mem.trim(u8, trimmed[3..], " \t");
        return null;
    };
    if (target_str.len == 0 or target_str[0] == '*' or target_str[0] == '.') return null;
    if (isRegister(target_str)) return null;
    return target_str;
}

fn isStdlibFunc(name: []const u8) bool {
    const bare = if (name.len > 0 and name[0] == '"') name[1..] else name;
    const prefixes = [_][]const u8{
        "debug.", "Thread.", "Io.", "fs.", "mem.", "os.", "posix.",
    };
    for (prefixes) |prefix| {
        if (std.mem.startsWith(u8, bare, prefix)) return true;
    }
    return false;
}

fn isRegister(name: []const u8) bool {
    const registers = [_][]const u8{
        "rax", "rbx", "rcx", "rdx", "rsi", "rdi", "rbp", "rsp",
        "r8",  "r9",  "r10", "r11", "r12", "r13", "r14", "r15",
    };
    for (registers) |r| if (std.mem.eql(u8, name, r)) return true;
    return false;
}

const ExtractFuncArgs = struct {
    branch_targets: *const std.StringHashMapUnmanaged(void),
    output: ?*std.ArrayList(u8),
    gpa: std.mem.Allocator,
};

fn extractFunc(all_lines: []const []const u8, start: usize, end: usize, args: ExtractFuncArgs) !usize {
    const branch_targets = args.branch_targets;
    const output = args.output;
    const gpa = args.gpa;
    var count: usize = 0;
    for (all_lines[start..end]) |raw_line| {
        const line = std.mem.trim(u8, raw_line, " \t\r");
        if (std.mem.startsWith(u8, line, ".section")) break;
        if (isDirective(line)) continue;
        if (line.len == 0) continue;

        if (std.mem.endsWith(u8, line, ":")) {
            const label = line[0 .. line.len - 1];
            if (branch_targets.contains(label)) {
                if (output) |out| {
                    try out.appendSlice(gpa, line);
                    try out.append(gpa, '\n');
                }
            } else {
                break;
            }
            continue;
        }

        if (output) |out| {
            try out.appendSlice(gpa, "        ");
            try out.appendSlice(gpa, line);
            try out.append(gpa, '\n');
        }
        count += 1;
    }
    return count;
}

/// Entry point for the assembly stripping tool.
// zlinter-disable-next-line no_inferred_error_unions
pub fn main() !void {
    var gpa_state: std.heap.DebugAllocator(.{}) = .init;
    defer _ = gpa_state.deinit();
    const gpa = gpa_state.allocator();

    const args = try std.process.argsAlloc(gpa);
    defer std.process.argsFree(gpa, args);

    var input_path: ?[]const u8 = null;
    var output_path: ?[]const u8 = null;
    var split_dir: ?[]const u8 = null;
    var i: usize = 1;
    while (i < args.len) : (i += 1) {
        if (std.mem.eql(u8, args[i], "--split-dir") and i + 1 < args.len) {
            i += 1;
            split_dir = args[i];
        } else if (input_path == null) {
            input_path = args[i];
        } else if (output_path == null) {
            output_path = args[i];
        }
    }

    if (input_path == null) {
        std.debug.print("Usage: strip_asm <input.s> [output.s | --split-dir <dir>]\n", .{});
        std.process.exit(1);
    }

    const input = try std.fs.cwd().readFileAlloc(gpa, input_path.?, 64 * 1024 * 1024);
    defer gpa.free(input);

    var line_list: std.ArrayList([]const u8) = .empty;
    defer line_list.deinit(gpa);
    {
        var iter = std.mem.splitScalar(u8, input, '\n');
        while (iter.next()) |line| try line_list.append(gpa, line);
    }
    const all_lines = line_list.items;

    // Pass 1: collect branch targets and ALL function labels
    var branch_targets: std.StringHashMapUnmanaged(void) = .empty;
    defer branch_targets.deinit(gpa);
    var all_funcs: std.StringHashMapUnmanaged(FuncRange) = .empty;
    defer all_funcs.deinit(gpa);

    for (all_lines, 0..) |raw_line, line_num| {
        const line = std.mem.trim(u8, raw_line, " \t\r");
        var search = line;
        while (findBranchTarget(search)) |result| {
            search = result.rest;
            if (!std.mem.startsWith(u8, line, result.label))
                try branch_targets.put(gpa, result.label, {});
        }
        if (isFuncLabel(raw_line)) |name|
            try all_funcs.put(gpa, name, .{ .start = line_num, .name = name });
    }

    // Compute end line for each function
    var func_ends: std.StringHashMapUnmanaged(usize) = .empty;
    defer func_ends.deinit(gpa);
    {
        var it = all_funcs.iterator();
        while (it.next()) |entry| {
            const start = entry.value_ptr.start;
            var end: usize = all_lines.len;
            for (all_lines[start + 1 ..], start + 1..) |raw_line, idx| {
                if (isFuncLabel(raw_line) != null) {
                    end = idx;
                    break;
                }
                const line = std.mem.trim(u8, raw_line, " \t\r");
                if (std.mem.startsWith(u8, line, ".section")) {
                    end = idx;
                    break;
                }
            }
            try func_ends.put(gpa, entry.key_ptr.*, end);
        }
    }

    // Pass 2: for each exported function, find its call targets
    var export_call_targets: std.StringHashMapUnmanaged(std.ArrayListUnmanaged([]const u8)) = .empty;
    defer {
        var ect_it = export_call_targets.iterator();
        while (ect_it.next()) |entry| {
            entry.value_ptr.deinit(gpa);
        }
        export_call_targets.deinit(gpa);
    }
    var ordered_exports: std.ArrayListUnmanaged([]const u8) = .{};
    defer ordered_exports.deinit(gpa);

    for (all_lines) |raw_line| {
        if (isFuncLabel(raw_line)) |name| {
            if (isExportedFunc(name)) {
                try ordered_exports.append(gpa, name);
                var targets: std.ArrayListUnmanaged([]const u8) = .{};
                const func = all_funcs.get(name).?;
                const end = func_ends.get(name).?;
                for (all_lines[func.start..end]) |func_line| {
                    if (extractCallTarget(func_line)) |target| {
                        if (!isStdlibFunc(target) and all_funcs.contains(target)) {
                            try targets.append(gpa, target);
                        }
                    }
                }
                try export_call_targets.put(gpa, name, targets);
            }
        }
    }

    if (split_dir) |dir| {
        try emitSplitFiles(gpa, dir, ordered_exports.items, &export_call_targets, &all_funcs, &func_ends, all_lines, &branch_targets);
    } else {
        try emitCombinedFile(gpa, output_path, ordered_exports.items, &export_call_targets, &all_funcs, &func_ends, all_lines, &branch_targets);
    }
}

fn emitFuncBody(
    gpa: std.mem.Allocator,
    output: *std.ArrayListUnmanaged(u8),
    name: []const u8,
    all_funcs: *const std.StringHashMapUnmanaged(FuncRange),
    func_ends: *const std.StringHashMapUnmanaged(usize),
    all_lines: []const []const u8,
    branch_targets: *const std.StringHashMapUnmanaged(void),
) !usize {
    const func = all_funcs.get(name).?;
    const end = func_ends.get(name).?;
    try output.appendSlice(gpa, name);
    try output.appendSlice(gpa, ":\n");
    return try extractFunc(all_lines, func.start + 1, end, .{ .branch_targets = branch_targets, .output = output, .gpa = gpa });
}

// zlinter-disable-next-line no_inferred_error_unions
fn emitSplitFiles(
    gpa: std.mem.Allocator,
    dir_path: []const u8,
    ordered_exports: []const []const u8,
    export_call_targets: *const std.StringHashMapUnmanaged(std.ArrayListUnmanaged([]const u8)),
    all_funcs: *const std.StringHashMapUnmanaged(FuncRange),
    func_ends: *const std.StringHashMapUnmanaged(usize),
    all_lines: []const []const u8,
    branch_targets: *const std.StringHashMapUnmanaged(void),
) !void {
    var total_exports: usize = 0;
    var total_helpers: usize = 0;
    var total_instr: usize = 0;

    for (ordered_exports) |name| {
        var output: std.ArrayListUnmanaged(u8) = .{};
        defer output.deinit(gpa);

        var instr = try emitFuncBody(gpa, &output, name, all_funcs, func_ends, all_lines, branch_targets);
        try output.appendSlice(gpa, "\n");
        total_exports += 1;

        const targets = export_call_targets.get(name).?;
        if (targets.items.len > 0) {
            var seen: std.StringHashMapUnmanaged(void) = .empty;
            defer seen.deinit(gpa);
            var has_helpers = false;
            for (targets.items) |target| {
                if (seen.contains(target)) continue;
                try seen.put(gpa, target, {});
                if (!has_helpers) {
                    try output.appendSlice(gpa, "; --- called functions ---\n\n");
                    has_helpers = true;
                }
                instr += try emitFuncBody(gpa, &output, target, all_funcs, func_ends, all_lines, branch_targets);
                try output.appendSlice(gpa, "\n");
                total_helpers += 1;
            }
        }
        total_instr += instr;

        const filename = try std.fmt.allocPrint(gpa, "{s}/{s}.s", .{ dir_path, name });
        defer gpa.free(filename);
        const file = try std.fs.cwd().createFile(filename, .{});
        defer file.close();
        var buf: [4096]u8 = undefined;
        var w = file.writer(&buf);
        try w.interface.writeAll(output.items);
        try w.interface.flush();
    }

    std.debug.print("{d} functions ({d} exported, {d} called), {d} instructions\n", .{
        total_exports + total_helpers,
        total_exports,
        total_helpers,
        total_instr,
    });
}

// zlinter-disable-next-line no_inferred_error_unions
fn emitCombinedFile(
    gpa: std.mem.Allocator,
    output_path: ?[]const u8,
    ordered_exports: []const []const u8,
    export_call_targets: *const std.StringHashMapUnmanaged(std.ArrayListUnmanaged([]const u8)),
    all_funcs: *const std.StringHashMapUnmanaged(FuncRange),
    func_ends: *const std.StringHashMapUnmanaged(usize),
    all_lines: []const []const u8,
    branch_targets: *const std.StringHashMapUnmanaged(void),
) !void {
    var output: std.ArrayListUnmanaged(u8) = .{};
    defer output.deinit(gpa);

    var total_instr: usize = 0;
    var all_helpers: std.StringHashMapUnmanaged(void) = .empty;
    defer all_helpers.deinit(gpa);
    var ordered_helpers: std.ArrayListUnmanaged([]const u8) = .{};
    defer ordered_helpers.deinit(gpa);

    for (ordered_exports) |name| {
        total_instr += try emitFuncBody(gpa, &output, name, all_funcs, func_ends, all_lines, branch_targets);
        try output.appendSlice(gpa, "\n");

        const targets = export_call_targets.get(name).?;
        for (targets.items) |target| {
            if (!all_helpers.contains(target)) {
                try all_helpers.put(gpa, target, {});
                try ordered_helpers.append(gpa, target);
            }
        }
    }

    if (ordered_helpers.items.len > 0) {
        try output.appendSlice(gpa, "; --- called functions ---\n\n");
        for (ordered_helpers.items) |name| {
            total_instr += try emitFuncBody(gpa, &output, name, all_funcs, func_ends, all_lines, branch_targets);
            try output.appendSlice(gpa, "\n");
        }
    }

    if (output_path) |path| {
        const file = try std.fs.cwd().createFile(path, .{});
        defer file.close();
        var buf: [4096]u8 = undefined;
        var w = file.writer(&buf);
        try w.interface.writeAll(output.items);
        try w.interface.flush();
    } else {
        const stdout = std.fs.File.stdout();
        var buf: [4096]u8 = undefined;
        var w = stdout.writer(&buf);
        try w.interface.writeAll(output.items);
        try w.interface.flush();
    }

    std.debug.print("{d} functions ({d} exported, {d} called), {d} instructions\n", .{
        ordered_exports.len + ordered_helpers.items.len,
        ordered_exports.len,
        ordered_helpers.items.len,
        total_instr,
    });
}

const testing = std.testing;

test "isFuncLabel recognizes top-level labels" {
    try testing.expectEqualStrings("codegen_read_u32", isFuncLabel("codegen_read_u32:").?);
    try testing.expectEqualStrings("my_helper", isFuncLabel("my_helper:").?);
}

test "isFuncLabel rejects indented, dot, and non-label lines" {
    try testing.expectEqual(null, isFuncLabel("        mov eax, 1"));
    try testing.expectEqual(null, isFuncLabel("\tmov eax, 1"));
    try testing.expectEqual(null, isFuncLabel(".LBB0_1:"));
    try testing.expectEqual(null, isFuncLabel(".Lfunc_end0:"));
    try testing.expectEqual(null, isFuncLabel(""));
    try testing.expectEqual(null, isFuncLabel("  label:  extra"));
}

test "isExportedFunc matches codegen_ prefix" {
    try testing.expect(isExportedFunc("codegen_read_u32"));
    try testing.expect(!isExportedFunc("my_helper"));
    try testing.expect(!isExportedFunc(""));
}

test "findBranchTarget extracts .LBB labels" {
    const result = findBranchTarget("        je\t.LBB5_3").?;
    try testing.expectEqualStrings(".LBB5_3", result.label);

    const multi = findBranchTarget("        jne .LBB12_42 ; comment");
    try testing.expectEqualStrings(".LBB12_42", multi.?.label);

    try testing.expectEqual(null, findBranchTarget("        mov eax, 1"));
    try testing.expectEqual(null, findBranchTarget(".LBB:"));
    try testing.expectEqual(null, findBranchTarget(".LBB_1:"));
}

test "findBranchTarget finds multiple targets in one line" {
    const first = findBranchTarget("cmov .LBB0_1, .LBB0_2").?;
    try testing.expectEqualStrings(".LBB0_1", first.label);
    const second = findBranchTarget(first.rest).?;
    try testing.expectEqualStrings(".LBB0_2", second.label);
}

test "extractCallTarget parses call and jmp instructions" {
    try testing.expectEqualStrings("my_helper", extractCallTarget("        call\tmy_helper").?);
    try testing.expectEqualStrings("foo", extractCallTarget("call foo").?);
    try testing.expectEqualStrings("my_func", extractCallTarget("        jmp\tmy_func").?);
    try testing.expectEqualStrings("foo", extractCallTarget("jmp foo").?);
    try testing.expectEqualStrings("read_helper", extractCallTarget("        call\tread_helper").?);
    try testing.expectEqualStrings("ram_data_component.write", extractCallTarget("        jmp\tram_data_component.write").?);
    try testing.expectEqual(null, extractCallTarget("        call\t*rax"));
    try testing.expectEqual(null, extractCallTarget("        call\trax"));
    try testing.expectEqual(null, extractCallTarget("        call\tr12"));
    try testing.expectEqual(null, extractCallTarget("        jmp\t.LBB0_1"));
    try testing.expectEqual(null, extractCallTarget("        jmp\trax"));
    try testing.expectEqual(null, extractCallTarget("        jmp\trsp"));
    try testing.expectEqual(null, extractCallTarget("        mov eax, 1"));
    try testing.expectEqual(null, extractCallTarget(""));
}

test "isStdlibFunc matches stdlib prefixes" {
    try testing.expect(isStdlibFunc("debug.defaultPanic"));
    try testing.expect(isStdlibFunc("debug.FullPanic((function 'defaultPanic')).outOfBounds"));
    try testing.expect(isStdlibFunc("\"debug.FullPanic((function 'defaultPanic')).unwrapNull\""));
    try testing.expect(isStdlibFunc("Thread.Mutex.FutexImpl.lockSlow"));
    try testing.expect(isStdlibFunc("fs.File.writeAll"));
    try testing.expect(isStdlibFunc("posix.abort"));
    try testing.expect(isStdlibFunc("mem.eql__anon_3258"));
    try testing.expect(!isStdlibFunc("ram_data_component.RamDataComponent.publish"));
    try testing.expect(!isStdlibFunc("system_data.SystemData.runtimeRead"));
    try testing.expect(!isStdlibFunc("codegen_foo"));
    try testing.expect(!isStdlibFunc("timer.TimerModule.tryRemove"));
}

test "isDirective filters assembler directives" {
    try testing.expect(isDirective(".loc\t1 2 3"));
    try testing.expect(isDirective(".cfi_startproc"));
    try testing.expect(isDirective(".globl codegen_foo"));
    try testing.expect(isDirective(".p2align 4"));
    try testing.expect(!isDirective("        mov eax, 1"));
    try testing.expect(!isDirective("codegen_foo:"));
}
