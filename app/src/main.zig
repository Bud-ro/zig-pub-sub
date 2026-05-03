const erd_schema = @import("erd_schema");
const std = @import("std");
const system_erds = @import("system_erds.zig");

/// Application entry point that dumps ERD definitions as JSON.
// zlinter-disable-next-line no_inferred_error_unions
pub fn main() !void {
    const max_json_size = comptime std.fmt.parseIntSizeSuffix("1MiB", 10) catch unreachable; // zlinter-disable-current-line no_swallow_error
    var buf: [max_json_size]u8 = undefined;

    var out = std.io.Writer.fixed(&buf);
    try erd_schema.json.generate(system_erds.erd, &out, .{});
    std.log.debug("System Erds as JSON Object:\n{s}", .{out.buffered()});
}
