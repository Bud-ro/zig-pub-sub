//! This module supports multiple different operations on ERDs of the same size:
//! - ._and:  Erd1 &&  Erd2 => Erd3
//! - ._or:   Erd1 ||  Erd2 => Erd3
//! - ._nor: !Erd1 && !Erd2 => Erd3
//! - ._xor:  Erd1 && !Erd2 || !Erd1 && Erd2 => Erd3
//!
//! And their bitwise counterparts:
//! - ._bitwise_and:  Erd1 &  Erd2 => Erd3
//! - ._bitwise_or:   Erd1 |  Erd2 => Erd3
//! - ._bitwise_nor: !Erd1 & !Erd2 => Erd3
//! - ._bitwise_xor:  Erd1 & !Erd2 | !Erd1 & Erd2 => Erd3
//!
//! Each instance of this creates its own `init` and `on_change` functions
//! and also takes `2 * @sizeof(Subscription) = 16/32` bytes of RAM.
//! As an upside, comptime read/writes are performed and the operator is comptime known so
//! there is an O(0) lookup.
//! TODO: For a version of this that is less intense on code size, use RuntimeErdLogic

const std = @import("std");
const SystemData = @import("../system_data.zig");
const SystemErds = @import("../system_erds.zig");
const Subscription = @import("../subscription.zig");
const Erd = @import("../erd.zig");

const ErdLogicOperator = enum {
    _and,
    _or,
    _nor,
    _xor,
    _bitwise_and,
    _bitwise_or,
    _bitwise_nor,
    _bitwise_xor,
};

pub fn ErdLogic(operator: ErdLogicOperator, erd1: SystemErds.ErdEnum, erd2: SystemErds.ErdEnum, outputErd: SystemErds.ErdEnum) type {
    comptime {
        std.debug.assert(SystemErds.erd_from_enum(erd1).T == SystemErds.erd_from_enum(erd2).T);
        std.debug.assert(SystemErds.erd_from_enum(erd2).T == SystemErds.erd_from_enum(outputErd).T);
    }

    return struct {
        fn on_change(_: ?*anyopaque, _: ?*const anyopaque, system_data: *SystemData) void {
            const val1 = system_data.read(erd1);
            const val2 = system_data.read(erd2);

            const output = switch (comptime operator) {
                ._and => val1 and val2,
                ._or => val1 or val2,
                ._nor => !(val1 or val2),
                ._xor => (!val1 and val2) or (val1 and !val2),
                ._bitwise_and => val1 & val2,
                ._bitwise_or => val1 | val2,
                ._bitwise_nor => ~(val1 | val2),
                ._bitwise_xor => (~val1 & val2) | (val1 & ~val2),
            };

            system_data.write(outputErd, output);
        }

        fn init(system_data: *SystemData) void {
            system_data.subscribe(erd1, null, on_change);
            system_data.subscribe(erd2, null, on_change);

            on_change(null, null, system_data);
        }
    };
}

test "can _bitwise_and" {
    var system_data: SystemData = .init();
    ErdLogic(._bitwise_and, .erd_unaligned_u16, .erd_cool_u16, .erd_best_u16).init(&system_data);

    try std.testing.expectEqual(0, system_data.read(.erd_best_u16));
    // Can't do anything about this without an extra subscription
    // it's up to the programmer to not write to "output" ERDs:
    system_data.write(.erd_best_u16, 1337);
    try std.testing.expectEqual(1337, system_data.read(.erd_best_u16));

    system_data.write(.erd_unaligned_u16, 0b01010101);
    system_data.write(.erd_cool_u16, 0b10101010);
    try std.testing.expectEqual(0, system_data.read(.erd_best_u16));

    system_data.write(.erd_unaligned_u16, 0b00001010);
    try std.testing.expectEqual(0b1010, system_data.read(.erd_best_u16));

    system_data.write(.erd_unaligned_u16, 0b10100000);
    try std.testing.expectEqual(0b10100000, system_data.read(.erd_best_u16));

    system_data.write(.erd_unaligned_u16, 0xFF);
    try std.testing.expectEqual(system_data.read(.erd_cool_u16), system_data.read(.erd_best_u16));
}

// TODO: Finish the rest of the tests when there's a way to create testing (locally scoped) ERDs
