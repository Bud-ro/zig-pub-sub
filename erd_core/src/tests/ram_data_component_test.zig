const erd_core = @import("erd_core");
const std = @import("std");
const Erd = erd_core.Erd;

const WellPackedStruct = struct {
    a: u8,
    b: u8,
    c: u16,
};

const PaddedStruct = extern struct {
    a: u8,
    b: u16,
    d: u32,
    c: bool,
};

const PackedFr = packed struct {
    a: u5,
    b: u5,
    c: u5,
    d: u5,
    e: u1,
    f: u1,
    g: u1,
};

const erds = [_]Erd{
    .{ .erd_number = null, .T = u32, .component_idx = 0, .subs = 0, .data_component_idx = 0, .system_data_idx = 0 },
    .{ .erd_number = null, .T = bool, .component_idx = 0, .subs = 0, .data_component_idx = 1, .system_data_idx = 1 },
    .{ .erd_number = null, .T = u16, .component_idx = 0, .subs = 0, .data_component_idx = 2, .system_data_idx = 2 },
    .{ .erd_number = null, .T = WellPackedStruct, .component_idx = 0, .subs = 0, .data_component_idx = 3, .system_data_idx = 3 },
    .{ .erd_number = null, .T = PaddedStruct, .component_idx = 0, .subs = 0, .data_component_idx = 4, .system_data_idx = 4 },
    .{ .erd_number = null, .T = PackedFr, .component_idx = 0, .subs = 0, .data_component_idx = 5, .system_data_idx = 5 },
    .{ .erd_number = null, .T = ?*u16, .component_idx = 0, .subs = 0, .data_component_idx = 6, .system_data_idx = 6 },
};

const RamDataComponent = erd_core.data_component.Ram(&erds);

const erd_u32 = erds[0];
const erd_bool = erds[1];
const erd_u16 = erds[2];
const erd_well_packed = erds[3];
const erd_padded = erds[4];
const erd_packed_fr = erds[5];
const erd_ptr = erds[6];

var dummy_publisher: u8 = 0;

test "ram data component read and write" {
    var ram_data = RamDataComponent.init();
    try std.testing.expectEqual(0, ram_data.read(erd_u32));

    ram_data.write(erd_u32, 0, &dummy_publisher);

    const new_ver: u32 = 0x12345678;
    ram_data.write(erd_u32, new_ver, &dummy_publisher);
    try std.testing.expectEqual(new_ver, ram_data.read(erd_u32));
}

test "unaligned read and write" {
    var ram_data = RamDataComponent.init();
    ram_data.write(erd_u16, 0x1234, &dummy_publisher);
    try std.testing.expectEqual(0x1234, ram_data.read(erd_u16));

    try std.testing.expectEqual(0, ram_data.read(erd_u32));
    try std.testing.expectEqual(false, ram_data.read(erd_bool));
}

test "read and write of type where @bitSizeOf is not multiple of 8" {
    var ram_data = RamDataComponent.init();
    try std.testing.expectEqual(false, ram_data.read(erd_bool));

    ram_data.write(erd_bool, true, &dummy_publisher);
    try std.testing.expectEqual(true, ram_data.read(erd_bool));
}

test "pointers read/write" {
    var ram_data = RamDataComponent.init();
    try std.testing.expectEqual(null, ram_data.read(erd_ptr));

    var temp: u16 = 2;
    ram_data.write(erd_ptr, &temp, &dummy_publisher);
    try std.testing.expectEqual(2, ram_data.read(erd_ptr).?.*);
}

test "structs" {
    var ram_data = RamDataComponent.init();
    const st = ram_data.read(erd_well_packed);
    try std.testing.expectEqual(@as(@TypeOf(st), .{ .a = 0, .b = 0, .c = 0 }), st);

    const packed_st = ram_data.read(erd_packed_fr);
    try std.testing.expectEqual(std.mem.zeroes(@TypeOf(packed_st)), packed_st);

    ram_data.write(erd_packed_fr, .{ .a = 1, .b = 0, .c = 0, .d = 0, .e = 1, .f = 0, .g = 1 }, &dummy_publisher);
    const packed_st_with_data = ram_data.read(erd_packed_fr);
    try std.testing.expectEqual(@TypeOf(packed_st_with_data){ .a = 1, .b = 0, .c = 0, .d = 0, .e = 1, .f = 0, .g = 1 }, packed_st_with_data);

    ram_data.write(erd_padded, .{ .a = 0x12, .b = 0x3456, .c = true, .d = 0x09ABCDEF }, &dummy_publisher);

    const padded = ram_data.read(erd_padded);
    try std.testing.expectEqual(@TypeOf(padded){ .a = 0x12, .b = 0x3456, .c = true, .d = 0x09ABCDEF }, padded);
}

test "failure upon writing incorrect types" {
    return error.SkipZigTest; // Test for compile error

    // var ram_data = RamDataComponent.init();
    // std.testing.expectError(, ram_data.write(erd_bool, 20, &dummy_publisher));
}

test "runtime reads" {
    var ram_data = RamDataComponent.init();

    ram_data.write(erd_bool, true, &dummy_publisher);

    var bool_val: bool = undefined;
    ram_data.runtimeRead(erd_bool.data_component_idx, &bool_val);

    try std.testing.expectEqual(true, bool_val);
}

test "runtime writes" {
    var ram_data = RamDataComponent.init();

    const very_true = true;
    ram_data.runtimeWrite(erd_bool.data_component_idx, &very_true, &dummy_publisher);

    const bool_val = ram_data.read(erd_bool);
    try std.testing.expectEqual(true, bool_val);

    ram_data.write(erd_bool, true, &dummy_publisher);
    try std.testing.expectEqual(true, ram_data.read(erd_bool));

    ram_data.write(erd_bool, false, &dummy_publisher);
    try std.testing.expectEqual(false, ram_data.read(erd_bool));
}

// Exercise the > 16-byte change-detection path in `write` (separate from the
// small-int readInt path that fits inside one [u128] compare).
const BigBlob = extern struct { bytes: [24]u8, tag: u32 };

const BigBlobErds = [_]Erd{
    .{ .erd_number = null, .T = BigBlob, .component_idx = 0, .subs = 1, .data_component_idx = 0, .system_data_idx = 0 },
};
const BigBlobErd = BigBlobErds[0];
const BigBlobRam = erd_core.data_component.Ram(&BigBlobErds);

var big_blob_publish_count: u32 = 0;
fn bigBlobPublishCounter(_: ?*anyopaque, _: ?*const anyopaque, _: *anyopaque) void {
    big_blob_publish_count += 1;
}

test "write detects change in > 16-byte struct" {
    big_blob_publish_count = 0;
    var ram = BigBlobRam.init();
    ram.subs.subscribe(BigBlobErd, null, bigBlobPublishCounter);

    // Storage is zero-initialized; first non-zero write must publish.
    var blob = BigBlob{ .bytes = [_]u8{0} ** 24, .tag = 1 };
    ram.write(BigBlobErd, blob, &dummy_publisher);
    try std.testing.expectEqual(1, big_blob_publish_count);

    // identical write -> no publish
    ram.write(BigBlobErd, blob, &dummy_publisher);
    try std.testing.expectEqual(1, big_blob_publish_count);

    // change only in the trailing bytes after the first 16
    blob.bytes[20] = 0xAB;
    ram.write(BigBlobErd, blob, &dummy_publisher);
    try std.testing.expectEqual(2, big_blob_publish_count);

    // change only in `tag` (the 4-byte tail past the 8-byte chunks)
    blob.tag = 2;
    ram.write(BigBlobErd, blob, &dummy_publisher);
    try std.testing.expectEqual(3, big_blob_publish_count);
}

// Exercise the partial-word tail branch of `bytesChanged` (len > 16 with
// len % 8 != 0). 17 bytes is the smallest size that triggers both the
// readInt(u64) chunk loop and the trailing partial-word read.
const OddSizeBlob = extern struct { bytes: [17]u8 };

const OddSizeErds = [_]Erd{
    .{ .erd_number = null, .T = OddSizeBlob, .component_idx = 0, .subs = 1, .data_component_idx = 0, .system_data_idx = 0 },
};
const OddSizeErd = OddSizeErds[0];
const OddSizeRam = erd_core.data_component.Ram(&OddSizeErds);

var odd_blob_publish_count: u32 = 0;
fn oddBlobPublishCounter(_: ?*anyopaque, _: ?*const anyopaque, _: *anyopaque) void {
    odd_blob_publish_count += 1;
}

test "write detects change in tail byte of 17-byte struct" {
    odd_blob_publish_count = 0;
    var ram = OddSizeRam.init();
    ram.subs.subscribe(OddSizeErd, null, oddBlobPublishCounter);

    var blob = OddSizeBlob{ .bytes = [_]u8{0} ** 17 };
    blob.bytes[0] = 0x42;
    ram.write(OddSizeErd, blob, &dummy_publisher);
    try std.testing.expectEqual(1, odd_blob_publish_count);

    // Change ONLY the tail byte (index 16). Previous bytes 0..15 are
    // unchanged, so the readInt(u64) chunks compare equal; only the
    // 1-byte tail read should detect this difference.
    blob.bytes[16] = 0xFF;
    ram.write(OddSizeErd, blob, &dummy_publisher);
    try std.testing.expectEqual(2, odd_blob_publish_count);
}

// Regression: an ordinary AUTO-layout struct ERD with a subscriber must
// compile and publish. The struct path reads the old value through a typed
// pointer (not @bitCast, which rejects auto-layout structs at compile time);
// before that fix this whole component failed to build.
const AutoStruct = struct { a: u32, b: u32 };

const AutoStructErds = [_]Erd{
    .{ .erd_number = null, .T = AutoStruct, .component_idx = 0, .subs = 1, .data_component_idx = 0, .system_data_idx = 0 },
};
const AutoStructErd = AutoStructErds[0];
const AutoStructRam = erd_core.data_component.Ram(&AutoStructErds);

var auto_struct_publish_count: u32 = 0;
fn autoStructPublishCounter(_: ?*anyopaque, _: ?*const anyopaque, _: *anyopaque) void {
    auto_struct_publish_count += 1;
}

test "auto-layout struct ERD with a subscriber compiles and detects change" {
    auto_struct_publish_count = 0;
    var ram = AutoStructRam.init();
    ram.subs.subscribe(AutoStructErd, null, autoStructPublishCounter);

    ram.write(AutoStructErd, .{ .a = 1, .b = 2 }, &dummy_publisher);
    try std.testing.expectEqual(1, auto_struct_publish_count);

    // identical write -> no publish
    ram.write(AutoStructErd, .{ .a = 1, .b = 2 }, &dummy_publisher);
    try std.testing.expectEqual(1, auto_struct_publish_count);

    // change one field -> publish
    ram.write(AutoStructErd, .{ .a = 1, .b = 3 }, &dummy_publisher);
    try std.testing.expectEqual(2, auto_struct_publish_count);
}

// A struct-embedded float must publish a +0.0 -> -0.0 change (different bits,
// equal under `==`). Float-bearing types take the bit-exact byte path so a
// struct float behaves the same as a scalar float ERD.
const FloatStruct = extern struct { f: f32, n: u32 };

const FloatStructErds = [_]Erd{
    .{ .erd_number = null, .T = FloatStruct, .component_idx = 0, .subs = 1, .data_component_idx = 0, .system_data_idx = 0 },
};
const FloatStructErd = FloatStructErds[0];
const FloatStructRam = erd_core.data_component.Ram(&FloatStructErds);

var float_struct_publish_count: u32 = 0;
fn floatStructPublishCounter(_: ?*anyopaque, _: ?*const anyopaque, _: *anyopaque) void {
    float_struct_publish_count += 1;
}

test "struct-embedded float publishes a +0.0 -> -0.0 (bit-exact) change" {
    float_struct_publish_count = 0;
    var ram = FloatStructRam.init();
    ram.subs.subscribe(FloatStructErd, null, floatStructPublishCounter);

    const pos_zero: f32 = @bitCast(@as(u32, 0x0000_0000));
    const neg_zero: f32 = @bitCast(@as(u32, 0x8000_0000));

    ram.write(FloatStructErd, .{ .f = pos_zero, .n = 1 }, &dummy_publisher);
    try std.testing.expectEqual(1, float_struct_publish_count);

    // identical write -> no publish
    ram.write(FloatStructErd, .{ .f = pos_zero, .n = 1 }, &dummy_publisher);
    try std.testing.expectEqual(1, float_struct_publish_count);

    // +0.0 -> -0.0: equal under `==`, different bits -> must publish
    ram.write(FloatStructErd, .{ .f = neg_zero, .n = 1 }, &dummy_publisher);
    try std.testing.expectEqual(2, float_struct_publish_count);
}

// A struct containing an extern (untagged) union is not std.meta.eql-comparable,
// so it falls back to the byte-compare path. It must still publish on change.
const ExternPayload = extern union { as_u32: u32, as_f32: f32 };
const HasExternUnion = extern struct { payload: ExternPayload, tag: u8 };

const UnionStructErds = [_]Erd{
    .{ .erd_number = null, .T = HasExternUnion, .component_idx = 0, .subs = 1, .data_component_idx = 0, .system_data_idx = 0 },
};
const UnionStructErd = UnionStructErds[0];
const UnionStructRam = erd_core.data_component.Ram(&UnionStructErds);

var union_struct_publish_count: u32 = 0;
fn unionStructPublishCounter(_: ?*anyopaque, _: ?*const anyopaque, _: *anyopaque) void {
    union_struct_publish_count += 1;
}

test "struct with an extern union uses the byte fallback and detects change" {
    union_struct_publish_count = 0;
    var ram = UnionStructRam.init();
    ram.subs.subscribe(UnionStructErd, null, unionStructPublishCounter);

    ram.write(UnionStructErd, .{ .payload = .{ .as_u32 = 7 }, .tag = 1 }, &dummy_publisher);
    try std.testing.expectEqual(1, union_struct_publish_count);

    ram.write(UnionStructErd, .{ .payload = .{ .as_u32 = 7 }, .tag = 1 }, &dummy_publisher);
    try std.testing.expectEqual(1, union_struct_publish_count);

    ram.write(UnionStructErd, .{ .payload = .{ .as_u32 = 8 }, .tag = 1 }, &dummy_publisher);
    try std.testing.expectEqual(2, union_struct_publish_count);
}

// A tagged union ERD is std.meta.eql-comparable, so it takes the field-aware
// path (compare tag, then active field). Changing the active variant publishes.
const TaggedErd = union(enum) { a: u32, b: u16 };

const TaggedErds = [_]Erd{
    .{ .erd_number = null, .T = TaggedErd, .component_idx = 0, .subs = 1, .data_component_idx = 0, .system_data_idx = 0 },
};
const TaggedErdErd = TaggedErds[0];
const TaggedRam = erd_core.data_component.Ram(&TaggedErds);

var tagged_publish_count: u32 = 0;
fn taggedPublishCounter(_: ?*anyopaque, _: ?*const anyopaque, _: *anyopaque) void {
    tagged_publish_count += 1;
}

test "tagged union ERD uses the field-aware path and detects variant change" {
    tagged_publish_count = 0;
    var ram = TaggedRam.init();
    ram.subs.subscribe(TaggedErdErd, null, taggedPublishCounter);

    ram.write(TaggedErdErd, .{ .a = 5 }, &dummy_publisher);
    try std.testing.expectEqual(1, tagged_publish_count);

    ram.write(TaggedErdErd, .{ .a = 5 }, &dummy_publisher);
    try std.testing.expectEqual(1, tagged_publish_count);

    // switch active variant (same numeric value) -> publish
    ram.write(TaggedErdErd, .{ .b = 5 }, &dummy_publisher);
    try std.testing.expectEqual(2, tagged_publish_count);
}

// A padded struct ERD with a subscriber: a real field change publishes and a
// no-op write does not. (Whether a padding-only difference publishes is
// optimizer-dependent -- the field compare ignores padding only when LLVM keeps
// it field-level -- so it is deliberately not asserted here.)
const PaddedSubErds = [_]Erd{
    .{ .erd_number = null, .T = PaddedStruct, .component_idx = 0, .subs = 1, .data_component_idx = 0, .system_data_idx = 0 },
};
const PaddedSubErd = PaddedSubErds[0];
const PaddedSubRam = erd_core.data_component.Ram(&PaddedSubErds);

var padded_publish_count: u32 = 0;
fn paddedPublishCounter(_: ?*anyopaque, _: ?*const anyopaque, _: *anyopaque) void {
    padded_publish_count += 1;
}

test "padded struct ERD: field change publishes, no-op does not" {
    padded_publish_count = 0;
    var ram = PaddedSubRam.init();
    ram.subs.subscribe(PaddedSubErd, null, paddedPublishCounter);

    const val = PaddedStruct{ .a = 0x12, .b = 0x3456, .c = true, .d = 0x09ABCDEF };
    ram.write(PaddedSubErd, val, &dummy_publisher);
    try std.testing.expectEqual(1, padded_publish_count);

    // identical write -> no publish
    ram.write(PaddedSubErd, val, &dummy_publisher);
    try std.testing.expectEqual(1, padded_publish_count);

    // a real field change publishes
    ram.write(PaddedSubErd, .{ .a = 0x99, .b = 0x3456, .c = true, .d = 0x09ABCDEF }, &dummy_publisher);
    try std.testing.expectEqual(2, padded_publish_count);
}

// An over-aligned ERD (u128, align 16) preceded by a narrow ERD exercises
// storageAlign()'s @max branch (storage over-aligned to 16) and forward-align
// padding. The subscriber @alignCasts the published pointer to *const u128;
// in safety builds that traps if the pointer is not 16-aligned.
const OverAlignedErds = [_]Erd{
    .{ .erd_number = null, .T = u8, .component_idx = 0, .subs = 0, .data_component_idx = 0, .system_data_idx = 0 },
    .{ .erd_number = null, .T = u128, .component_idx = 0, .subs = 1, .data_component_idx = 1, .system_data_idx = 1 },
};
const OverAlignedU8 = OverAlignedErds[0];
const OverAlignedU128 = OverAlignedErds[1];
const OverAlignedRam = erd_core.data_component.Ram(&OverAlignedErds);

var over_aligned_seen: u128 = 0;
fn overAlignedSubscriber(_: ?*anyopaque, args: ?*const anyopaque, _: *anyopaque) void {
    const oc: *const erd_core.system_data.OnChangeArgs = @ptrCast(@alignCast(args.?));
    // @alignCast to *const u128 traps in safety builds if oc.data (a pointer
    // straight into storage) is not 16-aligned.
    const p: *const u128 = @ptrCast(@alignCast(oc.data));
    over_aligned_seen = p.*;
}

test "over-aligned (u128) ERD publishes an aligned pointer subscribers can @alignCast" {
    try std.testing.expectEqual(16, @alignOf(OverAlignedRam));

    over_aligned_seen = 0;
    var ram = OverAlignedRam.init();
    ram.subs.subscribe(OverAlignedU128, null, overAlignedSubscriber);

    // Write the narrow ERD first so the u128 lives past forward-align padding.
    ram.write(OverAlignedU8, 0xAB, &dummy_publisher);

    const big: u128 = 0x1122_3344_5566_7788_99AA_BBCC_DDEE_FF00;
    ram.write(OverAlignedU128, big, &dummy_publisher);
    // The @alignCast inside the subscriber would trap in safety builds if the
    // published pointer were misaligned; reaching here with the right value
    // proves it is 16-aligned.
    try std.testing.expectEqual(big, over_aligned_seen);
    try std.testing.expectEqual(0xAB, ram.read(OverAlignedU8));
}

// sizeReport() exposes the forward-align cost (storage vs payload) so a
// pessimal ERD order (here alternating u8/u64 -> ~78% growth) is visible and
// CI-gateable. Callers compute overhead themselves as storage - payload.
test "sizeReport reports storage and payload bytes" {
    const PessimalErds = [_]Erd{
        .{ .erd_number = null, .T = u8, .component_idx = 0, .subs = 0, .data_component_idx = 0, .system_data_idx = 0 },
        .{ .erd_number = null, .T = u64, .component_idx = 0, .subs = 0, .data_component_idx = 1, .system_data_idx = 1 },
        .{ .erd_number = null, .T = u8, .component_idx = 0, .subs = 0, .data_component_idx = 2, .system_data_idx = 2 },
        .{ .erd_number = null, .T = u64, .component_idx = 0, .subs = 0, .data_component_idx = 3, .system_data_idx = 3 },
    };
    const PessimalRam = erd_core.data_component.Ram(&PessimalErds);
    const ram = PessimalRam.init();
    const report = ram.sizeReport();

    try std.testing.expectEqual(18, report.payload_bytes); // 1 + 8 + 1 + 8
    try std.testing.expectEqual(32, report.storage_bytes); // 1,(7 pad),8,1,(7 pad),8
    try std.testing.expectEqual(14, report.storage_bytes - report.payload_bytes); // overhead
}
