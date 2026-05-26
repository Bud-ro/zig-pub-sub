//! Register-level GPIO driver for the RP2040.
//!
//! GPIO on the RP2040 is controlled through three register blocks:
//!   - IO_BANK0 (0x40014000): function select and status per pin
//!   - PADS_BANK0 (0x4001C000): pad electrical configuration (drive, pull, etc.)
//!   - SIO (0xD0000000): single-cycle I/O for fast GPIO reads/writes
//!
//! Each GPIO pin must be:
//!   1. Released from reset (IO_BANK0, PADS_BANK0 via RESETS peripheral)
//!   2. Assigned to the SIO function (function 5) in IO_BANK0
//!   3. Configured as output via SIO_GPIO_OE_SET
//!   4. Driven via SIO_GPIO_OUT_SET / SIO_GPIO_OUT_CLR

// zlinter-disable declaration_naming - hardware register names follow RP2040 datasheet convention

// --- Subsystem reset registers ---
const RESETS_BASE: u32 = 0x4000C000;
const RESETS_RESET: *volatile u32 = @ptrFromInt(RESETS_BASE + 0x00);
const RESETS_RESET_DONE: *volatile u32 = @ptrFromInt(RESETS_BASE + 0x08);

// Reset bit positions
const RESET_IO_BANK0: u32 = 1 << 5;
const RESET_PADS_BANK0: u32 = 1 << 8;

// --- IO_BANK0 registers (function select) ---
const IO_BANK0_BASE: u32 = 0x40014000;

// --- PADS_BANK0 registers (pad configuration) ---
const PADS_BANK0_BASE: u32 = 0x4001C000;

// --- SIO registers (single-cycle I/O) ---
const SIO_BASE: u32 = 0xD0000000;
const SIO_GPIO_IN: *volatile u32 = @ptrFromInt(SIO_BASE + 0x004);
const SIO_GPIO_OUT_SET: *volatile u32 = @ptrFromInt(SIO_BASE + 0x014);
const SIO_GPIO_OUT_CLR: *volatile u32 = @ptrFromInt(SIO_BASE + 0x018);
const SIO_GPIO_OUT_XOR: *volatile u32 = @ptrFromInt(SIO_BASE + 0x01C);
const SIO_GPIO_OE_SET: *volatile u32 = @ptrFromInt(SIO_BASE + 0x024);
const SIO_GPIO_OE_CLR: *volatile u32 = @ptrFromInt(SIO_BASE + 0x028);

// zlinter-enable declaration_naming

/// Release IO_BANK0 and PADS_BANK0 from reset.
/// Must be called before any GPIO configuration. Blocks until the
/// reset controller reports both subsystems are ready.
pub fn initSubsystems() void {
    // Deassert reset for IO_BANK0 and PADS_BANK0
    RESETS_RESET.* &= ~(RESET_IO_BANK0 | RESET_PADS_BANK0);

    // Wait for reset to complete
    while (RESETS_RESET_DONE.* & (RESET_IO_BANK0 | RESET_PADS_BANK0) != (RESET_IO_BANK0 | RESET_PADS_BANK0)) {}
}

/// Configure a GPIO pin for SIO function (function 5).
/// This sets the IO_BANK0 CTRL register for the given pin and clears
/// the output-disable bit in the pad configuration.
pub fn initPin(pin: u5) void {
    // IO_BANK0: GPIO_CTRL register for pin n is at offset 0x04 + 8*n
    // FUNCSEL field is bits [4:0], value 5 = SIO
    const ctrl_addr = IO_BANK0_BASE + 0x04 + @as(u32, pin) * 8;
    const ctrl: *volatile u32 = @ptrFromInt(ctrl_addr);
    ctrl.* = 5; // FUNCSEL = SIO

    // PADS_BANK0: pad register for GPIO n is at offset 0x04 + 4*n
    // Clear bit 7 (OD = output disable), set bit 6 (IE = input enable)
    const pad_addr = PADS_BANK0_BASE + 0x04 + @as(u32, pin) * 4;
    const pad: *volatile u32 = @ptrFromInt(pad_addr);
    var pad_val = pad.*;
    pad_val &= ~@as(u32, 1 << 7); // clear OD (output disable)
    pad_val |= (1 << 6); // set IE (input enable)
    pad.* = pad_val;
}

/// Configure a GPIO pin as output.
pub fn setOutput(pin: u5) void {
    SIO_GPIO_OE_SET.* = @as(u32, 1) << pin;
}

/// Configure a GPIO pin as input.
pub fn setInput(pin: u5) void {
    SIO_GPIO_OE_CLR.* = @as(u32, 1) << pin;
}

/// Drive a GPIO pin high.
pub fn setPin(pin: u5) void {
    SIO_GPIO_OUT_SET.* = @as(u32, 1) << pin;
}

/// Drive a GPIO pin low.
pub fn clearPin(pin: u5) void {
    SIO_GPIO_OUT_CLR.* = @as(u32, 1) << pin;
}

/// Toggle a GPIO pin.
pub fn togglePin(pin: u5) void {
    SIO_GPIO_OUT_XOR.* = @as(u32, 1) << pin;
}

/// Read the current level of a GPIO pin.
pub fn readPin(pin: u5) bool {
    return (SIO_GPIO_IN.* >> pin) & 1 != 0;
}
