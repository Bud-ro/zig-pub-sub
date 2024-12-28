const std = @import("std");

const Erd = struct {
    T: type,
    subs: comptime_int,
};

pub const ErdDefinitions = struct {
    // zig fmt: off
    application_version:  Erd = .{ .T = u32,   .subs = 0 },
    some_bool:            Erd = .{ .T = bool,  .subs = 3 },
    unaligned_u16:        Erd = .{ .T = u16,   .subs = 1 },
    always_42:            Erd = .{ .T = u16,   .subs = 0 },
    pointer_to_something: Erd = .{ .T = ?*u16, .subs = 0 },
    another_erd_plus_one: Erd = .{ .T = u16,   .subs = 0 },
    // zig fmt: on
};

const erds = ErdDefinitions{};

pub fn main() void {
    std.log.err("some_bool has {} subs", .{erds.some_bool.subs});
}
