//! Hardware abstraction layer for the Adafruit Metro M4 board.
//! Owns GPIO pin assignments and provides a board-specific LED interface.

const gpio = @import("gpio.zig");

/// PA16 -- onboard red LED on Adafruit Metro M4 (active-high).
const LED_PIN: gpio.Pin = .{ .group = .a, .pin = 16 }; // zlinter-disable-current-line declaration_naming

/// Configure GPIO pins and set initial peripheral state.
pub fn init() void {
    gpio.setOutput(LED_PIN);
    gpio.clearPin(LED_PIN);
}

/// Drive the onboard LED. The LED is active-high: set pin = on, clear pin = off.
pub fn setLed(on: bool) void {
    if (on) {
        gpio.setPin(LED_PIN);
    } else {
        gpio.clearPin(LED_PIN);
    }
}
