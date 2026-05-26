//! Minimal UART0 driver for RP2040 debug output.
//!
//! Configures UART0 at 115200 baud using the ring oscillator (~6.5MHz).
//! TX pin: GPIO0 (physical pin 1), function 2 (UART).
//!
//! Baud rate calculation (ring oscillator at ~6.5MHz):
//!   divisor = 6500000 / (16 * 115200) = 3.526
//!   IBRD = 3, FBRD = round(0.526 * 64) = 34

// zlinter-disable declaration_naming - hardware register names follow RP2040 datasheet

// --- Subsystem reset ---
const RESETS_BASE: u32 = 0x4000C000;
const RESETS_RESET: *volatile u32 = @ptrFromInt(RESETS_BASE + 0x00);
const RESETS_RESET_DONE: *volatile u32 = @ptrFromInt(RESETS_BASE + 0x08);
const RESET_UART0: u32 = 1 << 22;

// --- IO_BANK0 for UART pin mux ---
const IO_BANK0_BASE: u32 = 0x40014000;

// --- UART0 registers ---
const UART0_BASE: u32 = 0x40034000;
const UARTDR: *volatile u32 = @ptrFromInt(UART0_BASE + 0x000);
const UARTFR: *volatile u32 = @ptrFromInt(UART0_BASE + 0x018);
const UARTIBRD: *volatile u32 = @ptrFromInt(UART0_BASE + 0x024);
const UARTFBRD: *volatile u32 = @ptrFromInt(UART0_BASE + 0x028);
const UARTLCR_H: *volatile u32 = @ptrFromInt(UART0_BASE + 0x02C);
const UARTCR: *volatile u32 = @ptrFromInt(UART0_BASE + 0x030);

// zlinter-enable declaration_naming

/// Initialize UART0 for TX at 115200 baud, 8N1.
/// Releases UART0 from reset, configures GPIO0 as UART TX,
/// and sets baud rate registers for the ring oscillator clock.
pub fn init() void {
    // Release UART0 from reset
    RESETS_RESET.* &= ~RESET_UART0;
    while (RESETS_RESET_DONE.* & RESET_UART0 == 0) {}

    // Configure GPIO0 for UART function (function 2)
    const gpio0_ctrl: *volatile u32 = @ptrFromInt(IO_BANK0_BASE + 0x04);
    gpio0_ctrl.* = 2; // FUNCSEL = UART

    // Disable UART before configuration
    UARTCR.* = 0;

    // Set baud rate: IBRD=3, FBRD=34 for ~115200 at 6.5MHz rosc
    UARTIBRD.* = 3;
    UARTFBRD.* = 34;

    // 8 data bits, FIFO enabled, no parity, 1 stop bit
    // bit 4 = FEN (FIFO enable), bits [6:5] = WLEN (11 = 8 bits)
    UARTLCR_H.* = (0x3 << 5) | (1 << 4);

    // Enable UART, TX only
    // bit 0 = UARTEN, bit 8 = TXE
    UARTCR.* = (1 << 0) | (1 << 8);
}

/// Write a single byte, blocking until the TX FIFO has space.
/// Polls the TXFF (TX FIFO full) flag in the UARTFR register.
pub fn putc(c: u8) void {
    // UARTFR bit 5 = TXFF (TX FIFO full)
    while (UARTFR.* & (1 << 5) != 0) {}
    UARTDR.* = c;
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
