//! Flags binary expressions where both operands are identical for operators
//! where this produces trivial or suspicious results.
//!
//! `x - x` is always 0, `x / x` is always 1, `x % x` is always 0,
//! `x & x` / `x | x` / `x ^ x` are redundant or always 0. These usually
//! indicate copy-paste bugs.
//!
//! Note: `x + x` and `x * x` are NOT flagged — `x + x` is `2*x` and
//! `x * x` is `x²`, both common and intentional.

// zlinter-disable require_doc_comment
const std = @import("std");
const zlinter = @import("zlinter");
const shims = zlinter.shims;
const Ast = std.zig.Ast;

pub const Config = struct {
    severity: zlinter.rules.LintProblemSeverity = .warning,
};

pub fn buildRule(options: zlinter.rules.RuleOptions) zlinter.rules.LintRule {
    _ = options;
    return .{ .rule_id = "no_identical_binary_operands", .run = &run };
}

const suspicious_tags = [_]Ast.Node.Tag{
    .sub,
    .div,
    .mod,
    .bit_and,
    .bit_xor,
    .sub_wrap,
};

fn isSuspiciousTag(tag: Ast.Node.Tag) bool {
    for (suspicious_tags) |t| {
        if (tag == t) return true;
    }
    return false;
}

fn opSymbol(tag: Ast.Node.Tag) []const u8 {
    return switch (tag) {
        .sub => "-",
        .div => "/",
        .mod => "%",
        .bit_and => "&",
        .bit_xor => "^",
        .sub_wrap => "-%",
        else => "?",
    };
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
    var it = try doc.nodeLineageIterator(.root, gpa);
    defer it.deinit();

    while (try it.next()) |tuple| {
        const node, _ = tuple;
        const node_idx = node.toNodeIndex();

        const tag = shims.nodeTag(tree.*, node_idx);
        if (!isSuspiciousTag(tag)) continue;

        const data = shims.nodeData(tree.*, node_idx);
        const lhs = data.node_and_node[0];
        const rhs = data.node_and_node[1];

        const lhs_src = tree.getNodeSource(lhs);
        const rhs_src = tree.getNodeSource(rhs);

        if (lhs_src.len > 0 and std.mem.eql(u8, lhs_src, rhs_src)) {
            try lint_problems.append(gpa, .{
                .rule_id = rule.rule_id,
                .severity = config.severity,
                .start = .startOfNode(tree.*, node_idx),
                .end = .endOfNode(tree.*, node_idx),
                .message = try std.fmt.allocPrint(
                    gpa,
                    "Both operands of `{s}` are identical (`{s}`) — result is trivially known",
                    .{ opSymbol(tag), lhs_src },
                ),
            });
        }
    }

    return if (lint_problems.items.len > 0)
        try zlinter.results.LintResult.init(gpa, doc.path, try lint_problems.toOwnedSlice(gpa))
    else
        null;
}
