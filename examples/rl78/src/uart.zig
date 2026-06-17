//! Minimal UART0 TX driver for the Renesas RL78 (SAU0 channel 0).
//! Configures SAU0-CH0 as asynchronous UART transmit at 9600 baud using
//! the 32MHz high-speed on-chip oscillator (HOCO). TX pin is P1.2 (TxD0).
//!
//! This is a polling-only driver -- putc blocks until the shift register
//! is empty before writing the next byte.

/// SAU0 peripheral enable (PER0 bit 2).
const per0: *volatile u8 = @ptrFromInt(0xF00F0);

/// Serial clock select register.
const sps0: *volatile u16 = @ptrFromInt(0xF0126);

/// Serial mode register, channel 0.
const smr00: *volatile u16 = @ptrFromInt(0xF0010);

/// Serial communication operation setting, channel 0.
const scr00: *volatile u16 = @ptrFromInt(0xF0012);

/// Serial data register, channel 0.
/// Upper 9 bits hold TX/RX data; lower 7 bits hold clock divider setting.
const sdr00: *volatile u16 = @ptrFromInt(0xFFF10);

/// Serial output register.
const so0: *volatile u16 = @ptrFromInt(0xF0128);

/// Serial output enable register.
const soe0: *volatile u16 = @ptrFromInt(0xF012A);

/// Serial channel start register (write-only trigger).
const ss0: *volatile u16 = @ptrFromInt(0xF0122);

/// Serial status register, channel 0.
/// Bit 6 (TSF00) = 1 while transmission is in progress.
const ssr00: *volatile u16 = @ptrFromInt(0xF0100);

/// Port 1 output register.
const p1: *volatile u8 = @ptrFromInt(0xFFF01);

/// Port 1 mode register.
const pm1: *volatile u8 = @ptrFromInt(0xFFF21);

/// Initialize SAU0-CH0 as UART TX at 9600 baud (32MHz HOCO).
///
/// Prescaler: SPS0 CK00 = 0x4 -> fCLK/16 = 2MHz
/// SDR00 divider: 0x0067 in upper byte -> divide by 104 -> 2MHz/104 ~= 19231
/// Actual baud: 19231/2 = 9615 (within 0.2% of 9600)
pub fn init() void {
    // Enable SAU0 peripheral clock
    per0.* = per0.* | (1 << 2);

    // Select operation clock CK00 prescaler: fCLK / 2^4 = 32MHz/16 = 2MHz
    sps0.* = (sps0.* & 0xFFF0) | 0x04;

    // SMR00: CK00 clock, transfer-end interrupt, UART mode
    // Bit 15 = 0 (CK00), Bit 0 = 1 (buffer empty interrupt)
    smr00.* = 0x0023;

    // SCR00: TX only, 8N1
    // Bits 15-14 = 10 (TX only), Bit 2 = 1 (stop bit), Bits 1-0 = 11 (8-bit data)
    scr00.* = 0x8097;

    // SDR00: clock divider in upper byte
    // 9600 baud from 2MHz: divider = 2000000/(2*9600) - 1 ~= 103 = 0x67
    sdr00.* = 0x6700;

    // Set TxD0 (P1.2) as output, initial level high (idle)
    p1.* = p1.* | (1 << 2);
    pm1.* = pm1.* & ~@as(u8, 1 << 2);

    // Serial output: set initial level high (idle)
    so0.* = so0.* | 0x0001;

    // Enable serial output on channel 0
    soe0.* = soe0.* | 0x0001;

    // Start channel 0
    ss0.* = 0x0001;
}

/// Write a single byte, blocking until the TX shift register is idle.
pub fn putc(c: u8) void {
    // Wait for TSF00 (bit 6) to clear -- shift register idle
    while (ssr00.* & (1 << 6) != 0) {}
    sdr00.* = @as(u16, c) << 9;
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
