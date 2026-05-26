//! Hardware abstraction layer for the RL78/G14 board.
//! Owns GPIO pin assignments and provides a board-specific LED interface.
//! Targets the RL78/G14 Promotion Board where the user LED is on P7.7.

const gpio = @import("gpio.zig");
const uart = @import("uart.zig");

/// P7.7 -- user LED on the RL78/G14 Promotion Board.
const led_port: u3 = 7;
const led_bit: u3 = 7;

/// Configure GPIO pins, UART, and set initial peripheral state.
pub fn init() void {
    gpio.setOutput(led_port, led_bit);
    gpio.clearPin(led_port, led_bit);
    uart.init();
}

/// Drive the onboard LED. Active-high: set pin = on, clear pin = off.
pub fn setLed(on: bool) void {
    if (on) {
        gpio.setPin(led_port, led_bit);
    } else {
        gpio.clearPin(led_port, led_bit);
    }
}
