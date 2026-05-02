const std = @import("std");
const contracts = @import("contracts.zig");

/// Asserts that a type's validate function accepts the given value (comptime).
/// Equivalent to contracts.assertValid — provided for semantic clarity in test code.
pub const expectValid = contracts.assertValid;

/// Asserts two struct values are field-by-field equal at comptime.
/// On mismatch, produces a @compileError listing which fields differ.
pub fn expectStructEql(comptime T: type, comptime expected: T, comptime actual: T) void {
    const diff = structDiff(T, expected, actual);
    if (!std.mem.eql(u8, diff, "(identical)")) {
        @compileError(std.fmt.comptimePrint(
            "struct values differ:\n{s}",
            .{diff},
        ));
    }
}

/// Produces a comptime field-by-field diff string between two struct values.
/// Returns "(identical)" if all fields match.
pub fn structDiff(comptime T: type, comptime a: T, comptime b: T) []const u8 {
    var msg: []const u8 = "";
    for (std.meta.fieldNames(T)) |name| {
        if (@field(a, name) != @field(b, name)) {
            msg = msg ++ std.fmt.comptimePrint(
                "  .{s}: {} != {}\n",
                .{ name, @field(a, name), @field(b, name) },
            );
        }
    }
    return if (msg.len == 0) "(identical)" else msg;
}
