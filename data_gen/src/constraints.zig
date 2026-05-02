const std = @import("std");

/// Asserts value is within [min, max] inclusive. Compile error on failure.
pub fn inRange(comptime T: type, comptime min: T, comptime max: T, comptime value: T) void {
    if (value < min or value > max) {
        @compileError(std.fmt.comptimePrint(
            "value {} is outside range [{}, {}]",
            .{ value, min, max },
        ));
    }
}

/// Returns true if value is in [min, max] inclusive.
pub fn isInRange(comptime T: type, comptime min: T, comptime max: T, comptime value: T) bool {
    return value >= min and value <= max;
}

/// Asserts value equals one of the allowed values. Compile error on failure.
pub fn oneOf(comptime T: type, comptime allowed: anytype, comptime value: T) void {
    if (!isOneOf(T, allowed, value)) {
        var set_str: []const u8 = "";
        for (allowed, 0..) |a, i| {
            if (i > 0) set_str = set_str ++ ", ";
            set_str = set_str ++ std.fmt.comptimePrint("{}", .{a});
        }
        @compileError(std.fmt.comptimePrint(
            "value {} is not in the allowed set: [{s}]",
            .{ value, set_str },
        ));
    }
}

/// Returns true if value equals one of the allowed values.
pub fn isOneOf(comptime T: type, comptime allowed: anytype, comptime value: T) bool {
    for (allowed) |a| {
        if (value == a) return true;
    }
    return false;
}

/// Asserts array/slice length is exactly `expected`. Compile error on failure.
pub fn exactLen(comptime expected: usize, comptime actual: usize) void {
    if (actual != expected) {
        @compileError(std.fmt.comptimePrint(
            "expected length {}, got {}",
            .{ expected, actual },
        ));
    }
}

/// Asserts length is within [min, max] inclusive. Compile error on failure.
pub fn lenInRange(comptime min: usize, comptime max: usize, comptime actual: usize) void {
    if (actual < min or actual > max) {
        @compileError(std.fmt.comptimePrint(
            "length {} is outside [{}, {}]",
            .{ actual, min, max },
        ));
    }
}

/// Asserts every element of a comptime array satisfies a check function.
/// The check function must take `(comptime T) void` and @compileError on failure.
pub fn allElements(
    comptime T: type,
    comptime arr: []const T,
    comptime check: fn (comptime T) void,
) void {
    for (arr) |elem| {
        @call(.auto, check, .{elem});
    }
}

/// Asserts array is sorted in ascending order. Compile error on failure.
pub fn isSorted(comptime T: type, comptime arr: []const T) void {
    if (arr.len < 2) return;
    for (1..arr.len) |i| {
        if (arr[i] < arr[i - 1]) {
            @compileError(std.fmt.comptimePrint(
                "array not sorted at index {}: {} < {}",
                .{ i, arr[i], arr[i - 1] },
            ));
        }
    }
}

/// Asserts no duplicate values in the array. Compile error on failure.
pub fn noDuplicates(comptime T: type, comptime arr: []const T) void {
    for (0..arr.len) |i| {
        for (i + 1..arr.len) |j| {
            if (arr[i] == arr[j]) {
                @compileError(std.fmt.comptimePrint(
                    "duplicate value at indices {} and {}",
                    .{ i, j },
                ));
            }
        }
    }
}

/// Asserts value is a power of two. Compile error on failure.
pub fn isPowerOfTwo(comptime value: anytype) void {
    const v: usize = value;
    if (v == 0 or (v & (v - 1)) != 0) {
        @compileError(std.fmt.comptimePrint(
            "{} is not a power of two",
            .{v},
        ));
    }
}

/// Asserts value is a multiple of divisor. Compile error on failure.
pub fn isMultipleOf(comptime divisor: anytype, comptime value: anytype) void {
    const d: usize = divisor;
    const v: usize = value;
    if (v % d != 0) {
        @compileError(std.fmt.comptimePrint(
            "{} is not a multiple of {}",
            .{ v, d },
        ));
    }
}

/// Asserts value is not zero. Compile error on failure.
pub fn nonZero(comptime T: type, comptime value: T) void {
    if (value == 0) {
        @compileError("value must not be zero");
    }
}

/// OR combinator: asserts at least one of the bool checks is true.
/// Pass results from soft-check functions (isInRange, isOneOf, etc.).
pub fn anyOf(comptime checks: []const bool) void {
    for (checks) |check| {
        if (check) return;
    }
    @compileError("none of the constraint alternatives were satisfied");
}

/// Asserts all bool checks are true.
pub fn allOf(comptime checks: []const bool) void {
    for (checks, 0..) |check, i| {
        if (!check) {
            @compileError(std.fmt.comptimePrint(
                "constraint {} of {} failed",
                .{ i + 1, checks.len },
            ));
        }
    }
}

/// Asserts that a comptime value is strictly less than another.
pub fn lessThan(comptime T: type, comptime a: T, comptime b: T) void {
    if (a >= b) {
        @compileError(std.fmt.comptimePrint(
            "expected {} < {}, but it is not",
            .{ a, b },
        ));
    }
}

/// Asserts that a comptime value is strictly greater than another.
pub fn greaterThan(comptime T: type, comptime a: T, comptime b: T) void {
    if (a <= b) {
        @compileError(std.fmt.comptimePrint(
            "expected {} > {}, but it is not",
            .{ a, b },
        ));
    }
}

/// Asserts that the sum of an array of values does not exceed a budget.
pub fn sumAtMost(comptime T: type, comptime values: []const T, comptime budget: T) void {
    var total: T = 0;
    for (values) |v| {
        total += v;
    }
    if (total > budget) {
        @compileError(std.fmt.comptimePrint(
            "sum {} exceeds budget {}",
            .{ total, budget },
        ));
    }
}

/// Asserts that the sum of an array equals an exact target.
pub fn sumEquals(comptime T: type, comptime values: []const T, comptime target: T) void {
    var total: T = 0;
    for (values) |v| {
        total += v;
    }
    if (total != target) {
        @compileError(std.fmt.comptimePrint(
            "sum {} does not equal target {}",
            .{ total, target },
        ));
    }
}
