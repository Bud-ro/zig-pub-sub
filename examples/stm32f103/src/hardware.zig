//! Hardware abstraction layer for the STM32F103C8T6 Blue Pill board.
//!
//! Owns GPIO pin assignments and provides a board-specific LED interface.
//! The Blue Pill has a green LED on PC13 (active-low).

const gpio = @import("gpio.zig");
const rcc = @import("rcc.zig");
const uart = @import("uart.zig");

/// PC13 -- on-board green LED on Blue Pill (active-low).
const LED_PIN: u4 = 13; // zlinter-disable-current-line declaration_naming

/// Configure GPIO pins, UART, and set initial peripheral state.
pub fn init() void {
    // Enable clocks for peripherals we use
    rcc.enableGpioC();
    rcc.enableGpioA();
    rcc.enableUsart1();

    // Configure PC13 as push-pull output for the LED
    gpio.configureOutput(.c, LED_PIN);

    // Start with LED off (active-low: set pin high = LED off)
    gpio.setPin(.c, LED_PIN);

    // Initialize UART1 for debug output
    uart.init();
}

/// Drive the onboard LED. The LED is active-low: clear pin = on, set pin = off.
pub fn setLed(on: bool) void {
    if (on) {
        gpio.clearPin(.c, LED_PIN);
    } else {
        gpio.setPin(.c, LED_PIN);
    }
}
