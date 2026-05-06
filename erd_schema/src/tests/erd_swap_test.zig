//! Tests for comptime endian swap rule generation.
const std = @import("std");
const erd_swap = @import("erd_schema").swap;

test "u8 has no swap rules" {
    const Rules = erd_swap.SwapRules(u8);
    try std.testing.expectEqual(0, Rules.ruleCount());
}

test "bool has no swap rules" {
    const Rules = erd_swap.SwapRules(bool);
    try std.testing.expectEqual(0, Rules.ruleCount());
}

test "u16 has one 2-byte swap rule" {
    const Rules = erd_swap.SwapRules(u16);
    try std.testing.expectEqual(1, Rules.ruleCount());
    try std.testing.expectEqual(0, Rules.swap_rules[0].offset);
    try std.testing.expectEqual(2, Rules.swap_rules[0].size);
}

test "u32 has one 4-byte swap rule" {
    const Rules = erd_swap.SwapRules(u32);
    try std.testing.expectEqual(1, Rules.ruleCount());
    try std.testing.expectEqual(0, Rules.swap_rules[0].offset);
    try std.testing.expectEqual(4, Rules.swap_rules[0].size);
}

test "u16 swap is correct" {
    const Rules = erd_swap.SwapRules(u16);
    var buf = std.mem.toBytes(@as(u16, 0x1234));
    // native LE: 34 12
    try std.testing.expectEqual(@as(u8, 0x34), buf[0]);
    try std.testing.expectEqual(@as(u8, 0x12), buf[1]);

    Rules.apply(&buf);
    // big-endian: 12 34
    try std.testing.expectEqual(@as(u8, 0x12), buf[0]);
    try std.testing.expectEqual(@as(u8, 0x34), buf[1]);

    // applying again restores original
    Rules.apply(&buf);
    try std.testing.expectEqual(@as(u8, 0x34), buf[0]);
    try std.testing.expectEqual(@as(u8, 0x12), buf[1]);
}

test "u32 swap is correct" {
    const Rules = erd_swap.SwapRules(u32);
    var buf = std.mem.toBytes(@as(u32, 0xDEADBEEF));

    Rules.apply(&buf);
    try std.testing.expectEqual(@as(u8, 0xDE), buf[0]);
    try std.testing.expectEqual(@as(u8, 0xAD), buf[1]);
    try std.testing.expectEqual(@as(u8, 0xBE), buf[2]);
    try std.testing.expectEqual(@as(u8, 0xEF), buf[3]);
}

test "extern struct: rules for each multi-byte field" {
    const S = extern struct { a: u8, b: u16, c: u32 };
    const Rules = erd_swap.SwapRules(S);

    // a (u8 at 0) -> no rule
    // b (u16 at 2) -> swap 2 bytes at offset 2
    // c (u32 at 4) -> swap 4 bytes at offset 4
    try std.testing.expectEqual(2, Rules.ruleCount());
    try std.testing.expectEqual(2, Rules.swap_rules[0].offset);
    try std.testing.expectEqual(2, Rules.swap_rules[0].size);
    try std.testing.expectEqual(4, Rules.swap_rules[1].offset);
    try std.testing.expectEqual(4, Rules.swap_rules[1].size);
}

test "extern struct swap round-trip" {
    const S = extern struct { a: u8, b: u16 };
    const Rules = erd_swap.SwapRules(S);

    const val = S{ .a = 0x42, .b = 0x1234 };
    var buf = std.mem.toBytes(val);

    Rules.apply(&buf);
    // a unchanged (single byte), b swapped
    try std.testing.expectEqual(@as(u8, 0x42), buf[0]);
    try std.testing.expectEqual(@as(u8, 0x12), buf[2]);
    try std.testing.expectEqual(@as(u8, 0x34), buf[3]);

    // round-trip
    Rules.apply(&buf);
    const restored: S = @bitCast(buf);
    try std.testing.expectEqual(@as(u8, 0x42), restored.a);
    try std.testing.expectEqual(@as(u16, 0x1234), restored.b);
}

test "[N]u8 string has no swap rules" {
    const Rules = erd_swap.SwapRules([32]u8);
    try std.testing.expectEqual(0, Rules.ruleCount());
}

test "array of u16 has per-element swap rules" {
    const Rules = erd_swap.SwapRules([3]u16);
    try std.testing.expectEqual(3, Rules.ruleCount());
    try std.testing.expectEqual(0, Rules.swap_rules[0].offset);
    try std.testing.expectEqual(2, Rules.swap_rules[0].size);
    try std.testing.expectEqual(2, Rules.swap_rules[1].offset);
    try std.testing.expectEqual(4, Rules.swap_rules[2].offset);
}

test "enum(u8) has no swap rules" {
    const E = enum(u8) { a, b, c };
    const Rules = erd_swap.SwapRules(E);
    try std.testing.expectEqual(0, Rules.ruleCount());
}

test "enum(u16) has one swap rule" {
    const E = enum(u16) { a, b, c };
    const Rules = erd_swap.SwapRules(E);
    try std.testing.expectEqual(1, Rules.ruleCount());
    try std.testing.expectEqual(2, Rules.swap_rules[0].size);
}

test "nested extern struct" {
    const Inner = extern struct { x: u16, y: u16 };
    const Outer = extern struct { inner: Inner, z: u32 };
    const Rules = erd_swap.SwapRules(Outer);

    // inner.x (u16 at 0) -> swap 2 at 0
    // inner.y (u16 at 2) -> swap 2 at 2
    // z (u32 at 4) -> swap 4 at 4
    try std.testing.expectEqual(3, Rules.ruleCount());
    try std.testing.expectEqual(0, Rules.swap_rules[0].offset);
    try std.testing.expectEqual(2, Rules.swap_rules[1].offset);
    try std.testing.expectEqual(4, Rules.swap_rules[2].offset);
}

test "extern union has no swap rules (swap per-variant)" {
    const U = extern union { a: u32, b: u16 };
    const Rules = erd_swap.SwapRules(U);
    try std.testing.expectEqual(0, Rules.ruleCount());
}

test "tagged union pattern: tag swapped, union not" {
    const Msg = extern struct {
        tag: enum(u8) { temp, err },
        payload: extern union { temp: u16, err: u8 },
    };
    const Rules = erd_swap.SwapRules(Msg);
    // tag is u8 -> no rule
    // payload is extern union -> no rule (swap per-variant)
    try std.testing.expectEqual(0, Rules.ruleCount());
}

test "tagged union pattern with u16 tag: tag gets swapped" {
    const Msg = extern struct {
        tag: enum(u16) { temp, err },
        payload: extern union { temp: u32, err: u8 },
    };
    const Rules = erd_swap.SwapRules(Msg);
    // tag is u16 -> swap 2 bytes at offset 0
    // payload is extern union -> no rule
    try std.testing.expectEqual(1, Rules.ruleCount());
    try std.testing.expectEqual(0, Rules.swap_rules[0].offset);
    try std.testing.expectEqual(2, Rules.swap_rules[0].size);
}

test "packed struct treated as single integer" {
    const P = packed struct { a: u5, b: u3 };
    const Rules = erd_swap.SwapRules(P);
    // 1 byte total -> no swap needed
    try std.testing.expectEqual(0, Rules.ruleCount());
}

test "packed struct > 1 byte gets single swap" {
    const P = packed struct { a: u8, b: u8, c: u8 };
    const Rules = erd_swap.SwapRules(P);
    try std.testing.expectEqual(1, Rules.ruleCount());
    try std.testing.expectEqual(0, Rules.swap_rules[0].offset);
    try std.testing.expectEqual(@sizeOf(P), Rules.swap_rules[0].size);
}

// =======================================================================
// Floats
// =======================================================================

test "f32 has one 4-byte swap rule" {
    const Rules = erd_swap.SwapRules(f32);
    try std.testing.expectEqual(1, Rules.ruleCount());
    try std.testing.expectEqual(4, Rules.swap_rules[0].size);
}

test "f64 has one 8-byte swap rule" {
    const Rules = erd_swap.SwapRules(f64);
    try std.testing.expectEqual(1, Rules.ruleCount());
    try std.testing.expectEqual(8, Rules.swap_rules[0].size);
}

test "f16 has one 2-byte swap rule" {
    const Rules = erd_swap.SwapRules(f16);
    try std.testing.expectEqual(1, Rules.ruleCount());
    try std.testing.expectEqual(2, Rules.swap_rules[0].size);
}

test "extern struct with float fields" {
    const S = extern struct { temp: f32, pressure: f64 };
    const Rules = erd_swap.SwapRules(S);
    try std.testing.expectEqual(2, Rules.ruleCount());
    try std.testing.expectEqual(0, Rules.swap_rules[0].offset);
    try std.testing.expectEqual(4, Rules.swap_rules[0].size);
    try std.testing.expectEqual(8, Rules.swap_rules[1].offset);
    try std.testing.expectEqual(8, Rules.swap_rules[1].size);
}

test "f32 swap produces big-endian" {
    const Rules = erd_swap.SwapRules(f32);
    var buf = std.mem.toBytes(@as(f32, 1.0));
    // IEEE 754: 1.0f = 0x3F800000, LE bytes: 00 00 80 3F
    try std.testing.expectEqual(@as(u8, 0x00), buf[0]);
    try std.testing.expectEqual(@as(u8, 0x3F), buf[3]);

    Rules.apply(&buf);
    // BE: 3F 80 00 00
    try std.testing.expectEqual(@as(u8, 0x3F), buf[0]);
    try std.testing.expectEqual(@as(u8, 0x00), buf[3]);
}

// =======================================================================
// SwapVariant for union fields
// =======================================================================

test "SwapVariant generates rules for a specific union field" {
    const U = extern union { int_val: u32, byte_val: u8 };
    const IntSwap = erd_swap.SwapVariant(U, "int_val", 0);
    try std.testing.expectEqual(1, IntSwap.ruleCount());
    try std.testing.expectEqual(4, IntSwap.swap_rules[0].size);

    const ByteSwap = erd_swap.SwapVariant(U, "byte_val", 0);
    try std.testing.expectEqual(0, ByteSwap.ruleCount());
}

test "SwapVariant with offset in tagged union pattern" {
    const Msg = extern struct {
        tag: enum(u8) { temperature, error_code },
        payload: extern union { temperature: u16, error_code: u8 },
    };
    const payload_offset = @offsetOf(Msg, "payload");

    const TempSwap = erd_swap.SwapVariant(@TypeOf(@as(Msg, undefined).payload), "temperature", payload_offset);
    try std.testing.expectEqual(1, TempSwap.ruleCount());
    try std.testing.expectEqual(payload_offset, TempSwap.swap_rules[0].offset);
    try std.testing.expectEqual(2, TempSwap.swap_rules[0].size);

    const ErrSwap = erd_swap.SwapVariant(@TypeOf(@as(Msg, undefined).payload), "error_code", payload_offset);
    try std.testing.expectEqual(0, ErrSwap.ruleCount());
}

test "full tagged union swap workflow" {
    const Msg = extern struct {
        tag: enum(u8) { temperature, error_code },
        payload: extern union { temperature: u16, error_code: u8 },
    };

    // Write a temperature message: tag=0, pad, temp=0x1234
    var buf = [_]u8{ 0x00, 0x00, 0x34, 0x12 };
    const payload_offset = @offsetOf(Msg, "payload");

    // Swap the tag (u8, no-op) via struct rules
    const TagRules = erd_swap.SwapRules(@TypeOf(@as(Msg, undefined).tag));
    _ = TagRules;

    // Read tag, then swap the active variant
    const msg: *const Msg = @ptrCast(@alignCast(&buf));
    switch (msg.tag) {
        .temperature => {
            erd_swap.SwapVariant(@TypeOf(@as(Msg, undefined).payload), "temperature", payload_offset).apply(&buf);
            // After swap: bytes at offset 2-3 should be 12 34 (big-endian)
            try std.testing.expectEqual(@as(u8, 0x12), buf[payload_offset]);
            try std.testing.expectEqual(@as(u8, 0x34), buf[payload_offset + 1]);
        },
        .error_code => unreachable,
    }
}
