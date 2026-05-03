//! Primitive comptime constraint functions. Each returns ?[]const u8:
//! null means the check passed, a string means it failed (with a message).

const std = @import("std");

/// Checks value is within [min, max] inclusive.
pub fn inRange(comptime min: anytype, comptime max: anytype, comptime value: anytype) ?[]const u8 {
    if (value < min or value > max) {
        return std.fmt.comptimePrint("value {} is outside range [{}, {}]", .{ value, min, max });
    }
    return null;
}

/// Returns true if value is in [min, max] inclusive.
pub fn isInRange(comptime min: anytype, comptime max: anytype, comptime value: anytype) bool {
    return value >= min and value <= max;
}

/// Checks value equals one of the allowed values.
pub fn oneOf(comptime allowed: anytype, comptime value: anytype) ?[]const u8 {
    if (!isOneOf(allowed, value)) {
        var set_str: []const u8 = "";
        for (allowed, 0..) |a, i| {
            if (i > 0) set_str = set_str ++ ", ";
            set_str = set_str ++ std.fmt.comptimePrint("{}", .{a});
        }
        return std.fmt.comptimePrint("value {} is not in the allowed set: [{s}]", .{ value, set_str });
    }
    return null;
}

/// Returns true if value equals one of the allowed values.
pub fn isOneOf(comptime allowed: anytype, comptime value: anytype) bool {
    for (allowed) |a| {
        if (value == a) return true;
    }
    return false;
}

/// Checks array/slice length is exactly `expected`.
pub fn exactLen(comptime expected: usize, comptime actual: usize) ?[]const u8 {
    if (actual != expected) {
        return std.fmt.comptimePrint("expected length {}, got {}", .{ expected, actual });
    }
    return null;
}

/// Checks length is within [min, max] inclusive.
pub fn lenInRange(comptime min: usize, comptime max: usize, comptime actual: usize) ?[]const u8 {
    if (actual < min or actual > max) {
        return std.fmt.comptimePrint("length {} is outside [{}, {}]", .{ actual, min, max });
    }
    return null;
}

/// Checks every element of a comptime array satisfies a check function.
pub fn allElements(comptime T: type, comptime arr: []const T, comptime check: fn (comptime T) ?[]const u8) ?[]const u8 {
    for (arr) |elem| {
        if (check(elem)) |err| return err;
    }
    return null;
}

/// Checks array is sorted in ascending order.
pub fn isSorted(comptime T: type, comptime arr: []const T) ?[]const u8 {
    if (arr.len < 2) return null;
    for (1..arr.len) |i| {
        if (arr[i] < arr[i - 1]) {
            return std.fmt.comptimePrint("array not sorted at index {}: {} < {}", .{ i, arr[i], arr[i - 1] });
        }
    }
    return null;
}

/// Checks no duplicate values in the array.
pub fn noDuplicates(comptime T: type, comptime arr: []const T) ?[]const u8 {
    for (0..arr.len) |i| {
        for (i + 1..arr.len) |j| {
            if (arr[i] == arr[j]) {
                return std.fmt.comptimePrint("duplicate value at indices {} and {}", .{ i, j });
            }
        }
    }
    return null;
}

/// Checks value is a power of two. Value must be unsigned.
pub fn isPowerOfTwo(comptime value: anytype) ?[]const u8 {
    const T = @TypeOf(value);
    if (@typeInfo(T) == .int and @typeInfo(T).int.signedness == .signed)
        @compileError("isPowerOfTwo requires an unsigned integer");
    if (value == 0 or (value & (value - 1)) != 0) {
        return std.fmt.comptimePrint("{} is not a power of two", .{value});
    }
    return null;
}

/// Checks value is a multiple of divisor. Both must be unsigned.
pub fn isMultipleOf(comptime divisor: anytype, comptime value: anytype) ?[]const u8 {
    const DT = @TypeOf(divisor);
    const VT = @TypeOf(value);
    if (@typeInfo(DT) == .int and @typeInfo(DT).int.signedness == .signed)
        @compileError("isMultipleOf requires unsigned integers");
    if (@typeInfo(VT) == .int and @typeInfo(VT).int.signedness == .signed)
        @compileError("isMultipleOf requires unsigned integers");
    if (divisor == 0) return "divisor must not be zero";
    if (value % divisor != 0) {
        return std.fmt.comptimePrint("{} is not a multiple of {}", .{ value, divisor });
    }
    return null;
}

/// Checks value is not zero.
pub fn nonZero(comptime value: anytype) ?[]const u8 {
    if (value == 0) {
        return "value must not be zero";
    }
    return null;
}

/// OR combinator: passes if at least one bool check is true.
pub fn anyOf(comptime checks: []const bool) ?[]const u8 {
    for (checks) |chk| {
        if (chk) return null;
    }
    return "none of the constraint alternatives were satisfied";
}

/// Checks that a comptime value is strictly less than another.
pub fn lessThan(comptime a: anytype, comptime b: anytype) ?[]const u8 {
    if (a >= b) {
        return std.fmt.comptimePrint("expected {} < {}, but it is not", .{ a, b });
    }
    return null;
}

/// Checks that a comptime value is strictly greater than another.
pub fn greaterThan(comptime a: anytype, comptime b: anytype) ?[]const u8 {
    if (a <= b) {
        return std.fmt.comptimePrint("expected {} > {}, but it is not", .{ a, b });
    }
    return null;
}

/// Checks that the sum of an array does not exceed a budget.
pub fn sumAtMost(comptime T: type, comptime values: []const T, comptime budget: T) ?[]const u8 {
    var total: T = 0;
    for (values) |v| {
        total += v;
    }
    if (total > budget) {
        return std.fmt.comptimePrint("sum {} exceeds budget {}", .{ total, budget });
    }
    return null;
}

/// Checks that the sum of an array equals an exact target.
pub fn sumEquals(comptime T: type, comptime values: []const T, comptime target: T) ?[]const u8 {
    var total: T = 0;
    for (values) |v| {
        total += v;
    }
    if (total != target) {
        return std.fmt.comptimePrint("sum {} does not equal target {}", .{ total, target });
    }
    return null;
}
