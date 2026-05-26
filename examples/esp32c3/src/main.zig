//! ESP32-C3 bare-metal firmware entry point.
//! Initializes hardware and the erd_core application, then enters the
//! super-loop which polls the SYSTIMER for tick-based scheduling.

const application = @import("application.zig");
const hardware = @import("hardware.zig");
const start = @import("start.zig");
const uart = @import("uart.zig");

var app: application.Application = undefined;

comptime {
    // Force the linker to include the _start entry point from start.zig
    _ = &start;
}

/// Initialize hardware and application, then enter the super-loop.
pub fn main() noreturn {
    hardware.init();
    uart.puts("ESP32-C3 hardware initialized\r\n");

    application.init(&app);
    uart.puts("Application initialized\r\n");

    application.run();
}
