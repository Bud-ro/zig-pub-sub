//! Flags `x == true`, `x == false`, `x != true`, `x != false`.
//! Use `x` or `!x` directly instead.

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
    return .{ .rule_id = "no_boolean_literal_compare", .run = &run };
}

fn isBoolLiteral(tree: *const Ast, node: Ast.Node.Index) bool {
    if (shims.nodeTag(tree.*, node) != .identifier) return false;
    const slice = tree.tokenSlice(tree.firstToken(node));
    return std.mem.eql(u8, slice, "true") or std.mem.eql(u8, slice, "false");
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
        if (tag != .equal_equal and tag != .bang_equal) continue;

        const data = shims.nodeData(tree.*, node_idx);
        const lhs = data.node_and_node[0];
        const rhs = data.node_and_node[1];

        const lhs_is_bool = isBoolLiteral(tree, lhs);
        const rhs_is_bool = isBoolLiteral(tree, rhs);

        if (!lhs_is_bool and !rhs_is_bool) continue;

        const op_str = if (tag == .equal_equal) "==" else "!=";
        const bool_side = if (rhs_is_bool) tree.getNodeSource(rhs) else tree.getNodeSource(lhs);

        try lint_problems.append(gpa, .{
            .rule_id = rule.rule_id,
            .severity = config.severity,
            .start = .startOfNode(tree.*, node_idx),
            .end = .endOfNode(tree.*, node_idx),
            .message = try std.fmt.allocPrint(
                gpa,
                "Redundant comparison `{s} {s}` — use the expression directly",
                .{ op_str, bool_side },
            ),
        });
    }

    return if (lint_problems.items.len > 0)
        try zlinter.results.LintResult.init(gpa, doc.path, try lint_problems.toOwnedSlice(gpa))
    else
        null;
}
