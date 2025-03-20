const std = @import("std");
const SystemErds = @import("system_erds.zig");

pub fn generate_erd_json(allocator: std.mem.Allocator) ![]u8 {
    const string = try std.json.stringifyAlloc(
        allocator,
        SystemErds.erd,
        .{ .whitespace = .indent_4 },
    );
    return string;
}
