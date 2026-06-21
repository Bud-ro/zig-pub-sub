//! RISC-V startup code for ESP32-C3 bare-metal firmware.
//! Sets the stack pointer, zeroes .bss, and jumps to main.

export fn _start() callconv(.naked) noreturn { // zlinter-disable-current-line function_naming
    // Set the stack pointer and call _startZig to finish initialization.
    // Naked functions cannot contain regular Zig code, so the actual
    // .bss zeroing and main() call live in a separate non-naked function.
    asm volatile (
        \\la sp, _stack_top
        \\jal ra, _startZig
    );
}

extern var _bss_start: u32;
extern var _bss_end: u32;

/// Second-stage startup: zero .bss and call main. This is a normal (non-naked)
/// function so the compiler can emit a proper prologue/epilogue.
export fn _startZig() callconv(.c) noreturn { // zlinter-disable-current-line function_naming
    const bss_start: [*]u8 = @ptrCast(&_bss_start);
    const bss_end: [*]u8 = @ptrCast(&_bss_end);
    const bss_len = @intFromPtr(bss_end) - @intFromPtr(bss_start);
    @memset(bss_start[0..bss_len], 0);

    @import("main.zig").main();
}
