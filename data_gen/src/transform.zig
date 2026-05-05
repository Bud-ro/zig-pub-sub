//! Value transforms: convert human-readable units (floats, frequencies,
//! percentages) into machine representations (fixed-point, scaled integers,
//! tick counts). If a value isn't exactly representable, the error message
//! suggests the two nearest values the user can write instead.

const std = @import("std");

/// Converts a comptime float to fixed-point representation.
/// T is the storage type (e.g. u16, i16), frac_bits is the number of fractional bits.
/// Compile error if the value is not exactly representable, suggesting the two nearest values.
pub fn fixedPoint(T: type, frac_bits: comptime_int, value: comptime_float) T {
    const scale = comptimePow2(frac_bits);
    const scaled_value = value * scale;
    const truncated: comptime_int = @floor(scaled_value);

    if (@as(comptime_float, @floatFromInt(truncated)) != scaled_value) {
        const lower: comptime_float = @as(comptime_float, @floatFromInt(truncated)) / scale;
        const upper: comptime_float = @as(comptime_float, @floatFromInt(truncated + 1)) / scale;
        @compileError(std.fmt.comptimePrint(
            "{d} is not exactly representable in Q{}.{} fixed-point. Nearest values: {d} or {d}",
            .{ value, @typeInfo(T).int.bits - frac_bits, frac_bits, lower, upper },
        ));
    }

    const info = @typeInfo(T).int;
    const min_val = if (info.signedness == .signed) -(comptimePow2(info.bits - 1)) else 0;
    const max_val = comptimePow2(if (info.signedness == .signed) info.bits - 1 else info.bits) - 1;

    if (truncated < min_val or truncated > max_val) {
        @compileError(std.fmt.comptimePrint(
            "{d} overflows {} (range [{d}, {d}])",
            .{ value, @typeName(T), @as(comptime_float, @floatFromInt(min_val)) / scale, @as(comptime_float, @floatFromInt(max_val)) / scale },
        ));
    }

    return @intCast(truncated);
}

/// Converts a comptime float by multiplying by a scale factor and flooring to an integer.
/// Compile error if the result is not exact (i.e., the value has more precision than the scale allows).
pub fn scaled(T: type, scale: comptime_int, value: comptime_float) T {
    const result = value * @as(comptime_float, @floatFromInt(scale));
    const truncated: comptime_int = @floor(result);

    if (@as(comptime_float, @floatFromInt(truncated)) != result) {
        const lower: comptime_float = @as(comptime_float, @floatFromInt(truncated)) / @as(comptime_float, @floatFromInt(scale));
        const upper: comptime_float = @as(comptime_float, @floatFromInt(truncated + 1)) / @as(comptime_float, @floatFromInt(scale));
        @compileError(std.fmt.comptimePrint(
            "{d} is not exactly representable with scale factor {}. Nearest values: {d} or {d}",
            .{ value, scale, lower, upper },
        ));
    }

    return @intCast(truncated);
}

/// Converts a comptime float by multiplying by a scale factor, allowing inexact values.
/// Returns the nearest representable value (rounds to nearest).
pub fn scaledNearest(T: type, scale: comptime_int, value: comptime_float) T {
    const result = value * @as(comptime_float, @floatFromInt(scale));
    const rounded: comptime_int = @round(result);
    return @intCast(rounded);
}

/// Converts a percentage (0-100) to a fraction of a given max value.
/// Example: percentOf(u8, 255, 50.0) = 128 (50% of 255, nearest).
pub fn percentOf(T: type, max: comptime_int, pct: comptime_float) T {
    const result = pct / 100.0 * @as(comptime_float, @floatFromInt(max));
    const rounded: comptime_int = @round(result);
    if (rounded < 0 or rounded > max) {
        @compileError(std.fmt.comptimePrint(
            "{d}% of {} = {} which is out of range [0, {}]",
            .{ pct, max, rounded, max },
        ));
    }
    return @intCast(rounded);
}

fn comptimePow2(exp: comptime_int) comptime_float {
    return @floatFromInt(@as(u128, 1) << @intCast(exp));
}
