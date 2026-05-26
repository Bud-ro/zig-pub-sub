//! Register-level GPIO driver for the nRF52840.
//! The nRF52 GPIO uses a "task and event" system with set/clear registers
//! for atomic bit manipulation. Only port P0 is used here.

// zlinter-disable declaration_naming - hardware register names follow nRF52840 convention

/// GPIO P0 base address.
const P0_BASE: u32 = 0x50000000;

/// Set individual output pins (P0).
const P0_OUTSET: *volatile u32 = @ptrFromInt(P0_BASE + 0x508);
/// Clear individual output pins (P0).
const P0_OUTCLR: *volatile u32 = @ptrFromInt(P0_BASE + 0x50C);
/// Read input pins (P0).
const P0_IN: *volatile u32 = @ptrFromInt(P0_BASE + 0x510);
/// Set individual pin directions to output (P0).
const P0_DIRSET: *volatile u32 = @ptrFromInt(P0_BASE + 0x518);
/// Set individual pin directions to input (P0).
const P0_DIRCLR: *volatile u32 = @ptrFromInt(P0_BASE + 0x51C);

// zlinter-enable declaration_naming

/// PIN_CNF registers start at P0_BASE + 0x700, one per pin.
fn pinCnf(pin: u5) *volatile u32 {
    return @ptrFromInt(P0_BASE + 0x700 + @as(u32, pin) * 4);
}

/// Configure a pin as push-pull output with no pull resistor.
/// PIN_CNF[n]: DIR=1 (output), INPUT=1 (disconnect input buffer),
/// PULL=0 (none), DRIVE=0 (S0S1 standard), SENSE=0 (disabled).
pub fn configOutput(pin: u5) void {
    pinCnf(pin).* = 0x00000003; // DIR=1, INPUT=1 (disconnected)
    P0_DIRSET.* = @as(u32, 1) << pin;
}

/// Configure a pin as input with no pull resistor.
/// PIN_CNF[n]: DIR=0 (input), INPUT=0 (connect input buffer),
/// PULL=0 (none), SENSE=0 (disabled).
pub fn configInput(pin: u5) void {
    pinCnf(pin).* = 0x00000000;
    P0_DIRCLR.* = @as(u32, 1) << pin;
}

/// Drive a GPIO pin high.
pub fn setPin(pin: u5) void {
    P0_OUTSET.* = @as(u32, 1) << pin;
}

/// Drive a GPIO pin low.
pub fn clearPin(pin: u5) void {
    P0_OUTCLR.* = @as(u32, 1) << pin;
}

/// Read the current level of a GPIO pin.
pub fn readPin(pin: u5) bool {
    return (P0_IN.* >> pin) & 1 != 0;
}
