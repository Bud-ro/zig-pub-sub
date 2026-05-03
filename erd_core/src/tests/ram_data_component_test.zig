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
