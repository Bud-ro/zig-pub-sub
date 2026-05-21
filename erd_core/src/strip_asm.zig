const snapshot_comments = @import("snapshot_comments.zig");
const std = @import("std");

const FuncRange = struct {
    start: usize,
    name: []const u8,
};

fn isFuncLabel(raw_line: []const u8) ?[]const u8 {
    if (raw_line.len == 0 or raw_line[0] == ' ' or raw_line[0] == '\t') return null;
    const line = if (raw_line[0] == '"')
        raw_line
    else
        std.mem.trim(u8, raw_line, " \t\r");
    const colon = std.mem.lastIndexOfScalar(u8, line, ':') orelse return null;
    const after = std.mem.trim(u8, line[colon + 1 ..], " \t\r");
    if (after.len != 0) return null;
    const name = line[0..colon];
    if (name.len == 0) return null;
    if (name[0] == '.') {
        const non_func = [_][]const u8{ ".LBB", ".Ltmp", ".Lfunc", ".Lline", ".Lpcrel", ".LCPI", ".Ldebug", ".LFE", ".LFB" };
        for (non_func) |prefix| {
            if (std.mem.startsWith(u8, name, prefix)) {
                if (name.len > prefix.len and name[prefix.len] == '.') continue;
                return null;
            }
        }
    }
    return name;
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
    if (target_str.len == 0 or target_str[0] == '*') return null;
    if (isRegister(target_str)) return null;
    return target_str;
}

/// Exclude stdlib/runtime symbols from the called-functions section.
fn isStdlibFunc(name: []const u8) bool {
    const bare = blk: {
        var b: []const u8 = if (name.len > 0 and name[0] == '"') name[1..] else name;
        if (b.len > 2 and b[0] == '.' and b[1] == 'L') b = b[2..];
        break :blk b;
    };
    const prefixes = [_][]const u8{
        "std.",    "debug.", "Thread.", "Io.",
        "fs.",     "mem.",   "os.",     "posix.",
        "builtin",
    };
    for (prefixes) |prefix| {
        if (std.mem.startsWith(u8, bare, prefix)) return true;
    }
    return false;
}

const IdMap = std.StringHashMapUnmanaged(u32);

fn resolveMode(mode_name: []const u8) ?snapshot_comments.Mode {
    if (std.mem.eql(u8, mode_name, "ReleaseFast")) return .release_fast;
    if (std.mem.eql(u8, mode_name, "ReleaseSmall")) return .release_small;
    return null;
}

fn commentModeMatches(entry_modes: ?[]const snapshot_comments.Mode, mode: ?snapshot_comments.Mode) bool {
    const modes = entry_modes orelse return true;
    const m = mode orelse return false;
    for (modes) |allowed| {
        if (allowed == .all or allowed == m) return true;
    }
    return false;
}

fn findComment(name: []const u8, mode: ?snapshot_comments.Mode) ?[]const u8 {
    for (snapshot_comments.comments) |entry| {
        if (std.mem.eql(u8, entry.func, name) and commentModeMatches(entry.modes, mode))
            return entry.text;
    }
    return null;
}

fn findRating(name: []const u8, mode: snapshot_comments.Mode) ?snapshot_comments.Rating {
    for (snapshot_comments.ratings) |entry| {
        if (std.mem.eql(u8, entry.func, name) and (entry.mode == .all or entry.mode == mode))
            return entry;
    }
    return null;
}

fn emitAnnotations(gpa: std.mem.Allocator, output: *std.ArrayListUnmanaged(u8), name: []const u8, mode_name: []const u8, missing_ratings: *std.ArrayListUnmanaged(u8)) !void {
    const mode = resolveMode(mode_name);
    const rating = if (mode) |m| findRating(name, m) else null;
    const comment = if (mode) |m| findComment(name, m) else null;

    if (mode != null and rating == null) {
        try missing_ratings.appendSlice(gpa, name);
        try missing_ratings.append(gpa, ' ');
        try missing_ratings.appendSlice(gpa, mode_name);
        try missing_ratings.append(gpa, '\n');
    }

    try output.appendSlice(gpa, "; snapshot_comments.zig\n");
    if (rating) |r| {
        try output.appendSlice(gpa, "; Speed: ");
        try output.appendSlice(gpa, r.speed.label());
        try output.appendSlice(gpa, " | Size: ");
        switch (r.size) {
            .optimal => try output.appendSlice(gpa, "Optimal"),
            .suboptimal => try output.appendSlice(gpa, "Suboptimal"),
            .until => |n| {
                var buf: [32]u8 = undefined;
                const n_str = std.fmt.bufPrint(&buf, "{d}", .{n}) catch "?";
                try output.appendSlice(gpa, "Optimal (until ");
                try output.appendSlice(gpa, n_str);
                try output.appendSlice(gpa, " calls)");
            },
        }
        try output.append(gpa, '\n');
    }
    if (comment) |text| {
        var lines = std.mem.splitScalar(u8, text, '\n');
        while (lines.next()) |line| {
            try output.appendSlice(gpa, "; ");
            try output.appendSlice(gpa, line);
            try output.append(gpa, '\n');
        }
    }
    try output.appendSlice(gpa, ";\n");
}

/// Write `line` to `out`, replacing `__anon_NNNN` and `__struct_NNN`
/// suffixes with sequential per-file IDs so snapshots are stable across
/// compilation environments while preserving distinctness within a file.
/// When `normalize_labels` is true, also replaces `.LBBN_M` branch labels
/// with sequential `.L0`, `.L1`, ... so compiler-assigned function indices
/// don't cause diff noise when unrelated code changes.
fn appendNormalized(gpa: std.mem.Allocator, out: *std.ArrayListUnmanaged(u8), line: []const u8, id_map: *IdMap, normalize_labels: bool) !void {
    const needles = [_][]const u8{ "__anon_", "__struct_" };
    var pos: usize = 0;
    while (pos < line.len) {
        if (normalize_labels and pos + 4 <= line.len and std.mem.eql(u8, line[pos..][0..4], ".LBB")) {
            const lbb_start = pos;
            var end = pos + 4;
            const d1 = end;
            while (end < line.len and std.ascii.isDigit(line[end])) : (end += 1) {}
            if (end > d1 and end < line.len and line[end] == '_') {
                end += 1;
                const d2 = end;
                while (end < line.len and std.ascii.isDigit(line[end])) : (end += 1) {}
                if (end > d2) {
                    const original = line[lbb_start..end];
                    const gop = try id_map.getOrPut(gpa, original);
                    if (!gop.found_existing) gop.value_ptr.* = id_map.count() - 1;
                    try out.appendSlice(gpa, ".L");
                    var num_buf: [20]u8 = undefined;
                    const num_str = std.fmt.bufPrint(&num_buf, "{d}", .{gop.value_ptr.*}) catch unreachable;
                    try out.appendSlice(gpa, num_str);
                    pos = end;
                    continue;
                }
            }
        }

        var found = false;
        for (needles) |needle| {
            if (pos + needle.len <= line.len and std.mem.eql(u8, line[pos..][0..needle.len], needle)) {
                const digit_start = pos + needle.len;
                var digit_end = digit_start;
                while (digit_end < line.len and std.ascii.isDigit(line[digit_end])) : (digit_end += 1) {}
                if (digit_end > digit_start) {
                    const original = line[pos..digit_end];
                    const gop = try id_map.getOrPut(gpa, original);
                    if (!gop.found_existing) gop.value_ptr.* = id_map.count() - 1;
                    try out.appendSlice(gpa, needle);
                    var num_buf: [20]u8 = undefined;
                    const num_str = std.fmt.bufPrint(&num_buf, "{d}", .{gop.value_ptr.*}) catch unreachable;
                    try out.appendSlice(gpa, num_str);
                    pos = digit_end;
                } else {
                    try out.appendSlice(gpa, needle);
                    pos += needle.len;
                }
                found = true;
                break;
            }
        }
        if (!found) {
            try out.append(gpa, line[pos]);
            pos += 1;
        }
    }
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
    output: ?*std.ArrayListUnmanaged(u8),
    gpa: std.mem.Allocator,
    id_map: *IdMap,
    normalize_labels: bool,
};

fn extractFunc(all_lines: []const []const u8, start: usize, end: usize, args: ExtractFuncArgs) !usize {
    const branch_targets = args.branch_targets;
    const output = args.output;
    const gpa = args.gpa;
    const id_map = args.id_map;
    const norm = args.normalize_labels;
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
                    try appendNormalized(gpa, out, line, id_map, norm);
                    try out.append(gpa, '\n');
                }
            } else {
                break;
            }
            continue;
        }

        if (output) |out| {
            try out.appendSlice(gpa, "        ");
            try appendNormalized(gpa, out, line, id_map, norm);
            try out.append(gpa, '\n');
        }
        count += 1;
    }
    return count;
}

/// Entry point for the assembly stripping tool.
// zlinter-disable-next-line no_inferred_error_unions
pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;

    const args = try init.minimal.args.toSlice(init.arena.allocator());

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

    const input = try std.Io.Dir.cwd().readFileAlloc(io, input_path.?, gpa, .limited(64 * 1024 * 1024));
    defer gpa.free(input);

    var line_list: std.ArrayList([]const u8) = .empty;
    defer line_list.deinit(gpa);
    {
        var iter = std.mem.splitScalar(u8, input, '\n');
        while (iter.next()) |line| try line_list.append(gpa, line);
    }
    const all_lines = line_list.items;

    // Pass 1: collect branch targets, function labels, and .globl exports
    var branch_targets: std.StringHashMapUnmanaged(void) = .empty;
    defer branch_targets.deinit(gpa);
    var all_funcs: std.StringHashMapUnmanaged(FuncRange) = .empty;
    defer all_funcs.deinit(gpa);
    var globl_exports: std.StringHashMapUnmanaged(void) = .empty;
    defer globl_exports.deinit(gpa);

    var alias_to_target: std.StringHashMapUnmanaged([]const u8) = .empty;
    defer alias_to_target.deinit(gpa);

    for (all_lines, 0..) |raw_line, line_num| {
        const line = std.mem.trim(u8, raw_line, " \t\r");
        if (std.mem.startsWith(u8, line, ".globl\t") or std.mem.startsWith(u8, line, ".globl ")) {
            const sym = std.mem.trim(u8, line[".globl".len..], " \t");
            if (sym.len > 0) try globl_exports.put(gpa, sym, {});
        }
        if (std.mem.indexOf(u8, line, " = ")) |eq_pos| {
            const alias = std.mem.trim(u8, line[0..eq_pos], " \t");
            const target = std.mem.trim(u8, line[eq_pos + 3 ..], " \t");
            if (alias.len > 0 and target.len > 0)
                try alias_to_target.put(gpa, alias, target);
        }
        var search = line;
        while (findBranchTarget(search)) |result| {
            search = result.rest;
            if (!std.mem.startsWith(u8, line, result.label))
                try branch_targets.put(gpa, result.label, {});
        }
        if (isFuncLabel(raw_line)) |name|
            try all_funcs.put(gpa, name, .{ .start = line_num, .name = name });
    }

    // Resolve aliases: if "read_u32" is in globl_exports and aliases to
    // "codegen_harness.read_u32", add the target to globl_exports too.
    var display_names: std.StringHashMapUnmanaged([]const u8) = .empty;
    defer display_names.deinit(gpa);
    {
        var it = alias_to_target.iterator();
        while (it.next()) |entry| {
            const alias = entry.key_ptr.*;
            const target = entry.value_ptr.*;
            if (globl_exports.contains(alias) and !all_funcs.contains(alias)) {
                try globl_exports.put(gpa, target, {});
                try display_names.put(gpa, target, alias);
            }
        }
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

    // Pass 2: for each function, find its call targets
    var func_call_targets: std.StringHashMapUnmanaged(std.ArrayListUnmanaged([]const u8)) = .empty;
    defer {
        var fct_it = func_call_targets.iterator();
        while (fct_it.next()) |entry| {
            entry.value_ptr.deinit(gpa);
        }
        func_call_targets.deinit(gpa);
    }
    var ordered_exports: std.ArrayListUnmanaged([]const u8) = .empty;
    defer ordered_exports.deinit(gpa);

    for (all_lines) |raw_line| {
        const name = isFuncLabel(raw_line) orelse continue;
        if (globl_exports.contains(name))
            try ordered_exports.append(gpa, name);
        const func = all_funcs.get(name).?;
        const end = func_ends.get(name).?;
        var targets: std.ArrayListUnmanaged([]const u8) = .empty;
        for (all_lines[func.start..end]) |func_line| {
            if (extractCallTarget(func_line)) |target| {
                if (all_funcs.contains(target)) {
                    try targets.append(gpa, target);
                }
            }
        }
        try func_call_targets.put(gpa, name, targets);
    }

    if (split_dir) |dir| {
        const mode_name = std.Io.Dir.path.basename(dir);
        try emitSplitFiles(gpa, io, dir, mode_name, ordered_exports.items, &func_call_targets, &all_funcs, &func_ends, all_lines, &branch_targets, &display_names);
    } else {
        try emitCombinedFile(gpa, io, output_path, ordered_exports.items, &func_call_targets, &all_funcs, &func_ends, all_lines, &branch_targets, &display_names);
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
    display_names: *const std.StringHashMapUnmanaged([]const u8),
    id_map: *IdMap,
    normalize_labels: bool,
) !usize {
    const func = all_funcs.get(name).?;
    const end = func_ends.get(name).?;
    const label = display_names.get(name) orelse name;
    try appendNormalized(gpa, output, label, id_map, normalize_labels);
    try output.appendSlice(gpa, ":\n");
    return try extractFunc(all_lines, func.start + 1, end, .{ .branch_targets = branch_targets, .output = output, .gpa = gpa, .id_map = id_map, .normalize_labels = normalize_labels });
}

// zlinter-disable-next-line no_inferred_error_unions
fn emitSplitFiles(
    gpa: std.mem.Allocator,
    io: std.Io,
    dir_path: []const u8,
    mode_name: []const u8,
    ordered_exports: []const []const u8,
    func_call_targets: *const std.StringHashMapUnmanaged(std.ArrayListUnmanaged([]const u8)),
    all_funcs: *const std.StringHashMapUnmanaged(FuncRange),
    func_ends: *const std.StringHashMapUnmanaged(usize),
    all_lines: []const []const u8,
    branch_targets: *const std.StringHashMapUnmanaged(void),
    display_names: *const std.StringHashMapUnmanaged([]const u8),
) !void {
    var total_exports: usize = 0;
    var total_helpers: usize = 0;
    var total_instr: usize = 0;

    var missing_ratings: std.ArrayListUnmanaged(u8) = .empty;
    defer missing_ratings.deinit(gpa);

    for (ordered_exports) |name| {
        var output: std.ArrayListUnmanaged(u8) = .empty;
        defer output.deinit(gpa);
        var file_ids: IdMap = .empty;
        defer file_ids.deinit(gpa);

        const file_label = display_names.get(name) orelse name;
        try emitAnnotations(gpa, &output, file_label, mode_name, &missing_ratings);

        var instr = try emitFuncBody(gpa, &output, name, all_funcs, func_ends, all_lines, branch_targets, display_names, &file_ids, true);
        try output.appendSlice(gpa, "\n");
        total_exports += 1;

        const targets = func_call_targets.get(name).?;
        if (targets.items.len > 0) {
            var seen: std.StringHashMapUnmanaged(void) = .empty;
            defer seen.deinit(gpa);
            var has_helpers = false;
            for (targets.items) |target| {
                if (seen.contains(target) or isStdlibFunc(target)) continue;
                try seen.put(gpa, target, {});
                if (!has_helpers) {
                    try output.appendSlice(gpa, "; --- called functions ---\n\n");
                    has_helpers = true;
                }
                instr += try emitFuncBody(gpa, &output, target, all_funcs, func_ends, all_lines, branch_targets, display_names, &file_ids, true);
                try output.appendSlice(gpa, "\n");
                total_helpers += 1;
            }
        }
        total_instr += instr;

        const filename = try std.fmt.allocPrint(gpa, "{s}/{s}.s", .{ dir_path, file_label });
        defer gpa.free(filename);
        const file = try std.Io.Dir.cwd().createFile(io, filename, .{});
        defer file.close(io);
        var buf: [4096]u8 = undefined;
        var w = file.writer(io, &buf);
        try w.interface.writeAll(output.items);
        try w.interface.flush();
    }

    if (missing_ratings.items.len > 0) {
        std.debug.print("ERROR: Missing snapshot_comments.zig ratings for:\n{s}", .{missing_ratings.items});
        std.process.exit(1);
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
    io: std.Io,
    output_path: ?[]const u8,
    ordered_exports: []const []const u8,
    func_call_targets: *const std.StringHashMapUnmanaged(std.ArrayListUnmanaged([]const u8)),
    all_funcs: *const std.StringHashMapUnmanaged(FuncRange),
    func_ends: *const std.StringHashMapUnmanaged(usize),
    all_lines: []const []const u8,
    branch_targets: *const std.StringHashMapUnmanaged(void),
    display_names: *const std.StringHashMapUnmanaged([]const u8),
) !void {
    var output: std.ArrayListUnmanaged(u8) = .empty;
    defer output.deinit(gpa);
    var file_ids: IdMap = .empty;
    defer file_ids.deinit(gpa);

    var total_instr: usize = 0;
    var all_helpers: std.StringHashMapUnmanaged(void) = .empty;
    defer all_helpers.deinit(gpa);
    var ordered_helpers: std.ArrayListUnmanaged([]const u8) = .empty;
    defer ordered_helpers.deinit(gpa);

    for (ordered_exports) |name| {
        total_instr += try emitFuncBody(gpa, &output, name, all_funcs, func_ends, all_lines, branch_targets, display_names, &file_ids, false);
        try output.appendSlice(gpa, "\n");

        const targets = func_call_targets.get(name).?;
        for (targets.items) |target| {
            if (!all_helpers.contains(target)) {
                try all_helpers.put(gpa, target, {});
                try ordered_helpers.append(gpa, target);
            }
        }
    }

    // Transitively discover helpers' own call targets.
    {
        var hi: usize = 0;
        while (hi < ordered_helpers.items.len) : (hi += 1) {
            const helper = ordered_helpers.items[hi];
            if (isStdlibFunc(helper)) continue;
            if (func_call_targets.get(helper)) |targets| {
                for (targets.items) |target| {
                    if (!all_helpers.contains(target)) {
                        try all_helpers.put(gpa, target, {});
                        try ordered_helpers.append(gpa, target);
                    }
                }
            }
        }
    }

    if (ordered_helpers.items.len > 0) {
        try output.appendSlice(gpa, "; --- called functions ---\n\n");
        for (ordered_helpers.items) |name| {
            total_instr += try emitFuncBody(gpa, &output, name, all_funcs, func_ends, all_lines, branch_targets, display_names, &file_ids, false);
            try output.appendSlice(gpa, "\n");
        }
    }

    if (output_path) |path| {
        const file = try std.Io.Dir.cwd().createFile(io, path, .{});
        defer file.close(io);
        var buf: [4096]u8 = undefined;
        var w = file.writer(io, &buf);
        try w.interface.writeAll(output.items);
        try w.interface.flush();
    } else {
        const stdout = std.Io.File.stdout();
        var buf: [4096]u8 = undefined;
        var w = stdout.writer(io, &buf);
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
    try testing.expectEqual(null, isFuncLabel(".Ldebug_info0:"));
    try testing.expectEqual(null, isFuncLabel(""));
    try testing.expectEqual(null, isFuncLabel("  label:  extra"));
}

test "isFuncLabel recognizes namespaced .L labels" {
    try testing.expectEqualStrings(".Ldebug.defaultPanic", isFuncLabel(".Ldebug.defaultPanic:").?);
    try testing.expectEqualStrings(".Ldebug.FullPanic.outOfBounds", isFuncLabel(".Ldebug.FullPanic.outOfBounds:").?);
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
    try testing.expectEqualStrings(".Ldebug.defaultPanic", extractCallTarget("        call\t.Ldebug.defaultPanic").?);
    try testing.expectEqualStrings(".LBB0_1", extractCallTarget("        jmp\t.LBB0_1").?);
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
    try testing.expect(isStdlibFunc("Io.File.writeAll"));
    try testing.expect(isStdlibFunc("fs.File.writeAll"));
    try testing.expect(isStdlibFunc("posix.abort"));
    try testing.expect(isStdlibFunc("mem.eql__anon_3258"));
    try testing.expect(isStdlibFunc("std.process.exit"));
    try testing.expect(isStdlibFunc(".Ldebug.defaultPanic"));
    try testing.expect(isStdlibFunc(".Lstd.process.exit"));
    try testing.expect(!isStdlibFunc("ram_data_component.RamDataComponent.publish"));
    try testing.expect(!isStdlibFunc("system_data.SystemData.runtimeRead"));
    try testing.expect(!isStdlibFunc("read_u32"));
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
