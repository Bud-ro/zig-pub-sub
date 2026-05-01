/// Generates an array of N values by mapping each index through a comptime function.
pub fn generateArray(
    comptime T: type,
    comptime n: usize,
    comptime func: fn (comptime usize) T,
) [n]T {
    var result: [n]T = undefined;
    for (0..n) |i| {
        result[i] = @call(.auto, func, .{i});
    }
    return result;
}

/// Generates a lookup table by mapping inputs [min, min+step, ..., max] through a function.
pub fn lookupTable(
    comptime InputT: type,
    comptime OutputT: type,
    comptime min: InputT,
    comptime max: InputT,
    comptime step: InputT,
    comptime func: fn (comptime InputT) OutputT,
) [tableLen(InputT, min, max, step)]LookupEntry(InputT, OutputT) {
    const len = tableLen(InputT, min, max, step);
    var result: [len]LookupEntry(InputT, OutputT) = undefined;
    var input = min;
    for (0..len) |i| {
        result[i] = .{ .input = input, .output = @call(.auto, func, .{input}) };
        input += step;
    }
    return result;
}

pub fn LookupEntry(comptime InputT: type, comptime OutputT: type) type {
    return struct {
        input: InputT,
        output: OutputT,
    };
}

fn tableLen(comptime T: type, comptime min: T, comptime max: T, comptime step: T) usize {
    return @intCast(@divExact(max - min, step) + 1);
}

/// Repeats a single value N times.
pub fn repeated(comptime T: type, comptime value: T, comptime n: usize) [n]T {
    return [_]T{value} ** n;
}

/// Generates N entries where each is derived from the previous.
pub fn unfold(
    comptime T: type,
    comptime n: usize,
    comptime seed: T,
    comptime step: fn (comptime T, comptime usize) T,
) [n]T {
    var result: [n]T = undefined;
    result[0] = seed;
    for (1..n) |i| {
        result[i] = @call(.auto, step, .{ result[i - 1], i });
    }
    return result;
}

/// Validates each element of a sequence using a check function, then returns the sequence.
pub fn validatedSequence(
    comptime T: type,
    comptime steps: []const T,
    comptime validate: fn (comptime T, comptime usize) void,
) [steps.len]T {
    for (steps, 0..) |s, i| {
        @call(.auto, validate, .{ s, i });
    }
    return steps[0..steps.len].*;
}

/// Generates N linearly spaced integer values from start to end (inclusive).
pub fn linearMap(comptime T: type, comptime n: usize, comptime start: T, comptime end: T) [n]T {
    if (n < 2) @compileError("linearMap requires at least 2 points");
    var result: [n]T = undefined;
    for (0..n) |i| {
        result[i] = start + @as(T, @intCast(i)) * @divExact(end - start, @as(T, @intCast(n - 1)));
    }
    return result;
}
