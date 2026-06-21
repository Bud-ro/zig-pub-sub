//! Register-level GPIO driver for ATSAMD51 PORT peripheral.
//! The SAMD51 uses the PORT controller with two 32-pin groups (PA, PB).
//! Each group has direction, output, input, pin config, and peripheral mux
//! registers at fixed offsets from the group base address.

// zlinter-disable declaration_naming - hardware register names follow SAMD51 convention

/// PORT peripheral base address.
const PORT_BASE: u32 = 0x41008000;

/// Byte offset between PORT groups (PA=0x00, PB=0x80).
const GROUP_STRIDE: u32 = 0x80;

// Register offsets within each group
const DIRSET_OFFSET: u32 = 0x08;
const DIRCLR_OFFSET: u32 = 0x04;
const OUTSET_OFFSET: u32 = 0x18;
const OUTCLR_OFFSET: u32 = 0x14;
const OUTTGL_OFFSET: u32 = 0x1C;
const IN_OFFSET: u32 = 0x20;
const PINCFG_OFFSET: u32 = 0x40;
const PMUX_OFFSET: u32 = 0x30;

// zlinter-enable declaration_naming

/// Port group identifier.
pub const Group = enum(u1) {
    a = 0,
    b = 1,
};

/// A GPIO pin identified by group and bit position.
pub const Pin = struct {
    group: Group,
    pin: u5,
};

/// Return a volatile pointer to a 32-bit register at the given address.
fn reg32(addr: u32) *volatile u32 {
    return @ptrFromInt(addr);
}

/// Return a volatile pointer to an 8-bit register at the given address.
fn reg8(addr: u32) *volatile u8 {
    return @ptrFromInt(addr);
}

/// Compute the base address for a PORT group.
fn groupBase(group: Group) u32 {
    return PORT_BASE + @as(u32, @intFromEnum(group)) * GROUP_STRIDE;
}

/// Configure a pin as output.
pub fn setOutput(pin: Pin) void {
    reg32(groupBase(pin.group) + DIRSET_OFFSET).* = @as(u32, 1) << pin.pin;
}

/// Configure a pin as input.
pub fn setInput(pin: Pin) void {
    reg32(groupBase(pin.group) + DIRCLR_OFFSET).* = @as(u32, 1) << pin.pin;
}

/// Drive a pin high.
pub fn setPin(pin: Pin) void {
    reg32(groupBase(pin.group) + OUTSET_OFFSET).* = @as(u32, 1) << pin.pin;
}

/// Drive a pin low.
pub fn clearPin(pin: Pin) void {
    reg32(groupBase(pin.group) + OUTCLR_OFFSET).* = @as(u32, 1) << pin.pin;
}

/// Toggle a pin output.
pub fn togglePin(pin: Pin) void {
    reg32(groupBase(pin.group) + OUTTGL_OFFSET).* = @as(u32, 1) << pin.pin;
}

/// Read the current level of a pin.
pub fn readPin(pin: Pin) bool {
    return (reg32(groupBase(pin.group) + IN_OFFSET).* >> pin.pin) & 1 != 0;
}

/// Write the PINCFG register for a pin.
/// bit 1 = INEN (input enable), bit 2 = PULLEN, bit 6 = DRVSTR.
pub fn setPinCfg(pin: Pin, value: u8) void {
    reg8(groupBase(pin.group) + PINCFG_OFFSET + @as(u32, pin.pin)).* = value;
}

/// Set the peripheral mux for a pin. Each PMUX byte covers two pins
/// (lower nibble = even pin, upper nibble = odd pin).
pub fn setPmux(pin: Pin, func: u4) void {
    const pmux_addr = groupBase(pin.group) + PMUX_OFFSET + @as(u32, pin.pin) / 2;
    const pmux = reg8(pmux_addr);
    if (pin.pin & 1 == 0) {
        pmux.* = (pmux.* & 0xF0) | func;
    } else {
        pmux.* = (pmux.* & 0x0F) | (@as(u8, func) << 4);
    }
}

/// Enable peripheral mux on a pin (set PMUXEN bit in PINCFG).
pub fn enablePmux(pin: Pin) void {
    const cfg_addr = groupBase(pin.group) + PINCFG_OFFSET + @as(u32, pin.pin);
    const cfg = reg8(cfg_addr);
    cfg.* = cfg.* | 0x01;
}
