//! Hardware abstraction layer for the TI MSP430G2553 LaunchPad.
//! Owns GPIO pin assignments and provides a board-specific LED interface.

const gpio = @import("gpio.zig");

/// Red LED on the LaunchPad is connected to P1.0 (active-high).
const LED_PIN: u3 = 0; // zlinter-disable-current-line declaration_naming

/// Configure GPIO pins and set initial peripheral state.
pub fn init() void {
    gpio.selectGpio(LED_PIN);
    gpio.setOutput(LED_PIN);
    gpio.clearPin(LED_PIN);
}

/// Drive the onboard red LED. Active-high: set pin = on, clear pin = off.
pub fn setLed(on: bool) void {
    if (on) {
        gpio.setPin(LED_PIN);
    } else {
        gpio.clearPin(LED_PIN);
    }
}
