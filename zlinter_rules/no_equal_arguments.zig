//! Flags function calls where the same expression is passed as multiple arguments.
//! Catches copy-paste bugs like `write(.erd_a, .erd_a)`.

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
    return .{ .rule_id = "no_equal_arguments", .run = &run };
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

        var call_buffer: [1]Ast.Node.Index = undefined;
        const call = tree.fullCall(&call_buffer, node_idx) orelse continue;
        const params = call.ast.params;
        if (params.len < 2) continue;

        for (0..params.len) |i| {
            const src_i = tree.getNodeSource(params[i]);
            if (src_i.len == 0) continue;
            for (i + 1..params.len) |j| {
                const src_j = tree.getNodeSource(params[j]);
                if (std.mem.eql(u8, src_i, src_j)) {
                    try lint_problems.append(gpa, .{
                        .rule_id = rule.rule_id,
                        .severity = config.severity,
                        .start = .startOfNode(tree.*, params[j]),
                        .end = .endOfNode(tree.*, params[j]),
                        .message = try std.fmt.allocPrint(
                            gpa,
                            "Argument {d} is identical to argument {d}: `{s}`",
                            .{ j + 1, i + 1, src_i },
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
