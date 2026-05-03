const std = @import("std");
const constraint = @import("data_gen").constraint;

// --- Network Topology with Symmetric Cost Matrix ---
// A communication cost matrix between N nodes.
// Must be symmetric (cost[i][j] == cost[j][i]),
// diagonal must be zero (cost to self is 0),
// and the triangle inequality must hold:
// cost[i][j] <= cost[i][k] + cost[k][j] for all i,j,k.

fn CostMatrix(comptime n: usize) type {
    return struct {
        matrix: [n][n]u16,

        pub fn contractValidate(comptime self: @This()) ?[]const u8 {
            @setEvalBranchQuota(10_000);

            // Diagonal must be zero
            for (0..n) |i| {
                if (self.matrix[i][i] != 0)
                    return std.fmt.comptimePrint(
                        "cost matrix diagonal[{}][{}] must be 0, got {}",
                        .{ i, i, self.matrix[i][i] },
                    );
            }

            // Symmetry
            for (0..n) |i| {
                for (i + 1..n) |j| {
                    if (self.matrix[i][j] != self.matrix[j][i])
                        return std.fmt.comptimePrint(
                            "cost matrix not symmetric: [{},{}]={} != [{},{}]={}",
                            .{ i, j, self.matrix[i][j], j, i, self.matrix[j][i] },
                        );
                }
            }

            // All non-diagonal entries must be positive
            for (0..n) |i| {
                for (0..n) |j| {
                    if (i != j and self.matrix[i][j] == 0)
                        return std.fmt.comptimePrint(
                            "non-diagonal cost[{}][{}] must be > 0",
                            .{ i, j },
                        );
                }
            }

            // Triangle inequality
            for (0..n) |i| {
                for (0..n) |j| {
                    for (0..n) |k| {
                        if (i == j or i == k or j == k) continue;
                        const direct: u32 = self.matrix[i][j];
                        const via_k: u32 = @as(u32, self.matrix[i][k]) + self.matrix[k][j];
                        if (direct > via_k)
                            return std.fmt.comptimePrint(
                                "triangle inequality violated: cost[{}][{}]={} > cost[{}][{}]+cost[{}][{}]={}",
                                .{ i, j, direct, i, k, k, j, via_k },
                            );
                    }
                }
            }

            return null;
        }
    };
}

const latency_matrix = blk: {
    // 5 nodes, latency in microseconds
    const m = [5][5]u16{
        .{ 0, 10, 20, 25, 30 },
        .{ 10, 0, 15, 20, 25 },
        .{ 20, 15, 0, 10, 15 },
        .{ 25, 20, 10, 0, 8 },
        .{ 30, 25, 15, 8, 0 },
    };
    const wrapper: CostMatrix(5) = .{ .matrix = m };
    if (wrapper.contractValidate()) |err| @compileError(err);
    break :blk m;
};

test "latency matrix is symmetric" {
    comptime {
        for (0..5) |i| {
            for (i + 1..5) |j| {
                try std.testing.expectEqual(latency_matrix[i][j], latency_matrix[j][i]);
            }
        }
    }
}

test "latency matrix diagonal is zero" {
    comptime {
        for (0..5) |i| {
            try std.testing.expectEqual(0, latency_matrix[i][i]);
        }
    }
}

test "latency matrix satisfies triangle inequality" {
    comptime {
        for (0..5) |i| {
            for (0..5) |j| {
                for (0..5) |k| {
                    if (i == j or i == k or j == k) continue;
                    try std.testing.expect(latency_matrix[i][j] <= latency_matrix[i][k] + latency_matrix[k][j]);
                }
            }
        }
    }
}

// --- Spanning Tree Validation ---
// A set of edges forming a spanning tree of N nodes.
// Must connect all nodes (N-1 edges for N nodes) with no cycles.

const Edge = struct {
    a: u8,
    b: u8,
    cost: u16,

    pub fn contractValidate(comptime self: Edge) ?[]const u8 {
        if (constraint.nonZero(self.cost)) |err| return err;
        return null;
    }
};

fn SpanningTree(comptime n: u8, comptime edge_count: usize) type {
    return struct {
        edges: [edge_count]Edge,

        pub fn contractValidate(comptime self: @This()) ?[]const u8 {
            if (self.edges.len != n - 1)
                return std.fmt.comptimePrint(
                    "spanning tree of {} nodes requires exactly {} edges, got {}",
                    .{ n, n - 1, self.edges.len },
                );

            // All node indices in range
            for (self.edges) |e| {
                if (e.a >= n or e.b >= n)
                    return "edge references node outside range";
                if (e.a == e.b)
                    return "self-loop in spanning tree";
                if (e.contractValidate()) |err| return err;
            }

            // No duplicate edges
            for (0..self.edges.len) |i| {
                for (i + 1..self.edges.len) |j| {
                    const same = (self.edges[i].a == self.edges[j].a and self.edges[i].b == self.edges[j].b) or
                        (self.edges[i].a == self.edges[j].b and self.edges[i].b == self.edges[j].a);
                    if (same)
                        return "duplicate edge in spanning tree";
                }
            }

            // Connectivity check using union-find
            var parent: [256]u8 = undefined;
            for (0..n) |i| parent[i] = @intCast(i);

            for (self.edges) |e| {
                var ra = e.a;
                while (parent[ra] != ra) ra = parent[ra];
                var rb = e.b;
                while (parent[rb] != rb) rb = parent[rb];

                if (ra == rb)
                    return "cycle detected in spanning tree";

                parent[ra] = rb;
            }

            // Verify all nodes share a root
            var root = parent[0];
            while (parent[root] != root) root = parent[root];
            for (1..n) |i| {
                var r: u8 = @intCast(i);
                while (parent[r] != r) r = parent[r];
                if (r != root)
                    return "spanning tree does not connect all nodes";
            }

            return null;
        }
    };
}

const network_tree = blk: {
    const edges = [_]Edge{
        .{ .a = 0, .b = 1, .cost = 10 },
        .{ .a = 1, .b = 2, .cost = 15 },
        .{ .a = 2, .b = 3, .cost = 10 },
        .{ .a = 3, .b = 4, .cost = 8 },
    };
    const node_count = 5;
    const wrapper: SpanningTree(node_count, edges.len) = .{ .edges = edges };
    if (wrapper.contractValidate()) |err| @compileError(err);
    break :blk edges;
};

test "spanning tree has N-1 edges" {
    comptime {
        try std.testing.expectEqual(4, network_tree.len);
    }
}

test "spanning tree total cost" {
    comptime {
        var total: u32 = 0;
        for (network_tree) |e| total += e.cost;
        try std.testing.expectEqual(43, total);
    }
}

// --- Adjacency Matrix Consistency ---
// An adjacency matrix and a spanning tree must be consistent:
// every edge in the tree must exist in the full graph (cost matches).

fn TreeGraphConsistency(comptime n: usize, comptime edge_count: usize) type {
    return struct {
        matrix: [n][n]u16,
        tree: [edge_count]Edge,

        pub fn contractValidate(comptime self: @This()) ?[]const u8 {
            for (self.tree) |e| {
                if (self.matrix[e.a][e.b] != e.cost)
                    return std.fmt.comptimePrint(
                        "tree edge ({},{}) cost {} doesn't match graph cost {}",
                        .{ e.a, e.b, e.cost, self.matrix[e.a][e.b] },
                    );
            }
            return null;
        }
    };
}

test "spanning tree edges match latency matrix" {
    comptime {
        const wrapper: TreeGraphConsistency(5, network_tree.len) = .{
            .matrix = latency_matrix,
            .tree = network_tree,
        };
        if (wrapper.contractValidate()) |err| @compileError(err);
    }
}

// --- Clock Distribution Tree ---
// Clock signals distributed from a root PLL through dividers.
// Output frequencies must be exact integer divisions of the parent.
// The tree must be connected and have no cycles (guaranteed by
// requiring parent_idx < self_idx).

const ClockNode = struct {
    name_id: u8,
    parent_idx: ?u8,
    divider: u8,
    frequency_hz: u32,
};

fn ClockTree(comptime n: usize) type {
    return struct {
        nodes: [n]ClockNode,

        pub fn contractValidate(comptime self: @This()) ?[]const u8 {
            if (constraint.lenInRange(1, 16, n)) |err| return err;

            if (self.nodes[0].parent_idx != null)
                return "root clock must have no parent";

            var ids: [n]u8 = undefined;
            for (self.nodes, 0..) |node, i| {
                ids[i] = node.name_id;
                if (constraint.nonZero(node.frequency_hz)) |err| return err;

                if (node.parent_idx) |pidx| {
                    if (pidx >= i)
                        return "parent must appear before child in clock tree";

                    if (constraint.nonZero(node.divider)) |err| return err;
                    const parent_freq = self.nodes[pidx].frequency_hz;
                    const expected_freq = parent_freq / node.divider;

                    if (expected_freq != node.frequency_hz)
                        return std.fmt.comptimePrint(
                            "clock {} frequency {} != parent {} / divider {} = {}",
                            .{ node.name_id, node.frequency_hz, parent_freq, node.divider, expected_freq },
                        );

                    if (parent_freq % node.divider != 0)
                        return std.fmt.comptimePrint(
                            "parent frequency {} is not evenly divisible by {}",
                            .{ parent_freq, node.divider },
                        );
                }
            }
            if (constraint.noDuplicates(u8, &ids)) |err| return err;

            return null;
        }
    };
}

const clock_tree = blk: {
    const nodes = [_]ClockNode{
        .{ .name_id = 0, .parent_idx = null, .divider = 1, .frequency_hz = 480_000_000 },
        .{ .name_id = 1, .parent_idx = 0, .divider = 2, .frequency_hz = 240_000_000 },
        .{ .name_id = 2, .parent_idx = 0, .divider = 4, .frequency_hz = 120_000_000 },
        .{ .name_id = 3, .parent_idx = 1, .divider = 5, .frequency_hz = 48_000_000 },
        .{ .name_id = 4, .parent_idx = 2, .divider = 3, .frequency_hz = 40_000_000 },
        .{ .name_id = 5, .parent_idx = 3, .divider = 48, .frequency_hz = 1_000_000 },
        .{ .name_id = 6, .parent_idx = 3, .divider = 3, .frequency_hz = 16_000_000 },
    };
    const wrapper: ClockTree(nodes.len) = .{ .nodes = nodes };
    if (wrapper.contractValidate()) |err| @compileError(err);
    break :blk nodes;
};

test "clock tree root is 480MHz" {
    comptime {
        try std.testing.expectEqual(480_000_000, clock_tree[0].frequency_hz);
    }
}

test "clock tree frequencies are exact divisions" {
    comptime {
        for (clock_tree) |node| {
            if (node.parent_idx) |pidx| {
                try std.testing.expectEqual(
                    clock_tree[pidx].frequency_hz / node.divider,
                    node.frequency_hz,
                );
            }
        }
    }
}

test "clock tree has 7 nodes" {
    comptime {
        try std.testing.expectEqual(7, clock_tree.len);
    }
}

test "clock tree 1MHz node derived from 48MHz" {
    comptime {
        try std.testing.expectEqual(1_000_000, clock_tree[5].frequency_hz);
        try std.testing.expectEqual(48_000_000, clock_tree[clock_tree[5].parent_idx.?].frequency_hz);
    }
}
