//! Register-level GPIO driver for MC9S08QE8.
//! Port A and Port B each have 8 pins. Direction registers (PTxDD) control
//! input vs output: 1 = output, 0 = input. Data registers (PTxD) read or
//! drive pin state. Since the HCS08 SFRs live at absolute addresses that
//! require SDCC's __at syntax, all register access goes through C accessor
//! functions in sfr_access.c.

/// Write the Port A data register (PTAD at 0x0000).
pub extern fn sfr_set_ptad(val: u8) void;
/// Read the Port A data register.
pub extern fn sfr_get_ptad() u8;
/// Write the Port A direction register (PTADD at 0x0001).
pub extern fn sfr_set_ptadd(val: u8) void;

/// Write the Port B data register (PTBD at 0x0002).
pub extern fn sfr_set_ptbd(val: u8) void;
/// Read the Port B data register.
pub extern fn sfr_get_ptbd() u8;
/// Write the Port B direction register (PTBDD at 0x0003).
pub extern fn sfr_set_ptbdd(val: u8) void;

/// Configure a Port A pin as output.
pub fn setOutputA(pin: u3) void {
    const current = sfr_get_ptadd_cached();
    sfr_set_ptadd(current | (@as(u8, 1) << pin));
}

/// Drive a Port A pin high.
pub fn setPinA(pin: u3) void {
    sfr_set_ptad(sfr_get_ptad() | (@as(u8, 1) << pin));
}

/// Drive a Port A pin low.
pub fn clearPinA(pin: u3) void {
    sfr_set_ptad(sfr_get_ptad() & ~(@as(u8, 1) << pin));
}

/// Read a Port A pin level.
pub fn readPinA(pin: u3) bool {
    return (sfr_get_ptad() >> pin) & 1 != 0;
}

// Shadow copy of PTADD to avoid extra reads on the 8-bit bus.
var ptadd_shadow: u8 = 0;

fn sfr_get_ptadd_cached() u8 { // zlinter-disable-current-line function_naming
    return ptadd_shadow;
}

/// Set Port A direction register and update the shadow.
pub fn setDirectionA(val: u8) void {
    ptadd_shadow = val;
    sfr_set_ptadd(val);
}
