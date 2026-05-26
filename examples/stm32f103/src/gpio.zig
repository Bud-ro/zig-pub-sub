//! Register-level GPIO driver for STM32F103.
//!
//! The STM32F103 uses the older GPIO peripheral (not the STM32F4-style).
//! Each port has CRL (pins 0-7) and CRH (pins 8-15) configuration registers
//! where each pin occupies 4 bits: 2 MODE bits + 2 CNF bits.
//!
//! Port base addresses:
//!   GPIOA: 0x40010800
//!   GPIOB: 0x40010C00
//!   GPIOC: 0x40011000

const rcc = @import("rcc.zig");

/// GPIO port identifier.
pub const Port = enum(u2) {
    a,
    b,
    c,

    /// Return the base address for a GPIO port.
    fn base(self: Port) u32 {
        return switch (self) {
            .a => 0x40010800,
            .b => 0x40010C00,
            .c => 0x40011000,
        };
    }

    /// Enable the clock for this GPIO port via RCC APB2ENR.
    pub fn enableClock(self: Port) void {
        switch (self) {
            .a => rcc.enableGpioA(),
            .b => rcc.enableGpioB(),
            .c => rcc.enableGpioC(),
        }
    }
};

/// GPIO pin configuration mode (MODE bits).
pub const Mode = enum(u2) {
    /// Input mode (reset state).
    input = 0b00,
    /// Output mode, max speed 10 MHz.
    output_10mhz = 0b01,
    /// Output mode, max speed 2 MHz.
    output_2mhz = 0b10,
    /// Output mode, max speed 50 MHz.
    output_50mhz = 0b11,
};

/// GPIO pin configuration type (CNF bits).
pub const Cnf = enum(u2) {
    /// Output: push-pull. Input: analog.
    push_pull_or_analog = 0b00,
    /// Output: open-drain. Input: floating.
    open_drain_or_floating = 0b01,
    /// Output: alt-func push-pull. Input: pull-up/pull-down.
    alt_push_pull_or_pull = 0b10,
    /// Output: alt-func open-drain. Input: reserved.
    alt_open_drain_or_reserved = 0b11,
};

/// Register offsets from GPIO port base.
const crl_offset: u32 = 0x00;
const crh_offset: u32 = 0x04;
const idr_offset: u32 = 0x08;
const bsrr_offset: u32 = 0x10;
const brr_offset: u32 = 0x14;

/// Configure a pin's mode and type in the appropriate CR register.
pub fn configure(port: Port, pin: u4, mode: Mode, cnf: Cnf) void {
    const port_base = port.base();
    const cr_offset: u32 = if (pin < 8) crl_offset else crh_offset;
    const cr: *volatile u32 = @ptrFromInt(port_base + cr_offset);
    const shift: u5 = @as(u5, pin % 8) * 4;
    const mask: u32 = @as(u32, 0xF) << shift;
    const val: u32 = (@as(u32, @intFromEnum(cnf)) << 2 | @as(u32, @intFromEnum(mode))) << shift;
    cr.* = (cr.* & ~mask) | val;
}

/// Configure a pin as general-purpose push-pull output (10 MHz).
pub fn configureOutput(port: Port, pin: u4) void {
    configure(port, pin, .output_10mhz, .push_pull_or_analog);
}

/// Configure a pin as alternate function push-pull output (10 MHz).
pub fn configureAltOutput(port: Port, pin: u4) void {
    configure(port, pin, .output_10mhz, .alt_push_pull_or_pull);
}

/// Configure a pin as floating input.
pub fn configureInput(port: Port, pin: u4) void {
    configure(port, pin, .input, .open_drain_or_floating);
}

/// Set a pin high via the BSRR register (atomic).
pub fn setPin(port: Port, pin: u4) void {
    const bsrr: *volatile u32 = @ptrFromInt(port.base() + bsrr_offset);
    bsrr.* = @as(u32, 1) << pin;
}

/// Clear a pin low via the BRR register (atomic).
pub fn clearPin(port: Port, pin: u4) void {
    const brr: *volatile u32 = @ptrFromInt(port.base() + brr_offset);
    brr.* = @as(u32, 1) << pin;
}

/// Read the current level of a pin from the IDR register.
pub fn readPin(port: Port, pin: u4) bool {
    const idr: *volatile u32 = @ptrFromInt(port.base() + idr_offset);
    return (idr.* >> pin) & 1 != 0;
}
