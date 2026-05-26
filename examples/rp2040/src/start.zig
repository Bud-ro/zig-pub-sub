//! Cortex-M0+ startup code for the RP2040.
//!
//! Provides the vector table, reset handler (.data copy, .bss zero),
//! default fault/interrupt handlers, and compiler runtime support.
//! The vector table is placed at the start of flash via the .vectors
//! linker section.

const app = @import("main.zig");
const std = @import("std");

/// Disable std.log on freestanding (no output backend).
pub const std_options: std.Options = .{
    .logFn = struct {
        fn f(
            comptime _: std.log.Level,
            comptime _: anytype,
            comptime _: []const u8,
            _: anytype,
        ) void {
            // Intentionally empty: no log output on bare-metal.
        }
    }.f,
};

/// Trigger a breakpoint and hang on panic (visible via SWD debugger).
pub fn panic(_: []const u8, _: ?*const std.builtin.StackTrace, _: ?usize) noreturn {
    while (true) {
        asm volatile ("bkpt #0");
    }
}

extern var _sdata: u32;
extern var _edata: u32;
extern const _sidata: u32;
extern var _sbss: u32;
extern var _ebss: u32;

fn resetHandler() callconv(.{ .arm_aapcs = .{} }) noreturn {
    // Copy .data from flash to RAM
    const data_start: [*]u32 = @ptrCast(&_sdata);
    const data_end: [*]u32 = @ptrCast(&_edata);
    const data_load: [*]const u32 = @ptrCast(&_sidata);
    const data_len = @intFromPtr(data_end) - @intFromPtr(data_start);
    @memcpy(data_start[0 .. data_len / 4], data_load[0 .. data_len / 4]);

    // Zero .bss
    const bss_start: [*]u32 = @ptrCast(&_sbss);
    const bss_end: [*]u32 = @ptrCast(&_ebss);
    const bss_len = @intFromPtr(bss_end) - @intFromPtr(bss_start);
    @memset(bss_start[0 .. bss_len / 4], 0);

    app.main();
    while (true) {}
}

fn defaultHandler() callconv(.{ .arm_aapcs = .{} }) void {
    while (true) {}
}

const Handler = *const fn () callconv(.{ .arm_aapcs = .{} }) void;

// --- Compiler runtime support ---
// Cortex-M0+ has no native 32-bit atomic instructions. The erd_core timer
// module uses @atomicLoad(u32, ...) which the compiler lowers to a call to
// __atomic_load_4. We provide a bare-metal implementation that disables
// interrupts around the load to guarantee a consistent read.

export fn __atomic_load_4(src: *volatile u32, _: c_int) callconv(.c) u32 { // zlinter-disable-current-line function_naming
    // Disable interrupts via PRIMASK
    asm volatile ("cpsid i");
    const val = src.*;
    // Re-enable interrupts
    asm volatile ("cpsie i");
    return val;
}

export const vector_table: VectorTable linksection(".vectors") = .{};
export fn _start() callconv(.{ .arm_aapcs = .{} }) noreturn { // zlinter-disable-current-line function_naming
    resetHandler();
}

/// Cortex-M0+ vector table for the RP2040.
/// Initial stack pointer is set to top of the 256KB SRAM region.
/// Only the 16 system exception entries are defined; device-specific
/// IRQs (TIMER, UART, SPI, etc.) would follow for interrupt support.
// zlinter-disable field_naming - vector table field names follow ARM convention
const VectorTable = extern struct {
    /// Initial stack pointer (top of 256KB RAM).
    initial_sp: u32 = 0x20040000,
    reset: Handler = resetHandler,
    nmi: Handler = defaultHandler,
    hard_fault: Handler = defaultHandler,
    reserved_3: u32 = 0,
    reserved_4: u32 = 0,
    reserved_5: u32 = 0,
    reserved_6: u32 = 0,
    reserved_7: u32 = 0,
    reserved_8: u32 = 0,
    reserved_9: u32 = 0,
    svcall: Handler = defaultHandler,
    reserved_11: u32 = 0,
    reserved_12: u32 = 0,
    pendsv: Handler = defaultHandler,
    systick: Handler = defaultHandler,
};
// zlinter-enable field_naming
