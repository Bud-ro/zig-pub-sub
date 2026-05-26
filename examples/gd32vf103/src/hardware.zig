//! Hardware abstraction layer for the Sipeed Longan Nano board.
//! Owns GPIO pin assignments and provides a board-specific LED interface.
//! The Longan Nano has three LEDs, active-low:
//!   Red:   PC13
//!   Green: PA1
//!   Blue:  PA2
//! This module drives the red LED (PC13) as the primary indicator.

const gpio = @import("gpio.zig");

// zlinter-disable declaration_naming - hardware register names follow GD32VF103 convention

/// RCU APB2 clock enable register.
const RCU_APB2EN: *volatile u32 = @ptrFromInt(0x40021018);

// zlinter-enable declaration_naming

/// Red LED pin: PC13 (active-low).
const LED_PORT = gpio.Port.c; // zlinter-disable-current-line declaration_naming
/// Red LED pin number.
const LED_PIN: u4 = 13; // zlinter-disable-current-line declaration_naming

/// Configure GPIO clocks and LED pin as push-pull output.
pub fn init() void {
    // Enable GPIOC clock (bit 4 = PCEN in RCU APB2EN)
    RCU_APB2EN.* |= (1 << 4);

    // Configure PC13 as push-pull output at 10MHz
    gpio.configurePin(LED_PORT, LED_PIN, .output_10mhz, .push_pull_or_analog);

    // Start with LED off (pin high, since active-low)
    gpio.setPin(LED_PORT, LED_PIN);
}

/// Drive the onboard red LED. Active-low: clear pin = on, set pin = off.
pub fn setLed(on: bool) void {
    if (on) {
        gpio.clearPin(LED_PORT, LED_PIN);
    } else {
        gpio.setPin(LED_PORT, LED_PIN);
    }
}
