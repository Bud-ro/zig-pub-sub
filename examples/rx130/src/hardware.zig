//! Hardware abstraction layer for the RX130 Target Board (RTK5RX1300C00000BR).
//! Owns GPIO pin assignments and provides a board-specific LED interface.

const gpio = @import("gpio.zig");
const uart = @import("uart.zig");

/// P1.6 -- onboard LED on the RX130 Target Board (active-low).
const LED_PORT = gpio.Port.port1; // zlinter-disable-current-line declaration_naming
const LED_BIT: u3 = 6; // zlinter-disable-current-line declaration_naming

/// Configure GPIO pins, UART, and set initial peripheral state.
pub fn init() void {
    // Unlock register protection for clock/module-stop writes
    gpio.unlockProtection();

    // Set P1.6 as GPIO output for LED
    gpio.setGpioOutput(LED_PORT, LED_BIT);
    gpio.setPin(LED_PORT, LED_BIT); // LED off (active-low)

    // Initialize UART for debug output
    uart.init();
}

/// Drive the onboard LED. The LED is active-low: clear pin = on, set pin = off.
pub fn setLed(on: bool) void {
    if (on) {
        gpio.clearPin(LED_PORT, LED_BIT);
    } else {
        gpio.setPin(LED_PORT, LED_BIT);
    }
}
