//! RL78/G14 firmware entry point.
//! Provides the reset handler (_start) which initializes .data and .bss,
//! configures hardware peripherals, and enters the erd_core run-to-completion
//! super-loop. The RL78 has no OS -- the main loop ticks the timer module
//! and sleeps (HALT) when there is no work.

const application = @import("application.zig");
const hardware = @import("hardware.zig");
const uart = @import("uart.zig");

var app: application.Application = undefined;

/// C runtime initialization and main loop.
/// The linker script places this at the reset vector entry point.
export fn _start() callconv(.c) noreturn { // zlinter-disable-current-line function_naming
    // Copy .data from flash to RAM
    const data_start: [*]u8 = @ptrFromInt(@intFromPtr(&@extern(*u8, .{ .name = "_data_start" })));
    const data_end: [*]u8 = @ptrFromInt(@intFromPtr(&@extern(*u8, .{ .name = "_data_end" })));
    const data_load: [*]const u8 = @ptrFromInt(@intFromPtr(&@extern(*const u8, .{ .name = "_data_load" })));
    const data_len = @intFromPtr(data_end) - @intFromPtr(data_start);
    for (0..data_len) |i| {
        data_start[i] = data_load[i];
    }

    // Zero .bss
    const bss_start: [*]u8 = @ptrFromInt(@intFromPtr(&@extern(*u8, .{ .name = "_bss_start" })));
    const bss_end: [*]u8 = @ptrFromInt(@intFromPtr(&@extern(*u8, .{ .name = "_bss_end" })));
    const bss_len = @intFromPtr(bss_end) - @intFromPtr(bss_start);
    for (0..bss_len) |i| {
        bss_start[i] = 0;
    }

    hardware.init();
    uart.puts("RL78/G14 hardware initialized\r\n");

    application.init(&app);
    uart.puts("Application ready\r\n");

    // Super-loop: tick the timer, run pending callbacks, sleep when idle
    while (true) {
        application.tick(&app);
    }
}

/// Default handler for unused interrupt vectors.
export fn _default_handler() callconv(.c) void { // zlinter-disable-current-line function_naming
    // Intentionally empty -- unused interrupt vectors land here and return
}
