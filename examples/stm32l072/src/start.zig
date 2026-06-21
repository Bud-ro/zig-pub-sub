//! ARM Cortex-M0+ startup code for STM32L072.
//! Provides the vector table, Reset_Handler (copies .data, zeros .bss),
//! and default interrupt stubs. Exports linker symbols.

const app = @import("main.zig");
const std = @import("std");

const cc: std.builtin.CallingConvention = .{ .arm_aapcs = .{} };

extern var _sidata: u32;
extern var _sdata: u32;
extern var _edata: u32;
extern var _sbss: u32;
extern var _ebss: u32;

export fn resetHandler() callconv(cc) noreturn {
    // Copy .data from flash to RAM
    const data_start: [*]volatile u32 = @ptrCast(&_sdata);
    const data_end: [*]volatile u32 = @ptrCast(&_edata);
    const data_load: [*]const u32 = @ptrCast(&_sidata);

    const data_words = (@intFromPtr(data_end) - @intFromPtr(data_start)) / @sizeOf(u32);
    for (0..data_words) |i| {
        data_start[i] = data_load[i];
    }

    // Zero .bss
    const bss_start: [*]volatile u32 = @ptrCast(&_sbss);
    const bss_end: [*]volatile u32 = @ptrCast(&_ebss);

    const bss_words = (@intFromPtr(bss_end) - @intFromPtr(bss_start)) / @sizeOf(u32);
    for (0..bss_words) |i| {
        bss_start[i] = 0;
    }

    app.main();
}

fn defaultHandler() callconv(cc) void {
    while (true) {}
}

/// Initial stack pointer value, provided by the linker script.
extern const _stack_top: anyopaque;

/// Vector table entry: either a handler function pointer or null for reserved slots.
const VectorEntry = ?*const fn () callconv(cc) void;

/// ARM Cortex-M0+ vector table, placed in .isr_vector by the linker script.
pub export const vector_table: [16]VectorEntry linksection(".isr_vector") = .{
    // Initial SP (cast the linker symbol address to a function pointer for the table)
    @ptrCast(@alignCast(&_stack_top)),
    // Reset handler
    resetHandler,
    // NMI
    defaultHandler,
    // HardFault
    defaultHandler,
    // Reserved (4-6)
    null,
    null,
    null,
    // Reserved (7-10)
    null,
    null,
    null,
    null,
    // SVCall
    defaultHandler,
    // Reserved (12-13)
    null,
    null,
    // PendSV
    defaultHandler,
    // SysTick
    app.sysTickHandler,
};
