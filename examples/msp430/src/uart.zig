//! Minimal USCI_A0 UART driver for MSP430G2553.
//! Configured for 9600 baud at 1 MHz SMCLK. TX on P1.2.

const gpio = @import("gpio.zig");

// zlinter-disable declaration_naming - hardware register names follow TI convention

/// USCI_A0 control register 0.
const UCA0CTL0: *volatile u8 = @ptrFromInt(0x0060);
/// USCI_A0 control register 1.
const UCA0CTL1: *volatile u8 = @ptrFromInt(0x0061);
/// USCI_A0 baud rate control register 0 (low byte).
const UCA0BR0: *volatile u8 = @ptrFromInt(0x0062);
/// USCI_A0 baud rate control register 1 (high byte).
const UCA0BR1: *volatile u8 = @ptrFromInt(0x0063);
/// USCI_A0 modulation control register.
const UCA0MCTL: *volatile u8 = @ptrFromInt(0x0064);
/// USCI_A0 TX buffer.
const UCA0TXBUF: *volatile u8 = @ptrFromInt(0x0067);
/// Interrupt flag register 2 (bit 1 = UCA0TXIFG).
const IFG2: *volatile u8 = @ptrFromInt(0x0003);

/// UCSWRST bit in UCA0CTL1.
const UCSWRST: u8 = 0x01;
/// UCSSEL_SMCLK: select SMCLK as USCI clock source.
const UCSSEL_SMCLK: u8 = 0x80;
/// UCA0TXIFG bit in IFG2.
const UCA0TXIFG: u8 = 0x02;

// zlinter-enable declaration_naming

/// Initialize USCI_A0 for 9600 baud UART TX at 1 MHz SMCLK.
pub fn init() void {
    // Hold USCI in reset while configuring
    UCA0CTL1.* |= UCSWRST;

    // Select SMCLK as clock source
    UCA0CTL1.* = UCSSEL_SMCLK | UCSWRST;
    UCA0CTL0.* = 0; // 8N1, UART mode

    // 9600 baud from 1 MHz: N = 1000000/9600 = 104.17
    // UCA0BR = 104, UCBRS = 1 (modulation)
    UCA0BR0.* = 104;
    UCA0BR1.* = 0;
    UCA0MCTL.* = 0x02; // UCBRS = 1

    // Configure P1.2 as USCI TX
    gpio.selectPeripheral(2);

    // Release USCI from reset
    UCA0CTL1.* &= ~UCSWRST;
}

/// Write a single byte, blocking until the TX buffer is ready.
pub fn putc(c: u8) void {
    while (IFG2.* & UCA0TXIFG == 0) {}
    UCA0TXBUF.* = c;
}

/// Write a string to UART.
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
