const erd_schema = @import("erd_schema");
const std = @import("std");
const erd_json = erd_schema.json;
const Erd = @import("erd_core").Erd;

fn tdString(T: type) !struct { str: []const u8, out: std.Io.Writer.Allocating } {
    var out: std.Io.Writer.Allocating = .init(std.testing.allocator);
    errdefer out.deinit();
    try erd_json.generateTypeDescriptor(T, &out.writer);
    return .{ .str = out.writer.buffered(), .out = out };
}

// =======================================================================
// Primitives
// =======================================================================

test "u8" {
    var r = try tdString(u8);
    defer r.out.deinit();
    try std.testing.expectEqualStrings(
        \\{
        \\    "kind": "primitive",
        \\    "name": "u8",
        \\    "size": 1,
        \\    "signedness": "unsigned",
        \\    "bits": 8
        \\}
    , r.str);
}

test "u16" {
    var r = try tdString(u16);
    defer r.out.deinit();
    try std.testing.expectEqualStrings(
        \\{
        \\    "kind": "primitive",
        \\    "name": "u16",
        \\    "size": 2,
        \\    "signedness": "unsigned",
        \\    "bits": 16
        \\}
    , r.str);
}

test "u32" {
    var r = try tdString(u32);
    defer r.out.deinit();
    try std.testing.expectEqualStrings(
        \\{
        \\    "kind": "primitive",
        \\    "name": "u32",
        \\    "size": 4,
        \\    "signedness": "unsigned",
        \\    "bits": 32
        \\}
    , r.str);
}

test "u64" {
    var r = try tdString(u64);
    defer r.out.deinit();
    try std.testing.expectEqualStrings(
        \\{
        \\    "kind": "primitive",
        \\    "name": "u64",
        \\    "size": 8,
        \\    "signedness": "unsigned",
        \\    "bits": 64
        \\}
    , r.str);
}

test "i8" {
    var r = try tdString(i8);
    defer r.out.deinit();
    try std.testing.expectEqualStrings(
        \\{
        \\    "kind": "primitive",
        \\    "name": "i8",
        \\    "size": 1,
        \\    "signedness": "signed",
        \\    "bits": 8
        \\}
    , r.str);
}

test "i16" {
    var r = try tdString(i16);
    defer r.out.deinit();
    try std.testing.expectEqualStrings(
        \\{
        \\    "kind": "primitive",
        \\    "name": "i16",
        \\    "size": 2,
        \\    "signedness": "signed",
        \\    "bits": 16
        \\}
    , r.str);
}

test "i32" {
    var r = try tdString(i32);
    defer r.out.deinit();
    try std.testing.expectEqualStrings(
        \\{
        \\    "kind": "primitive",
        \\    "name": "i32",
        \\    "size": 4,
        \\    "signedness": "signed",
        \\    "bits": 32
        \\}
    , r.str);
}

test "i64" {
    var r = try tdString(i64);
    defer r.out.deinit();
    try std.testing.expectEqualStrings(
        \\{
        \\    "kind": "primitive",
        \\    "name": "i64",
        \\    "size": 8,
        \\    "signedness": "signed",
        \\    "bits": 64
        \\}
    , r.str);
}

test "bool" {
    var r = try tdString(bool);
    defer r.out.deinit();
    try std.testing.expectEqualStrings(
        \\{
        \\    "kind": "primitive",
        \\    "name": "bool",
        \\    "size": 1,
        \\    "signedness": "unsigned",
        \\    "bits": 1
        \\}
    , r.str);
}

// =======================================================================
// Extern structs (guaranteed byte layout)
// =======================================================================

test "simple extern struct" {
    const S = extern struct { a: u8, b: u16 };
    var r = try tdString(S);
    defer r.out.deinit();
    try std.testing.expectEqualStrings(
        \\{
        \\    "kind": "struct",
        \\    "name": "tests.erd_json_test.test.simple extern struct.S",
        \\    "layout": "extern",
        \\    "size": 4,
        \\    "fields": [
        \\        {
        \\            "name": "a",
        \\            "offset": 0,
        \\            "type_descriptor": {
        \\                "kind": "primitive",
        \\                "name": "u8",
        \\                "size": 1,
        \\                "signedness": "unsigned",
        \\                "bits": 8
        \\            }
        \\        },
        \\        {
        \\            "name": "b",
        \\            "offset": 2,
        \\            "type_descriptor": {
        \\                "kind": "primitive",
        \\                "name": "u16",
        \\                "size": 2,
        \\                "signedness": "unsigned",
        \\                "bits": 16
        \\            }
        \\        }
        \\    ]
        \\}
    , r.str);
}

test "extern struct with padding" {
    const S = extern struct { a: u8, b: u32 };
    var r = try tdString(S);
    defer r.out.deinit();
    try std.testing.expectEqualStrings(
        \\{
        \\    "kind": "struct",
        \\    "name": "tests.erd_json_test.test.extern struct with padding.S",
        \\    "layout": "extern",
        \\    "size": 8,
        \\    "fields": [
        \\        {
        \\            "name": "a",
        \\            "offset": 0,
        \\            "type_descriptor": {
        \\                "kind": "primitive",
        \\                "name": "u8",
        \\                "size": 1,
        \\                "signedness": "unsigned",
        \\                "bits": 8
        \\            }
        \\        },
        \\        {
        \\            "name": "b",
        \\            "offset": 4,
        \\            "type_descriptor": {
        \\                "kind": "primitive",
        \\                "name": "u32",
        \\                "size": 4,
        \\                "signedness": "unsigned",
        \\                "bits": 32
        \\            }
        \\        }
        \\    ]
        \\}
    , r.str);
}

// Auto structs intentionally produce a compile error:
// typeDescriptor(struct { x: u32 }) would fail with
// "Cannot serialize auto-layout struct: Zig may reorder fields"

// =======================================================================
// Packed structs (bit-level layout)
// =======================================================================

test "packed struct with bit offsets" {
    const S = packed struct { a: u5, b: u3 };
    var r = try tdString(S);
    defer r.out.deinit();
    try std.testing.expectEqualStrings(
        \\{
        \\    "kind": "struct",
        \\    "name": "tests.erd_json_test.test.packed struct with bit offsets.S",
        \\    "layout": "packed",
        \\    "size": 1,
        \\    "backing_integer_bits": 8,
        \\    "fields": [
        \\        {
        \\            "name": "a",
        \\            "bit_offset": 0,
        \\            "bits": 5,
        \\            "type_descriptor": {
        \\                "kind": "primitive",
        \\                "name": "u5",
        \\                "size": 1,
        \\                "signedness": "unsigned",
        \\                "bits": 5
        \\            }
        \\        },
        \\        {
        \\            "name": "b",
        \\            "bit_offset": 5,
        \\            "bits": 3,
        \\            "type_descriptor": {
        \\                "kind": "primitive",
        \\                "name": "u3",
        \\                "size": 1,
        \\                "signedness": "unsigned",
        \\                "bits": 3
        \\            }
        \\        }
        \\    ]
        \\}
    , r.str);
}

test "packed struct with bool" {
    const S = packed struct { enabled: bool, value: u7 };
    var r = try tdString(S);
    defer r.out.deinit();
    try std.testing.expectEqualStrings(
        \\{
        \\    "kind": "struct",
        \\    "name": "tests.erd_json_test.test.packed struct with bool.S",
        \\    "layout": "packed",
        \\    "size": 1,
        \\    "backing_integer_bits": 8,
        \\    "fields": [
        \\        {
        \\            "name": "enabled",
        \\            "bit_offset": 0,
        \\            "bits": 1,
        \\            "type_descriptor": {
        \\                "kind": "primitive",
        \\                "name": "bool",
        \\                "size": 1,
        \\                "signedness": "unsigned",
        \\                "bits": 1
        \\            }
        \\        },
        \\        {
        \\            "name": "value",
        \\            "bit_offset": 1,
        \\            "bits": 7,
        \\            "type_descriptor": {
        \\                "kind": "primitive",
        \\                "name": "u7",
        \\                "size": 1,
        \\                "signedness": "unsigned",
        \\                "bits": 7
        \\            }
        \\        }
        \\    ]
        \\}
    , r.str);
}

// =======================================================================
// Enums
// =======================================================================

test "enum with u8 tag" {
    const E = enum(u8) { off, on, standby };
    var r = try tdString(E);
    defer r.out.deinit();
    try std.testing.expectEqualStrings(
        \\{
        \\    "kind": "enum",
        \\    "name": "tests.erd_json_test.test.enum with u8 tag.E",
        \\    "tag_type": "u8",
        \\    "size": 1,
        \\    "variants": [
        \\        "off",
        \\        "on",
        \\        "standby"
        \\    ]
        \\}
    , r.str);
}

test "enum with u16 tag" {
    const E = enum(u16) { alpha, beta };
    var r = try tdString(E);
    defer r.out.deinit();
    try std.testing.expectEqualStrings(
        \\{
        \\    "kind": "enum",
        \\    "name": "tests.erd_json_test.test.enum with u16 tag.E",
        \\    "tag_type": "u16",
        \\    "size": 2,
        \\    "variants": [
        \\        "alpha",
        \\        "beta"
        \\    ]
        \\}
    , r.str);
}

// =======================================================================
// Floats
// =======================================================================

test "f32" {
    var r = try tdString(f32);
    defer r.out.deinit();
    try std.testing.expectEqualStrings(
        \\{
        \\    "kind": "float",
        \\    "name": "f32",
        \\    "size": 4,
        \\    "bits": 32
        \\}
    , r.str);
}

test "f64" {
    var r = try tdString(f64);
    defer r.out.deinit();
    try std.testing.expectEqualStrings(
        \\{
        \\    "kind": "float",
        \\    "name": "f64",
        \\    "size": 8,
        \\    "bits": 64
        \\}
    , r.str);
}

test "f16" {
    var r = try tdString(f16);
    defer r.out.deinit();
    try std.testing.expectEqualStrings(
        \\{
        \\    "kind": "float",
        \\    "name": "f16",
        \\    "size": 2,
        \\    "bits": 16
        \\}
    , r.str);
}

// =======================================================================
// Arrays
// =======================================================================

test "u8 array is string" {
    var r = try tdString([32]u8);
    defer r.out.deinit();
    try std.testing.expectEqualStrings(
        \\{
        \\    "kind": "string",
        \\    "max_len": 32,
        \\    "size": 32
        \\}
    , r.str);
}

test "2D array" {
    var r = try tdString([2][3]u16);
    defer r.out.deinit();
    try std.testing.expectEqualStrings(
        \\{
        \\    "kind": "array",
        \\    "len": 2,
        \\    "size": 12,
        \\    "element": {
        \\        "kind": "array",
        \\        "len": 3,
        \\        "size": 6,
        \\        "element": {
        \\            "kind": "primitive",
        \\            "name": "u16",
        \\            "size": 2,
        \\            "signedness": "unsigned",
        \\            "bits": 16
        \\        }
        \\    }
        \\}
    , r.str);
}

// =======================================================================
// Extern unions
// =======================================================================

test "extern union" {
    const U = extern union { int_val: u32, byte_val: u8 };
    var r = try tdString(U);
    defer r.out.deinit();
    try std.testing.expectEqualStrings(
        \\{
        \\    "kind": "union",
        \\    "name": "tests.erd_json_test.test.extern union.U",
        \\    "layout": "extern",
        \\    "size": 4,
        \\    "fields": [
        \\        {
        \\            "name": "int_val",
        \\            "type_descriptor": {
        \\                "kind": "primitive",
        \\                "name": "u32",
        \\                "size": 4,
        \\                "signedness": "unsigned",
        \\                "bits": 32
        \\            }
        \\        },
        \\        {
        \\            "name": "byte_val",
        \\            "type_descriptor": {
        \\                "kind": "primitive",
        \\                "name": "u8",
        \\                "size": 1,
        \\                "signedness": "unsigned",
        \\                "bits": 8
        \\            }
        \\        }
        \\    ]
        \\}
    , r.str);
}

// =======================================================================
// Tagged union pattern (extern struct + enum tag + extern union)
// =======================================================================

test "tagged union via extern struct wrapper" {
    const Msg = extern struct {
        tag: enum(u8) { temperature, error_code },
        payload: extern union {
            temperature: u16,
            error_code: u8,
        },
    };
    var r = try tdString(Msg);
    defer r.out.deinit();

    // Verify tag is an enum at offset 0
    const parsed = try std.json.parseFromSlice(std.json.Value, std.testing.allocator, r.str, .{});
    defer parsed.deinit();
    const fields = parsed.value.object.get("fields").?.array.items;
    try std.testing.expectEqual(2, fields.len);

    const tag_field = fields[0].object;
    try std.testing.expectEqualStrings("tag", tag_field.get("name").?.string);
    try std.testing.expectEqual(0, tag_field.get("offset").?.integer);
    const tag_td = tag_field.get("type_descriptor").?.object;
    try std.testing.expectEqualStrings("enum", tag_td.get("kind").?.string);

    const payload_field = fields[1].object;
    try std.testing.expectEqualStrings("payload", payload_field.get("name").?.string);
    try std.testing.expectEqual(@offsetOf(Msg, "payload"), @as(usize, @intCast(payload_field.get("offset").?.integer)));
    const payload_td = payload_field.get("type_descriptor").?.object;
    try std.testing.expectEqualStrings("union", payload_td.get("kind").?.string);
}

test "tagged union: switch on tag and access payload from raw bytes" {
    const Msg = extern struct {
        tag: enum(u8) { temperature, error_code },
        payload: extern union {
            temperature: u16,
            error_code: u8,
        },
    };

    // tag=0 (temperature), pad byte, payload=0x04D2 (1234 LE)
    const raw = [_]u8{ 0x00, 0x00, 0xD2, 0x04 };
    const msg: *const Msg = @ptrCast(@alignCast(&raw));

    switch (msg.tag) {
        .temperature => try std.testing.expectEqual(@as(u16, 1234), msg.payload.temperature),
        .error_code => return error.TestUnexpectedResult,
    }

    // tag=1 (error_code), pad byte, payload=0x2A (42)
    const raw2 = [_]u8{ 0x01, 0x00, 0x2A, 0x00 };
    const msg2: *const Msg = @ptrCast(@alignCast(&raw2));

    switch (msg2.tag) {
        .temperature => return error.TestUnexpectedResult,
        .error_code => try std.testing.expectEqual(@as(u8, 42), msg2.payload.error_code),
    }
}

// =======================================================================
// Enum dot syntax
// =======================================================================

test "enum created from descriptor supports dot syntax" {
    const Mode = erd_schema.TypeFromDescriptor(
        \\{"kind":"enum","name":"Mode","tag_type":"u8","size":1,"variants":["off","on","standby"]}
    );
    const v: Mode = .standby;
    try std.testing.expectEqualStrings("standby", @tagName(v));
    try std.testing.expectEqual(@as(u8, 2), @intFromEnum(v));
}

// =======================================================================
// Nested compound types
// =======================================================================

test "extern struct containing string" {
    const S = extern struct { header: u8, data: [3]u8 };
    var r = try tdString(S);
    defer r.out.deinit();
    try std.testing.expectEqualStrings(
        \\{
        \\    "kind": "struct",
        \\    "name": "tests.erd_json_test.test.extern struct containing string.S",
        \\    "layout": "extern",
        \\    "size": 4,
        \\    "fields": [
        \\        {
        \\            "name": "header",
        \\            "offset": 0,
        \\            "type_descriptor": {
        \\                "kind": "primitive",
        \\                "name": "u8",
        \\                "size": 1,
        \\                "signedness": "unsigned",
        \\                "bits": 8
        \\            }
        \\        },
        \\        {
        \\            "name": "data",
        \\            "offset": 1,
        \\            "type_descriptor": {
        \\                "kind": "string",
        \\                "max_len": 3,
        \\                "size": 3
        \\            }
        \\        }
        \\    ]
        \\}
    , r.str);
}

test "extern struct containing enum" {
    const Status = enum(u8) { ok, err };
    const S = extern struct { status: Status, code: u8 };
    var r = try tdString(S);
    defer r.out.deinit();
    try std.testing.expectEqualStrings(
        \\{
        \\    "kind": "struct",
        \\    "name": "tests.erd_json_test.test.extern struct containing enum.S",
        \\    "layout": "extern",
        \\    "size": 2,
        \\    "fields": [
        \\        {
        \\            "name": "status",
        \\            "offset": 0,
        \\            "type_descriptor": {
        \\                "kind": "enum",
        \\                "name": "tests.erd_json_test.test.extern struct containing enum.Status",
        \\                "tag_type": "u8",
        \\                "size": 1,
        \\                "variants": [
        \\                    "ok",
        \\                    "err"
        \\                ]
        \\            }
        \\        },
        \\        {
        \\            "name": "code",
        \\            "offset": 1,
        \\            "type_descriptor": {
        \\                "kind": "primitive",
        \\                "name": "u8",
        \\                "size": 1,
        \\                "signedness": "unsigned",
        \\                "bits": 8
        \\            }
        \\        }
        \\    ]
        \\}
    , r.str);
}

test "extern struct nested in extern struct" {
    const Inner = extern struct { x: u16, y: u16 };
    const Outer = extern struct { inner: Inner, z: u32 };
    var r = try tdString(Outer);
    defer r.out.deinit();
    try std.testing.expectEqualStrings(
        \\{
        \\    "kind": "struct",
        \\    "name": "tests.erd_json_test.test.extern struct nested in extern struct.Outer",
        \\    "layout": "extern",
        \\    "size": 8,
        \\    "fields": [
        \\        {
        \\            "name": "inner",
        \\            "offset": 0,
        \\            "type_descriptor": {
        \\                "kind": "struct",
        \\                "name": "tests.erd_json_test.test.extern struct nested in extern struct.Inner",
        \\                "layout": "extern",
        \\                "size": 4,
        \\                "fields": [
        \\                    {
        \\                        "name": "x",
        \\                        "offset": 0,
        \\                        "type_descriptor": {
        \\                            "kind": "primitive",
        \\                            "name": "u16",
        \\                            "size": 2,
        \\                            "signedness": "unsigned",
        \\                            "bits": 16
        \\                        }
        \\                    },
        \\                    {
        \\                        "name": "y",
        \\                        "offset": 2,
        \\                        "type_descriptor": {
        \\                            "kind": "primitive",
        \\                            "name": "u16",
        \\                            "size": 2,
        \\                            "signedness": "unsigned",
        \\                            "bits": 16
        \\                        }
        \\                    }
        \\                ]
        \\            }
        \\        },
        \\        {
        \\            "name": "z",
        \\            "offset": 4,
        \\            "type_descriptor": {
        \\                "kind": "primitive",
        \\                "name": "u32",
        \\                "size": 4,
        \\                "signedness": "unsigned",
        \\                "bits": 32
        \\            }
        \\        }
        \\    ]
        \\}
    , r.str);
}

test "array of extern structs" {
    const Item = extern struct { a: u8, b: u8 };
    var r = try tdString([2]Item);
    defer r.out.deinit();
    try std.testing.expectEqualStrings(
        \\{
        \\    "kind": "array",
        \\    "len": 2,
        \\    "size": 4,
        \\    "element": {
        \\        "kind": "struct",
        \\        "name": "tests.erd_json_test.test.array of extern structs.Item",
        \\        "layout": "extern",
        \\        "size": 2,
        \\        "fields": [
        \\            {
        \\                "name": "a",
        \\                "offset": 0,
        \\                "type_descriptor": {
        \\                    "kind": "primitive",
        \\                    "name": "u8",
        \\                    "size": 1,
        \\                    "signedness": "unsigned",
        \\                    "bits": 8
        \\                }
        \\            },
        \\            {
        \\                "name": "b",
        \\                "offset": 1,
        \\                "type_descriptor": {
        \\                    "kind": "primitive",
        \\                    "name": "u8",
        \\                    "size": 1,
        \\                    "signedness": "unsigned",
        \\                    "bits": 8
        \\                }
        \\            }
        \\        ]
        \\    }
        \\}
    , r.str);
}

// =======================================================================
// Full ERD table integration
// =======================================================================

test "full ERD table with type_descriptors" {
    const Erds = struct {
        // zig fmt: off
        version: Erd = .{ .erd_number = 0x0000, .T = u32,  .component_idx = 0, .subs = 0 },
        flag:    Erd = .{ .erd_number = 0x0001, .T = bool, .component_idx = 0, .subs = 0 },
        hidden:  Erd = .{ .erd_number = null,   .T = u16,  .component_idx = 0, .subs = 0 },
        sensor:  Erd = .{ .erd_number = 0x0010, .T = i32,  .component_idx = 0, .subs = 0 },
        // zig fmt: on
    };
    var out: std.Io.Writer.Allocating = .init(std.testing.allocator);
    defer out.deinit();

    try erd_json.generate(@as(Erds, .{}), &out.writer, .{ .namespace = "test" });
    try std.testing.expectEqualStrings(
        \\{
        \\    "erd-json-version": "0.1.0",
        \\    "namespace": "test",
        \\    "erds": [
        \\        {
        \\            "name": "version",
        \\            "id": "0x0000",
        \\            "type": {
        \\                "kind": "primitive",
        \\                "name": "u32",
        \\                "size": 4,
        \\                "signedness": "unsigned",
        \\                "bits": 32
        \\            }
        \\        },
        \\        {
        \\            "name": "flag",
        \\            "id": "0x0001",
        \\            "type": {
        \\                "kind": "primitive",
        \\                "name": "bool",
        \\                "size": 1,
        \\                "signedness": "unsigned",
        \\                "bits": 1
        \\            }
        \\        },
        \\        {
        \\            "name": "sensor",
        \\            "id": "0x0010",
        \\            "type": {
        \\                "kind": "primitive",
        \\                "name": "i32",
        \\                "size": 4,
        \\                "signedness": "signed",
        \\                "bits": 32
        \\            }
        \\        }
        \\    ]
        \\}
    , out.writer.buffered());
}

test "empty ERD definitions" {
    const EmptyErds = struct {}; // zlinter-disable-current-line declaration_naming
    var out: std.Io.Writer.Allocating = .init(std.testing.allocator);
    defer out.deinit();
    try erd_json.generate(@as(EmptyErds, .{}), &out.writer, .{});
    try std.testing.expectEqualStrings(
        \\{
        \\    "erd-json-version": "0.1.0",
        \\    "namespace": "zig-pub-sub",
        \\    "erds": []
        \\}
    , out.writer.buffered());
}
