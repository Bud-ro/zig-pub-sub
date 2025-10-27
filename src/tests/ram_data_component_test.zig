const std = @import("std");
const RamDataComponent = @import("../ram_data_component.zig");
const SystemErds = @import("../system_erds.zig");

const ExampleRamDataComponent = RamDataComponent.RamDataComponent(
    SystemErds,
);

test "ram data component read and write" {
    var ram_data: ExampleRamDataComponent = .init();
    // Should zero init
    try std.testing.expectEqual(0, ram_data.read(SystemErds.erd.erd_application_version));
    try std.testing.expectEqual(false, ram_data.write(SystemErds.erd.erd_application_version, 0));

    const new_application_version: u32 = 0x12345678;
    try std.testing.expectEqual(true, ram_data.write(SystemErds.erd.erd_application_version, new_application_version));
    try std.testing.expectEqual(new_application_version, ram_data.read(SystemErds.erd.erd_application_version));
}

test "unaligned read and write" {
    var ram_data: ExampleRamDataComponent = .init();
    _ = ram_data.write(SystemErds.erd.erd_unaligned_u16, 0x1234);
    try std.testing.expectEqual(0x1234, ram_data.read(SystemErds.erd.erd_unaligned_u16));

    try std.testing.expectEqual(0, ram_data.read(SystemErds.erd.erd_application_version));
    try std.testing.expectEqual(false, ram_data.read(SystemErds.erd.erd_some_bool));
}

test "read and write of type where @bitSizeOf is not multiple of 8" {
    var ram_data: ExampleRamDataComponent = .init();
    try std.testing.expectEqual(false, ram_data.read(SystemErds.erd.erd_some_bool));

    _ = ram_data.write(SystemErds.erd.erd_some_bool, true);
    try std.testing.expectEqual(true, ram_data.read(SystemErds.erd.erd_some_bool));
}

test "pointers read/write" {
    var ram_data: ExampleRamDataComponent = .init();
    try std.testing.expectEqual(null, ram_data.read(SystemErds.erd.erd_pointer_to_something));

    var temp: u16 = 2;
    _ = ram_data.write(SystemErds.erd.erd_pointer_to_something, &temp);
    try std.testing.expectEqual(2, ram_data.read(SystemErds.erd.erd_pointer_to_something).?.*);
}

test "structs" {
    var ram_data: ExampleRamDataComponent = .init();
    const st = ram_data.read(SystemErds.erd.erd_well_packed);
    try std.testing.expectEqual(@as(@TypeOf(st), .{ .a = 0, .b = 0, .c = 0 }), st);

    const packed_st = ram_data.read(SystemErds.erd.erd_actually_packed_fr);
    try std.testing.expectEqual(std.mem.zeroes(@TypeOf(packed_st)), packed_st);

    _ = ram_data.write(SystemErds.erd.erd_actually_packed_fr, .{ .a = 1, .b = 0, .c = 0, .d = 0, .e = 1, .f = 0, .g = 1 });
    const packed_st_with_data = ram_data.read(SystemErds.erd.erd_actually_packed_fr);
    try std.testing.expectEqual(@TypeOf(packed_st_with_data){ .a = 1, .b = 0, .c = 0, .d = 0, .e = 1, .f = 0, .g = 1 }, packed_st_with_data);

    _ = ram_data.write(SystemErds.erd.erd_padded, .{ .a = 0x12, .b = 0x3456, .c = true, .d = 0x09ABCDEF });

    const erd_padded = ram_data.read(SystemErds.erd.erd_padded);
    try std.testing.expectEqual(@TypeOf(erd_padded){ .a = 0x12, .b = 0x3456, .c = true, .d = 0x09ABCDEF }, erd_padded);
}

test "failure upon writing incorrect types" {
    return error.SkipZigTest; // Test for compile error

    // var ram_data: ExampleRamDataComponent = .init();
    // std.testing.expectError(, ram_data.write(SystemErds.erd.erd_some_bool, 20));
}

test "runtime reads" {
    var ram_data: ExampleRamDataComponent = .init();

    _ = ram_data.write(SystemErds.erd.erd_some_bool, true);

    var bool_val: bool = undefined;
    ram_data.runtime_read(SystemErds.erd.erd_some_bool.data_component_idx, &bool_val);

    try std.testing.expectEqual(true, bool_val);
}

test "runtime writes" {
    var ram_data: ExampleRamDataComponent = .init();

    const very_true = true;
    var changed = ram_data.runtime_write(SystemErds.erd.erd_some_bool.data_component_idx, &very_true);
    try std.testing.expect(changed);

    const bool_val = ram_data.read(SystemErds.erd.erd_some_bool);
    try std.testing.expectEqual(true, bool_val);

    changed = ram_data.write(SystemErds.erd.erd_some_bool, true);
    try std.testing.expect(!changed);

    changed = ram_data.write(SystemErds.erd.erd_some_bool, false);
    try std.testing.expect(changed);
}
