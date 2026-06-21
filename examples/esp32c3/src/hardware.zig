//! Hardware abstraction layer for the ESP32-C3 board.
//! Owns GPIO pin assignments and provides a board-specific LED interface.
//! The DevKitM-1 has an addressable RGB LED on GPIO8.

const gpio = @import("gpio.zig");

/// GPIO8 -- onboard LED on ESP32-C3-DevKitM-1.
const LED_PIN: u5 = 8; // zlinter-disable-current-line declaration_naming

/// Configure GPIO pins and set initial peripheral state.
pub fn init() void {
    gpio.configureOutput(LED_PIN);
    gpio.clearPin(LED_PIN);
}

/// Drive the onboard LED. Active-high on most ESP32-C3-DevKitM boards.
pub fn setLed(on: bool) void {
    if (on) {
        gpio.setPin(LED_PIN);
    } else {
        gpio.clearPin(LED_PIN);
    }
}
