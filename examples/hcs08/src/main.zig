//! MC9S08QE8 (HCS08) firmware entry point.
//! Initializes hardware (COP disable, GPIO, UART), sets up the erd_core
//! application layer, then enters a simple super-loop that ticks the
//! timer module at approximately 1ms intervals via a busy-wait delay.

const application = @import("application.zig");
const hardware = @import("hardware.zig");
const uart = @import("uart.zig");

var app: application.Application = undefined;

/// Volatile sink to prevent the optimizer from removing busy-wait loops.
/// Written through a volatile pointer so the C backend emits a real store.
var delay_sink: u16 = 0;

/// Rough busy-wait delay. At 4 MHz bus clock each iteration is a few
/// cycles; this is tuned for approximately 1ms per call. Exact timing
/// is not critical -- the LED blink and uptime counter are best-effort.
fn delayMs(ms: u16) void {
    const sink: *volatile u16 = &delay_sink;
    var i: u16 = 0;
    while (i < ms) : (i += 1) {
        var j: u16 = 0;
        while (j < 400) : (j += 1) {
            sink.* = j;
        }
    }
}

export fn main() void {
    hardware.init();
    uart.puts("HCS08 init\r\n");

    application.init(&app);
    uart.puts("System ready\r\n");

    // Super-loop: tick the timer module at ~1ms intervals
    while (true) {
        application.tick();
        delayMs(1);
    }
}
