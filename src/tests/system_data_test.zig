const std = @import("std");
const SystemData = @import("../system_data.zig");
const SystemErds = @import("../system_erds.zig");

test "ram data component read and write" {
    var system_data = SystemData.init();
    // Should zero init
    try std.testing.expectEqual(@as(u32, 0), system_data.read(SystemErds.erd.application_version));

    const new_application_version: u32 = 0x12345678;
    system_data.write(SystemErds.erd.application_version, new_application_version);
    try std.testing.expectEqual(new_application_version, system_data.read(SystemErds.erd.application_version));
}

test "indirect data component read and a note on reads" {
    var system_data = SystemData.init();
    // Should zero init
    try std.testing.expectEqual(@as(u16, 42), system_data.read(SystemErds.erd.always_42));

    // This does not work:
    // src\system_data.zig:49:31: error: reached unreachable code
    //     .Indirect => comptime unreachable,
    // system_data.write(SystemErds.erd.always_42, 43);
}
