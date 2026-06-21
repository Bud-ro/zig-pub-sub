//! Hardware abstraction layer for the nRF52840-DK board.
//! Owns GPIO pin assignments and provides a board-specific LED interface.

const gpio = @import("gpio.zig");

/// LED1 on the nRF52840-DK is connected to P0.13 (active-low).
const LED_PIN: u5 = 13; // zlinter-disable-current-line declaration_naming

/// Configure GPIO pins and set initial peripheral state.
pub fn init() void {
    gpio.configOutput(LED_PIN);
    gpio.setPin(LED_PIN); // LED off (active-low)
}

/// Drive the onboard LED1. The LED is active-low: clear pin = on, set pin = off.
pub fn setLed(on: bool) void {
    if (on) {
        gpio.clearPin(LED_PIN);
    } else {
        gpio.setPin(LED_PIN);
    }
}
