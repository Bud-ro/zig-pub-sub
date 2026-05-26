//! Minimal UART driver for the 8051 (STC89C52RC).
//! Configures Timer1 as baud-rate generator for 9600 baud at 11.0592 MHz,
//! then provides blocking TX-only output through SBUF.
//! SFR access goes through C accessor functions in sfr_access.c.

/// Initialize UART in mode 1 (8-bit, variable baud).
/// Timer1 mode 2 (8-bit auto-reload) generates 9600 baud at 11.0592 MHz.
///
/// SFR setup performed via C accessors:
///   SCON = 0x40  (mode 1, TX only, REN=0)
///   TMOD = 0x20  (Timer1 mode 2, Timer0 unchanged)
///   TH1  = 0xFD  (9600 baud reload value)
///   TR1  = 1     (start Timer1 via TCON bit 6)
pub fn init() void {
    sfr_uart_init();
}

/// Write a single byte, blocking until the previous transmission completes.
pub fn putc(c: u8) void {
    sfr_uart_putc(c);
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

// --- C extern SFR accessors (defined in sfr_access.c) ---

extern fn sfr_uart_init() void;
extern fn sfr_uart_putc(c: u8) void;
