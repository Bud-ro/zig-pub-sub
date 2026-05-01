const std = @import("std");
const generators = @import("data_gen").generators;

test "generateArray produces correct values" {
    const doubler = struct {
        fn f(comptime i: usize) u32 {
            return @intCast(i * 2);
        }
    }.f;

    comptime {
        const arr = generators.generateArray(u32, 5, doubler);
        try std.testing.expectEqual(5, arr.len);
        try std.testing.expectEqual(0, arr[0]);
        try std.testing.expectEqual(2, arr[1]);
        try std.testing.expectEqual(8, arr[4]);
    }
}

test "repeated produces N identical values" {
    comptime {
        const arr = generators.repeated(u8, 42, 4);
        try std.testing.expectEqual(4, arr.len);
        for (arr) |v| {
            try std.testing.expectEqual(42, v);
        }
    }
}

test "unfold generates sequence from seed" {
    const doubleStep = struct {
        fn f(comptime prev: u32, comptime _: usize) u32 {
            return prev * 2;
        }
    }.f;

    comptime {
        const arr = generators.unfold(u32, 5, 1, doubleStep);
        try std.testing.expectEqual(1, arr[0]);
        try std.testing.expectEqual(2, arr[1]);
        try std.testing.expectEqual(4, arr[2]);
        try std.testing.expectEqual(8, arr[3]);
        try std.testing.expectEqual(16, arr[4]);
    }
}

test "lookupTable generates input-output pairs" {
    const square = struct {
        fn f(comptime x: i32) i32 {
            return x * x;
        }
    }.f;

    comptime {
        const table = generators.lookupTable(i32, i32, 0, 4, 1, square);
        try std.testing.expectEqual(5, table.len);
        try std.testing.expectEqual(0, table[0].input);
        try std.testing.expectEqual(0, table[0].output);
        try std.testing.expectEqual(2, table[2].input);
        try std.testing.expectEqual(4, table[2].output);
        try std.testing.expectEqual(4, table[4].input);
        try std.testing.expectEqual(16, table[4].output);
    }
}

test "validatedSequence validates and returns" {
    const Step = struct { value: u32 };
    const checkAscending = struct {
        fn f(comptime step: Step, comptime _: usize) void {
            if (step.value > 100) @compileError("too large");
        }
    }.f;

    comptime {
        const steps = generators.validatedSequence(Step, &.{
            .{ .value = 10 },
            .{ .value = 20 },
            .{ .value = 50 },
        }, checkAscending);
        try std.testing.expectEqual(3, steps.len);
        try std.testing.expectEqual(10, steps[0].value);
    }
}

test "linearMap generates evenly spaced values" {
    comptime {
        const arr = generators.linearMap(i32, 5, 0, 100);
        try std.testing.expectEqual(0, arr[0]);
        try std.testing.expectEqual(25, arr[1]);
        try std.testing.expectEqual(50, arr[2]);
        try std.testing.expectEqual(75, arr[3]);
        try std.testing.expectEqual(100, arr[4]);
    }
}
