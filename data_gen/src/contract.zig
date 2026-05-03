//! Protocol for types that carry their own validation logic. Types opt in
//! by declaring `pub fn contractValidate(comptime self: T) ?[]const u8`
//! which returns null on success or an error message string on failure.
//!
//! assertValid/validated recursively walk struct fields and array elements,
//! calling contractValidate on each sub-value that has one. Users get
//! automatic deep validation without manually calling child validates.

const std = @import("std");

/// Recursively validates a value. On failure, @compileError with the
/// field path and error message. On success, returns the value unchanged.
pub fn validated(comptime value: anytype) @TypeOf(value) {
    assertValid(value);
    return value;
}

/// Recursively validates a value. On failure, @compileError with the
/// field path and error message.
pub fn assertValid(comptime value: anytype) void {
    if (check(value, "")) |err| {
        @compileError(err);
    }
}

/// Recursively validates a value. Returns null if valid, or an error
/// message string (with field path) if not.
pub fn check(comptime value: anytype, comptime path: []const u8) ?[]const u8 {
    const T = @TypeOf(value);

    switch (@typeInfo(T)) {
        .@"struct" => |info| {
            if (@hasDecl(T, "contractValidate")) {
                if (T.contractValidate(value)) |msg| {
                    return if (path.len == 0) msg else path ++ ": " ++ msg;
                }
            }
            inline for (info.fields) |field| {
                const field_val = @field(value, field.name);
                const field_path = if (path.len == 0) "." ++ field.name else path ++ "." ++ field.name;
                if (checkInner(field.type, field_val, field_path)) |err| return err;
            }
        },
        .array => |arr_info| {
            @setEvalBranchQuota(value.len * 1000 + 4000);
            for (0..value.len) |idx| {
                const elem_path = path ++ std.fmt.comptimePrint("[{}]", .{idx});
                if (checkInner(arr_info.child, value[idx], elem_path)) |err| return err;
            }
        },
        else => {},
    }

    return null;
}

fn checkInner(comptime T: type, comptime value: T, comptime path: []const u8) ?[]const u8 {
    switch (@typeInfo(T)) {
        .@"struct", .array => return check(value, path),
        else => return null,
    }
}
