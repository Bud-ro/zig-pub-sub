//! Comptime array generators. Produce fixed-size arrays ([N]T) that live
//! in .rodata — no heap, no runtime allocation. Use generateArray to build
//! lookup tables, calibration arrays, and repeated configs.

/// Generates an array of N values by mapping each index through a comptime function.
pub fn generateArray(
    comptime T: type,
    comptime n: usize,
    comptime func: fn (comptime usize) T,
) [n]T {
    var result: [n]T = undefined;
    for (0..n) |i| {
        result[i] = func(i);
    }
    return result;
}
