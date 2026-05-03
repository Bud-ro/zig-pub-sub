//! Flags test blocks that contain no assertion calls.
//! A test without assertions verifies nothing. Tests that intentionally skip
//! (via `return error.SkipZigTest`) are excluded.

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
    return .{ .rule_id = "missing_test_assertion", .run = &run };
}

fn isAnonymousTest(tree: *const Ast, node: Ast.Node.Index) bool {
    const data = shims.nodeData(tree.*, node);
    return data.opt_token_and_node[0].unwrap() == null;
}

fn nodeContainsAssertion(tree: *const Ast, node: Ast.Node.Index) bool {
    const src = tree.getNodeSource(node);
    const patterns = [_][]const u8{
        "expectEqual",
        "expectError",
        "expectEqualSlices",
        "expectEqualStrings",
        "expectApproxEqAbs",
        "expectApproxEqRel",
        "expectFmt",
        ".expect(",
        "SkipZigTest",
        "@compileError",
        "debug.assert",
        "assertValid",
        "try ",
        "comptime",
    };
    for (patterns) |pat| {
        if (std.mem.indexOf(u8, src, pat) != null) return true;
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

        if (shims.nodeTag(tree.*, node_idx) != .test_decl) continue;
        if (isAnonymousTest(tree, node_idx)) continue;

        const data = shims.nodeData(tree.*, node_idx);
        const body_node = data.opt_token_and_node[1];

        if (!nodeContainsAssertion(tree, body_node)) {
            const test_token = shims.nodeMainToken(tree.*, node_idx);
            try lint_problems.append(gpa, .{
                .rule_id = rule.rule_id,
                .severity = config.severity,
                .start = .startOfToken(tree.*, test_token),
                .end = .endOfToken(tree.*, test_token),
                .message = try std.fmt.allocPrint(gpa, "Test block contains no assertions", .{}),
            });
        }
    }

    return if (lint_problems.items.len > 0)
        try zlinter.results.LintResult.init(gpa, doc.path, try lint_problems.toOwnedSlice(gpa))
    else
        null;
}
