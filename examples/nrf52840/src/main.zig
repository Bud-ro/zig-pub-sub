//! nRF52840-DK firmware entry point.
//! Initializes hardware peripherals and the erd_core application layer,
//! then enters the main run-to-completion loop.

const application = @import("application.zig");
const hardware = @import("hardware.zig");
const uart = @import("uart.zig");

/// Called from the reset handler after .data/.bss initialization.
pub fn main() noreturn {
    hardware.init();
    uart.init();
    uart.puts("nRF52840-DK booted\r\n");

    application.init();
    uart.puts("Application initialized\r\n");

    while (true) {
        application.run();
    }
}
