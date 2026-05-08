const std = @import("std");
const decode = @import("erd_schema").decode;
const TypeDescriptor = decode.TypeDescriptor;

const FormatResult = struct {
    str: []const u8,
    out: std.Io.Writer.Allocating,

    fn deinit(self: *FormatResult) void {
        self.out.deinit();
    }
};

fn format(td: *const TypeDescriptor, bytes: []const u8) !FormatResult {
    var out: std.Io.Writer.Allocating = .init(std.testing.allocator);
    errdefer out.deinit();
    try td.formatBytes(bytes, &out.writer);
    return .{ .str = out.writer.buffered(), .out = out };
}

const TdHandle = struct {
    td: TypeDescriptor,
    parsed: std.json.Parsed(std.json.Value),

    fn deinit(self: *TdHandle) void {
        self.td.deinit(std.testing.allocator);
        self.parsed.deinit();
    }
};

fn parseTd(json_str: []const u8) !TdHandle {
    const parsed = try std.json.parseFromSlice(std.json.Value, std.testing.allocator, json_str, .{});
    const td = try TypeDescriptor.init(std.testing.allocator, parsed);
    return .{ .td = td, .parsed = parsed };
}

test "primitive u8" {
    var h = try parseTd(
        \\{"kind":"primitive","name":"u8","size":1,"signedness":"unsigned","bits":8}
    );
    defer h.deinit();
    var r = try format(&h.td, &.{42});
    defer r.deinit();
    try std.testing.expectEqualStrings("42", r.str);
}

test "primitive u16 little-endian" {
    var h = try parseTd(
        \\{"kind":"primitive","name":"u16","size":2,"signedness":"unsigned","bits":16}
    );
    defer h.deinit();
    var r = try format(&h.td, &.{ 0xD2, 0x04 });
    defer r.deinit();
    try std.testing.expectEqualStrings("1234", r.str);
}

test "primitive i16 negative" {
    var h = try parseTd(
        \\{"kind":"primitive","name":"i16","size":2,"signedness":"signed","bits":16}
    );
    defer h.deinit();
    var r = try format(&h.td, &.{ 0xFF, 0xFF });
    defer r.deinit();
    try std.testing.expectEqualStrings("-1", r.str);
}

test "primitive bool true" {
    var h = try parseTd(
        \\{"kind":"primitive","name":"bool","size":1,"signedness":"unsigned","bits":1}
    );
    defer h.deinit();
    var r = try format(&h.td, &.{1});
    defer r.deinit();
    try std.testing.expectEqualStrings("true", r.str);
}

test "primitive bool false" {
    var h = try parseTd(
        \\{"kind":"primitive","name":"bool","size":1,"signedness":"unsigned","bits":1}
    );
    defer h.deinit();
    var r = try format(&h.td, &.{0});
    defer r.deinit();
    try std.testing.expectEqualStrings("false", r.str);
}

test "float f32" {
    var h = try parseTd(
        \\{"kind":"float","name":"f32","size":4,"bits":32}
    );
    defer h.deinit();
    // 1.0f = 0x3F800000, LE: 00 00 80 3F
    var r = try format(&h.td, &.{ 0x00, 0x00, 0x80, 0x3F });
    defer r.deinit();
    try std.testing.expectEqualStrings("1", r.str);
}

test "float f64" {
    var h = try parseTd(
        \\{"kind":"float","name":"f64","size":8,"bits":64}
    );
    defer h.deinit();
    var r = try format(&h.td, &.{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40 });
    defer r.deinit();
    try std.testing.expectEqualStrings("2", r.str);
}

test "primitive u32" {
    var h = try parseTd(
        \\{"kind":"primitive","name":"u32","size":4,"signedness":"unsigned","bits":32}
    );
    defer h.deinit();
    var r = try format(&h.td, &.{ 0x78, 0x56, 0x34, 0x12 });
    defer r.deinit();
    try std.testing.expectEqualStrings("305419896", r.str);
}

test "enum known variant" {
    var h = try parseTd(
        \\{"kind":"enum","name":"Status","tag_type":"u8","size":1,"variants":["off","on","standby"]}
    );
    defer h.deinit();
    var r = try format(&h.td, &.{1});
    defer r.deinit();
    try std.testing.expectEqualStrings("on", r.str);
}

test "enum unknown variant" {
    var h = try parseTd(
        \\{"kind":"enum","name":"Status","tag_type":"u8","size":1,"variants":["off","on"]}
    );
    defer h.deinit();
    var r = try format(&h.td, &.{5});
    defer r.deinit();
    try std.testing.expectEqualStrings("<unknown:5>", r.str);
}

test "extern struct" {
    var h = try parseTd(
        \\{"kind":"struct","name":"S","layout":"extern","size":4,"fields":[{"name":"a","offset":0,"type_descriptor":{"kind":"primitive","name":"u8","size":1,"signedness":"unsigned","bits":8}},{"name":"b","offset":2,"type_descriptor":{"kind":"primitive","name":"u16","size":2,"signedness":"unsigned","bits":16}}]}
    );
    defer h.deinit();
    var r = try format(&h.td, &.{ 0x0A, 0x00, 0xD2, 0x04 });
    defer r.deinit();
    try std.testing.expectEqualStrings("{ a: 10, b: 1234 }", r.str);
}

test "packed struct" {
    var h = try parseTd(
        \\{"kind":"struct","name":"Flags","layout":"packed","size":1,"backing_integer_bits":8,"fields":[{"name":"a","bit_offset":0,"bits":5,"type_descriptor":{"kind":"primitive","name":"u5","size":1,"signedness":"unsigned","bits":5}},{"name":"b","bit_offset":5,"bits":3,"type_descriptor":{"kind":"primitive","name":"u3","size":1,"signedness":"unsigned","bits":3}}]}
    );
    defer h.deinit();
    // 0b_101_10011 = 0x93 -> a=0b10011=19, b=0b101=5 (reversed from bit positions)
    // Actually: bit 0-4 are 'a', bit 5-7 are 'b'
    // 0b_101_10011 = byte 0x93 -> bits[0:4]=10011=19, bits[5:7]=100=4
    // Let me use 0xB3 = 0b_101_10011 -> a=10011=19, b=101=5
    var r = try format(&h.td, &.{0xB3});
    defer r.deinit();
    try std.testing.expectEqualStrings("{ a: 19, b: 5 }", r.str);
}

test "string with null terminator" {
    var h = try parseTd(
        \\{"kind":"string","max_len":16,"size":16}
    );
    defer h.deinit();
    const bytes = "Hello\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00";
    var r = try format(&h.td, bytes);
    defer r.deinit();
    try std.testing.expectEqualStrings("\"Hello\"", r.str);
}

test "string fills entire buffer" {
    var h = try parseTd(
        \\{"kind":"string","max_len":4,"size":4}
    );
    defer h.deinit();
    var r = try format(&h.td, "ABCD");
    defer r.deinit();
    try std.testing.expectEqualStrings("\"ABCD\"", r.str);
}

test "empty string" {
    var h = try parseTd(
        \\{"kind":"string","max_len":8,"size":8}
    );
    defer h.deinit();
    var r = try format(&h.td, &.{ 0, 0, 0, 0, 0, 0, 0, 0 });
    defer r.deinit();
    try std.testing.expectEqualStrings("\"\"", r.str);
}

test "array of u8" {
    var h = try parseTd(
        \\{"kind":"array","len":4,"size":4,"element":{"kind":"primitive","name":"u8","size":1,"signedness":"unsigned","bits":8}}
    );
    defer h.deinit();
    var r = try format(&h.td, &.{ 1, 2, 3, 4 });
    defer r.deinit();
    try std.testing.expectEqualStrings("[1, 2, 3, 4]", r.str);
}

test "array of u16" {
    var h = try parseTd(
        \\{"kind":"array","len":2,"size":4,"element":{"kind":"primitive","name":"u16","size":2,"signedness":"unsigned","bits":16}}
    );
    defer h.deinit();
    var r = try format(&h.td, &.{ 0x01, 0x00, 0x02, 0x00 });
    defer r.deinit();
    try std.testing.expectEqualStrings("[1, 2]", r.str);
}

test "nested: struct containing enum" {
    var h = try parseTd(
        \\{"kind":"struct","name":"Msg","layout":"extern","size":2,"fields":[{"name":"status","offset":0,"type_descriptor":{"kind":"enum","name":"Status","tag_type":"u8","size":1,"variants":["ok","err"]}},{"name":"code","offset":1,"type_descriptor":{"kind":"primitive","name":"u8","size":1,"signedness":"unsigned","bits":8}}]}
    );
    defer h.deinit();
    var r = try format(&h.td, &.{ 0x00, 0x2A });
    defer r.deinit();
    try std.testing.expectEqualStrings("{ status: ok, code: 42 }", r.str);
}

test "extern union prints all field interpretations" {
    var h = try parseTd(
        \\{"kind":"union","name":"U","layout":"extern","size":4,"fields":[{"name":"unsigned_val","type_descriptor":{"kind":"primitive","name":"u32","size":4,"signedness":"unsigned","bits":32}},{"name":"signed_val","type_descriptor":{"kind":"primitive","name":"i32","size":4,"signedness":"signed","bits":32}}]}
    );
    defer h.deinit();
    // 0xFFFFFFFF in LE: unsigned=4294967295, signed=-1
    var r = try format(&h.td, &.{ 0xFF, 0xFF, 0xFF, 0xFF });
    defer r.deinit();
    try std.testing.expectEqualStrings("union{ unsigned_val: 4294967295, signed_val: -1 }", r.str);
}

test "tagged union struct prints only active variant" {
    // extern struct { tag: enum(u8) { temp, err }, payload: extern union { temp: u16, err: u8 } }
    var h = try parseTd(
        \\{"kind":"struct","name":"Msg","layout":"extern","size":4,"fields":[{"name":"tag","offset":0,"type_descriptor":{"kind":"enum","name":"Tag","tag_type":"u8","size":1,"variants":["temp","err"]}},{"name":"payload","offset":2,"type_descriptor":{"kind":"union","name":"Payload","layout":"extern","size":2,"fields":[{"name":"temp","type_descriptor":{"kind":"primitive","name":"u16","size":2,"signedness":"unsigned","bits":16}},{"name":"err","type_descriptor":{"kind":"primitive","name":"u8","size":1,"signedness":"unsigned","bits":8}}]}}]}
    );
    defer h.deinit();
    // tag=0 (temp), pad, temp=0x0064 (100 in LE)
    var r1 = try format(&h.td, &.{ 0x00, 0x00, 0x64, 0x00 });
    defer r1.deinit();
    try std.testing.expectEqualStrings("{ tag: temp, payload.temp: 100 }", r1.str);

    // tag=1 (err), pad, err=0x2A (42)
    var r2 = try format(&h.td, &.{ 0x01, 0x00, 0x2A, 0x00 });
    defer r2.deinit();
    try std.testing.expectEqualStrings("{ tag: err, payload.err: 42 }", r2.str);
}

test "tagged union with unknown tag value" {
    var h = try parseTd(
        \\{"kind":"struct","name":"Msg","layout":"extern","size":4,"fields":[{"name":"tag","offset":0,"type_descriptor":{"kind":"enum","name":"Tag","tag_type":"u8","size":1,"variants":["a","b"]}},{"name":"data","offset":2,"type_descriptor":{"kind":"union","name":"U","layout":"extern","size":2,"fields":[{"name":"a","type_descriptor":{"kind":"primitive","name":"u16","size":2,"signedness":"unsigned","bits":16}},{"name":"b","type_descriptor":{"kind":"primitive","name":"u8","size":1,"signedness":"unsigned","bits":8}}]}}]}
    );
    defer h.deinit();
    // tag=99 (unknown)
    var r = try format(&h.td, &.{ 99, 0x00, 0x2A, 0x00 });
    defer r.deinit();
    // Falls back to printing tag as number + all union interpretations
    try std.testing.expectEqualStrings("{ tag: 99, union{ a: 42, b: 42 } }", r.str);
}
