//! Minimal SCI (UART) driver for MC9S08QE8 debug output.
//! Configured for 9600 baud at 4 MHz bus clock (default FEI mode).
//! TX on PTB0 (default SCI TX pin). All register access goes through
//! C accessor functions in sfr_access.c because SDCC needs __at syntax
//! for HCS08 absolute-addressed SFRs.

// zlinter-disable declaration_naming - hardware register bit masks
/// SCI Status Register 1 bit masks.
const TDRE: u8 = 0x80; // Transmit Data Register Empty (bit 7)

/// SCI Control Register 2 bit masks.
const TE: u8 = 0x08; // Transmitter Enable (bit 3)
// zlinter-enable declaration_naming

// SCI register accessors from sfr_access.c
extern fn sfr_set_scibdh(val: u8) void;
extern fn sfr_set_scibdl(val: u8) void;
extern fn sfr_set_scic2(val: u8) void;
extern fn sfr_get_scis1() u8;
extern fn sfr_set_scid(val: u8) void;

/// Initialize the SCI for 9600 baud TX-only.
/// Bus clock = 4 MHz (default FEI), BRG = 4000000 / (16 * 9600) = 26.
pub fn init() void {
    sfr_set_scibdh(0);
    sfr_set_scibdl(26);
    sfr_set_scic2(TE);
}

/// Write a single byte, blocking until the TX data register is empty.
pub fn putc(c: u8) void {
    while (sfr_get_scis1() & TDRE == 0) {}
    sfr_set_scid(c);
}

/// Write a string to the SCI.
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
