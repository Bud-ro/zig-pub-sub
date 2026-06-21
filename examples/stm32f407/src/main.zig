//! STM32F407 Discovery firmware entry point.
//! Initializes hardware and the erd_core application, then enters a
//! super-loop that ticks the timer module and executes pending callbacks.

const application = @import("application.zig");
const hardware = @import("hardware.zig");
const uart = @import("uart.zig");

// Force the start module to be included so the vector table and
// Reset_Handler are linked into the final binary.
comptime {
    _ = @import("start.zig");
}

var app: application.Application = undefined;

/// Application main, called from Reset_Handler after .data/.bss init.
/// Runs the super-loop: tick the timer, run pending callbacks, then WFI.
pub fn main() noreturn {
    hardware.init();
    uart.puts("STM32F407 hardware initialized\r\n");

    application.init(&app);
    uart.puts("Application ready\r\n");

    // Super-loop: each iteration is one tick (~1ms with SysTick or busy wait).
    // In a full system you would configure SysTick to fire every 1ms and
    // increment the timer from the ISR. For this minimal demo we use a
    // naive busy-wait delay so the firmware runs without any interrupt setup.
    while (true) {
        busyDelayMs(1);
        application.timer_module.incrementCurrentTime(1);
        while (application.timer_module.run()) {}
    }
}

/// Rough busy-wait delay. At 16 MHz HSI each loop iteration is approximately
/// 4 cycles, giving ~4000 iterations per millisecond.
fn busyDelayMs(ms: u32) void {
    const cycles_per_ms: u32 = 4000;
    var count: u32 = ms * cycles_per_ms;
    while (count > 0) : (count -= 1) {
        asm volatile ("nop");
    }
}
