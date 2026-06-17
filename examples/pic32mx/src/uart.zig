//! Minimal UART1 driver for PIC32MX270F256B debug output.
//! Configures UART1 at 9600 baud using the 8 MHz FRC oscillator.
//! TX is routed to RB3 via Peripheral Pin Select (PPS).

// zlinter-disable declaration_naming - hardware register names follow PIC32 convention
const U1MODE: *volatile u32 = @ptrFromInt(0xBF806000);
const U1STA: *volatile u32 = @ptrFromInt(0xBF806010);
const U1TXREG: *volatile u32 = @ptrFromInt(0xBF806020);
const U1BRG: *volatile u32 = @ptrFromInt(0xBF806040);

/// PPS output register for RB3: write 0x01 to assign U1TX.
const RPB3R: *volatile u32 = @ptrFromInt(0xBF80FB0C);

/// ANSELBCLR: disable analog function on PORTB pins.
const ANSELBCLR: *volatile u32 = @ptrFromInt(0xBF886104);
// zlinter-enable declaration_naming

/// Initialize UART1 at 9600 baud (8N1) with TX on RB3.
pub fn init() void {
    // Disable analog on RB3 so it can be used as digital output
    ANSELBCLR.* = (1 << 3);

    // Route U1TX to RB3 via PPS
    RPB3R.* = 0x01;

    // BRG = (Fpb / (16 * baud)) - 1 = (8000000 / (16 * 9600)) - 1 = 51
    U1BRG.* = 51;

    // 8-N-1, TX enabled
    U1STA.* = (1 << 10); // UTXEN
    U1MODE.* = (1 << 15); // ON
}

/// Write a single byte, blocking until the TX buffer has space.
/// Bit 9 of U1STA (UTXBF) indicates the transmit buffer is full.
pub fn putc(c: u8) void {
    while ((U1STA.* & (1 << 9)) != 0) {}
    U1TXREG.* = c;
}

/// Write a string to UART1.
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
