//! Hardware abstraction layer for the PIC32MX270F256B.
//! Owns pin assignments and provides a board-specific LED interface.
//! Targets the PIC32MX270 Curiosity board with LED on RB5 (active-high).

const gpio = @import("gpio.zig");
const uart = @import("uart.zig");

/// RB5 -- onboard LED on PIC32MX270 Curiosity (active-high).
const LED_PIN: u5 = 5; // zlinter-disable-current-line declaration_naming

/// Configure GPIO pins, disable watchdog, and initialize UART.
pub fn init() void {
    // Disable watchdog timer (clear ON bit in WDTCON)
    const wdtcon_clr: *volatile u32 = @ptrFromInt(0xBF800804);
    wdtcon_clr.* = 0x8000;

    // Configure LED pin as output on PORTB
    gpio.setOutputB(LED_PIN);
    gpio.clearPinB(LED_PIN);

    // Initialize UART1 for debug output
    uart.init();
}

/// Drive the onboard LED. Active-high: set pin = on, clear pin = off.
pub fn setLed(on: bool) void {
    if (on) {
        gpio.setPinB(LED_PIN);
    } else {
        gpio.clearPinB(LED_PIN);
    }
}
