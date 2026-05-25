//! Protocol for types that carry their own validation logic. Types opt in
//! by declaring `pub fn contractValidate(comptime self: T) ?[]const u8`
//! which returns null on success or an error message string on failure.
//!
//! `contractValidate` is only expected to check the value itself; the
//! framework handles descent through structural types so that every
//! `contractValidate` reachable from the root value is run automatically.
//! Descent happens through: struct fields, array elements, slice elements,
//! single-item pointer dereferences, present optionals, and the active
//! variant of a tagged union. Untagged unions and many-item / C pointers
//! are skipped because the framework can't safely pick what to inspect.

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
                const field_path = path ++ "." ++ field.name;
                if (check(field_val, field_path)) |err| return err;
            }
        },
        .@"union" => |info| {
            if (@hasDecl(T, "contractValidate")) {
                if (T.contractValidate(value)) |msg| {
                    return if (path.len == 0) msg else path ++ ": " ++ msg;
                }
            }
            if (info.tag_type != null) {
                const tag = std.meta.activeTag(value);
                const field_path = path ++ "." ++ @tagName(tag);
                if (check(@field(value, @tagName(tag)), field_path)) |err| return err;
            }
        },
        .array => {
            @setEvalBranchQuota(value.len * 1000 + 4000);
            for (0..value.len) |idx| {
                const elem_path = path ++ std.fmt.comptimePrint("[{}]", .{idx});
                if (check(value[idx], elem_path)) |err| return err;
            }
        },
        .pointer => |info| switch (info.size) {
            .one => return check(value.*, path),
            .slice => {
                @setEvalBranchQuota(value.len * 1000 + 4000);
                for (0..value.len) |idx| {
                    const elem_path = path ++ std.fmt.comptimePrint("[{}]", .{idx});
                    if (check(value[idx], elem_path)) |err| return err;
                }
            },
            .many, .c => {},
        },
        .optional => {
            if (value) |unwrapped| {
                if (check(unwrapped, path)) |err| return err;
            }
        },
        else => {},
    }

    return null;
}
