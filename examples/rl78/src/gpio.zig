//! Register-level GPIO driver for the Renesas RL78.
//! RL78 GPIO uses port registers in the SFR area (0xFFF00-0xFFF27).
//!
//! Port output registers:  P0-P7 at 0xFFF00-0xFFF07
//! Port mode registers:    PM0-PM7 at 0xFFF20-0xFFF27
//!   PM bit = 0 -> output, PM bit = 1 -> input (note: opposite of ARM)
//!
//! All GPIO access goes through volatile pointer dereferences, which the
//! C backend emits as standard C volatile reads/writes for rl78-elf-gcc.

/// Read a port output register (P0-P7).
fn portReg(port: u3) *volatile u8 {
    return @ptrFromInt(@as(u32, 0xFFF00) + @as(u32, port));
}

/// Read a port mode register (PM0-PM7).
fn portModeReg(port: u3) *volatile u8 {
    return @ptrFromInt(@as(u32, 0xFFF20) + @as(u32, port));
}

/// Configure a pin as output (clear the PM bit).
pub fn setOutput(port: u3, bit: u3) void {
    const pm = portModeReg(port);
    pm.* = pm.* & ~(@as(u8, 1) << bit);
}

/// Configure a pin as input (set the PM bit).
pub fn setInput(port: u3, bit: u3) void {
    const pm = portModeReg(port);
    pm.* = pm.* | (@as(u8, 1) << bit);
}

/// Drive a pin high.
pub fn setPin(port: u3, bit: u3) void {
    const p = portReg(port);
    p.* = p.* | (@as(u8, 1) << bit);
}

/// Drive a pin low.
pub fn clearPin(port: u3, bit: u3) void {
    const p = portReg(port);
    p.* = p.* & ~(@as(u8, 1) << bit);
}

/// Read the current level of a pin.
pub fn readPin(port: u3, bit: u3) bool {
    return (portReg(port).* >> bit) & 1 != 0;
}
