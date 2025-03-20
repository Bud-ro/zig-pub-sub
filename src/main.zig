const std = @import("std");
const SystemData = @import("system_data.zig");
const SystemErds = @import("system_erds.zig");
const ErdJson = @import("erd_json.zig");

pub fn main() !void {
    const max_json_size = comptime std.fmt.parseIntSizeSuffix("1MiB", 10) catch unreachable;
    var buf: [max_json_size]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buf);
    const json_string = try ErdJson.generate_erd_json(fba.allocator());
    std.log.debug("System Erds as JSON Object:\n{s}", .{json_string});
}
