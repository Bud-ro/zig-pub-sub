//! Minimal UART0 driver for debug output.
//! Writes directly to the UART0 FIFO register at 74880 baud (the rate
//! the ROM bootloader leaves UART0 configured at on boot).

const std = @import("std");

const UART0_FIFO: *volatile u32 = @ptrFromInt(0x60000000);
const UART0_STATUS: *volatile u32 = @ptrFromInt(0x60000004);

/// Write a single byte, blocking until the TX FIFO has space.
pub fn putc(c: u8) void {
    while ((UART0_STATUS.* >> 16) & 0xFF >= 126) {}
    UART0_FIFO.* = c;
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
    if (val == std.math.minInt(i32)) {
        puts("-2147483648");
        return;
    }
    if (val < 0) {
        putc('-');
        dec(@intCast(-val));
    } else {
        dec(@intCast(val));
    }
}
