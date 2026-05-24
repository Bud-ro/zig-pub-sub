//! This module supports multiple different operations on ERDs of the same type
//!
//! Each instance of this creates its own `init` and `onChange` functions
//! and also takes `n * @sizeof(Subscription) = 8n/16n` bytes of RAM.
//! As an upside, comptime read/writes are performed and the operator is comptime known so
//! there is an O(0) lookup.

const std = @import("std");

const ErdLogicOperator = enum {
    _and,
    _or,
    _xor,
    _not,
    _bitwise_and,
    _bitwise_or,
    _bitwise_xor,
    _bitwise_not,
};

// TODO: Should this really be this generic? It probably leads to a lot of code bloat. I'd much prefer
// this to use the same machine code for all instances (or at least one set for the unary operators, and one set for binary operators).
/// Constructs an ErdLogic type
pub fn ErdLogic(SystemDataType: type, comptime operator: ErdLogicOperator, comptime erds: []const SystemDataType.ErdEnumType, outputErd: SystemDataType.ErdEnumType) type {
    comptime {
        switch (operator) {
            ._bitwise_not, ._not => if (erds.len != 1) @compileError(std.fmt.comptimePrint(
                "ErdLogic.{s}: unary operator requires exactly 1 input ERD, got {}",
                .{ @tagName(operator), erds.len },
            )),
            else => if (erds.len < 2) @compileError(std.fmt.comptimePrint(
                "ErdLogic.{s}: binary/reducing operator requires at least 2 input ERDs, got {}",
                .{ @tagName(operator), erds.len },
            )),
        }

        if (erds.len > 1) {
            var window = std.mem.window(SystemDataType.ErdEnumType, erds, 2, 1);
            while (window.next()) |erd_pair| {
                const T0 = SystemDataType.erdFromEnum(erd_pair[0]).T;
                const T1 = SystemDataType.erdFromEnum(erd_pair[1]).T;
                if (T0 != T1) @compileError(std.fmt.comptimePrint(
                    "ErdLogic.{s}: input ERD {s} has type {s}, but {s} has type {s} (all inputs must share a type)",
                    .{ @tagName(operator), @tagName(erd_pair[0]), @typeName(T0), @tagName(erd_pair[1]), @typeName(T1) },
                ));
            }
        }

        const InputT = SystemDataType.erdFromEnum(erds[0]).T;
        const OutputT = SystemDataType.erdFromEnum(outputErd).T;
        if (InputT != OutputT) @compileError(std.fmt.comptimePrint(
            "ErdLogic.{s}: input type {s} does not match output {s} type {s}",
            .{ @tagName(operator), @typeName(InputT), @tagName(outputErd), @typeName(OutputT) },
        ));
    }

    return struct {
        // TODO: Utilize args here to improve the code
        fn onChange(_: ?*anyopaque, _: ?*const anyopaque, publisher: *anyopaque) void {
            const system_data: *SystemDataType = @ptrCast(@alignCast(publisher));

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
                        ._xor => value != next,
                        ._bitwise_and => value & next,
                        ._bitwise_or => value | next,
                        ._bitwise_xor => value ^ next,
                        else => comptime unreachable,
                    };
                }

                system_data.write(outputErd, value);
            }
        }

        fn init(system_data: *SystemDataType) void {
            inline for (erds) |erd| {
                system_data.subscribe(erd, null, onChange);
            }

            onChange(null, null, system_data);
        }
    };
}

const erd_core = @import("erd_core");
const Erd = erd_core.Erd;
const SystemDataTestDouble = erd_core.testing.SystemDataTestDouble;

const TestSystem = SystemDataTestDouble.create(struct {
    input_a: Erd = SystemDataTestDouble.ramErd(u16, .{ .subs = 1 }),
    input_b: Erd = SystemDataTestDouble.ramErd(u16, .{ .subs = 1 }),
    output: Erd = SystemDataTestDouble.ramErd(u16, .{}),
});
const SystemData = TestSystem.SystemData;
const ErdEnum = SystemData.ErdEnumType;

test "can _bitwise_and" {
    var system_data: SystemData = TestSystem.init();

    const input_erds = &[_]ErdEnum{ .input_a, .input_b };
    ErdLogic(SystemData, ._bitwise_and, input_erds, .output).init(&system_data);

    try std.testing.expectEqual(0, system_data.read(.output));
    // Can't do anything about this without an extra subscription
    // it's up to the programmer to not write to "output" ERDs:
    system_data.write(.output, 1337);
    try std.testing.expectEqual(1337, system_data.read(.output));

    system_data.write(.input_a, 0b01010101);
    system_data.write(.input_b, 0b10101010);
    try std.testing.expectEqual(0, system_data.read(.output));

    system_data.write(.input_a, 0b00001010);
    try std.testing.expectEqual(0b1010, system_data.read(.output));

    system_data.write(.input_a, 0b10100000);
    try std.testing.expectEqual(0b10100000, system_data.read(.output));

    system_data.write(.input_a, 0xFF);
    try std.testing.expectEqual(system_data.read(.input_b), system_data.read(.output));
}

test "unary operators work" {
    var system_data: SystemData = TestSystem.init();

    ErdLogic(SystemData, ._bitwise_not, &[_]ErdEnum{.input_a}, .output).init(&system_data);

    system_data.write(.input_a, 0x1F7F);
    try std.testing.expectEqual(0b1110_0000_1000_0000, system_data.read(.output));
}

test "_bitwise_or combines bits from both inputs" {
    var system_data: SystemData = TestSystem.init();

    const input_erds = &[_]ErdEnum{ .input_a, .input_b };
    ErdLogic(SystemData, ._bitwise_or, input_erds, .output).init(&system_data);

    system_data.write(.input_a, 0b0101_0101);
    system_data.write(.input_b, 0b1010_1010);
    try std.testing.expectEqual(0b1111_1111, system_data.read(.output));

    system_data.write(.input_a, 0xF0F0);
    system_data.write(.input_b, 0x0F0F);
    try std.testing.expectEqual(0xFFFF, system_data.read(.output));
}

test "_bitwise_xor toggles differing bits" {
    var system_data: SystemData = TestSystem.init();

    const input_erds = &[_]ErdEnum{ .input_a, .input_b };
    ErdLogic(SystemData, ._bitwise_xor, input_erds, .output).init(&system_data);

    system_data.write(.input_a, 0b1100_1100);
    system_data.write(.input_b, 0b1010_1010);
    try std.testing.expectEqual(0b0110_0110, system_data.read(.output));

    system_data.write(.input_a, 0xABCD);
    system_data.write(.input_b, 0xABCD);
    try std.testing.expectEqual(0, system_data.read(.output));
}

const BoolTestSystem = SystemDataTestDouble.create(struct {
    input_a: Erd = SystemDataTestDouble.ramErd(bool, .{ .subs = 1 }),
    input_b: Erd = SystemDataTestDouble.ramErd(bool, .{ .subs = 1 }),
    output: Erd = SystemDataTestDouble.ramErd(bool, .{}),
});
const BoolSystemData = BoolTestSystem.SystemData;
const BoolErdEnum = BoolSystemData.ErdEnumType;

test "_and is true only when all inputs are true" {
    var system_data: BoolSystemData = BoolTestSystem.init();

    const inputs = &[_]BoolErdEnum{ .input_a, .input_b };
    ErdLogic(BoolSystemData, ._and, inputs, .output).init(&system_data);

    try std.testing.expectEqual(false, system_data.read(.output));
    system_data.write(.input_a, true);
    try std.testing.expectEqual(false, system_data.read(.output));
    system_data.write(.input_b, true);
    try std.testing.expectEqual(true, system_data.read(.output));
}

test "_or is true when any input is true" {
    var system_data: BoolSystemData = BoolTestSystem.init();

    const inputs = &[_]BoolErdEnum{ .input_a, .input_b };
    ErdLogic(BoolSystemData, ._or, inputs, .output).init(&system_data);

    try std.testing.expectEqual(false, system_data.read(.output));
    system_data.write(.input_a, true);
    try std.testing.expectEqual(true, system_data.read(.output));
    system_data.write(.input_a, false);
    system_data.write(.input_b, true);
    try std.testing.expectEqual(true, system_data.read(.output));
}

test "_xor on bools" {
    var system_data: BoolSystemData = BoolTestSystem.init();
    const inputs = &[_]BoolErdEnum{ .input_a, .input_b };
    ErdLogic(BoolSystemData, ._xor, inputs, .output).init(&system_data);

    system_data.write(.input_a, true);
    system_data.write(.input_b, false);
    try std.testing.expectEqual(true, system_data.read(.output));
    system_data.write(.input_b, true);
    try std.testing.expectEqual(false, system_data.read(.output));
}

test "_not inverts the boolean input" {
    var system_data: BoolSystemData = BoolTestSystem.init();
    ErdLogic(BoolSystemData, ._not, &[_]BoolErdEnum{.input_a}, .output).init(&system_data);

    try std.testing.expectEqual(true, system_data.read(.output));
    system_data.write(.input_a, true);
    try std.testing.expectEqual(false, system_data.read(.output));
}
