//! RISC-V startup code for GD32VF103.
//! Sets up the stack pointer, zeros .bss, copies .data from flash to RAM,
//! and calls into the Zig main function.

const main = @import("main.zig");

extern var _bss_start: u32;
extern var _bss_end: u32;
extern var _data_start: u32;
extern var _data_end: u32;
extern const _data_load: u32;

fn zeroBss() void {
    const bss_start: [*]u32 = @ptrCast(&_bss_start);
    const bss_end: [*]u32 = @ptrCast(&_bss_end);
    const len = (@intFromPtr(bss_end) - @intFromPtr(bss_start)) / @sizeOf(u32);
    for (bss_start[0..len]) |*word| {
        word.* = 0;
    }
}

fn copyData() void {
    const data_start: [*]u32 = @ptrCast(&_data_start);
    const data_end: [*]u32 = @ptrCast(&_data_end);
    const data_load: [*]const u32 = @ptrCast(&_data_load);
    const len = (@intFromPtr(data_end) - @intFromPtr(data_start)) / @sizeOf(u32);
    for (data_start[0..len], data_load[0..len]) |*dst, src| {
        dst.* = src;
    }
}

/// Non-naked init function called after stack and global pointer are set up.
/// Zeroes .bss, copies .data, then calls main.
fn initAndMain() callconv(.c) noreturn {
    zeroBss();
    copyData();
    main.main();
    while (true) {
        asm volatile ("wfi");
    }
}

/// RISC-V entry point. Sets stack pointer and global pointer via inline
/// assembly, then tail-calls into `initAndMain` which handles the rest
/// in normal (non-naked) Zig code.
export fn _start() callconv(.naked) noreturn { // zlinter-disable-current-line function_naming
    asm volatile (
        \\la sp, _stack_top
        \\.option push
        \\.option norelax
        \\la gp, __global_pointer$
        \\.option pop
        \\tail %[init]
        :
        : [init] "s" (&initAndMain),
    );
}
