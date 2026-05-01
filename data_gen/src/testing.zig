const std = @import("std");

/// Asserts that a type's validate function accepts the given value (comptime).
/// If the type has no validate, this is a no-op.
pub fn expectValid(comptime T: type, comptime value: T) void {
    if (@hasDecl(T, "validate")) {
        T.validate(value);
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
