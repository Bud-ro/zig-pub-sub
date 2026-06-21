//! Minimal USART2 driver for debug output on the STM32F407 Discovery.
//! USART2_TX is PA2 (AF7), which connects to the ST-Link virtual COM port.
//! Configured for 115200 baud at the default 16 MHz HSI clock.

const gpio = @import("gpio.zig");
const rcc = @import("rcc.zig");

// zlinter-disable declaration_naming - hardware register names follow STM32 convention

const USART2_BASE: u32 = 0x40004400;
const USART2_SR: *volatile u32 = @ptrFromInt(USART2_BASE + 0x00);
const USART2_DR: *volatile u32 = @ptrFromInt(USART2_BASE + 0x04);
const USART2_BRR: *volatile u32 = @ptrFromInt(USART2_BASE + 0x08);
const USART2_CR1: *volatile u32 = @ptrFromInt(USART2_BASE + 0x0C);

// zlinter-enable declaration_naming

/// Status register bit: transmit data register empty.
const txe_bit: u32 = 1 << 7;
/// CR1 bit: USART enable.
const ue_bit: u32 = 1 << 13;
/// CR1 bit: transmitter enable.
const te_bit: u32 = 1 << 3;

/// Initialize USART2 for TX-only at 115200 baud (16 MHz HSI).
pub fn init() void {
    // Enable GPIOA and USART2 clocks.
    rcc.enableAhb1(rcc.GPIOAEN);
    rcc.enableApb1(rcc.USART2EN);

    // Configure PA2 as AF7 (USART2_TX).
    gpio.setMode(.a, 2, .alternate);
    gpio.setOutputType(.a, 2, .push_pull);
    gpio.setSpeed(.a, 2, .high);
    gpio.setPull(.a, 2, .up);
    gpio.setAltFunc(.a, 2, 7);

    // 16 MHz / 115200 = 138.89 -> mantissa 8, fraction 11 -> 0x8B.
    USART2_BRR.* = 0x8B;

    // Enable USART with transmitter.
    USART2_CR1.* = ue_bit | te_bit;
}

/// Write a single byte, blocking until the TX data register is empty.
pub fn putc(c: u8) void {
    while (USART2_SR.* & txe_bit == 0) {}
    USART2_DR.* = c;
}

/// Write a string to USART2.
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

/// Write a signed 32-bit integer as decimal.
pub fn sdec(val: i32) void {
    if (val < 0) putc('-');
    dec(@abs(val));
}
