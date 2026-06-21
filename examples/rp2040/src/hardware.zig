//! Hardware abstraction layer for the Raspberry Pi Pico board.
//! Owns GPIO pin assignments and provides a board-specific LED interface.
//! The standard Pico has its on-board LED on GPIO25 (active-high).

const gpio = @import("gpio.zig");

/// GPIO25 -- on-board LED on the standard Raspberry Pi Pico (active-high).
const LED_PIN: u5 = 25; // zlinter-disable-current-line declaration_naming

/// Release GPIO subsystems from reset, configure the LED pin, and set
/// initial peripheral state. Must be called before any other GPIO use.
pub fn init() void {
    gpio.initSubsystems();
    gpio.initPin(LED_PIN);
    gpio.setOutput(LED_PIN);
    gpio.clearPin(LED_PIN);
}

/// Drive the on-board LED. Active-high: set pin = on, clear pin = off.
pub fn setLed(on: bool) void {
    if (on) {
        gpio.setPin(LED_PIN);
    } else {
        gpio.clearPin(LED_PIN);
    }
}
