//! Helpers shared by `IndirectDataComponent` and `ConvertedDataComponent` for
//! mapping ERDs to their compute/read function pointers.

const Erd = @import("Erd.zig");
const std = @import("std");

/// Resolve the function pointer for an ERD from a comptime mappings array.
/// Each mapping must expose a `.erd` (an `Erd`) and a `.fn_ptr` field.
/// Comptime error if no mapping covers the ERD — the user's data
/// component declares N ERDs but failed to supply a mapping for one of them.
pub fn fnFromMappings(comptime erd: Erd, comptime mappings: anytype) @TypeOf(mappings[0].fn_ptr) {
    for (mappings) |mapping| {
        if (mapping.erd.data_component_idx == erd.data_component_idx) return mapping.fn_ptr;
    }
    @compileError(std.fmt.comptimePrint(
        "No mapping found for ERD at data_component_idx {} (erd_number 0x{x:0>4} or null)",
        .{ erd.data_component_idx, erd.erd_number orelse 0 },
    ));
}

/// Build a comptime array of erased function pointers indexed by
/// `data_component_idx`, used by data components' `runtimeRead` path.
pub fn buildFunctionTable(comptime erds: []const Erd, comptime mappings: anytype) [erds.len]*const anyopaque {
    var fns: [erds.len]*const anyopaque = undefined;
    for (mappings) |mapping| {
        fns[mapping.erd.data_component_idx] = mapping.fn_ptr;
    }
    return fns;
}

const TestMapping = struct { erd: Erd, fn_ptr: *const anyopaque };

fn testFnA() void {
    // marker function; identity matters, not behavior
}
fn testFnB() void {
    // marker function; identity matters, not behavior
}
fn testFnC() void {
    // marker function; identity matters, not behavior
}

const test_erds = [_]Erd{
    .{ .erd_number = null, .T = u32, .component_idx = 0, .subs = 0, .data_component_idx = 0 },
    .{ .erd_number = null, .T = u32, .component_idx = 0, .subs = 0, .data_component_idx = 1 },
    .{ .erd_number = null, .T = u32, .component_idx = 0, .subs = 0, .data_component_idx = 2 },
};

const test_mappings = [_]TestMapping{
    // Intentionally out of order to verify lookup is by data_component_idx not array position.
    .{ .erd = test_erds[2], .fn_ptr = @ptrCast(&testFnC) },
    .{ .erd = test_erds[0], .fn_ptr = @ptrCast(&testFnA) },
    .{ .erd = test_erds[1], .fn_ptr = @ptrCast(&testFnB) },
};

test "fnFromMappings finds by data_component_idx regardless of mapping order" {
    try std.testing.expectEqual(@as(*const anyopaque, @ptrCast(&testFnA)), comptime fnFromMappings(test_erds[0], test_mappings));
    try std.testing.expectEqual(@as(*const anyopaque, @ptrCast(&testFnB)), comptime fnFromMappings(test_erds[1], test_mappings));
    try std.testing.expectEqual(@as(*const anyopaque, @ptrCast(&testFnC)), comptime fnFromMappings(test_erds[2], test_mappings));
}

test "buildFunctionTable indexes by data_component_idx" {
    const table = comptime buildFunctionTable(&test_erds, test_mappings);
    try std.testing.expectEqual(3, table.len);
    try std.testing.expectEqual(@as(*const anyopaque, @ptrCast(&testFnA)), table[0]);
    try std.testing.expectEqual(@as(*const anyopaque, @ptrCast(&testFnB)), table[1]);
    try std.testing.expectEqual(@as(*const anyopaque, @ptrCast(&testFnC)), table[2]);
}
