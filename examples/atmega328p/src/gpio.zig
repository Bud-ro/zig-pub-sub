//! Register-level GPIO driver for ATmega328P.
//! AVR GPIO uses memory-mapped IO registers for port direction, output data,
//! and input pins. Each port (B, C, D) has three registers: PINx, DDRx, PORTx.

/// AVR IO register helper. Returns a volatile pointer to the memory-mapped
/// IO register at the given address.
fn ioReg(comptime addr: u16) *volatile u8 {
    return @ptrFromInt(addr);
}

// Port B registers (PB0-PB7, includes Arduino pins 8-13)
// zlinter-disable declaration_naming - hardware register names follow AVR convention
const PINB = ioReg(0x23);
const DDRB = ioReg(0x24);
const PORTB = ioReg(0x25);

// Port C registers (PC0-PC6, includes Arduino analog pins A0-A5)
const PINC = ioReg(0x26);
const DDRC = ioReg(0x27);
const PORTC = ioReg(0x28);

// Port D registers (PD0-PD7, includes Arduino pins 0-7)
const PIND = ioReg(0x29);
const DDRD = ioReg(0x2A);
const PORTD = ioReg(0x2B);
// zlinter-enable declaration_naming

/// Which AVR port a pin belongs to.
pub const Port = enum { b, c, d };

/// A GPIO pin identified by its port and bit position.
pub const Pin = struct {
    port: Port,
    bit: u3,
};

/// Return the DDR register for the given port.
fn ddrReg(port: Port) *volatile u8 {
    return switch (port) {
        .b => DDRB,
        .c => DDRC,
        .d => DDRD,
    };
}

/// Return the PORT (output) register for the given port.
fn portReg(port: Port) *volatile u8 {
    return switch (port) {
        .b => PORTB,
        .c => PORTC,
        .d => PORTD,
    };
}

/// Return the PIN (input) register for the given port.
fn pinReg(port: Port) *volatile u8 {
    return switch (port) {
        .b => PINB,
        .c => PINC,
        .d => PIND,
    };
}

/// Configure a pin as output by setting its DDR bit.
pub fn setOutput(pin: Pin) void {
    const mask: u8 = @as(u8, 1) << pin.bit;
    ddrReg(pin.port).* |= mask;
}

/// Configure a pin as input by clearing its DDR bit.
pub fn setInput(pin: Pin) void {
    const mask: u8 = @as(u8, 1) << pin.bit;
    ddrReg(pin.port).* &= ~mask;
}

/// Drive a pin high.
pub fn setPin(pin: Pin) void {
    const mask: u8 = @as(u8, 1) << pin.bit;
    portReg(pin.port).* |= mask;
}

/// Drive a pin low.
pub fn clearPin(pin: Pin) void {
    const mask: u8 = @as(u8, 1) << pin.bit;
    portReg(pin.port).* &= ~mask;
}

/// Read the current logic level of a pin.
pub fn readPin(pin: Pin) bool {
    const mask: u8 = @as(u8, 1) << pin.bit;
    return (pinReg(pin.port).* & mask) != 0;
}
