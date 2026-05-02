//! Value transforms: convert human-readable units (floats, frequencies,
//! percentages) into machine representations (fixed-point, scaled integers,
//! tick counts). If a value isn't exactly representable, the error message
//! suggests the two nearest values the user can write instead.

const std = @import("std");

/// Converts a comptime float to fixed-point representation.
/// T is the storage type (e.g. u16, i16), frac_bits is the number of fractional bits.
/// Compile error if the value is not exactly representable, suggesting the two nearest values.
pub fn fixedPoint(comptime T: type, comptime frac_bits: comptime_int, comptime value: comptime_float) T {
    const scale = comptime_pow2(frac_bits);
    const scaled_value = value * scale;
    const truncated = @as(comptime_int, @intFromFloat(scaled_value));

    if (@as(comptime_float, @floatFromInt(truncated)) != scaled_value) {
        const lower: comptime_float = @as(comptime_float, @floatFromInt(truncated)) / scale;
        const upper: comptime_float = @as(comptime_float, @floatFromInt(truncated + 1)) / scale;
        @compileError(std.fmt.comptimePrint(
            "{d} is not exactly representable in Q{}.{} fixed-point. Nearest values: {d} or {d}",
            .{ value, @typeInfo(T).int.bits - frac_bits, frac_bits, lower, upper },
        ));
    }

    const info = @typeInfo(T).int;
    const min_val = if (info.signedness == .signed) -(comptime_pow2(info.bits - 1)) else 0;
    const max_val = comptime_pow2(if (info.signedness == .signed) info.bits - 1 else info.bits) - 1;

    if (truncated < min_val or truncated > max_val) {
        @compileError(std.fmt.comptimePrint(
            "{d} overflows {} (range [{d}, {d}])",
            .{ value, @typeName(T), @as(comptime_float, @floatFromInt(min_val)) / scale, @as(comptime_float, @floatFromInt(max_val)) / scale },
        ));
    }

    return @intCast(truncated);
}

/// Converts a comptime float by multiplying by a scale factor and rounding to the nearest integer.
/// Compile error if the result is not exact (i.e., the value has more precision than the scale allows).
pub fn scaled(comptime T: type, comptime scale: comptime_int, comptime value: comptime_float) T {
    const result = value * @as(comptime_float, @floatFromInt(scale));
    const truncated = @as(comptime_int, @intFromFloat(result));

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
pub fn scaledNearest(comptime T: type, comptime scale: comptime_int, comptime value: comptime_float) T {
    const result = value * @as(comptime_float, @floatFromInt(scale));
    const rounded = @as(comptime_int, @intFromFloat(@round(result)));
    return @intCast(rounded);
}

/// Converts a percentage (0-100) to a fraction of a given max value.
/// Example: percentOf(u8, 255, 50.0) = 127 (50% of 255, nearest).
pub fn percentOf(comptime T: type, comptime max: comptime_int, comptime pct: comptime_float) T {
    const result = pct / 100.0 * @as(comptime_float, @floatFromInt(max));
    const rounded = @as(comptime_int, @intFromFloat(@round(result)));
    if (rounded < 0 or rounded > max) {
        @compileError(std.fmt.comptimePrint(
            "{d}% of {} = {} which is out of range [0, {}]",
            .{ pct, max, rounded, max },
        ));
    }
    return @intCast(rounded);
}

/// Converts a frequency in Hz to a period in the given time unit.
/// Example: freqToPeriod(u32, 1000.0, .microseconds) = 1000
pub fn freqToPeriod(comptime T: type, comptime freq_hz: comptime_float, comptime unit: TimeUnit) T {
    if (freq_hz <= 0) @compileError("frequency must be positive");
    const multiplier: comptime_float = switch (unit) {
        .seconds => 1.0,
        .milliseconds => 1_000.0,
        .microseconds => 1_000_000.0,
        .nanoseconds => 1_000_000_000.0,
        .ticks => @compileError("ticks require explicit tick_hz; use freqToTicks instead"),
    };
    const period = multiplier / freq_hz;
    const truncated = @as(comptime_int, @intFromFloat(period));
    if (@as(comptime_float, @floatFromInt(truncated)) != period) {
        const lower_freq = multiplier / @as(comptime_float, @floatFromInt(truncated + 1));
        const upper_freq = multiplier / @as(comptime_float, @floatFromInt(truncated));
        @compileError(std.fmt.comptimePrint(
            "{d} Hz does not produce an integer period in {s}. Try {d} Hz (period={}) or {d} Hz (period={})",
            .{ freq_hz, @tagName(unit), upper_freq, truncated, lower_freq, truncated + 1 },
        ));
    }
    return @intCast(truncated);
}

/// Converts a frequency to a tick count given a tick rate.
/// Example: freqToTicks(u16, 100.0, 10000.0) = 100 (100Hz sampled at 10kHz tick)
pub fn freqToTicks(comptime T: type, comptime freq_hz: comptime_float, comptime tick_hz: comptime_float) T {
    if (freq_hz <= 0) @compileError("frequency must be positive");
    if (tick_hz <= 0) @compileError("tick rate must be positive");
    if (freq_hz > tick_hz) @compileError("frequency exceeds tick rate (Nyquist violation)");
    const ticks = tick_hz / freq_hz;
    const truncated = @as(comptime_int, @intFromFloat(ticks));
    if (@as(comptime_float, @floatFromInt(truncated)) != ticks) {
        @compileError(std.fmt.comptimePrint(
            "{d} Hz at {d} Hz tick rate = {d} ticks (not integer). Try {d} Hz or {d} Hz",
            .{ freq_hz, tick_hz, ticks, tick_hz / @as(comptime_float, @floatFromInt(truncated)), tick_hz / @as(comptime_float, @floatFromInt(truncated + 1)) },
        ));
    }
    return @intCast(truncated);
}

pub const TimeUnit = enum { seconds, milliseconds, microseconds, nanoseconds, ticks };

fn comptime_pow2(comptime exp: comptime_int) comptime_float {
    var result: comptime_float = 1.0;
    var i: comptime_int = 0;
    while (i < exp) : (i += 1) {
        result *= 2.0;
    }
    return result;
}
