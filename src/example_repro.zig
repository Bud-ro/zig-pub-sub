const std = @import("std");

const Erd = struct {
    T: type,
    owner: ErdOwner,

    pub const ErdOwner = enum {
        Ram,
        Indirect,
    };
};

pub const ErdDefinitions = struct {
    // zig fmt: off
    application_version:  Erd = .{ .T = u32,   .owner = .Ram      },
    some_bool:            Erd = .{ .T = bool,  .owner = .Ram      },
    unaligned_u16:        Erd = .{ .T = u16,   .owner = .Ram      },
    always_42:            Erd = .{ .T = u16,   .owner = .Indirect },
    pointer_to_something: Erd = .{ .T = ?*u16, .owner = .Ram      },
    another_erd_plus_one: Erd = .{ .T = u16,   .owner = .Indirect },
    // zig fmt: on
};

const erds = ErdDefinitions{};

pub export fn main() void {
    std.log.err("some_bool has type {}", .{erds.some_bool.T});
}
