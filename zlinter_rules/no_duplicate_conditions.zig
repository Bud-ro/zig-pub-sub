//! Flags if-else-if chains where the same condition appears more than once.
//! The second (or later) branch with the same condition is dead code.

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
    return .{ .rule_id = "no_duplicate_conditions", .run = &run };
}

fn collectIfChainConditions(tree: *const Ast, node: Ast.Node.Index, conditions: *shims.ArrayList(Ast.Node.Index), gpa: std.mem.Allocator) void {
    const full_if = tree.fullIf(node) orelse return;
    conditions.append(gpa, full_if.ast.cond_expr) catch return;

    const else_node = full_if.ast.else_expr.unwrap() orelse return;
    const else_tag = shims.nodeTag(tree.*, else_node);
    if (else_tag == .if_simple or else_tag == .@"if") {
        collectIfChainConditions(tree, else_node, conditions, gpa);
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
    var it = try doc.nodeLineageIterator(.root, gpa);
    defer it.deinit();

    var conditions: shims.ArrayList(Ast.Node.Index) = .empty;
    defer conditions.deinit(gpa);

    while (try it.next()) |tuple| {
        const node, _ = tuple;
        const node_idx = node.toNodeIndex();

        const tag = shims.nodeTag(tree.*, node_idx);
        if (tag != .if_simple and tag != .@"if") continue;

        // Only process the head of an if-else-if chain (skip nested else-ifs)
        const full_if = tree.fullIf(node_idx) orelse continue;
        const else_node = full_if.ast.else_expr.unwrap() orelse continue;
        const else_tag = shims.nodeTag(tree.*, else_node);
        if (else_tag != .if_simple and else_tag != .@"if") continue;

        conditions.clearRetainingCapacity();
        collectIfChainConditions(tree, node_idx, &conditions, gpa);

        if (conditions.items.len < 2) continue;

        for (0..conditions.items.len) |i| {
            const src_i = tree.getNodeSource(conditions.items[i]);
            for (i + 1..conditions.items.len) |j| {
                const src_j = tree.getNodeSource(conditions.items[j]);
                if (std.mem.eql(u8, src_i, src_j)) {
                    try lint_problems.append(gpa, .{
                        .rule_id = rule.rule_id,
                        .severity = config.severity,
                        .start = .startOfNode(tree.*, conditions.items[j]),
                        .end = .endOfNode(tree.*, conditions.items[j]),
                        .message = try std.fmt.allocPrint(
                            gpa,
                            "Condition `{s}` duplicates an earlier branch — this branch is dead code",
                            .{src_i},
                        ),
                    });
                }
            }
        }
    }

    return if (lint_problems.items.len > 0)
        try zlinter.results.LintResult.init(gpa, doc.path, try lint_problems.toOwnedSlice(gpa))
    else
        null;
}
