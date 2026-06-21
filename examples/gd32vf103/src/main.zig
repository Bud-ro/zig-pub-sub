//! GD32VF103 (Longan Nano) firmware entry point.
//! Initializes hardware peripherals and the erd_core application, then enters
//! a tick-based super-loop that drives the timer scheduler. Each iteration
//! advances the tick counter by 1ms using a busy-wait delay.

const application = @import("application.zig");
const hardware = @import("hardware.zig");
const start = @import("start.zig");
const uart = @import("uart.zig");

var app: application.Application = undefined;

/// Crude busy-wait delay calibrated for ~1ms at the 8MHz default IRC8M clock.
/// At 8MHz each instruction takes ~125ns; a loop iteration with a volatile
/// decrement compiles to roughly 4 instructions = ~500ns, so ~2000 iterations
/// gives approximately 1ms.
fn delayMs(ms: u32) void {
    var i: u32 = 0;
    while (i < ms) : (i += 1) {
        var count: u32 = 2000;
        while (count > 0) : (count -= 1) {
            asm volatile ("");
        }
    }
}

comptime {
    // Force the linker to include the _start entry point from start.zig
    _ = &start;
}

/// Initialize hardware and erd_core application, then run the super-loop.
pub fn main() void {
    hardware.init();
    uart.init();
    uart.puts("GD32VF103 hardware initialized\r\n");

    application.init(&app);
    uart.puts("erd_core application ready\r\n");

    // Super-loop: tick the timer module at ~1ms intervals
    while (true) {
        application.tick();
        delayMs(1);
    }
}
