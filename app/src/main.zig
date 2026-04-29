const std = @import("std");
const erd_schema = @import("erd_schema");
const SystemErds = @import("system_erds.zig");

pub fn main() !void {
    const max_json_size = comptime std.fmt.parseIntSizeSuffix("1MiB", 10) catch unreachable;
    var buf: [max_json_size]u8 = undefined;

    var out = std.io.Writer.fixed(&buf);
    try erd_schema.json.generate(SystemErds.ErdDefinitions, SystemErds.erd, &out, .{});
    std.log.debug("System Erds as JSON Object:\n{s}", .{out.buffered()});
}
