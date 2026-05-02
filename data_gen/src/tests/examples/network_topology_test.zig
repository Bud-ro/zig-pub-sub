const std = @import("std");
const constraints = @import("data_gen").constraints;
const contracts = @import("data_gen").contracts;

// --- Network Topology with Symmetric Cost Matrix ---
// A communication cost matrix between N nodes.
// Must be symmetric (cost[i][j] == cost[j][i]),
// diagonal must be zero (cost to self is 0),
// and the triangle inequality must hold:
// cost[i][j] <= cost[i][k] + cost[k][j] for all i,j,k.

fn validateCostMatrix(comptime matrix: anytype) void {
    const N = matrix.len;
    @setEvalBranchQuota(10_000);

    // Diagonal must be zero
    for (0..N) |i| {
        if (matrix[i][i] != 0)
            @compileError(std.fmt.comptimePrint(
                "cost matrix diagonal[{}][{}] must be 0, got {}",
                .{ i, i, matrix[i][i] },
            ));
    }

    // Symmetry
    for (0..N) |i| {
        for (i + 1..N) |j| {
            if (matrix[i][j] != matrix[j][i])
                @compileError(std.fmt.comptimePrint(
                    "cost matrix not symmetric: [{},{}]={} != [{},{}]={}",
                    .{ i, j, matrix[i][j], j, i, matrix[j][i] },
                ));
        }
    }

    // All non-diagonal entries must be positive
    for (0..N) |i| {
        for (0..N) |j| {
            if (i != j and matrix[i][j] == 0)
                @compileError(std.fmt.comptimePrint(
                    "non-diagonal cost[{}][{}] must be > 0",
                    .{ i, j },
                ));
        }
    }

    // Triangle inequality
    for (0..N) |i| {
        for (0..N) |j| {
            for (0..N) |k| {
                if (i == j or i == k or j == k) continue;
                const direct: u32 = matrix[i][j];
                const via_k: u32 = @as(u32, matrix[i][k]) + matrix[k][j];
                if (direct > via_k)
                    @compileError(std.fmt.comptimePrint(
                        "triangle inequality violated: cost[{}][{}]={} > cost[{}][{}]+cost[{}][{}]={}",
                        .{ i, j, direct, i, k, k, j, via_k },
                    ));
            }
        }
    }
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
    validateCostMatrix(m);
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
};

fn validateSpanningTree(comptime N: u8, comptime edges: []const Edge) void {
    if (edges.len != N - 1)
        @compileError(std.fmt.comptimePrint(
            "spanning tree of {} nodes requires exactly {} edges, got {}",
            .{ N, N - 1, edges.len },
        ));

    // All node indices in range
    for (edges) |e| {
        if (e.a >= N or e.b >= N)
            @compileError("edge references node outside range");
        if (e.a == e.b)
            @compileError("self-loop in spanning tree");
        constraints.assert(constraints.nonZero(e.cost));
    }

    // No duplicate edges
    for (0..edges.len) |i| {
        for (i + 1..edges.len) |j| {
            const same = (edges[i].a == edges[j].a and edges[i].b == edges[j].b) or
                (edges[i].a == edges[j].b and edges[i].b == edges[j].a);
            if (same)
                @compileError("duplicate edge in spanning tree");
        }
    }

    // Connectivity check using union-find
    var parent: [256]u8 = undefined;
    for (0..N) |i| parent[i] = @intCast(i);

    for (edges) |e| {
        var ra = e.a;
        while (parent[ra] != ra) ra = parent[ra];
        var rb = e.b;
        while (parent[rb] != rb) rb = parent[rb];

        if (ra == rb)
            @compileError("cycle detected in spanning tree");

        parent[ra] = rb;
    }

    // Verify all nodes share a root
    var root = parent[0];
    while (parent[root] != root) root = parent[root];
    for (1..N) |i| {
        var r: u8 = @intCast(i);
        while (parent[r] != r) r = parent[r];
        if (r != root)
            @compileError("spanning tree does not connect all nodes");
    }
}

const network_tree = blk: {
    const edges = [_]Edge{
        .{ .a = 0, .b = 1, .cost = 10 },
        .{ .a = 1, .b = 2, .cost = 15 },
        .{ .a = 2, .b = 3, .cost = 10 },
        .{ .a = 3, .b = 4, .cost = 8 },
    };
    const node_count = 5;
    validateSpanningTree(node_count, &edges);
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

fn validateTreeMatchesGraph(
    comptime matrix: anytype,
    comptime tree: []const Edge,
) void {
    for (tree) |e| {
        if (matrix[e.a][e.b] != e.cost)
            @compileError(std.fmt.comptimePrint(
                "tree edge ({},{}) cost {} doesn't match graph cost {}",
                .{ e.a, e.b, e.cost, matrix[e.a][e.b] },
            ));
    }
}

test "spanning tree edges match latency matrix" {
    comptime {
        validateTreeMatchesGraph(latency_matrix, &network_tree);
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

fn validateClockTree(comptime nodes: []const ClockNode) void {
    constraints.assert(constraints.lenInRange(1, 16, nodes.len));

    if (nodes[0].parent_idx != null)
        @compileError("root clock must have no parent");

    var ids: [nodes.len]u8 = undefined;
    for (nodes, 0..) |node, i| {
        ids[i] = node.name_id;
        constraints.assert(constraints.nonZero(node.frequency_hz));

        if (node.parent_idx) |pidx| {
            if (pidx >= i)
                @compileError("parent must appear before child in clock tree");

            constraints.assert(constraints.nonZero(node.divider));
            const parent_freq = nodes[pidx].frequency_hz;
            const expected_freq = parent_freq / node.divider;

            if (expected_freq != node.frequency_hz)
                @compileError(std.fmt.comptimePrint(
                    "clock {} frequency {} != parent {} / divider {} = {}",
                    .{ node.name_id, node.frequency_hz, parent_freq, node.divider, expected_freq },
                ));

            if (parent_freq % node.divider != 0)
                @compileError(std.fmt.comptimePrint(
                    "parent frequency {} is not evenly divisible by {}",
                    .{ parent_freq, node.divider },
                ));
        }
    }
    constraints.assert(constraints.noDuplicates(u8, &ids));
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
    validateClockTree(&nodes);
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
