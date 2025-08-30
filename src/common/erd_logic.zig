//! This module supports multiple different operations on ERDs of the same type
//!
//! Each instance of this creates its own `init` and `on_change` functions
//! and also takes `n * @sizeof(Subscription) = 8n/16n` bytes of RAM.
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
    _not,
    _bitwise_and,
    _bitwise_or,
    _bitwise_nor,
    _bitwise_xor,
    _bitwise_not,
};

// TODO: Should this really be this generic? It probably leads to a lot of code bloat. I'd much prefer
// this to use the same machine code for all instances (or at least one set for the unary operators, and one set for binary operators).
/// Constructs an ErdLogic type
pub fn ErdLogic(comptime operator: ErdLogicOperator, comptime erds: []const SystemErds.ErdEnum, outputErd: SystemErds.ErdEnum) type {
    comptime {
        switch (operator) {
            ._bitwise_not, ._not => std.debug.assert(erds.len == 1), // Unary operators
            else => std.debug.assert(erds.len > 1), // Binary operators that reduce
        }

        if (erds.len > 1) {
            var window = std.mem.window(SystemErds.ErdEnum, erds, 2, 1);
            while (window.next()) |erd_pair| {
                std.debug.assert(SystemErds.erd_from_enum(erd_pair[0]).T == SystemErds.erd_from_enum(erd_pair[1]).T);
            }
        }

        std.debug.assert(SystemErds.erd_from_enum(erds[0]).T == SystemErds.erd_from_enum(outputErd).T);
    }

    return struct {
        // TODO: Utilize args here to improve the code
        fn on_change(_: ?*anyopaque, _: ?*const SystemData.OnChangeArgs, system_data: *SystemData) void {
            if (erds.len == 1) {
                const value = system_data.read(erds[0]);
                const output = switch (operator) {
                    ._bitwise_not => ~value,
                    ._not => !value,
                    else => comptime unreachable,
                };

                system_data.write(outputErd, output);
            } else if (erds.len > 1) {
                var value = system_data.read(erds[0]);

                inline for (erds[1..]) |erd| {
                    const next = system_data.read(erd);

                    value = switch (operator) {
                        ._and => value and next,
                        ._or => value or next,
                        ._nor => !(value or next),
                        ._xor => (!value and next) or (value and !next), // TODO: `value != next` ?
                        ._bitwise_and => value & next,
                        ._bitwise_or => value | next,
                        ._bitwise_nor => ~(value | next),
                        ._bitwise_xor => (~value & next) | (value & ~next),
                        else => comptime unreachable,
                    };
                }

                system_data.write(outputErd, value);
            }
        }

        fn init(system_data: *SystemData) void {
            inline for (erds) |erd| {
                system_data.subscribe(erd, null, on_change);
            }

            on_change(null, null, system_data);
        }
    };
}

test "can _bitwise_and" {
    var system_data: SystemData = .init();

    const input_erds = &[_]SystemErds.ErdEnum{ .erd_unaligned_u16, .erd_cool_u16 };
    ErdLogic(._bitwise_and, input_erds, .erd_best_u16).init(&system_data);

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

test "unary operators work" {
    var system_data: SystemData = .init();

    ErdLogic(._bitwise_not, &[_]SystemErds.ErdEnum{.erd_cool_u16}, .erd_best_u16).init(&system_data);

    system_data.write(.erd_cool_u16, 0x1F7F);
    try std.testing.expectEqual(0b1110_0000_1000_0000, system_data.read(.erd_best_u16));
}

// TODO: Finish the rest of the tests when there's a way to create testing (locally scoped) ERDs
