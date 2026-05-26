//! Minimal SERCOM5 USART driver for debug output on the Adafruit Metro M4.
//! Uses PA22 (TX, pad 0) and PA23 (RX, pad 1) at 115200 baud with polling TX.
//! SERCOM5 is the peripheral behind the Metro M4 TX/RX header pins.

const gpio = @import("gpio.zig");

// zlinter-disable declaration_naming - hardware register names follow SAMD51 convention

/// GCLK peripheral base address.
const GCLK_BASE: u32 = 0x40001C00;
/// GCLK_PCHCTRL register array (one per peripheral channel).
const GCLK_PCHCTRL_BASE: u32 = GCLK_BASE + 0x80;
/// SERCOM5 core clock channel index.
const SERCOM5_GCLK_ID: u32 = 35;

/// MCLK peripheral base address.
const MCLK_BASE: u32 = 0x40000800;
/// APB bus D mask register (SERCOM4/5 live on APB-D).
const MCLK_APBDMASK: *volatile u32 = @ptrFromInt(MCLK_BASE + 0x20);

/// SERCOM5 base address.
const SERCOM5_BASE: u32 = 0x43000400;

/// USART CTRLA register.
const SERCOM5_CTRLA: *volatile u32 = @ptrFromInt(SERCOM5_BASE + 0x00);
/// USART CTRLB register.
const SERCOM5_CTRLB: *volatile u32 = @ptrFromInt(SERCOM5_BASE + 0x04);
/// USART BAUD register.
const SERCOM5_BAUD: *volatile u16 = @ptrFromInt(SERCOM5_BASE + 0x0C);
/// USART INTFLAG register.
const SERCOM5_INTFLAG: *volatile u8 = @ptrFromInt(SERCOM5_BASE + 0x18);
/// USART DATA register.
const SERCOM5_DATA: *volatile u16 = @ptrFromInt(SERCOM5_BASE + 0x28);
/// USART SYNCBUSY register.
const SERCOM5_SYNCBUSY: *volatile u32 = @ptrFromInt(SERCOM5_BASE + 0x1C);

// zlinter-enable declaration_naming

const PA22: gpio.Pin = .{ .group = .a, .pin = 22 }; // zlinter-disable-current-line declaration_naming
const PA23: gpio.Pin = .{ .group = .a, .pin = 23 }; // zlinter-disable-current-line declaration_naming

/// Wait until SERCOM5 synchronization is complete.
fn waitSync() void {
    while (SERCOM5_SYNCBUSY.* != 0) {}
}

/// Initialize SERCOM5 in USART mode at 115200 baud (48 MHz GCLK0).
pub fn init() void {
    // Enable SERCOM5 bus clock (APB-D, bit 0 = SERCOM4, bit 1 = SERCOM5)
    MCLK_APBDMASK.* = MCLK_APBDMASK.* | (1 << 1);

    // Connect GCLK0 (48 MHz DFLL) to SERCOM5 core clock
    const pchctrl: *volatile u32 = @ptrFromInt(GCLK_PCHCTRL_BASE + SERCOM5_GCLK_ID * 4);
    pchctrl.* = (1 << 6) | 0; // CHEN=1, GEN=0

    // Configure PA22 as SERCOM5 pad 0 (TX) - peripheral function C (0x02)
    gpio.setPmux(PA22, 0x03);
    gpio.enablePmux(PA22);

    // Configure PA23 as SERCOM5 pad 1 (RX) - peripheral function C (0x02)
    gpio.setPmux(PA23, 0x03);
    gpio.enablePmux(PA23);

    // Disable SERCOM5 before configuring
    SERCOM5_CTRLA.* = 0;
    waitSync();

    // CTRLA: MODE=1 (USART internal clock), RXPO=1 (pad 1), TXPO=0 (pad 0),
    // DORD=1 (LSB first)
    const ctrla: u32 = (1 << 2) | // MODE[2:0] = 1 (internal clock USART)
        (1 << 20) | // RXPO = pad 1
        (0 << 16) | // TXPO = pad 0
        (1 << 30); // DORD = LSB first
    SERCOM5_CTRLA.* = ctrla;
    waitSync();

    // BAUD: 65536 * (1 - 16 * 115200 / 48000000) = 63019
    SERCOM5_BAUD.* = 63019;

    // CTRLB: TXEN=1, RXEN=1, CHSIZE=0 (8 bit)
    SERCOM5_CTRLB.* = (1 << 16) | (1 << 17);
    waitSync();

    // Enable SERCOM5
    SERCOM5_CTRLA.* = SERCOM5_CTRLA.* | (1 << 1);
    waitSync();
}

/// Write a single byte, blocking until the TX data register is empty.
pub fn putc(c: u8) void {
    while (SERCOM5_INTFLAG.* & 0x01 == 0) {}
    SERCOM5_DATA.* = c;
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
