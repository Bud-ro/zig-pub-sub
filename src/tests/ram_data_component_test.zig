const std = @import("std");
const RamDataComponent = @import("../ram_data_component.zig");
const erd = RamDataComponent.erds; // TODO: Should a data component know about its ERDs, or should it be told about them via .init?

test "ram data component read and write" {
    var ram_data = RamDataComponent{};
    // Should zero init
    try std.testing.expectEqual(@as(u32, 0), ram_data.read(erd.application_version));

    const new_application_version: u32 = 0x12345678;
    ram_data.write(erd.application_version, new_application_version);
    try std.testing.expectEqual(new_application_version, ram_data.read(erd.application_version));
}
