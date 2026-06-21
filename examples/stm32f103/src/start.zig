//! Cortex-M3 startup code for STM32F103C8T6.
//!
//! Provides the vector table, reset handler (.data copy, .bss zero),
//! and default fault/interrupt handlers.

const app = @import("main.zig");
const std = @import("std");

/// Disable std.log for freestanding (no OS logging backend).
pub const std_options: std.Options = .{
    .logFn = struct {
        fn f(
            comptime _: std.log.Level,
            comptime _: anytype,
            comptime _: []const u8,
            _: anytype,
        ) void {
            // No logging backend on bare-metal.
        }
    }.f,
};

/// Halt on panic -- trigger a breakpoint for debugger inspection.
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

export const vector_table: VectorTable linksection(".vectors") = .{};
export fn _start() callconv(.{ .arm_aapcs = .{} }) noreturn { // zlinter-disable-current-line function_naming
    resetHandler();
}

/// Cortex-M3 vector table. Only the first 16 entries (system exceptions)
/// are defined here. STM32F103-specific IRQs would follow if interrupt
/// handlers are added later.
const VectorTable = extern struct {
    /// Initial stack pointer (top of 20KB SRAM).
    initial_sp: u32 = 0x20005000,
    reset: Handler = resetHandler,
    nmi: Handler = defaultHandler,
    hardFault: Handler = defaultHandler,
    memManage: Handler = defaultHandler,
    busFault: Handler = defaultHandler,
    usageFault: Handler = defaultHandler,
    reserved_7: u32 = 0,
    reserved_8: u32 = 0,
    reserved_9: u32 = 0,
    reserved_10: u32 = 0,
    svcall: Handler = defaultHandler,
    debugMon: Handler = defaultHandler,
    reserved_13: u32 = 0,
    pendsv: Handler = defaultHandler,
    systick: Handler = defaultHandler,
};
