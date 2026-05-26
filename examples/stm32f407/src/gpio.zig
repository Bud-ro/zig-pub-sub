//! Register-level GPIO driver for the STM32F4 family.
//! Each GPIO port has MODER, OTYPER, OSPEEDR, PUPDR, IDR, ODR, and BSRR
//! registers. Pin configuration uses 2-bit fields in MODER/OSPEEDR/PUPDR
//! and 1-bit fields in OTYPER. BSRR provides atomic set/reset.

/// GPIO port identifier.
pub const Port = enum(u32) {
    a = 0x40020000,
    b = 0x40020400,
    c = 0x40020800,
    d = 0x40020C00,
    e = 0x40021000,
};

/// Pin mode (MODER register, 2 bits per pin).
pub const Mode = enum(u2) {
    input = 0b00,
    output = 0b01,
    alternate = 0b10,
    analog = 0b11,
};

/// Output type (OTYPER register, 1 bit per pin).
pub const OutputType = enum(u1) {
    push_pull = 0,
    open_drain = 1,
};

/// Output speed (OSPEEDR register, 2 bits per pin).
pub const Speed = enum(u2) {
    low = 0b00,
    medium = 0b01,
    high = 0b10,
    very_high = 0b11,
};

/// Pull-up / pull-down (PUPDR register, 2 bits per pin).
pub const Pull = enum(u2) {
    none = 0b00,
    up = 0b01,
    down = 0b10,
};

// Register offsets from port base.
const moder_offset: u32 = 0x00;
const otyper_offset: u32 = 0x04;
const ospeedr_offset: u32 = 0x08;
const pupdr_offset: u32 = 0x0C;
const bsrr_offset: u32 = 0x18;
const afrl_offset: u32 = 0x20;
const afrh_offset: u32 = 0x24;

fn reg(port: Port, offset: u32) *volatile u32 {
    return @ptrFromInt(@intFromEnum(port) + offset);
}

/// Set the mode for a single pin.
pub fn setMode(port: Port, pin: u4, mode: Mode) void {
    const shift = @as(u5, pin) * 2;
    const r = reg(port, moder_offset);
    r.* = (r.* & ~(@as(u32, 0b11) << shift)) | (@as(u32, @intFromEnum(mode)) << shift);
}

/// Set the output type for a single pin.
pub fn setOutputType(port: Port, pin: u4, otype: OutputType) void {
    const r = reg(port, otyper_offset);
    r.* = (r.* & ~(@as(u32, 1) << pin)) | (@as(u32, @intFromEnum(otype)) << pin);
}

/// Set the output speed for a single pin.
pub fn setSpeed(port: Port, pin: u4, speed: Speed) void {
    const shift = @as(u5, pin) * 2;
    const r = reg(port, ospeedr_offset);
    r.* = (r.* & ~(@as(u32, 0b11) << shift)) | (@as(u32, @intFromEnum(speed)) << shift);
}

/// Set the pull-up/pull-down for a single pin.
pub fn setPull(port: Port, pin: u4, pull: Pull) void {
    const shift = @as(u5, pin) * 2;
    const r = reg(port, pupdr_offset);
    r.* = (r.* & ~(@as(u32, 0b11) << shift)) | (@as(u32, @intFromEnum(pull)) << shift);
}

/// Set the alternate function for a single pin (AF0-AF15).
pub fn setAltFunc(port: Port, pin: u4, af: u4) void {
    // Pins 0-7 use AFRL, pins 8-15 use AFRH.
    const offset = if (pin < 8) afrl_offset else afrh_offset;
    const bit: u5 = (@as(u5, pin) % 8) * 4;
    const r = reg(port, offset);
    r.* = (r.* & ~(@as(u32, 0xF) << bit)) | (@as(u32, af) << bit);
}

/// Drive a pin high using BSRR (atomic, no read-modify-write).
pub fn setPin(port: Port, pin: u4) void {
    reg(port, bsrr_offset).* = @as(u32, 1) << pin;
}

/// Drive a pin low using BSRR (atomic, no read-modify-write).
pub fn clearPin(port: Port, pin: u4) void {
    reg(port, bsrr_offset).* = @as(u32, 1) << (@as(u5, pin) + 16);
}

/// Write a pin to a given level.
pub fn writePin(port: Port, pin: u4, high: bool) void {
    if (high) {
        setPin(port, pin);
    } else {
        clearPin(port, pin);
    }
}

/// Configure a pin as push-pull output with medium speed, no pull.
pub fn configOutput(port: Port, pin: u4) void {
    setMode(port, pin, .output);
    setOutputType(port, pin, .push_pull);
    setSpeed(port, pin, .medium);
    setPull(port, pin, .none);
}
