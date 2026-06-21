//! Minimal USART1 driver for debug output on the STM32F103.
//!
//! USART1 is on APB2, base address 0x40013800. TX is PA9.
//! Configured for 115200 baud using the 8 MHz HSI default clock.
//! Baud divisor: 8000000 / 115200 = 69.44, rounded to 69 (0x45).

const gpio = @import("gpio.zig");

// zlinter-disable declaration_naming - hardware register names follow ST datasheet

/// USART1 base address.
const USART1_BASE: u32 = 0x40013800;

/// Status register. Bit 7 = TXE (transmit data register empty).
const USART1_SR: *volatile u32 = @ptrFromInt(USART1_BASE + 0x00);

/// Data register.
const USART1_DR: *volatile u32 = @ptrFromInt(USART1_BASE + 0x04);

/// Baud rate register.
const USART1_BRR: *volatile u32 = @ptrFromInt(USART1_BASE + 0x08);

/// Control register 1. Bit 13 = UE, bit 3 = TE, bit 2 = RE.
const USART1_CR1: *volatile u32 = @ptrFromInt(USART1_BASE + 0x0C);

// zlinter-enable declaration_naming

/// Initialize USART1 for TX at 115200 baud (8 MHz HSI clock).
pub fn init() void {
    // Configure PA9 as alternate function push-pull output (USART1_TX)
    gpio.configureAltOutput(.a, 9);

    // Set baud rate: 8 MHz / 115200 = 69.44 -> 69
    USART1_BRR.* = 69;

    // Enable USART and transmitter (UE=1, TE=1)
    USART1_CR1.* = (1 << 13) | (1 << 3);
}

/// Write a single byte, blocking until the TX data register is empty.
pub fn putc(c: u8) void {
    // Wait for TXE (bit 7)
    while (USART1_SR.* & (1 << 7) == 0) {}
    USART1_DR.* = c;
}

/// Write a string to USART1.
pub fn puts(s: []const u8) void {
    for (s) |c| putc(c);
}

/// Write an unsigned 32-bit integer as decimal.
pub fn dec(val: u32) void {
    if (val == 0) {
        putc('0');
        return;
    }
    var buf: [10]u8 = undefined;
    var n = val;
    var i: u8 = 0;
    while (n > 0) : (i += 1) {
        buf[i] = @truncate(n % 10 + '0');
        n /= 10;
    }
    while (i > 0) {
        i -= 1;
        putc(buf[i]);
    }
}
