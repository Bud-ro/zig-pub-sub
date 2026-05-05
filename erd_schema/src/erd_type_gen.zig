/// Comptime type generation from JSON type descriptors (primitives only).
///
/// Zig 0.16 does not support @Type for struct/enum creation. This module
/// handles primitive types (which use @Int) and arrays. For structs and enums,
/// use the runtime decoder (erd_json_decode.zig) which interprets bytes
/// according to the type descriptor without needing to create Zig types.
///
/// Usage:
///   const T = TypeFromDescriptor(
///       \\{"kind":"primitive","name":"u32","size":4,"signedness":"unsigned","bits":32}
///   );
///   // T is u32
const std = @import("std");

/// Generate a Zig type from a comptime-known JSON type descriptor string.
/// Supports: primitives (all int widths + bool), arrays of supported types.
/// Does NOT support: structs, enums (Zig 0.16 limitation - no @Type for these).
pub fn TypeFromDescriptor(comptime json_str: []const u8) type {
    return ParseType(json_str);
}

fn ParseType(comptime json_str: []const u8) type {
    @setEvalBranchQuota(500_000);
    const kind = extractString(json_str, "\"kind\":\"");

    if (strEql(kind, "primitive")) {
        return ParsePrimitive(json_str);
    } else if (strEql(kind, "array")) {
        return ParseArray(json_str);
    } else {
        @compileError("TypeFromDescriptor only supports primitive and array types in Zig 0.16 " ++
            "(no @Type for struct/enum). Use erd_json_decode for runtime interpretation. Got kind: " ++ kind);
    }
}

fn ParsePrimitive(comptime json_str: []const u8) type {
    const name = extractString(json_str, "\"name\":\"");

    if (strEql(name, "bool")) return bool;
    if (strEql(name, "u8")) return u8;
    if (strEql(name, "u16")) return u16;
    if (strEql(name, "u32")) return u32;
    if (strEql(name, "u64")) return u64;
    if (strEql(name, "i8")) return i8;
    if (strEql(name, "i16")) return i16;
    if (strEql(name, "i32")) return i32;
    if (strEql(name, "i64")) return i64;

    const bits = extractInt(json_str, "\"bits\":");
    const signedness_str = extractString(json_str, "\"signedness\":\"");
    const signedness: std.builtin.Signedness = if (strEql(signedness_str, "signed")) .signed else .unsigned;
    return @Int(signedness, bits);
}

fn ParseArray(comptime json_str: []const u8) type {
    const len: usize = extractInt(json_str, "\"len\":");
    const elem_json = extractObject(json_str, "\"element\":");
    const Child = ParseType(elem_json);
    return [len]Child;
}

// --- Comptime mini JSON helpers ---

fn strEql(comptime a: []const u8, comptime b: []const u8) bool {
    return std.mem.eql(u8, a, b);
}

fn extractString(comptime json: []const u8, comptime key: []const u8) []const u8 {
    const start = std.mem.indexOf(u8, json, key) orelse @compileError("Key not found: " ++ key);
    const val_start = start + key.len;
    const end = std.mem.indexOfScalarPos(u8, json, val_start, '"') orelse @compileError("Unterminated string");
    return json[val_start..end];
}

fn extractInt(comptime json: []const u8, comptime key: []const u8) u16 {
    const start = std.mem.indexOf(u8, json, key) orelse @compileError("Key not found: " ++ key);
    const val_start = start + key.len;
    var end = val_start;
    while (end < json.len and json[end] >= '0' and json[end] <= '9') : (end += 1) {}
    return std.fmt.parseInt(u16, json[val_start..end], 10) catch @compileError("Invalid int");
}

fn extractObject(comptime json: []const u8, comptime key: []const u8) []const u8 {
    const start = std.mem.indexOf(u8, json, key) orelse @compileError("Key not found: " ++ key);
    var pos = start + key.len;
    while (pos < json.len and json[pos] != '{') : (pos += 1) {}
    return balancedSlice(json, pos, '{', '}');
}

fn balancedSlice(comptime json: []const u8, comptime from: usize, comptime open: u8, comptime close: u8) []const u8 {
    var pos = from;
    var depth: usize = 0;
    while (pos < json.len) : (pos += 1) {
        if (json[pos] == '"') {
            pos += 1;
            while (pos < json.len and json[pos] != '"') : (pos += 1) {}
        } else if (json[pos] == open) {
            depth += 1;
        } else if (json[pos] == close) {
            depth -= 1;
            if (depth == 0) return json[from .. pos + 1];
        }
    }
    @compileError("Unbalanced brackets");
}
