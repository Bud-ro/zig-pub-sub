const std = @import("std");
const SystemData = @import("system_data.zig");
const SystemErds = @import("system_erds.zig");

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Data Model Init\n", .{});
    try bw.flush();
    var system_data = SystemData.init();

    try stdout.print("Data Model Read\n", .{});
    const applicationVersion = system_data.read(SystemErds.erd.application_version);
    try stdout.print("Application Version: {x}\n", .{applicationVersion});

    try stdout.print("\n", .{});

    try stdout.print("Data Model Write\n", .{});
    const newApplicationVersion = 0x12345678;
    system_data.write(SystemErds.erd.application_version, newApplicationVersion);
    try stdout.print("New Application Version: 0x{x}\n", .{system_data.read(SystemErds.erd.application_version)});

    try bw.flush(); // don't forget to flush!
}
