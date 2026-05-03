const std = @import("std");
const constraint = @import("data_gen").constraint;

test "equals passes on equal values" {
    comptime {
        if (constraint.equals(42, 42)) |err| @compileError(err);
        if (constraint.equals(0, 0)) |err| @compileError(err);
    }
}

test "equals error message" {
    comptime {
        try std.testing.expectEqualStrings("expected 10, got 20", constraint.equals(10, 20).?);
    }
}

test "inRange accepts values within bounds" {
    comptime {
        if (constraint.inRange(10, 100, 10)) |err| @compileError(err);
        if (constraint.inRange(10, 100, 50)) |err| @compileError(err);
        if (constraint.inRange(10, 100, 100)) |err| @compileError(err);
        if (constraint.inRange(-100, 100, -100)) |err| @compileError(err);
        if (constraint.inRange(-100, 100, 0)) |err| @compileError(err);
    }
}

test "inRange error message" {
    comptime {
        try std.testing.expectEqualStrings(
            "value 101 is outside range [10, 100]",
            constraint.inRange(10, 100, 101).?,
        );
        try std.testing.expectEqualStrings(
            "value -5 is outside range [0, 10]",
            constraint.inRange(0, 10, -5).?,
        );
    }
}

test "oneOf accepts allowed values" {
    comptime {
        if (constraint.oneOf(&.{ 100, 200, 500, 1000 }, 200)) |err| @compileError(err);
        if (constraint.oneOf(&.{ 100, 200, 500, 1000 }, 1000)) |err| @compileError(err);
    }
}

test "oneOf error message" {
    comptime {
        try std.testing.expectEqualStrings(
            "value 42 is not in the allowed set: [1, 2, 3]",
            constraint.oneOf(&.{ 1, 2, 3 }, 42).?,
        );
    }
}

test "lenInRange passes within bounds" {
    comptime {
        if (constraint.lenInRange(2, 256, 2)) |err| @compileError(err);
        if (constraint.lenInRange(2, 256, 128)) |err| @compileError(err);
        if (constraint.lenInRange(2, 256, 256)) |err| @compileError(err);
    }
}

test "lenInRange error message" {
    comptime {
        try std.testing.expectEqualStrings(
            "length 1 is outside [2, 256]",
            constraint.lenInRange(2, 256, 1).?,
        );
    }
}

test "isSorted passes on sorted array" {
    comptime {
        if (constraint.isSorted(i16, &.{ -10, 0, 5, 100 })) |err| @compileError(err);
        if (constraint.isSorted(u32, &.{ 1, 2, 3, 4, 5 })) |err| @compileError(err);
        if (constraint.isSorted(u8, &.{42})) |err| @compileError(err);
        if (constraint.isSorted(u8, &.{})) |err| @compileError(err);
    }
}

test "isSorted error message" {
    comptime {
        try std.testing.expectEqualStrings(
            "array not sorted at index 2: 1 < 5",
            constraint.isSorted(u8, &.{ 3, 5, 1 }).?,
        );
    }
}

test "noDuplicates passes on unique array" {
    comptime {
        if (constraint.noDuplicates(u32, &.{ 1, 2, 3, 4, 5 })) |err| @compileError(err);
        if (constraint.noDuplicates(i8, &.{ -1, 0, 1 })) |err| @compileError(err);
        if (constraint.noDuplicates(u8, &.{42})) |err| @compileError(err);
        if (constraint.noDuplicates(u8, &.{})) |err| @compileError(err);
    }
}

test "noDuplicates error message" {
    comptime {
        try std.testing.expectEqualStrings(
            "duplicate value at indices 0 and 2",
            constraint.noDuplicates(u8, &.{ 5, 3, 5 }).?,
        );
    }
}

test "isPowerOfTwo passes on powers of two" {
    comptime {
        if (constraint.isPowerOfTwo(1)) |err| @compileError(err);
        if (constraint.isPowerOfTwo(2)) |err| @compileError(err);
        if (constraint.isPowerOfTwo(4)) |err| @compileError(err);
        if (constraint.isPowerOfTwo(256)) |err| @compileError(err);
        if (constraint.isPowerOfTwo(1024)) |err| @compileError(err);
    }
}

test "isPowerOfTwo error message" {
    comptime {
        try std.testing.expectEqualStrings("3 is not a power of two", constraint.isPowerOfTwo(3).?);
        try std.testing.expectEqualStrings("0 is not a power of two", constraint.isPowerOfTwo(0).?);
    }
}

test "isPowerOfTwo rejects signed integers" {
    comptime {
        try std.testing.expectEqualStrings(
            "isPowerOfTwo requires an unsigned integer",
            constraint.isPowerOfTwo(@as(i8, 4)).?,
        );
    }
}

test "isMultipleOf passes on valid multiples" {
    comptime {
        if (constraint.isMultipleOf(4, 8)) |err| @compileError(err);
        if (constraint.isMultipleOf(4, 16)) |err| @compileError(err);
        if (constraint.isMultipleOf(10, 100)) |err| @compileError(err);
        if (constraint.isMultipleOf(1, 7)) |err| @compileError(err);
        if (constraint.isMultipleOf(3, -6)) |err| @compileError(err);
    }
}

test "isMultipleOf error message" {
    comptime {
        try std.testing.expectEqualStrings("7 is not a multiple of 4", constraint.isMultipleOf(4, 7).?);
        try std.testing.expectEqualStrings("divisor must not be zero", constraint.isMultipleOf(0, 5).?);
    }
}

test "nonZero passes on non-zero values" {
    comptime {
        if (constraint.nonZero(1)) |err| @compileError(err);
        if (constraint.nonZero(42)) |err| @compileError(err);
        if (constraint.nonZero(-1)) |err| @compileError(err);
    }
}

test "nonZero error message" {
    comptime {
        try std.testing.expectEqualStrings("value must not be zero", constraint.nonZero(0).?);
    }
}

test "lessThan passes for strictly less values" {
    comptime {
        if (constraint.lessThan(5, 10)) |err| @compileError(err);
        if (constraint.lessThan(-10, 0)) |err| @compileError(err);
    }
}

test "lessThan error message" {
    comptime {
        try std.testing.expectEqualStrings("expected 10 < 5, but it is not", constraint.lessThan(10, 5).?);
    }
}

test "greaterThan passes for strictly greater values" {
    comptime {
        if (constraint.greaterThan(10, 5)) |err| @compileError(err);
        if (constraint.greaterThan(0, -10)) |err| @compileError(err);
    }
}

test "greaterThan error message" {
    comptime {
        try std.testing.expectEqualStrings("expected 3 > 5, but it is not", constraint.greaterThan(3, 5).?);
    }
}

test "anyOf passes when at least one constraint passes" {
    comptime {
        if (constraint.anyOf(&.{
            constraint.inRange(0, 10, 95),
            constraint.inRange(90, 100, 95),
        })) |err| @compileError(err);

        if (constraint.anyOf(&.{
            constraint.equals(42, 42),
            constraint.equals(42, 99),
        })) |err| @compileError(err);
    }
}

test "anyOf error message lists all failures" {
    comptime {
        const result = constraint.anyOf(&.{
            constraint.inRange(0, 10, 50),
            constraint.inRange(90, 100, 50),
        }).?;
        try std.testing.expectEqualStrings(
            "no alternative satisfied:\n  - value 50 is outside range [0, 10]\n  - value 50 is outside range [90, 100]",
            result,
        );
    }
}
