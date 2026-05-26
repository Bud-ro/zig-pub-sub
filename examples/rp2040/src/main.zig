//! RP2040 firmware entry point.
//!
//! Initializes hardware peripherals and the erd_core application layer,
//! then enters the run-to-completion main loop. Called from the reset
//! handler in start.zig after .data/.bss initialization.

const application = @import("application.zig");
const hardware = @import("hardware.zig");
const uart = @import("uart.zig");

var app: application.Application = undefined;

/// Initialize hardware and erd_core, then run the main loop forever.
pub fn main() noreturn {
    hardware.init();
    uart.puts("RP2040 hardware initialized\r\n");

    application.init(&app);
    uart.puts("erd_core application ready\r\n");

    while (true) {
        application.run(&app);
    }
}
