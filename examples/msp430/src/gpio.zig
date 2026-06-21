//! Register-level GPIO driver for MSP430G2553.
//! Provides direct access to Port 1 and Port 2 direction, output, input,
//! function-select, and pull-resistor registers.

// zlinter-disable declaration_naming - hardware register names follow TI convention

/// Port 1 input register.
pub const P1IN: *volatile u8 = @ptrFromInt(0x0020);
/// Port 1 output register.
pub const P1OUT: *volatile u8 = @ptrFromInt(0x0021);
/// Port 1 direction register (1 = output).
pub const P1DIR: *volatile u8 = @ptrFromInt(0x0022);
/// Port 1 interrupt flag register.
pub const P1IFG: *volatile u8 = @ptrFromInt(0x0023);
/// Port 1 interrupt edge select register.
pub const P1IES: *volatile u8 = @ptrFromInt(0x0024);
/// Port 1 interrupt enable register.
pub const P1IE: *volatile u8 = @ptrFromInt(0x0025);
/// Port 1 function select register.
pub const P1SEL: *volatile u8 = @ptrFromInt(0x0026);
/// Port 1 pull-resistor enable register.
pub const P1REN: *volatile u8 = @ptrFromInt(0x0027);

/// Port 2 input register.
pub const P2IN: *volatile u8 = @ptrFromInt(0x0028);
/// Port 2 output register.
pub const P2OUT: *volatile u8 = @ptrFromInt(0x0029);
/// Port 2 direction register (1 = output).
pub const P2DIR: *volatile u8 = @ptrFromInt(0x002A);
/// Port 2 function select register.
pub const P2SEL: *volatile u8 = @ptrFromInt(0x002E);

// zlinter-enable declaration_naming

/// Set a Port 1 pin as output.
pub fn setOutput(comptime pin: u3) void {
    P1DIR.* |= @as(u8, 1) << pin;
}

/// Set a Port 1 pin as input.
pub fn setInput(comptime pin: u3) void {
    P1DIR.* &= ~(@as(u8, 1) << pin);
}

/// Drive a Port 1 pin high.
pub fn setPin(comptime pin: u3) void {
    P1OUT.* |= @as(u8, 1) << pin;
}

/// Drive a Port 1 pin low.
pub fn clearPin(comptime pin: u3) void {
    P1OUT.* &= ~(@as(u8, 1) << pin);
}

/// Toggle a Port 1 pin.
pub fn togglePin(comptime pin: u3) void {
    P1OUT.* ^= @as(u8, 1) << pin;
}

/// Read the current level of a Port 1 pin.
pub fn readPin(comptime pin: u3) bool {
    return (P1IN.* >> pin) & 1 != 0;
}

/// Select peripheral function for a Port 1 pin (P1SEL bit set).
pub fn selectPeripheral(comptime pin: u3) void {
    P1SEL.* |= @as(u8, 1) << pin;
}

/// Select GPIO function for a Port 1 pin (P1SEL bit cleared).
pub fn selectGpio(comptime pin: u3) void {
    P1SEL.* &= ~(@as(u8, 1) << pin);
}
