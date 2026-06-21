//! STM32F103 (Blue Pill) firmware entry point.
//!
//! Initializes hardware and the erd_core application, then runs the
//! main super-loop. Called from the reset handler after .data/.bss init.

const application = @import("application.zig");
const hardware = @import("hardware.zig");
const uart = @import("uart.zig");

/// Initialize hardware, application layer, and run the super-loop.
pub fn main() noreturn {
    hardware.init();
    uart.puts("STM32F103 hardware initialized\r\n");

    application.init();
    uart.puts("Application ready\r\n");

    while (true) {
        application.run();
    }
}
