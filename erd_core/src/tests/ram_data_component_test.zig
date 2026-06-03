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

    ram_data.modify(erd_packed_fr, struct {
        fn m(val: *PackedFr) void {
            val.* = .{ .a = 1, .b = 0, .c = 0, .d = 0, .e = 1, .f = 0, .g = 1 };
        }
    }.m, &dummy_publisher);
    const packed_st_with_data = ram_data.read(erd_packed_fr);
    try std.testing.expectEqual(@TypeOf(packed_st_with_data){ .a = 1, .b = 0, .c = 0, .d = 0, .e = 1, .f = 0, .g = 1 }, packed_st_with_data);

    ram_data.modify(erd_padded, struct {
        fn m(val: *PaddedStruct) void {
            val.* = .{ .a = 0x12, .b = 0x3456, .c = true, .d = 0x09ABCDEF };
        }
    }.m, &dummy_publisher);

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
