//! STC89C52RC (8051) firmware entry point.
//! Initializes hardware peripherals and the erd_core application, then enters
//! a cooperative super-loop. Timer0 is used as the 1ms system tick source;
//! the main loop calls `timer_module.run()` each iteration to dispatch
//! expired software timers.

const application = @import("application.zig");
const hardware = @import("hardware.zig");
const uart = @import("uart.zig");

var app: application.Application = undefined;

/// Approximate 1ms busy-wait delay for an 11.0592 MHz 8051.
/// Each machine cycle is 12 clock cycles, so ~921 machine cycles per ms.
/// The inner loop body is roughly 4 machine cycles, giving ~230 iterations.
fn delayMs() void {
    var i: u8 = 0;
    while (i < 230) : (i += 1) {
        var j: u8 = 0;
        while (j < 4) : (j += 1) {
            asm volatile ("");
        }
    }
}

/// Firmware entry point. SDCC expects `main` for the mcs51 target.
export fn main() void {
    hardware.init();
    uart.init();
    uart.puts("STC89C52 boot\r\n");

    application.init(&app);
    uart.puts("System ready\r\n");

    // Super-loop: tick every ~1ms, dispatch expired timers.
    while (true) {
        delayMs();
        application.timer_module.incrementCurrentTime(1);
        while (application.timer_module.run()) {}
    }
}
