//! SAMD51 (Adafruit Metro M4) firmware entry point.
//! Initializes hardware and the erd_core application, configures the SysTick
//! timer for a 1 ms tick, then enters an idle loop (all work is driven by
//! the SysTick interrupt).

const application = @import("application.zig");
const hardware = @import("hardware.zig");
const uart = @import("uart.zig");

comptime {
    _ = @import("start.zig");
}

// zlinter-disable declaration_naming - ARM core register names
/// SysTick Control and Status Register.
const SYST_CSR: *volatile u32 = @ptrFromInt(0xE000E010);
/// SysTick Reload Value Register.
const SYST_RVR: *volatile u32 = @ptrFromInt(0xE000E014);
/// SysTick Current Value Register.
const SYST_CVR: *volatile u32 = @ptrFromInt(0xE000E018);
// zlinter-enable declaration_naming

var app: application.Application = undefined;

/// Configure SysTick for 1 ms interrupts at 48 MHz.
fn initSysTick() void {
    // Reload value: 48_000_000 / 1000 - 1 = 47999
    SYST_RVR.* = 47999;
    SYST_CVR.* = 0;
    // Enable SysTick: processor clock, interrupt, enable
    SYST_CSR.* = (1 << 2) | (1 << 1) | (1 << 0);
}

/// SysTick interrupt handler -- ticks the application timer module.
pub fn SysTick_Handler() void { // zlinter-disable-current-line function_naming
    application.tick();
}

/// Firmware entry point called by Reset_Handler after .data/.bss init.
pub fn main() noreturn {
    hardware.init();
    uart.init();
    uart.puts("Hardware initialized\r\n");

    application.init(&app);
    uart.puts("Application ready\r\n");

    initSysTick();

    // Idle loop -- all work is interrupt-driven via SysTick
    while (true) {
        asm volatile ("wfi");
    }
}
