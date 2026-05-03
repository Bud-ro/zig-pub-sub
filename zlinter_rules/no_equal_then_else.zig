//! Flags `if`/`else` branches with identical bodies (likely copy-paste bug).

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
    return .{ .rule_id = "no_equal_then_else", .run = &run };
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

        const full_if = tree.fullIf(node_idx) orelse continue;
        const else_node = full_if.ast.else_expr.unwrap() orelse continue;

        const then_src = tree.getNodeSource(full_if.ast.then_expr);
        const else_src = tree.getNodeSource(else_node);

        if (std.mem.eql(u8, then_src, else_src)) {
            try lint_problems.append(gpa, .{
                .rule_id = rule.rule_id,
                .severity = config.severity,
                .start = .startOfToken(tree.*, full_if.ast.if_token),
                .end = .endOfNode(tree.*, else_node),
                .message = try std.fmt.allocPrint(gpa, "if/else branches have identical bodies", .{}),
            });
        }
    }

    return if (lint_problems.items.len > 0)
        try zlinter.results.LintResult.init(gpa, doc.path, try lint_problems.toOwnedSlice(gpa))
    else
        null;
}
