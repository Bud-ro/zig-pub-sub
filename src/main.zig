const std = @import("std");
const system_data = @import("system_data");
const erd = system_data.erd;

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Data Model Init\n", .{});
    var data_model = system_data.init();

    try stdout.print("Data Model Read\n", .{});
    const applicationVersion: u32 = data_model.read(erd.applicationVersion);

    try bw.flush(); // don't forget to flush!
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
