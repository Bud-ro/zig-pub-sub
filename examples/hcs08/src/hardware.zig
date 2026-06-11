//! Hardware abstraction layer for the DEMO9S08QE8 board.
//! Owns GPIO pin assignments and provides a board-specific LED interface.
//! Also handles early chip setup: disabling the COP watchdog and
//! initializing the SCI for debug UART output.

const gpio = @import("gpio.zig");
const uart = @import("uart.zig");

/// PTA0 -- onboard LED on the DEMO9S08QE8 board (active-high).
const LED_PIN: u3 = 0; // zlinter-disable-current-line declaration_naming

/// COP (watchdog) disable via SOPT1 register (write-once after reset).
extern fn sfr_set_sopt1(val: u8) void;

/// Configure chip peripherals and GPIO pins.
/// Must be called early -- SOPT1 is write-once after reset.
pub fn init() void {
    // Disable COP watchdog (SOPT1 bits [7:6] = 00)
    sfr_set_sopt1(0x00);

    // Configure PTA0 as output for the LED
    gpio.setDirectionA(1 << LED_PIN);
    gpio.clearPinA(LED_PIN);

    // Initialize SCI for debug UART
    uart.init();
}

/// Drive the onboard LED. Active-high: set pin = on, clear pin = off.
pub fn setLed(on: bool) void {
    if (on) {
        gpio.setPinA(LED_PIN);
    } else {
        gpio.clearPinA(LED_PIN);
    }
}
