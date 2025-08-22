const std = @import("std");
const SystemErds = @import("system_erds.zig");

pub fn generate_erd_json(writer: *std.io.Writer) !void {
    var write_stream: std.json.Stringify = .{
        .writer = writer,
        .options = .{ .whitespace = .indent_4 },
    };
    try write_stream.write(SystemErds.erd);
}
