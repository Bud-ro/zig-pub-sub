//! Register-level GPIO driver for GD32VF103.
//! The GD32VF103 GPIO peripheral is register-compatible with STM32F103
//! (old-style CTL0/CTL1 configuration registers). Each pin uses 4 config
//! bits: 2 for mode (input/output speed) and 2 for configuration
//! (push-pull, open-drain, alternate function, analog).

/// GPIO port base addresses.
pub const Port = enum(u32) {
    a = 0x40010800,
    b = 0x40010C00,
    c = 0x40011000,
};

/// Pin output mode: controls speed for output pins.
pub const Mode = enum(u2) {
    input = 0b00,
    output_10mhz = 0b01,
    output_2mhz = 0b10,
    output_50mhz = 0b11,
};

/// Pin configuration: combined with mode to fully specify pin behavior.
pub const Config = enum(u2) {
    /// Output: push-pull. Input: analog.
    push_pull_or_analog = 0b00,
    /// Output: open-drain. Input: floating.
    open_drain_or_floating = 0b01,
    /// Output: alt-func push-pull. Input: pull-up/pull-down.
    alt_push_pull_or_pull = 0b10,
    /// Output: alt-func open-drain. Input: reserved.
    alt_open_drain = 0b11,
};

/// Configure a pin's mode and configuration bits in CTL0 (pins 0-7) or
/// CTL1 (pins 8-15). Each pin occupies 4 bits: [MD1:MD0:CTL1:CTL0].
pub fn configurePin(port: Port, pin: u4, mode: Mode, config: Config) void {
    const base = @intFromEnum(port);
    // CTL0 covers pins 0-7, CTL1 covers pins 8-15
    const reg_offset: u32 = if (pin < 8) 0x00 else 0x04;
    const reg: *volatile u32 = @ptrFromInt(base + reg_offset);
    const bit_offset: u5 = @as(u5, pin % 8) * 4;
    const mask: u32 = @as(u32, 0xF) << bit_offset;
    const val: u32 = (@as(u32, @intFromEnum(mode)) | (@as(u32, @intFromEnum(config)) << 2)) << bit_offset;
    reg.* = (reg.* & ~mask) | val;
}

/// Set a GPIO pin high via the bit-operate register (BOP).
pub fn setPin(port: Port, pin: u4) void {
    const bop: *volatile u32 = @ptrFromInt(@intFromEnum(port) + 0x10);
    bop.* = @as(u32, 1) << pin;
}

/// Clear a GPIO pin low via the bit-clear register (BC).
pub fn clearPin(port: Port, pin: u4) void {
    const bc: *volatile u32 = @ptrFromInt(@intFromEnum(port) + 0x14);
    bc.* = @as(u32, 1) << pin;
}

/// Read the current input level of a GPIO pin via ISTAT.
pub fn readPin(port: Port, pin: u4) bool {
    const istat: *volatile u32 = @ptrFromInt(@intFromEnum(port) + 0x08);
    return (istat.* >> pin) & 1 != 0;
}
