//! Minimal UART0 driver for ESP32-C3 debug output.
//! The ROM bootloader leaves UART0 configured at 115200 baud on GPIO21 (TX).
//! We write directly to the TX FIFO, waiting when it is full.

// zlinter-disable declaration_naming - hardware register names follow ESP32-C3 convention
const UART0_BASE = 0x60000000;
const UART_FIFO_REG: *volatile u32 = @ptrFromInt(UART0_BASE + 0x00);
const UART_STATUS_REG: *volatile u32 = @ptrFromInt(UART0_BASE + 0x1C);
// zlinter-enable declaration_naming

/// Write a single byte, blocking until the TX FIFO has space.
/// TXFIFO_CNT is in bits [7:0] of UART_STATUS_REG. The FIFO depth is 128.
pub fn putc(c: u8) void {
    while (UART_STATUS_REG.* & 0xFF >= 128) {}
    UART_FIFO_REG.* = c;
}

/// Write a string to UART0.
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
