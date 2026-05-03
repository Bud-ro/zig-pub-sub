const std = @import("std");
const constraints = @import("data_gen").constraints;

test "inRange accepts values within bounds" {
    comptime {
        if (constraints.inRange(10, 100, 10)) |err| @compileError(err);
        if (constraints.inRange(10, 100, 50)) |err| @compileError(err);
        if (constraints.inRange(10, 100, 100)) |err| @compileError(err);
        if (constraints.inRange(-100, 100, -100)) |err| @compileError(err);
        if (constraints.inRange(-100, 100, 0)) |err| @compileError(err);
        if (constraints.inRange(-100, 100, 100)) |err| @compileError(err);
    }
}

test "isInRange returns correct bool" {
    comptime {
        try std.testing.expect(constraints.isInRange(0, 10, 5));
        try std.testing.expect(constraints.isInRange(0, 10, 0));
        try std.testing.expect(constraints.isInRange(0, 10, 10));
        try std.testing.expect(!constraints.isInRange(0, 10, 11));
        try std.testing.expect(!constraints.isInRange(-5, 5, -6));
    }
}

test "oneOf accepts allowed values" {
    comptime {
        if (constraints.oneOf(&.{ 100, 200, 500, 1000 }, 200)) |err| @compileError(err);
        if (constraints.oneOf(&.{ 100, 200, 500, 1000 }, 1000)) |err| @compileError(err);
    }
}

test "isOneOf returns correct bool" {
    comptime {
        try std.testing.expect(constraints.isOneOf(&.{ 1, 2, 3 }, 2));
        try std.testing.expect(!constraints.isOneOf(&.{ 1, 2, 3 }, 4));
    }
}

test "exactLen passes on correct length" {
    comptime {
        if (constraints.exactLen(4, 4)) |err| @compileError(err);
        if (constraints.exactLen(0, 0)) |err| @compileError(err);
        if (constraints.exactLen(256, 256)) |err| @compileError(err);
    }
}

test "lenInRange passes within bounds" {
    comptime {
        if (constraints.lenInRange(2, 256, 2)) |err| @compileError(err);
        if (constraints.lenInRange(2, 256, 128)) |err| @compileError(err);
        if (constraints.lenInRange(2, 256, 256)) |err| @compileError(err);
    }
}

test "isSorted passes on sorted array" {
    comptime {
        if (constraints.isSorted(i16, &.{ -10, 0, 5, 100 })) |err| @compileError(err);
        if (constraints.isSorted(u32, &.{ 1, 2, 3, 4, 5 })) |err| @compileError(err);
        if (constraints.isSorted(u8, &.{42})) |err| @compileError(err);
        if (constraints.isSorted(u8, &.{})) |err| @compileError(err);
    }
}

test "noDuplicates passes on unique array" {
    comptime {
        if (constraints.noDuplicates(u32, &.{ 1, 2, 3, 4, 5 })) |err| @compileError(err);
        if (constraints.noDuplicates(i8, &.{ -1, 0, 1 })) |err| @compileError(err);
        if (constraints.noDuplicates(u8, &.{42})) |err| @compileError(err);
        if (constraints.noDuplicates(u8, &.{})) |err| @compileError(err);
    }
}

test "isPowerOfTwo passes on powers of two" {
    comptime {
        if (constraints.isPowerOfTwo(1)) |err| @compileError(err);
        if (constraints.isPowerOfTwo(2)) |err| @compileError(err);
        if (constraints.isPowerOfTwo(4)) |err| @compileError(err);
        if (constraints.isPowerOfTwo(256)) |err| @compileError(err);
        if (constraints.isPowerOfTwo(1024)) |err| @compileError(err);
    }
}

test "isMultipleOf passes on valid multiples" {
    comptime {
        if (constraints.isMultipleOf(4, 8)) |err| @compileError(err);
        if (constraints.isMultipleOf(4, 16)) |err| @compileError(err);
        if (constraints.isMultipleOf(10, 100)) |err| @compileError(err);
        if (constraints.isMultipleOf(1, 7)) |err| @compileError(err);
    }
}

test "nonZero passes on non-zero values" {
    comptime {
        if (constraints.nonZero(1)) |err| @compileError(err);
        if (constraints.nonZero(42)) |err| @compileError(err);
        if (constraints.nonZero(-1)) |err| @compileError(err);
    }
}

test "anyOf passes when at least one is true" {
    comptime {
        if (constraints.anyOf(&.{ false, true, false })) |err| @compileError(err);
        if (constraints.anyOf(&.{ true, false })) |err| @compileError(err);
        if (constraints.anyOf(&.{true})) |err| @compileError(err);
    }
}

test "lessThan passes for strictly less values" {
    comptime {
        if (constraints.lessThan(5, 10)) |err| @compileError(err);
        if (constraints.lessThan(-10, 0)) |err| @compileError(err);
    }
}

test "greaterThan passes for strictly greater values" {
    comptime {
        if (constraints.greaterThan(10, 5)) |err| @compileError(err);
        if (constraints.greaterThan(0, -10)) |err| @compileError(err);
    }
}

test "sumAtMost passes when sum is within budget" {
    comptime {
        if (constraints.sumAtMost(u32, &.{ 10, 20, 30 }, 100)) |err| @compileError(err);
        if (constraints.sumAtMost(u32, &.{ 10, 20, 30 }, 60)) |err| @compileError(err);
        if (constraints.sumAtMost(u16, &.{0}, 0)) |err| @compileError(err);
    }
}

test "sumEquals passes when sum matches target" {
    comptime {
        if (constraints.sumEquals(u32, &.{ 25, 25, 50 }, 100)) |err| @compileError(err);
        if (constraints.sumEquals(u16, &.{ 10, 20, 30, 40 }, 100)) |err| @compileError(err);
    }
}

test "allElements passes when all elements satisfy check" {
    const checkPositive = struct {
        fn f(comptime v: i32) ?[]const u8 {
            if (v <= 0) return "must be positive";
            return null;
        }
    }.f;

    comptime {
        if (constraints.allElements(i32, &.{ 1, 2, 3, 100 }, checkPositive)) |err| @compileError(err);
    }
}

test "anyOf with isInRange for OR composition" {
    comptime {
        const value: u32 = 95;
        if (constraints.anyOf(&.{
            constraints.isInRange(0, 10, value),
            constraints.isInRange(90, 100, value),
        })) |err| @compileError(err);
    }
}
