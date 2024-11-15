const std = @import("std");
// const system_data = @import("system_data.zig");
// const erd = system_data.erd;

pub fn main() !void {
    // const stdout_file = std.io.getStdOut().writer();
    // var bw = std.io.bufferedWriter(stdout_file);
    // const stdout = bw.writer();

    // try stdout.print("Data Model Init\n", .{});
    // var data_model = system_data.init();

    // try stdout.print("Data Model Read\n", .{});
    // const applicationVersion = data_model.read(erd.applicationVersion); // Type should be inferred as u32
    // try stdout.print("Application Version: {x}\n", .{applicationVersion});

    // try stdout.print("\n");

    // try stdout.print("Data Model Write\n", .{});
    // const newApplicationVersion = 0x12345678;
    // data_model.write(erd.applicationVersion, newApplicationVersion);
    // try stdout.print("New Application Version: {x}\n", .{applicationVersion});

    // try bw.flush(); // don't forget to flush!
}
