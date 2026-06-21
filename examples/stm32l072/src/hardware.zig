//! Hardware abstraction layer for the Nucleo-L073RZ board.
//! Owns GPIO pin assignments, clock setup, SysTick configuration, and
//! provides a board-specific LED interface.

const gpio = @import("gpio.zig");

// -- RCC registers --
// zlinter-disable declaration_naming - hardware register names follow STM32 convention
const RCC_CR: *volatile u32 = @ptrFromInt(0x40021000);
const RCC_CFGR: *volatile u32 = @ptrFromInt(0x4002100C);
const RCC_IOPENR: *volatile u32 = @ptrFromInt(0x4002102C);
const RCC_APB1ENR: *volatile u32 = @ptrFromInt(0x40021038);

// -- SysTick registers (ARM core, not STM32-specific) --
const SYST_CSR: *volatile u32 = @ptrFromInt(0xE000E010);
const SYST_RVR: *volatile u32 = @ptrFromInt(0xE000E014);
const SYST_CVR: *volatile u32 = @ptrFromInt(0xE000E018);
// zlinter-enable declaration_naming

/// Nucleo-L073RZ user LED: PA5 (LD2, active-high).
const led_port = gpio.Port.a;
const led_pin: u4 = 5;

/// Configure clocks, GPIO, UART, and SysTick.
pub fn init() void {
    // Switch system clock to HSI16 (16 MHz internal RC)
    RCC_CR.* |= (1 << 0); // HSI16ON
    while (RCC_CR.* & (1 << 2) == 0) {} // Wait for HSI16RDY
    RCC_CFGR.* = (RCC_CFGR.* & ~@as(u32, 0x3)) | 0x01; // SW = HSI16

    // Enable GPIOA clock
    RCC_IOPENR.* |= (1 << 0); // IOPAEN

    // Enable USART2 clock
    RCC_APB1ENR.* |= (1 << 17); // USART2EN

    // Configure PA5 as push-pull output for LED
    gpio.setMode(led_port, led_pin, .output);
    gpio.setOutputPushPull(led_port, led_pin);

    // Configure PA2 as USART2_TX (AF4)
    gpio.setMode(.a, 2, .alternate);
    gpio.setAlternateFunction(.a, 2, 4);

    // Configure SysTick for 1ms tick at 16 MHz
    // Reload value = 16000000 / 1000 - 1 = 15999
    SYST_RVR.* = 15999;
    SYST_CVR.* = 0;
    // Enable SysTick with processor clock and interrupt
    SYST_CSR.* = (1 << 0) | (1 << 1) | (1 << 2);
}

/// Drive the onboard LED. PA5 is active-high: set = on, clear = off.
pub fn setLed(on: bool) void {
    if (on) {
        gpio.setPin(led_port, led_pin);
    } else {
        gpio.clearPin(led_port, led_pin);
    }
}
