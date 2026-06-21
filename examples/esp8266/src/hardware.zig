//! Hardware abstraction layer for the ESP8266 board.
//! Owns GPIO pin assignments and provides a board-specific LED interface.

const gpio = @import("gpio.zig");

/// GPIO2 — built-in blue LED on most ESP-12F modules (active-low).
const LED_PIN: u5 = 2; // zlinter-disable-current-line declaration_naming

/// Configure GPIO pins and set initial peripheral state.
pub fn init() void {
    gpio.setGpioFunc(LED_PIN);
    gpio.setOutput(LED_PIN);
    gpio.setPin(LED_PIN);
}

/// Drive the onboard LED. The LED is active-low: clear pin = on, set pin = off.
pub fn setLed(on: bool) void {
    if (on) {
        gpio.clearPin(LED_PIN);
    } else {
        gpio.setPin(LED_PIN);
    }
}
