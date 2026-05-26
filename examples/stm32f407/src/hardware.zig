//! Hardware abstraction layer for the STM32F407 Discovery board.
//! The Discovery has four user LEDs on port D, active-HIGH:
//!   PD12 (green), PD13 (orange), PD14 (red), PD15 (blue).
//! PD12 is the primary blink LED.

const gpio = @import("gpio.zig");
const rcc = @import("rcc.zig");
const uart = @import("uart.zig");

/// Green user LED on PD12.
pub const led_green: u4 = 12;
/// Orange user LED on PD13.
pub const led_orange: u4 = 13;
/// Red user LED on PD14.
pub const led_red: u4 = 14;
/// Blue user LED on PD15.
pub const led_blue: u4 = 15;

/// Primary blink LED (green, PD12).
const primary_led: u4 = led_green;

/// Configure GPIO pins, UART, and set initial peripheral state.
pub fn init() void {
    // Enable GPIOD clock for LEDs.
    rcc.enableAhb1(rcc.GPIODEN);

    // Configure all four LED pins as push-pull outputs.
    gpio.configOutput(.d, led_green);
    gpio.configOutput(.d, led_orange);
    gpio.configOutput(.d, led_red);
    gpio.configOutput(.d, led_blue);

    // All LEDs off at startup.
    gpio.clearPin(.d, led_green);
    gpio.clearPin(.d, led_orange);
    gpio.clearPin(.d, led_red);
    gpio.clearPin(.d, led_blue);

    uart.init();
}

/// Drive the primary (green) LED. Active-HIGH: set pin = on, clear pin = off.
pub fn setLed(on: bool) void {
    gpio.writePin(.d, primary_led, on);
}
