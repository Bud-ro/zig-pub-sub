const std = @import("std");
const SystemErds = @import("system_erds.zig");

pub fn generate_erd_json(allocator: std.mem.Allocator) ![]u8 {
    // const erd_names = comptime std.meta.fieldNames(SystemErds.ErdDefinitions);
    // inline for (erd_names, 0..) |erd_name, i| {
    //     if (@field(SystemErds.erd, erd_name).erd_number) |erd_number| {
    //         _ = erd_number;
    //         try std.json.string
    //     }
    // }

    const string = try std.json.stringifyAlloc(
        allocator,
        SystemErds.erd,
        .{ .whitespace = .indent_4 },
    );
    return string;
}
