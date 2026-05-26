//! Register-level GPIO driver for Renesas RX130.
//! Handles port direction, output data, and pin mode registers.
//! RX130 port registers are byte-accessible at base 0x0008C000.

// zlinter-disable declaration_naming - hardware register base addresses follow datasheet convention
const PORT_BASE: usize = 0x0008C000;
const PDR_OFFSET: usize = 0x00; // Port Direction Register (0=input, 1=output)
const PODR_OFFSET: usize = 0x20; // Port Output Data Register
const PIDR_OFFSET: usize = 0x40; // Port Input Data Register
const PMR_OFFSET: usize = 0x60; // Port Mode Register (0=GPIO, 1=peripheral)

/// SYSTEM.PRCR: protect register -- write 0xA502 to unlock PRC1 (clock registers).
const SYSTEM_PRCR: *volatile u16 = @ptrFromInt(0x000803FE);
// zlinter-enable declaration_naming

/// Port identifiers matching RX130 port numbering.
pub const Port = enum(u8) {
    port0 = 0x00,
    port1 = 0x01,
    port2 = 0x02,
    port3 = 0x03,
    port4 = 0x04,
    port5 = 0x05,
    porta = 0x0A,
    portb = 0x0B,
    portc = 0x0C,
    portd = 0x0D,
    porte = 0x0E,
};

fn pdrReg(port: Port) *volatile u8 {
    return @ptrFromInt(PORT_BASE + PDR_OFFSET + @intFromEnum(port));
}

fn podrReg(port: Port) *volatile u8 {
    return @ptrFromInt(PORT_BASE + PODR_OFFSET + @intFromEnum(port));
}

fn pidrReg(port: Port) *volatile u8 {
    return @ptrFromInt(PORT_BASE + PIDR_OFFSET + @intFromEnum(port));
}

fn pmrReg(port: Port) *volatile u8 {
    return @ptrFromInt(PORT_BASE + PMR_OFFSET + @intFromEnum(port));
}

/// Unlock SYSTEM register protection (PRC1) for clock and module-stop writes.
pub fn unlockProtection() void {
    SYSTEM_PRCR.* = 0xA502;
}

/// Lock SYSTEM register protection.
pub fn lockProtection() void {
    SYSTEM_PRCR.* = 0xA500;
}

/// Configure a pin as GPIO output (PMR=0 for GPIO mode, PDR=1 for output).
pub fn setGpioOutput(port: Port, bit: u3) void {
    const mask = @as(u8, 1) << bit;
    // Set GPIO mode (clear peripheral mode)
    pmrReg(port).* &= ~mask;
    // Set as output
    pdrReg(port).* |= mask;
}

/// Configure a pin as GPIO input (PMR=0 for GPIO mode, PDR=0 for input).
pub fn setGpioInput(port: Port, bit: u3) void {
    const mask = @as(u8, 1) << bit;
    // Set GPIO mode (clear peripheral mode)
    pmrReg(port).* &= ~mask;
    // Set as input
    pdrReg(port).* &= ~mask;
}

/// Drive a GPIO pin high.
pub fn setPin(port: Port, bit: u3) void {
    podrReg(port).* |= @as(u8, 1) << bit;
}

/// Drive a GPIO pin low.
pub fn clearPin(port: Port, bit: u3) void {
    podrReg(port).* &= ~(@as(u8, 1) << bit);
}

/// Read the current level of a GPIO pin.
pub fn readPin(port: Port, bit: u3) bool {
    return (pidrReg(port).* >> bit) & 1 != 0;
}

/// Set a pin to peripheral mode (PMR=1) for use with MPC.
pub fn setPeripheralMode(port: Port, bit: u3) void {
    pmrReg(port).* |= @as(u8, 1) << bit;
}
