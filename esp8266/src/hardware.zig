//! Hardware abstraction layer for the ESP8266 board.
//! Owns GPIO pin assignments and provides a board-specific LED interface.

const gpio = @import("gpio.zig");

/// GPIO2 — built-in blue LED on most ESP-12F modules (active-low).
const LED_PIN: u5 = 2;

/// Configure GPIO pins and set initial peripheral state.
pub fn init() void {
    gpio.set_gpio_func(LED_PIN);
    gpio.set_output(LED_PIN);
    gpio.set_pin(LED_PIN);
}

/// Drive the onboard LED. The LED is active-low: clear pin = on, set pin = off.
pub fn set_led(on: bool) void {
    if (on) {
        gpio.clear_pin(LED_PIN);
    } else {
        gpio.set_pin(LED_PIN);
    }
}
