//! Register-level GPIO driver for STM32L0.
//! The STM32L0 GPIO peripheral uses the MODER/OTYPER/OSPEEDR/PUPDR/BSRR model
//! (same as STM32F4), with port base addresses starting at 0x50000000.

/// GPIO port base addresses.
pub const Port = enum(u32) {
    a = 0x50000000,
    b = 0x50000400,
    c = 0x50000800,
};

/// GPIO pin mode (MODER register, 2 bits per pin).
pub const Mode = enum(u2) {
    input = 0b00,
    output = 0b01,
    alternate = 0b10,
    analog = 0b11,
};

/// Set the mode for a single pin on the given port.
pub fn setMode(port: Port, pin: u4, mode: Mode) void {
    const moder: *volatile u32 = @ptrFromInt(@intFromEnum(port) + 0x00);
    const shift: u5 = @as(u5, pin) * 2;
    moder.* = (moder.* & ~(@as(u32, 0x3) << shift)) | (@as(u32, @intFromEnum(mode)) << shift);
}

/// Configure a pin as push-pull output (OTYPER bit = 0).
pub fn setOutputPushPull(port: Port, pin: u4) void {
    const otyper: *volatile u32 = @ptrFromInt(@intFromEnum(port) + 0x04);
    otyper.* &= ~(@as(u32, 1) << pin);
}

/// Set a pin high via the BSRR register (atomic, no read-modify-write).
pub fn setPin(port: Port, pin: u4) void {
    const bsrr: *volatile u32 = @ptrFromInt(@intFromEnum(port) + 0x18);
    bsrr.* = @as(u32, 1) << pin;
}

/// Set a pin low via the BSRR register (upper 16 bits = reset).
pub fn clearPin(port: Port, pin: u4) void {
    const bsrr: *volatile u32 = @ptrFromInt(@intFromEnum(port) + 0x18);
    bsrr.* = @as(u32, 1) << (@as(u5, pin) + 16);
}

/// Read the current level of a pin from the IDR register.
pub fn readPin(port: Port, pin: u4) bool {
    const idr: *volatile u32 = @ptrFromInt(@intFromEnum(port) + 0x10);
    return (idr.* >> pin) & 1 != 0;
}

/// Set the alternate function for a pin.
/// Pins 0-7 use AFRL (offset 0x20), pins 8-15 use AFRH (offset 0x24).
/// Each pin gets 4 bits in the register to select AF0-AF15.
pub fn setAlternateFunction(port: Port, pin: u4, af: u4) void {
    const base = @intFromEnum(port);
    if (pin < 8) {
        const afrl: *volatile u32 = @ptrFromInt(base + 0x20);
        const shift: u5 = @as(u5, pin) * 4;
        afrl.* = (afrl.* & ~(@as(u32, 0xF) << shift)) | (@as(u32, af) << shift);
    } else {
        const afrh: *volatile u32 = @ptrFromInt(base + 0x24);
        const shift: u5 = @as(u5, pin - 8) * 4;
        afrh.* = (afrh.* & ~(@as(u32, 0xF) << shift)) | (@as(u32, af) << shift);
    }
}
