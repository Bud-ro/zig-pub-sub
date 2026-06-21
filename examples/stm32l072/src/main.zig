//! STM32L072 (Nucleo-L073RZ) firmware entry point.
//! Initializes hardware and the erd_core application, then enters the
//! run-to-completion main loop driven by the SysTick timer.

const std = @import("std");

const application = @import("application.zig");
const hardware = @import("hardware.zig");
const start = @import("start.zig");
const uart = @import("uart.zig");

const cc: std.builtin.CallingConvention = .{ .arm_aapcs = .{} };

var app: application.Application = undefined;

/// Called from the startup code after .data/.bss are initialized.
pub fn main() noreturn {
    hardware.init();
    uart.init();
    uart.puts("Hardware initialized\r\n");

    application.init(&app);
    uart.puts("Application initialized\r\n");

    while (true) {
        const did_work = application.run(&app);
        if (!did_work) {
            asm volatile ("wfi");
        }
    }
}

/// SysTick interrupt handler -- increments the application tick counter.
/// Referenced by the vector table in start.zig.
pub fn sysTickHandler() callconv(cc) void {
    application.tick(&app);
}

comptime {
    // Force the vector table to be included by the linker.
    _ = start.vector_table;
    // Pull in compiler-rt atomic stubs for Cortex-M0+.
    _ = @import("atomic.zig");
}
