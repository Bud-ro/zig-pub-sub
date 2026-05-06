const std = @import("std");
const type_gen = @import("erd_schema").type_gen;
const TypeFromDescriptor = type_gen.TypeFromDescriptor;

test "primitive u8" {
    const T = TypeFromDescriptor(
        \\{"kind":"primitive","name":"u8","size":1,"signedness":"unsigned","bits":8}
    );
    try std.testing.expect(T == u8);
}

test "primitive u16" {
    const T = TypeFromDescriptor(
        \\{"kind":"primitive","name":"u16","size":2,"signedness":"unsigned","bits":16}
    );
    try std.testing.expect(T == u16);
}

test "primitive u32" {
    const T = TypeFromDescriptor(
        \\{"kind":"primitive","name":"u32","size":4,"signedness":"unsigned","bits":32}
    );
    try std.testing.expect(T == u32);
}

test "primitive u64" {
    const T = TypeFromDescriptor(
        \\{"kind":"primitive","name":"u64","size":8,"signedness":"unsigned","bits":64}
    );
    try std.testing.expect(T == u64);
}

test "primitive i8" {
    const T = TypeFromDescriptor(
        \\{"kind":"primitive","name":"i8","size":1,"signedness":"signed","bits":8}
    );
    try std.testing.expect(T == i8);
}

test "primitive i16" {
    const T = TypeFromDescriptor(
        \\{"kind":"primitive","name":"i16","size":2,"signedness":"signed","bits":16}
    );
    try std.testing.expect(T == i16);
}

test "primitive i32" {
    const T = TypeFromDescriptor(
        \\{"kind":"primitive","name":"i32","size":4,"signedness":"signed","bits":32}
    );
    try std.testing.expect(T == i32);
}

test "primitive i64" {
    const T = TypeFromDescriptor(
        \\{"kind":"primitive","name":"i64","size":8,"signedness":"signed","bits":64}
    );
    try std.testing.expect(T == i64);
}

test "primitive bool" {
    const T = TypeFromDescriptor(
        \\{"kind":"primitive","name":"bool","size":1,"signedness":"unsigned","bits":1}
    );
    try std.testing.expect(T == bool);
}

test "non-standard width u5" {
    const T = TypeFromDescriptor(
        \\{"kind":"primitive","name":"u5","size":1,"signedness":"unsigned","bits":5}
    );
    try std.testing.expect(T == u5);
}

test "non-standard width i12" {
    const T = TypeFromDescriptor(
        \\{"kind":"primitive","name":"i12","size":2,"signedness":"signed","bits":12}
    );
    try std.testing.expect(T == i12);
}

test "array of u8" {
    const T = TypeFromDescriptor(
        \\{"kind":"array","len":4,"size":4,"element":{"kind":"primitive","name":"u8","size":1,"signedness":"unsigned","bits":8}}
    );
    try std.testing.expect(T == [4]u8);
}

test "string becomes [N]u8" {
    const T = TypeFromDescriptor(
        \\{"kind":"string","max_len":32,"size":32}
    );
    try std.testing.expect(T == [32]u8);
}

test "array of u32" {
    const T = TypeFromDescriptor(
        \\{"kind":"array","len":2,"size":8,"element":{"kind":"primitive","name":"u32","size":4,"signedness":"unsigned","bits":32}}
    );
    try std.testing.expect(T == [2]u32);
}

test "2D array" {
    const T = TypeFromDescriptor(
        \\{"kind":"array","len":3,"size":12,"element":{"kind":"array","len":4,"size":4,"element":{"kind":"primitive","name":"u8","size":1,"signedness":"unsigned","bits":8}}}
    );
    try std.testing.expect(T == [3][4]u8);
}

test "idempotency: same descriptor produces same type" {
    const desc =
        \\{"kind":"primitive","name":"u32","size":4,"signedness":"unsigned","bits":32}
    ;
    const T1 = TypeFromDescriptor(desc);
    const T2 = TypeFromDescriptor(desc);
    try std.testing.expect(T1 == T2);
}

// Struct and enum types are not supported in Zig 0.16 (no @Type).
// Use the runtime decoder (erd_json_decode) for interpreting those.
