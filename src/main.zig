const std = @import("std");
const SystemData = @import("system_data.zig");
const SystemErds = @import("system_erds.zig");
const ErdJson = @import("erd_json.zig");

pub fn main() !void {
    const max_json_size = comptime std.fmt.parseIntSizeSuffix("1MiB", 10) catch unreachable;
    var buf: [max_json_size]u8 = undefined;

    var out = std.io.Writer.fixed(&buf);
    try ErdJson.generate_erd_json(&out);
    std.log.debug("System Erds as JSON Object:\n{s}", .{out.buffered()});
}
