//! Minimal USART2 driver for debug output on the Nucleo-L073RZ.
//! USART2 TX (PA2) is connected to the ST-Link virtual COM port.
//! Configured for 115200 baud at 16 MHz HSI16.

// zlinter-disable declaration_naming - hardware register names follow STM32 convention
const USART2_CR1: *volatile u32 = @ptrFromInt(0x40004400);
const USART2_BRR: *volatile u32 = @ptrFromInt(0x4000440C);
const USART2_ISR: *volatile u32 = @ptrFromInt(0x4000441C);
const USART2_TDR: *volatile u32 = @ptrFromInt(0x40004428);
// zlinter-enable declaration_naming

/// Initialize USART2: 115200 baud, 8N1, TX only.
/// Must be called after RCC has enabled the USART2 clock and PA2 is configured.
pub fn init() void {
    USART2_BRR.* = 139; // 16000000 / 115200 ~= 139
    USART2_CR1.* = (1 << 0) | (1 << 3); // UE + TE
}

/// Write a single byte, blocking until the TX register is empty.
pub fn putc(c: u8) void {
    while (USART2_ISR.* & (1 << 7) == 0) {} // Wait for TXE
    USART2_TDR.* = c;
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
