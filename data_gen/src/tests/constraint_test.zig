const std = @import("std");
const constraints = @import("data_gen").constraints;

test "inRange accepts values within bounds" {
    comptime {
        constraints.inRange(u32, 10, 100, 10);
        constraints.inRange(u32, 10, 100, 50);
        constraints.inRange(u32, 10, 100, 100);
        constraints.inRange(i16, -100, 100, -100);
        constraints.inRange(i16, -100, 100, 0);
        constraints.inRange(i16, -100, 100, 100);
    }
}

test "isInRange returns correct bool" {
    comptime {
        try std.testing.expect(constraints.isInRange(u32, 0, 10, 5));
        try std.testing.expect(constraints.isInRange(u32, 0, 10, 0));
        try std.testing.expect(constraints.isInRange(u32, 0, 10, 10));
        try std.testing.expect(!constraints.isInRange(u32, 0, 10, 11));
        try std.testing.expect(!constraints.isInRange(i8, -5, 5, -6));
    }
}

test "oneOf accepts allowed values" {
    comptime {
        constraints.oneOf(u32, &.{ 100, 200, 500, 1000 }, 200);
        constraints.oneOf(u32, &.{ 100, 200, 500, 1000 }, 1000);
    }
}

test "isOneOf returns correct bool" {
    comptime {
        try std.testing.expect(constraints.isOneOf(u8, &.{ 1, 2, 3 }, 2));
        try std.testing.expect(!constraints.isOneOf(u8, &.{ 1, 2, 3 }, 4));
    }
}

test "exactLen passes on correct length" {
    comptime {
        constraints.exactLen(4, 4);
        constraints.exactLen(0, 0);
        constraints.exactLen(256, 256);
    }
}

test "lenInRange passes within bounds" {
    comptime {
        constraints.lenInRange(2, 256, 2);
        constraints.lenInRange(2, 256, 128);
        constraints.lenInRange(2, 256, 256);
    }
}

test "isSorted passes on sorted array" {
    comptime {
        constraints.isSorted(i16, &.{ -10, 0, 5, 100 });
        constraints.isSorted(u32, &.{ 1, 2, 3, 4, 5 });
        constraints.isSorted(u8, &.{42});
        constraints.isSorted(u8, &.{});
    }
}

test "noDuplicates passes on unique array" {
    comptime {
        constraints.noDuplicates(u32, &.{ 1, 2, 3, 4, 5 });
        constraints.noDuplicates(i8, &.{ -1, 0, 1 });
        constraints.noDuplicates(u8, &.{42});
        constraints.noDuplicates(u8, &.{});
    }
}

test "isPowerOfTwo passes on powers of two" {
    comptime {
        constraints.isPowerOfTwo(1);
        constraints.isPowerOfTwo(2);
        constraints.isPowerOfTwo(4);
        constraints.isPowerOfTwo(256);
        constraints.isPowerOfTwo(1024);
    }
}

test "isMultipleOf passes on valid multiples" {
    comptime {
        constraints.isMultipleOf(4, 8);
        constraints.isMultipleOf(4, 16);
        constraints.isMultipleOf(10, 100);
        constraints.isMultipleOf(1, 7);
    }
}

test "nonZero passes on non-zero values" {
    comptime {
        constraints.nonZero(u32, 1);
        constraints.nonZero(u32, 42);
        constraints.nonZero(i8, -1);
    }
}

test "anyOf passes when at least one is true" {
    comptime {
        constraints.anyOf(&.{ false, true, false });
        constraints.anyOf(&.{ true, false });
        constraints.anyOf(&.{true});
    }
}

test "lessThan passes for strictly less values" {
    comptime {
        constraints.lessThan(u32, 5, 10);
        constraints.lessThan(i16, -10, 0);
    }
}

test "greaterThan passes for strictly greater values" {
    comptime {
        constraints.greaterThan(u32, 10, 5);
        constraints.greaterThan(i16, 0, -10);
    }
}

test "sumAtMost passes when sum is within budget" {
    comptime {
        constraints.sumAtMost(u32, &.{ 10, 20, 30 }, 100);
        constraints.sumAtMost(u32, &.{ 10, 20, 30 }, 60);
        constraints.sumAtMost(u16, &.{0}, 0);
    }
}

test "sumEquals passes when sum matches target" {
    comptime {
        constraints.sumEquals(u32, &.{ 25, 25, 50 }, 100);
        constraints.sumEquals(u16, &.{ 10, 20, 30, 40 }, 100);
    }
}

test "allElements passes when all elements satisfy check" {
    const checkPositive = struct {
        fn f(comptime v: i32) void {
            if (v <= 0) @compileError("must be positive");
        }
    }.f;

    comptime {
        constraints.allElements(i32, &.{ 1, 2, 3, 100 }, checkPositive);
    }
}

test "anyOf with isInRange for OR composition" {
    comptime {
        const value: u32 = 95;
        constraints.anyOf(&.{
            constraints.isInRange(u32, 0, 10, value),
            constraints.isInRange(u32, 90, 100, value),
        });
    }
}
