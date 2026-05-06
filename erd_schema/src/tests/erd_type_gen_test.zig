const std = @import("std");
const TypeFromDescriptor = @import("erd_schema").TypeFromDescriptor;

// =======================================================================
// Primitives
// =======================================================================

test "u8" {
    try std.testing.expect(TypeFromDescriptor(
        \\{"kind":"primitive","name":"u8","size":1,"signedness":"unsigned","bits":8}
    ) == u8);
}

test "u16" {
    try std.testing.expect(TypeFromDescriptor(
        \\{"kind":"primitive","name":"u16","size":2,"signedness":"unsigned","bits":16}
    ) == u16);
}

test "u32" {
    try std.testing.expect(TypeFromDescriptor(
        \\{"kind":"primitive","name":"u32","size":4,"signedness":"unsigned","bits":32}
    ) == u32);
}

test "u64" {
    try std.testing.expect(TypeFromDescriptor(
        \\{"kind":"primitive","name":"u64","size":8,"signedness":"unsigned","bits":64}
    ) == u64);
}

test "i8" {
    try std.testing.expect(TypeFromDescriptor(
        \\{"kind":"primitive","name":"i8","size":1,"signedness":"signed","bits":8}
    ) == i8);
}

test "i16" {
    try std.testing.expect(TypeFromDescriptor(
        \\{"kind":"primitive","name":"i16","size":2,"signedness":"signed","bits":16}
    ) == i16);
}

test "i32" {
    try std.testing.expect(TypeFromDescriptor(
        \\{"kind":"primitive","name":"i32","size":4,"signedness":"signed","bits":32}
    ) == i32);
}

test "i64" {
    try std.testing.expect(TypeFromDescriptor(
        \\{"kind":"primitive","name":"i64","size":8,"signedness":"signed","bits":64}
    ) == i64);
}

test "bool" {
    try std.testing.expect(TypeFromDescriptor(
        \\{"kind":"primitive","name":"bool","size":1,"signedness":"unsigned","bits":1}
    ) == bool);
}

test "u5 (non-standard)" {
    try std.testing.expect(TypeFromDescriptor(
        \\{"kind":"primitive","name":"u5","size":1,"signedness":"unsigned","bits":5}
    ) == u5);
}

test "i12 (non-standard)" {
    try std.testing.expect(TypeFromDescriptor(
        \\{"kind":"primitive","name":"i12","size":2,"signedness":"signed","bits":12}
    ) == i12);
}

// =======================================================================
// Strings and arrays
// =======================================================================

test "string becomes [N]u8" {
    try std.testing.expect(TypeFromDescriptor(
        \\{"kind":"string","max_len":32,"size":32}
    ) == [32]u8);
}

test "array of u8 (via string)" {
    try std.testing.expect(TypeFromDescriptor(
        \\{"kind":"string","max_len":4,"size":4}
    ) == [4]u8);
}

test "array of u32" {
    try std.testing.expect(TypeFromDescriptor(
        \\{"kind":"array","len":2,"size":8,"element":{"kind":"primitive","name":"u32","size":4,"signedness":"unsigned","bits":32}}
    ) == [2]u32);
}

test "2D array" {
    try std.testing.expect(TypeFromDescriptor(
        \\{"kind":"array","len":3,"size":12,"element":{"kind":"array","len":4,"size":8,"element":{"kind":"primitive","name":"u16","size":2,"signedness":"unsigned","bits":16}}}
    ) == [3][4]u16);
}

// =======================================================================
// Extern structs
// =======================================================================

test "extern struct with two fields" {
    const T = TypeFromDescriptor(
        \\{"kind":"struct","name":"S","layout":"extern","size":4,"fields":[{"name":"a","offset":0,"type_descriptor":{"kind":"primitive","name":"u8","size":1,"signedness":"unsigned","bits":8}},{"name":"b","offset":2,"type_descriptor":{"kind":"primitive","name":"u16","size":2,"signedness":"unsigned","bits":16}}]}
    );
    try std.testing.expectEqual(4, @sizeOf(T));
    var v: T = undefined;
    v.a = 0x12;
    v.b = 0x3456;
    try std.testing.expectEqual(@as(u8, 0x12), v.a);
    try std.testing.expectEqual(@as(u16, 0x3456), v.b);
}

test "extern struct field offsets match" {
    const T = TypeFromDescriptor(
        \\{"kind":"struct","name":"S","layout":"extern","size":8,"fields":[{"name":"x","offset":0,"type_descriptor":{"kind":"primitive","name":"u8","size":1,"signedness":"unsigned","bits":8}},{"name":"y","offset":4,"type_descriptor":{"kind":"primitive","name":"u32","size":4,"signedness":"unsigned","bits":32}}]}
    );
    try std.testing.expectEqual(0, @offsetOf(T, "x"));
    try std.testing.expectEqual(4, @offsetOf(T, "y"));
    try std.testing.expectEqual(8, @sizeOf(T));
}

test "extern struct containing string field" {
    const T = TypeFromDescriptor(
        \\{"kind":"struct","name":"S","layout":"extern","size":36,"fields":[{"name":"id","offset":0,"type_descriptor":{"kind":"primitive","name":"u32","size":4,"signedness":"unsigned","bits":32}},{"name":"name","offset":4,"type_descriptor":{"kind":"string","max_len":32,"size":32}}]}
    );
    try std.testing.expectEqual(36, @sizeOf(T));
    var v: T = undefined;
    v.id = 42;
    v.name = [_]u8{0} ** 32;
    v.name[0] = 'A';
    try std.testing.expectEqual(@as(u8, 'A'), v.name[0]);
}

// =======================================================================
// Packed structs
// =======================================================================

test "packed struct" {
    const T = TypeFromDescriptor(
        \\{"kind":"struct","name":"F","layout":"packed","size":1,"backing_integer_bits":8,"fields":[{"name":"a","bit_offset":0,"bits":5,"type_descriptor":{"kind":"primitive","name":"u5","size":1,"signedness":"unsigned","bits":5}},{"name":"b","bit_offset":5,"bits":3,"type_descriptor":{"kind":"primitive","name":"u3","size":1,"signedness":"unsigned","bits":3}}]}
    );
    try std.testing.expectEqual(1, @sizeOf(T));
    var v: T = undefined;
    v.a = 19;
    v.b = 5;
    try std.testing.expectEqual(@as(u5, 19), v.a);
    try std.testing.expectEqual(@as(u3, 5), v.b);
}

// =======================================================================
// Enums
// =======================================================================

test "enum with u8 tag" {
    const T = TypeFromDescriptor(
        \\{"kind":"enum","name":"E","tag_type":"u8","size":1,"variants":["off","on","standby"]}
    );
    try std.testing.expectEqual(1, @sizeOf(T));
    const v: T = @enumFromInt(1);
    try std.testing.expectEqualStrings("on", @tagName(v));
}

test "enum with u16 tag" {
    const T = TypeFromDescriptor(
        \\{"kind":"enum","name":"E","tag_type":"u16","size":2,"variants":["alpha","beta","gamma"]}
    );
    try std.testing.expectEqual(2, @sizeOf(T));
    const v: T = @enumFromInt(2);
    try std.testing.expectEqualStrings("gamma", @tagName(v));
}

test "enum with u32 tag" {
    const T = TypeFromDescriptor(
        \\{"kind":"enum","name":"E","tag_type":"u32","size":4,"variants":["a","b"]}
    );
    try std.testing.expectEqual(4, @sizeOf(T));
}

// =======================================================================
// Extern unions
// =======================================================================

test "extern union" {
    const T = TypeFromDescriptor(
        \\{"kind":"union","name":"U","layout":"extern","size":4,"fields":[{"name":"int_val","type_descriptor":{"kind":"primitive","name":"u32","size":4,"signedness":"unsigned","bits":32}},{"name":"byte_val","type_descriptor":{"kind":"primitive","name":"u8","size":1,"signedness":"unsigned","bits":8}}]}
    );
    try std.testing.expectEqual(4, @sizeOf(T));
    var v: T = .{ .int_val = 42 };
    try std.testing.expectEqual(@as(u32, 42), v.int_val);
    v = .{ .byte_val = 7 };
    try std.testing.expectEqual(@as(u8, 7), v.byte_val);
}

// =======================================================================
// Nested / compound
// =======================================================================

test "extern struct containing array" {
    const T = TypeFromDescriptor(
        \\{"kind":"struct","name":"S","layout":"extern","size":8,"fields":[{"name":"header","offset":0,"type_descriptor":{"kind":"primitive","name":"u32","size":4,"signedness":"unsigned","bits":32}},{"name":"data","offset":4,"type_descriptor":{"kind":"array","len":2,"size":4,"element":{"kind":"primitive","name":"u16","size":2,"signedness":"unsigned","bits":16}}}]}
    );
    try std.testing.expectEqual(8, @sizeOf(T));
    var v: T = undefined;
    v.header = 42;
    v.data = .{ 1, 2 };
    try std.testing.expectEqual(@as(u16, 2), v.data[1]);
}

test "extern struct containing enum" {
    const T = TypeFromDescriptor(
        \\{"kind":"struct","name":"Msg","layout":"extern","size":4,"fields":[{"name":"status","offset":0,"type_descriptor":{"kind":"enum","name":"Status","tag_type":"u8","size":1,"variants":["ok","err"]}},{"name":"code","offset":2,"type_descriptor":{"kind":"primitive","name":"u16","size":2,"signedness":"unsigned","bits":16}}]}
    );
    try std.testing.expectEqual(4, @sizeOf(T));
    var v: T = undefined;
    v.status = @enumFromInt(0);
    v.code = 200;
    try std.testing.expectEqualStrings("ok", @tagName(v.status));
}

test "idempotency" {
    const desc =
        \\{"kind":"primitive","name":"u32","size":4,"signedness":"unsigned","bits":32}
    ;
    try std.testing.expect(TypeFromDescriptor(desc) == TypeFromDescriptor(desc));
}
