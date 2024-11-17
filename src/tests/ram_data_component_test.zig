const std = @import("std");
const RamDataComponent = @import("../ram_data_component.zig");
const erd = RamDataComponent.erds; // TODO: Should a data component know about its ERDs, or should it be told about them via .init?

test "ram data component read and write" {
    var ram_data = RamDataComponent.init();
    // Should zero init
    try std.testing.expectEqual(@as(u32, 0), ram_data.read(erd.application_version));

    const new_application_version: u32 = 0x12345678;
    ram_data.write(erd.application_version, new_application_version);
    try std.testing.expectEqual(new_application_version, ram_data.read(erd.application_version));
}

test "unaligned read and write" {
    var ram_data = RamDataComponent.init();
    ram_data.write(erd.unaligned_u16, 0x1234);
    try std.testing.expectEqual(@as(u16, 0x1234), ram_data.read(erd.unaligned_u16));

    try std.testing.expectEqual(@as(u32, 0), ram_data.read(erd.application_version));
    try std.testing.expectEqual(@as(bool, false), ram_data.read(erd.some_bool));
}

test "read and write of type where @bitSizeOf != @sizeOf" {
    var ram_data = RamDataComponent.init();
    try std.testing.expectEqual(@as(bool, false), ram_data.read(erd.some_bool));

    ram_data.write(erd.some_bool, true);
    try std.testing.expectEqual(@as(bool, true), ram_data.read(erd.some_bool));
}

test "failure upon writing incorrect types" {
    return error.SkipZigTest;
    // TODO: Enable this test once you can test for compile errors

    // var ram_data = RamDataComponent.init();
    // std.testing.expectError(, ram_data.write(erd.some_bool, 20));
}
