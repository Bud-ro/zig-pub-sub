const std = @import("std");
const SystemData = @import("system_data.zig");
const SystemErds = @import("system_erds.zig");
const ErdJson = @import("erd_json.zig");

pub fn main() !void {
    const max_json_size = comptime std.fmt.parseIntSizeSuffix("1MiB", 10) catch unreachable;
    var buf: [max_json_size]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buf);

    var out: std.io.Writer.Allocating = .init(fba.allocator());
    defer out.deinit();
    try ErdJson.generate_erd_json(&out.writer);
    std.log.debug("System Erds as JSON Object:\n{s}", .{out.writer.buffered()});
}
