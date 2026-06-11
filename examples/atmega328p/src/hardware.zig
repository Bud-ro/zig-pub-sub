//! Hardware abstraction layer for the Arduino Uno (ATmega328P).
//! Owns GPIO pin assignments and provides a board-specific LED interface.

const gpio = @import("gpio.zig");

/// PB5 -- onboard LED on the Arduino Uno (pin 13, active-high).
const LED_PIN: gpio.Pin = .{ .port = .b, .bit = 5 }; // zlinter-disable-current-line declaration_naming

/// Configure GPIO pins and set initial peripheral state.
pub fn init() void {
    gpio.setOutput(LED_PIN);
    gpio.clearPin(LED_PIN);
}

/// Drive the onboard LED. Active-high: set pin = on, clear pin = off.
pub fn setLed(on: bool) void {
    if (on) {
        gpio.setPin(LED_PIN);
    } else {
        gpio.clearPin(LED_PIN);
    }
}
