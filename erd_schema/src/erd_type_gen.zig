//! Comptime type generation from JSON type descriptors.
//!
//! Given a JSON type descriptor string (as produced by erd_json.typeDescriptor),
//! generates a Zig type at comptime. This is idempotent: the same descriptor
//! always produces a structurally identical type.
//!
//! Uses Zig 0.16 builtins: @Int, @Struct, @Enum, @Pointer for type creation.

const std = @import("std");

/// Generate a Zig type from a comptime-known JSON type descriptor string.
pub fn TypeFromDescriptor(comptime json_str: []const u8) type {
    return ParseType(json_str);
}

fn ParseType(comptime json_str: []const u8) type {
    @setEvalBranchQuota(500_000);
    const kind = extractString(json_str, "\"kind\":\"");

    if (strEql(kind, "primitive")) {
        return ParsePrimitive(json_str);
    } else if (strEql(kind, "float")) {
        return ParseFloat(json_str);
    } else if (strEql(kind, "string")) {
        const len: usize = extractInt(json_str, "\"max_len\":");
        return [len]u8;
    } else if (strEql(kind, "array")) {
        return ParseArray(json_str);
    } else if (strEql(kind, "struct")) {
        return ParseStruct(json_str);
    } else if (strEql(kind, "enum")) {
        return ParseEnum(json_str);
    } else if (strEql(kind, "union")) {
        return ParseUnion(json_str);
    } else {
        @compileError("Unsupported type descriptor kind: " ++ kind);
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
    const Child = ParseType(extractObject(json_str, "\"element\":"));
    return [len]Child;
}

fn ParseStruct(comptime json_str: []const u8) type {
    const layout_str = extractString(json_str, "\"layout\":\"");
    const layout: std.builtin.Type.ContainerLayout = if (strEql(layout_str, "packed"))
        .@"packed"
    else
        .@"extern";

    const fields_json = extractArray(json_str, "\"fields\":");
    const field_objects = splitObjects(fields_json);

    var field_names: [field_objects.len][]const u8 = undefined;
    var field_types: [field_objects.len]type = undefined;
    var field_attrs: [field_objects.len]std.builtin.Type.StructField.Attributes = undefined;

    for (field_objects, 0..) |field_json, i| {
        field_names[i] = extractString(field_json, "\"name\":\"");
        field_types[i] = ParseType(extractObject(field_json, "\"type_descriptor\":"));
        field_attrs[i] = .{};
    }

    const BackingInt: ?type = if (layout == .@"packed")
        @Int(.unsigned, extractInt(json_str, "\"backing_integer_bits\":"))
    else
        null;

    return @Struct(layout, BackingInt, &field_names, &field_types, &field_attrs);
}

fn ParseEnum(comptime json_str: []const u8) type {
    const tag_str = extractString(json_str, "\"tag_type\":\"");
    const TagType = ParsePrimitive(
        "{\"kind\":\"primitive\",\"name\":\"" ++ tag_str ++ "\",\"size\":0,\"signedness\":\"unsigned\",\"bits\":0}",
    );

    const variants_json = extractArray(json_str, "\"variants\":");
    const variant_names = splitStrings(variants_json);

    var values: [variant_names.len]TagType = undefined;
    for (0..variant_names.len) |i| {
        values[i] = @intCast(i);
    }

    return @Enum(TagType, .exhaustive, variant_names, &values);
}

fn ParseFloat(comptime json_str: []const u8) type {
    const bits = extractInt(json_str, "\"bits\":");
    return switch (bits) {
        16 => f16,
        32 => f32,
        64 => f64,
        80 => f80,
        128 => f128,
        else => @compileError("Unsupported float width"),
    };
}

fn ParseUnion(comptime json_str: []const u8) type {
    const fields_json = extractArray(json_str, "\"fields\":");
    const field_objects = splitObjects(fields_json);

    var field_names: [field_objects.len][]const u8 = undefined;
    var field_types: [field_objects.len]type = undefined;
    var field_attrs: [field_objects.len]std.builtin.Type.UnionField.Attributes = undefined;

    for (field_objects, 0..) |field_json, i| {
        field_names[i] = extractString(field_json, "\"name\":\"");
        field_types[i] = ParseType(extractObject(field_json, "\"type_descriptor\":"));
        field_attrs[i] = .{};
    }

    // extern unions cannot have tag types in Zig
    return @Union(.@"extern", null, &field_names, &field_types, &field_attrs);
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

fn extractArray(comptime json: []const u8, comptime key: []const u8) []const u8 {
    const start = std.mem.indexOf(u8, json, key) orelse @compileError("Key not found: " ++ key);
    var pos = start + key.len;
    while (pos < json.len and json[pos] != '[') : (pos += 1) {}
    return balancedSlice(json, pos, '[', ']');
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

fn splitObjects(comptime arr: []const u8) []const []const u8 {
    comptime {
        if (arr.len < 2) return &.{};
        const inner = arr[1 .. arr.len - 1];
        if (inner.len == 0) return &.{};

        var count: usize = 0;
        var i: usize = 0;
        while (i < inner.len) : (i += 1) {
            if (inner[i] == '{') {
                const obj = balancedSlice(inner, i, '{', '}');
                count += 1;
                i += obj.len - 1;
            }
        }

        var results: [count][]const u8 = undefined;
        i = 0;
        var idx: usize = 0;
        while (i < inner.len) : (i += 1) {
            if (inner[i] == '{') {
                const obj = balancedSlice(inner, i, '{', '}');
                results[idx] = obj;
                idx += 1;
                i += obj.len - 1;
            }
        }
        const final = results;
        return &final;
    }
}

fn splitStrings(comptime arr: []const u8) []const []const u8 {
    comptime {
        if (arr.len < 2) return &.{};
        const inner = arr[1 .. arr.len - 1];
        if (inner.len == 0) return &.{};

        var count: usize = 0;
        var i: usize = 0;
        while (i < inner.len) : (i += 1) {
            if (inner[i] == '"') {
                i += 1;
                while (i < inner.len and inner[i] != '"') : (i += 1) {}
                count += 1;
            }
        }

        var results: [count][]const u8 = undefined;
        i = 0;
        var idx: usize = 0;
        while (i < inner.len) : (i += 1) {
            if (inner[i] == '"') {
                const start = i + 1;
                i += 1;
                while (i < inner.len and inner[i] != '"') : (i += 1) {}
                results[idx] = inner[start..i];
                idx += 1;
            }
        }
        const final = results;
        return &final;
    }
}
