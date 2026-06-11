//! Hardware abstraction layer for the STC89C52RC board.
//! Owns GPIO pin assignments and provides a board-specific LED interface.
//! Most STC dev boards wire an LED to P1.0 (active-low).

const gpio = @import("gpio.zig");

/// P1 bit index for the onboard LED.
const led_bit: u3 = 0;

/// Configure GPIO pins and set initial peripheral state.
/// P1 defaults to all-high (quasi-bidirectional), so the LED starts off.
pub fn init() void {
    gpio.setP1Bit(led_bit);
}

/// Drive the onboard LED. The LED is active-low: clear bit = on, set bit = off.
pub fn setLed(on: bool) void {
    if (on) {
        gpio.clearP1Bit(led_bit);
    } else {
        gpio.setP1Bit(led_bit);
    }
}
