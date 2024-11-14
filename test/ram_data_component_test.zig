const std = @import("std");
const ram_data_component = @import("../src/ram_data_component.zig");
const erd = ram_data_component.erd; // TODO: Should a data component know about its ERDs, or should it be told thru init?

test "ram data component read and write" {
    var ram_data = ram_data_component.init();
    // Should zero init
    std.testing.expectEqual(@as(u32, 0), ram_data.read(erd.applicationVersion));

    const newApplicationVersion: u32 = 0x12345678;
    ram_data.write(erd.applicationVersion, newApplicationVersion);
    std.testing.expectEqual(newApplicationVersion, ram_data.read(erd.applicationVersion));
}
