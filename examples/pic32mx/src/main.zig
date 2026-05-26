//! PIC32MX270F256B firmware entry point.
//! Initializes hardware peripherals, wires up the erd_core application, then
//! enters a bare-metal super-loop that ticks the timer module every millisecond.

const application = @import("application.zig");
const hardware = @import("hardware.zig");
const uart = @import("uart.zig");

var app: application.Application = undefined;

/// Busy-wait delay loop. At 8 MHz FRC each NOP takes ~125 ns, so roughly
/// 8000 iterations per millisecond. This is approximate and sufficient for
/// a bare-metal tick source without a hardware timer.
fn delayMs(ms: u32) void {
    var i: u32 = 0;
    while (i < ms) : (i += 1) {
        var j: u32 = 0;
        while (j < 8000) : (j += 1) {
            asm volatile ("nop");
        }
    }
}

export fn main() void {
    hardware.init();
    uart.puts("PIC32MX270 hardware initialized\r\n");

    application.init(&app);
    uart.puts("erd_core application ready\r\n");

    // Super-loop: tick at ~1 ms intervals
    while (true) {
        application.tick(&app);
        delayMs(1);
    }
}
