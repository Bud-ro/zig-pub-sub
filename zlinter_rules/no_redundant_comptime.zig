//! Flags redundant `comptime` on parameters whose types are already comptime-known.
//!
//! In Zig, parameters of type `type`, `comptime_int`, `comptime_float`, and
//! `@TypeOf(...)` are always comptime. Writing `comptime T: type` is equivalent
//! to `T: type` — the `comptime` keyword adds nothing and is misleading.

// zlinter-disable require_doc_comment
const std = @import("std");
const zlinter = @import("zlinter");
const shims = zlinter.shims;
const Ast = std.zig.Ast;

/// Config for no_redundant_comptime rule.
pub const Config = struct {
    severity: zlinter.rules.LintProblemSeverity = .warning,
};

/// Builds and returns the no_redundant_comptime rule.
pub fn buildRule(options: zlinter.rules.RuleOptions) zlinter.rules.LintRule {
    _ = options;
    return zlinter.rules.LintRule{
        .rule_id = "no_redundant_comptime",
        .run = &run,
    };
}

const redundant_types = [_][]const u8{
    "type",
    "comptime_int",
    "comptime_float",
};

fn isRedundantComptimeType(tree: *const Ast, type_expr: Ast.Node.Index) bool {
    const tag = shims.nodeTag(tree.*, type_expr);
    switch (tag) {
        .identifier => {
            const slice = tree.tokenSlice(tree.firstToken(type_expr));
            for (redundant_types) |t| {
                if (std.mem.eql(u8, slice, t)) return true;
            }
            return false;
        },
        .builtin_call_two, .builtin_call_two_comma => {
            const builtin_token = tree.firstToken(type_expr);
            const slice = tree.tokenSlice(builtin_token);
            return std.mem.eql(u8, slice, "@TypeOf");
        },
        else => return false,
    }
}

fn run(
    rule: zlinter.rules.LintRule,
    _: *zlinter.session.LintContext,
    doc: *const zlinter.session.LintDocument,
    gpa: std.mem.Allocator,
    options: zlinter.rules.RunOptions,
) error{OutOfMemory}!?zlinter.results.LintResult {
    const config = options.getConfig(Config);
    if (config.severity == .off) return null;

    var lint_problems: shims.ArrayList(zlinter.results.LintProblem) = .empty;
    defer lint_problems.deinit(gpa);

    const tree = &doc.handle.tree;

    const root: shims.NodeIndexShim = .root;
    var it = try doc.nodeLineageIterator(root, gpa);
    defer it.deinit();

    while (try it.next()) |tuple| {
        const node, _ = tuple;

        var fn_proto_buffer: [1]Ast.Node.Index = undefined;
        const fn_proto = tree.fullFnProto(&fn_proto_buffer, node.toNodeIndex()) orelse continue;

        var param_it = fn_proto.iterate(tree);
        while (param_it.next()) |param| {
            const comptime_token = param.comptime_noalias orelse continue;
            if (tree.tokenTag(comptime_token) != .keyword_comptime) continue;

            const type_node = param.type_expr orelse continue;
            if (!isRedundantComptimeType(tree, type_node)) continue;

            const type_slice = tree.tokenSlice(tree.firstToken(type_node));
            try lint_problems.append(gpa, .{
                .rule_id = rule.rule_id,
                .severity = config.severity,
                .start = .startOfToken(tree.*, comptime_token),
                .end = .endOfToken(tree.*, tree.lastToken(type_node)),
                .message = try std.fmt.allocPrint(
                    gpa,
                    "Redundant `comptime` on parameter of type `{s}` — parameters of this type are always comptime",
                    .{type_slice},
                ),
            });
        }
    }

    return if (lint_problems.items.len > 0)
        try zlinter.results.LintResult.init(
            gpa,
            doc.path,
            try lint_problems.toOwnedSlice(gpa),
        )
    else
        null;
}
