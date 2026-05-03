//! Flags comparisons where both sides are identical (`x == x`, `x != x`, etc.).
//! These are always true or always false (barring NaN) and indicate a copy-paste bug.

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
    return .{ .rule_id = "no_self_comparison", .run = &run };
}

const comparison_tags = [_]Ast.Node.Tag{
    .equal_equal,
    .bang_equal,
    .less_than,
    .greater_than,
    .less_or_equal,
    .greater_or_equal,
};

fn isComparisonTag(tag: Ast.Node.Tag) bool {
    for (comparison_tags) |t| {
        if (tag == t) return true;
    }
    return false;
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
        if (!isComparisonTag(tag)) continue;

        const data = shims.nodeData(tree.*, node_idx);
        const lhs = data.node_and_node[0];
        const rhs = data.node_and_node[1];

        const lhs_src = tree.getNodeSource(lhs);
        const rhs_src = tree.getNodeSource(rhs);

        if (lhs_src.len > 0 and std.mem.eql(u8, lhs_src, rhs_src)) {
            const op_token = shims.nodeMainToken(tree.*, node_idx);
            try lint_problems.append(gpa, .{
                .rule_id = rule.rule_id,
                .severity = config.severity,
                .start = .startOfNode(tree.*, node_idx),
                .end = .endOfNode(tree.*, node_idx),
                .message = try std.fmt.allocPrint(
                    gpa,
                    "Comparing `{s}` to itself with `{s}` — result is always the same",
                    .{ lhs_src, tree.tokenSlice(op_token) },
                ),
            });
        }
    }

    return if (lint_problems.items.len > 0)
        try zlinter.results.LintResult.init(gpa, doc.path, try lint_problems.toOwnedSlice(gpa))
    else
        null;
}
