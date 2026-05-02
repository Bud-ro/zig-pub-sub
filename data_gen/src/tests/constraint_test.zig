const std = @import("std");
const constraints = @import("data_gen").constraints;

test "inRange accepts values within bounds" {
    comptime {
        constraints.assert(constraints.inRange(10, 100, 10));
        constraints.assert(constraints.inRange(10, 100, 50));
        constraints.assert(constraints.inRange(10, 100, 100));
        constraints.assert(constraints.inRange(-100, 100, -100));
        constraints.assert(constraints.inRange(-100, 100, 0));
        constraints.assert(constraints.inRange(-100, 100, 100));
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
        constraints.assert(constraints.oneOf(&.{ 100, 200, 500, 1000 }, 200));
        constraints.assert(constraints.oneOf(&.{ 100, 200, 500, 1000 }, 1000));
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
        constraints.assert(constraints.exactLen(4, 4));
        constraints.assert(constraints.exactLen(0, 0));
        constraints.assert(constraints.exactLen(256, 256));
    }
}

test "lenInRange passes within bounds" {
    comptime {
        constraints.assert(constraints.lenInRange(2, 256, 2));
        constraints.assert(constraints.lenInRange(2, 256, 128));
        constraints.assert(constraints.lenInRange(2, 256, 256));
    }
}

test "isSorted passes on sorted array" {
    comptime {
        constraints.assert(constraints.isSorted(i16, &.{ -10, 0, 5, 100 }));
        constraints.assert(constraints.isSorted(u32, &.{ 1, 2, 3, 4, 5 }));
        constraints.assert(constraints.isSorted(u8, &.{42}));
        constraints.assert(constraints.isSorted(u8, &.{}));
    }
}

test "noDuplicates passes on unique array" {
    comptime {
        constraints.assert(constraints.noDuplicates(u32, &.{ 1, 2, 3, 4, 5 }));
        constraints.assert(constraints.noDuplicates(i8, &.{ -1, 0, 1 }));
        constraints.assert(constraints.noDuplicates(u8, &.{42}));
        constraints.assert(constraints.noDuplicates(u8, &.{}));
    }
}

test "isPowerOfTwo passes on powers of two" {
    comptime {
        constraints.assert(constraints.isPowerOfTwo(1));
        constraints.assert(constraints.isPowerOfTwo(2));
        constraints.assert(constraints.isPowerOfTwo(4));
        constraints.assert(constraints.isPowerOfTwo(256));
        constraints.assert(constraints.isPowerOfTwo(1024));
    }
}

test "isMultipleOf passes on valid multiples" {
    comptime {
        constraints.assert(constraints.isMultipleOf(4, 8));
        constraints.assert(constraints.isMultipleOf(4, 16));
        constraints.assert(constraints.isMultipleOf(10, 100));
        constraints.assert(constraints.isMultipleOf(1, 7));
    }
}

test "nonZero passes on non-zero values" {
    comptime {
        constraints.assert(constraints.nonZero(1));
        constraints.assert(constraints.nonZero(42));
        constraints.assert(constraints.nonZero(-1));
    }
}

test "anyOf passes when at least one is true" {
    comptime {
        constraints.assert(constraints.anyOf(&.{ false, true, false }));
        constraints.assert(constraints.anyOf(&.{ true, false }));
        constraints.assert(constraints.anyOf(&.{true}));
    }
}

test "lessThan passes for strictly less values" {
    comptime {
        constraints.assert(constraints.lessThan(5, 10));
        constraints.assert(constraints.lessThan(-10, 0));
    }
}

test "greaterThan passes for strictly greater values" {
    comptime {
        constraints.assert(constraints.greaterThan(10, 5));
        constraints.assert(constraints.greaterThan(0, -10));
    }
}

test "sumAtMost passes when sum is within budget" {
    comptime {
        constraints.assert(constraints.sumAtMost(u32, &.{ 10, 20, 30 }, 100));
        constraints.assert(constraints.sumAtMost(u32, &.{ 10, 20, 30 }, 60));
        constraints.assert(constraints.sumAtMost(u16, &.{0}, 0));
    }
}

test "sumEquals passes when sum matches target" {
    comptime {
        constraints.assert(constraints.sumEquals(u32, &.{ 25, 25, 50 }, 100));
        constraints.assert(constraints.sumEquals(u16, &.{ 10, 20, 30, 40 }, 100));
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
        constraints.assert(constraints.allElements(i32, &.{ 1, 2, 3, 100 }, checkPositive));
    }
}

test "anyOf with isInRange for OR composition" {
    comptime {
        const value: u32 = 95;
        constraints.assert(constraints.anyOf(&.{
            constraints.isInRange(0, 10, value),
            constraints.isInRange(90, 100, value),
        }));
    }
}
