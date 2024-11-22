const std = @import("std");
const RamDataComponent = @import("../ram_data_component.zig");
const SystemErds = @import("../system_erds.zig");

test "ram data component read and write" {
    var ram_data = RamDataComponent.init();
    // Should zero init
    try std.testing.expectEqual(@as(u32, 0), ram_data.read(SystemErds.erd.application_version));

    const new_application_version: u32 = 0x12345678;
    ram_data.write(SystemErds.erd.application_version, new_application_version);
    try std.testing.expectEqual(new_application_version, ram_data.read(SystemErds.erd.application_version));
}

test "unaligned read and write" {
    var ram_data = RamDataComponent.init();
    ram_data.write(SystemErds.erd.unaligned_u16, 0x1234);
    try std.testing.expectEqual(@as(u16, 0x1234), ram_data.read(SystemErds.erd.unaligned_u16));

    try std.testing.expectEqual(@as(u32, 0), ram_data.read(SystemErds.erd.application_version));
    try std.testing.expectEqual(@as(bool, false), ram_data.read(SystemErds.erd.some_bool));
}

test "read and write of type where @bitSizeOf is not multiple of 8" {
    var ram_data = RamDataComponent.init();
    try std.testing.expectEqual(@as(bool, false), ram_data.read(SystemErds.erd.some_bool));

    ram_data.write(SystemErds.erd.some_bool, true);
    try std.testing.expectEqual(@as(bool, true), ram_data.read(SystemErds.erd.some_bool));
}

test "pointers read/write" {
    var ram_data = RamDataComponent.init();
    try std.testing.expectEqual(@as(?*u16, @ptrFromInt(0)), ram_data.read(SystemErds.erd.pointer_to_something));

    var temp: u16 = 2;
    ram_data.write(SystemErds.erd.pointer_to_something, &temp);
    try std.testing.expectEqual(@as(u16, 2), ram_data.read(SystemErds.erd.pointer_to_something).?.*);
}

test "structs" {
    var ram_data = RamDataComponent.init();
    const st = ram_data.read(SystemErds.erd.well_packed);
    try std.testing.expectEqual(@as(@TypeOf(st), .{ .a = 0, .b = 0, .c = 0 }), st);

    const packed_st = ram_data.read(SystemErds.erd.actually_packed_fr);
    try std.testing.expectEqual(std.mem.zeroes(@TypeOf(packed_st)), packed_st);

    ram_data.write(SystemErds.erd.actually_packed_fr, .{ .a = 1, .b = 0, .c = 0, .d = 0, .e = 1, .f = 0, .g = 1 });
    const packed_st_with_data = ram_data.read(SystemErds.erd.actually_packed_fr);
    try std.testing.expectEqual(@TypeOf(packed_st_with_data){ .a = 1, .b = 0, .c = 0, .d = 0, .e = 1, .f = 0, .g = 1 }, packed_st_with_data);

    ram_data.write(SystemErds.erd.padded, .{ .a = 0x12, .b = 0x3456, .c = true, .d = 0x09ABCDEF });

    const padded = ram_data.read(SystemErds.erd.padded);
    try std.testing.expectEqual(@TypeOf(padded){ .a = 0x12, .b = 0x3456, .c = true, .d = 0x09ABCDEF }, padded);
}

test "failure upon writing incorrect types" {
    return error.SkipZigTest;
    // TODO: Enable this test once you can test for compile errors

    // var ram_data = RamDataComponent.init();
    // std.testing.expectError(, ram_data.write(SystemErds.erd.some_bool, 20));
}
