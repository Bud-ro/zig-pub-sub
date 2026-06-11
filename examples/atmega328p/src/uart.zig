//! Minimal USART0 driver for ATmega328P debug output.
//! Configured for 9600 baud at 16MHz (UBRR=103, 0.2% error).

/// AVR IO register helper.
fn ioReg(comptime addr: u16) *volatile u8 {
    return @ptrFromInt(addr);
}

// zlinter-disable declaration_naming - hardware register names follow AVR convention
const UCSR0A = ioReg(0xC0);
const UCSR0B = ioReg(0xC1);
const UCSR0C = ioReg(0xC2);
const UBRR0L = ioReg(0xC4);
const UBRR0H = ioReg(0xC5);
const UDR0 = ioReg(0xC6);
/// UCSR0A bit: USART Data Register Empty.
const UDRE0: u8 = 1 << 5;
/// UCSR0B bit: Transmitter Enable.
const TXEN0: u8 = 1 << 3;
/// UCSR0C bits: 8-bit character size (UCSZ01:UCSZ00 = 11).
const UCSZ0_8BIT: u8 = 0x06;

/// UBRR value for 9600 baud at 16MHz: 16000000 / (16 * 9600) - 1 = 103.
const UBRR_9600: u16 = 103;
// zlinter-enable declaration_naming

/// Initialize USART0: 9600 baud, 8N1, TX only.
pub fn init() void {
    UBRR0H.* = @truncate(UBRR_9600 >> 8);
    UBRR0L.* = @truncate(UBRR_9600);
    UCSR0B.* = TXEN0;
    UCSR0C.* = UCSZ0_8BIT;
}

/// Write a single byte, blocking until the data register is empty.
pub fn putc(c: u8) void {
    while ((UCSR0A.* & UDRE0) == 0) {}
    UDR0.* = c;
}

/// Write a string to USART0.
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
