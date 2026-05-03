//! Register-level GPIO driver for ESP8266.
//! Handles pin mux configuration (function select + pullup) and basic
//! digital I/O. Pin mux addresses and function numbers vary per pin —
//! see ESP8266 Technical Reference, Chapter 5.

// zlinter-disable declaration_naming - hardware register names follow ESP8266 convention
const GPIO_OUT_W1TS: *volatile u32 = @ptrFromInt(0x60000304);
const GPIO_OUT_W1TC: *volatile u32 = @ptrFromInt(0x60000308);
const GPIO_ENABLE_W1TS: *volatile u32 = @ptrFromInt(0x60000310);
const GPIO_ENABLE_W1TC: *volatile u32 = @ptrFromInt(0x60000314);
const GPIO_IN: *volatile u32 = @ptrFromInt(0x60000318);

const FUNC_MASK: u32 = (1 << 4) | (0x3 << 8);
// zlinter-enable declaration_naming

const mux_addrs = [16]u32{
    0x60000834, // GPIO0
    0x60000844, // GPIO1 (U0TXD)
    0x60000838, // GPIO2
    0x60000840, // GPIO3 (U0RXD)
    0x6000083c, // GPIO4
    0x60000828, // GPIO5
    0x60000824, // GPIO6 (flash)
    0x60000820, // GPIO7 (flash)
    0x6000081c, // GPIO8 (flash)
    0x60000830, // GPIO9 (flash)
    0x6000082c, // GPIO10 (flash)
    0x60000818, // GPIO11 (flash)
    0x60000804, // GPIO12 (MTDI)
    0x60000808, // GPIO13 (MTCK)
    0x6000080c, // GPIO14 (MTMS)
    0x60000810, // GPIO15 (MTDO)
};

// GPIO function number per pin (varies by pin)
const gpio_funcs = [16]u32{
    0, // GPIO0: func 0
    3, // GPIO1: func 3
    0, // GPIO2: func 0
    3, // GPIO3: func 3
    0, // GPIO4: func 0
    0, // GPIO5: func 0
    0, 0, 0, 0, 0, 0, // GPIO6-11: flash, don't use
    3, // GPIO12: func 3
    3, // GPIO13: func 3
    3, // GPIO14: func 3
    3, // GPIO15: func 3
};

/// Configure a pin's mux register to GPIO function with pullup enabled.
/// Each ESP8266 pin has a different function number for GPIO mode;
/// the mapping is encoded in `gpio_funcs`. FUNC select bits: bit 4 (low),
/// bits 8-9 (high). Bit 7 enables the internal pullup.
pub fn set_gpio_func(pin: u5) void {
    if (pin >= 16) return;
    const mux: *volatile u32 = @ptrFromInt(mux_addrs[pin]);
    var val = mux.* & ~FUNC_MASK;
    const func = gpio_funcs[pin];
    val |= (func & 1) << 4;
    val |= ((func >> 1) & 3) << 8;
    val |= (1 << 7); // enable pullup
    mux.* = val;
}

pub fn read_mux(pin: u5) u32 {
    if (pin >= 16) return 0;
    const mux: *volatile u32 = @ptrFromInt(mux_addrs[pin]);
    return mux.*;
}

pub fn set_output(pin: u5) void {
    GPIO_ENABLE_W1TS.* = @as(u32, 1) << pin;
}

pub fn set_input(pin: u5) void {
    GPIO_ENABLE_W1TC.* = @as(u32, 1) << pin;
}

pub fn set_pin(pin: u5) void {
    GPIO_OUT_W1TS.* = @as(u32, 1) << pin;
}

pub fn clear_pin(pin: u5) void {
    GPIO_OUT_W1TC.* = @as(u32, 1) << pin;
}

pub fn read_pin(pin: u5) bool {
    return (GPIO_IN.* >> pin) & 1 != 0;
}
