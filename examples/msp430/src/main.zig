//! MSP430G2553 LaunchPad firmware entry point.
//! Initializes hardware and the erd_core application, then enters a
//! run-to-completion super-loop driven by Timer_A as the tick source.

const application = @import("application.zig");
const hardware = @import("hardware.zig");
const start = @import("start.zig");
const uart = @import("uart.zig");

// zlinter-disable declaration_naming - hardware register names follow TI convention

/// Timer_A0 control register.
const TA0CTL: *volatile u16 = @ptrFromInt(0x0160);
/// Timer_A0 counter register.
const TA0R: *volatile u16 = @ptrFromInt(0x0170);
/// DCO frequency control register.
const DCOCTL: *volatile u8 = @ptrFromInt(0x0056);
/// Basic clock system control register 1.
const BCSCTL1: *volatile u8 = @ptrFromInt(0x0057);

/// Factory-calibrated DCO setting for 1 MHz (flash info segment A).
const CALDCO_1MHZ: *const volatile u8 = @ptrFromInt(0x10FE); // zlinter-disable-current-line declaration_naming
/// Factory-calibrated BCSCTL1 setting for 1 MHz (flash info segment A).
const CALBC1_1MHZ: *const volatile u8 = @ptrFromInt(0x10FF); // zlinter-disable-current-line declaration_naming

/// TASSEL_2: select SMCLK as Timer_A clock source.
const TASSEL_2: u16 = 0x0200;
/// MC_2: continuous mode (count up to 0xFFFF).
const MC_2: u16 = 0x0020;
/// TACLR: clear the timer counter.
const TACLR: u16 = 0x0004;

// zlinter-enable declaration_naming

/// Ticks per millisecond at 1 MHz SMCLK.
const TICKS_PER_MS: u16 = 1000; // zlinter-disable-current-line declaration_naming

var app: application.Application = undefined;

/// Firmware entry point, called from start.zig after .bss/.data init.
pub fn main() noreturn {
    // Calibrate DCO to 1 MHz
    BCSCTL1.* = CALBC1_1MHZ.*;
    DCOCTL.* = CALDCO_1MHZ.*;

    hardware.init();
    uart.init();
    uart.puts("MSP430 ready\r\n");

    // Start Timer_A0 in continuous mode from SMCLK (1 MHz)
    TA0CTL.* = TASSEL_2 | MC_2 | TACLR;

    application.init(&app);

    // Super-loop: poll Timer_A for elapsed milliseconds, then run timers
    var last_count: u16 = TA0R.*;
    while (true) {
        const now = TA0R.*;
        // Wrapping subtraction handles 16-bit overflow correctly
        const elapsed = now -% last_count;
        if (elapsed >= TICKS_PER_MS) {
            const ms = elapsed / TICKS_PER_MS;
            last_count +%= ms * TICKS_PER_MS;
            application.timer_module.incrementCurrentTime(ms);
        }
        while (application.timer_module.run()) {}
    }
}

// Force the linker to pull in the vector table and bare-metal runtime
comptime {
    _ = &start.vectors;
    _ = @import("builtins.zig");
}
