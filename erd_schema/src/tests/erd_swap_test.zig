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

// =======================================================================
// Tagged union: toBig/fromBig automatic variant swapping
// =======================================================================

test "tagged union u8 tag: toBig swaps active variant" {
    const Msg = extern struct {
        tag: enum(u8) { temp, err },
        payload: extern union { temp: u16, err: u8 },
    };

    const msg = Msg{ .tag = .temp, .payload = .{ .temp = 0x1234 } };
    const wire = erd_swap.SwapRules(Msg).toBig(msg);

    try std.testing.expectEqual(@as(u8, 0x00), wire[0]); // tag
    try std.testing.expectEqual(@as(u8, 0x12), wire[@offsetOf(Msg, "payload")]); // u16 BE high
    try std.testing.expectEqual(@as(u8, 0x34), wire[@offsetOf(Msg, "payload") + 1]); // u16 BE low

    const restored = erd_swap.SwapRules(Msg).fromBig(&wire);
    try std.testing.expectEqual(@TypeOf(@as(Msg, undefined).tag).temp, restored.tag);
    try std.testing.expectEqual(@as(u16, 0x1234), restored.payload.temp);
}

test "tagged union u8 tag: single-byte variant needs no swap" {
    const Msg = extern struct {
        tag: enum(u8) { temp, err },
        payload: extern union { temp: u16, err: u8 },
    };

    const msg = Msg{ .tag = .err, .payload = .{ .err = 42 } };
    const wire = erd_swap.SwapRules(Msg).toBig(msg);

    try std.testing.expectEqual(@as(u8, 0x01), wire[0]); // tag = err
    try std.testing.expectEqual(@as(u8, 42), wire[@offsetOf(Msg, "payload")]); // u8 unchanged

    const restored = erd_swap.SwapRules(Msg).fromBig(&wire);
    try std.testing.expectEqual(@as(u8, 42), restored.payload.err);
}

test "tagged union u16 tag" {
    const Msg = extern struct {
        tag: enum(u16) { voltage, current, resistance },
        payload: extern union { voltage: u32, current: i16, resistance: f32 },
    };

    // voltage variant with u32 payload
    const v_msg = Msg{ .tag = .voltage, .payload = .{ .voltage = 0xDEADBEEF } };
    const v_wire = erd_swap.SwapRules(Msg).toBig(v_msg);

    // tag should be BE u16 = 0x0000
    try std.testing.expectEqual(@as(u8, 0x00), v_wire[0]);
    try std.testing.expectEqual(@as(u8, 0x00), v_wire[1]);
    // payload u32 should be BE
    const po = @offsetOf(Msg, "payload");
    try std.testing.expectEqual(@as(u8, 0xDE), v_wire[po]);
    try std.testing.expectEqual(@as(u8, 0xAD), v_wire[po + 1]);
    try std.testing.expectEqual(@as(u8, 0xBE), v_wire[po + 2]);
    try std.testing.expectEqual(@as(u8, 0xEF), v_wire[po + 3]);

    const v_restored = erd_swap.SwapRules(Msg).fromBig(&v_wire);
    try std.testing.expectEqual(@TypeOf(@as(Msg, undefined).tag).voltage, v_restored.tag);
    try std.testing.expectEqual(@as(u32, 0xDEADBEEF), v_restored.payload.voltage);

    // current variant with i16 payload
    const c_msg = Msg{ .tag = .current, .payload = .{ .current = -500 } };
    const c_wire = erd_swap.SwapRules(Msg).toBig(c_msg);

    // tag = 1 in BE
    try std.testing.expectEqual(@as(u8, 0x00), c_wire[0]);
    try std.testing.expectEqual(@as(u8, 0x01), c_wire[1]);

    const c_restored = erd_swap.SwapRules(Msg).fromBig(&c_wire);
    try std.testing.expectEqual(@as(i16, -500), c_restored.payload.current);
}

test "tagged union u32 tag" {
    const Msg = extern struct {
        tag: enum(u32) { ping, pong, data },
        payload: extern union { ping: u64, pong: u64, data: u32 },
    };

    const msg = Msg{ .tag = .pong, .payload = .{ .pong = 0x0102030405060708 } };
    const wire = erd_swap.SwapRules(Msg).toBig(msg);

    // tag = 1 in BE u32
    try std.testing.expectEqual(@as(u8, 0x00), wire[0]);
    try std.testing.expectEqual(@as(u8, 0x00), wire[1]);
    try std.testing.expectEqual(@as(u8, 0x00), wire[2]);
    try std.testing.expectEqual(@as(u8, 0x01), wire[3]);

    // u64 payload in BE
    const po = @offsetOf(Msg, "payload");
    try std.testing.expectEqual(@as(u8, 0x01), wire[po]);
    try std.testing.expectEqual(@as(u8, 0x08), wire[po + 7]);

    const restored = erd_swap.SwapRules(Msg).fromBig(&wire);
    try std.testing.expectEqual(@TypeOf(@as(Msg, undefined).tag).pong, restored.tag);
    try std.testing.expectEqual(@as(u64, 0x0102030405060708), restored.payload.pong);
}

test "tagged union u32 tag: data variant (smaller than largest)" {
    const Msg = extern struct {
        tag: enum(u32) { ping, pong, data },
        payload: extern union { ping: u64, pong: u64, data: u32 },
    };

    const msg = Msg{ .tag = .data, .payload = .{ .data = 0xCAFEBABE } };
    const wire = erd_swap.SwapRules(Msg).toBig(msg);

    const po = @offsetOf(Msg, "payload");
    try std.testing.expectEqual(@as(u8, 0xCA), wire[po]);
    try std.testing.expectEqual(@as(u8, 0xFE), wire[po + 1]);
    try std.testing.expectEqual(@as(u8, 0xBA), wire[po + 2]);
    try std.testing.expectEqual(@as(u8, 0xBE), wire[po + 3]);

    const restored = erd_swap.SwapRules(Msg).fromBig(&wire);
    try std.testing.expectEqual(@as(u32, 0xCAFEBABE), restored.payload.data);
}

test "tagged union with struct variant" {
    const Inner = extern struct { x: u16, y: u16 };
    const Msg = extern struct {
        tag: enum(u8) { point, raw },
        payload: extern union { point: Inner, raw: u32 },
    };

    const msg = Msg{ .tag = .point, .payload = .{ .point = .{ .x = 100, .y = 200 } } };
    const wire = erd_swap.SwapRules(Msg).toBig(msg);

    const po = @offsetOf(Msg, "payload");
    // x = 100 = 0x0064 in BE
    try std.testing.expectEqual(@as(u8, 0x00), wire[po]);
    try std.testing.expectEqual(@as(u8, 0x64), wire[po + 1]);
    // y = 200 = 0x00C8 in BE
    try std.testing.expectEqual(@as(u8, 0x00), wire[po + 2]);
    try std.testing.expectEqual(@as(u8, 0xC8), wire[po + 3]);

    const restored = erd_swap.SwapRules(Msg).fromBig(&wire);
    try std.testing.expectEqual(@as(u16, 100), restored.payload.point.x);
    try std.testing.expectEqual(@as(u16, 200), restored.payload.point.y);
}

test "tagged union inside a larger struct" {
    const Inner = extern struct {
        tag: enum(u8) { a, b },
        payload: extern union { a: u16, b: u8 },
    };
    const Outer = extern struct {
        header: u32,
        inner: Inner,
        footer: u16,
    };

    const msg = Outer{
        .header = 0x11223344,
        .inner = .{ .tag = .a, .payload = .{ .a = 0xABCD } },
        .footer = 0x5566,
    };
    const wire = erd_swap.SwapRules(Outer).toBig(msg);

    // header BE
    try std.testing.expectEqual(@as(u8, 0x11), wire[0]);
    try std.testing.expectEqual(@as(u8, 0x44), wire[3]);

    // inner.tag = 0 (a)
    const inner_off = @offsetOf(Outer, "inner");
    try std.testing.expectEqual(@as(u8, 0x00), wire[inner_off]);

    // inner.payload.a = 0xABCD in BE
    const payload_off = inner_off + @offsetOf(Inner, "payload");
    try std.testing.expectEqual(@as(u8, 0xAB), wire[payload_off]);
    try std.testing.expectEqual(@as(u8, 0xCD), wire[payload_off + 1]);

    // footer BE
    const footer_off = @offsetOf(Outer, "footer");
    try std.testing.expectEqual(@as(u8, 0x55), wire[footer_off]);
    try std.testing.expectEqual(@as(u8, 0x66), wire[footer_off + 1]);

    const restored = erd_swap.SwapRules(Outer).fromBig(&wire);
    try std.testing.expectEqual(@as(u32, 0x11223344), restored.header);
    try std.testing.expectEqual(@TypeOf(@as(Inner, undefined).tag).a, restored.inner.tag);
    try std.testing.expectEqual(@as(u16, 0xABCD), restored.inner.payload.a);
    try std.testing.expectEqual(@as(u16, 0x5566), restored.footer);
}

test "tagged union round-trip for all variants" {
    const Msg = extern struct {
        tag: enum(u8) { u8_val, u16_val, u32_val, i16_val },
        payload: extern union { u8_val: u8, u16_val: u16, u32_val: u32, i16_val: i16 },
    };

    // Test every variant round-trips correctly
    const u8_msg = Msg{ .tag = .u8_val, .payload = .{ .u8_val = 0xFF } };
    const u8_rt = erd_swap.SwapRules(Msg).fromBig(&erd_swap.SwapRules(Msg).toBig(u8_msg));
    try std.testing.expectEqual(@as(u8, 0xFF), u8_rt.payload.u8_val);

    const u16_msg = Msg{ .tag = .u16_val, .payload = .{ .u16_val = 0x1234 } };
    const u16_rt = erd_swap.SwapRules(Msg).fromBig(&erd_swap.SwapRules(Msg).toBig(u16_msg));
    try std.testing.expectEqual(@as(u16, 0x1234), u16_rt.payload.u16_val);

    const u32_msg = Msg{ .tag = .u32_val, .payload = .{ .u32_val = 0xDEADBEEF } };
    const u32_rt = erd_swap.SwapRules(Msg).fromBig(&erd_swap.SwapRules(Msg).toBig(u32_msg));
    try std.testing.expectEqual(@as(u32, 0xDEADBEEF), u32_rt.payload.u32_val);

    const i16_msg = Msg{ .tag = .i16_val, .payload = .{ .i16_val = -1 } };
    const i16_rt = erd_swap.SwapRules(Msg).fromBig(&erd_swap.SwapRules(Msg).toBig(i16_msg));
    try std.testing.expectEqual(@as(i16, -1), i16_rt.payload.i16_val);
}
