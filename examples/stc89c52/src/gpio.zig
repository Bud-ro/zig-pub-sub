//! Register-level GPIO driver for the 8051 (STC89C52RC).
//! 8051 SFRs live in a special address space that requires SDCC's `__sfr`
//! keyword, so actual register access is performed by C accessor functions
//! in sfr_access.c. This module wraps those externs with a Zig-idiomatic API.

/// Write a full byte to port P1.
pub fn writeP1(val: u8) void {
    sfr_set_p1(val);
}

/// Read the current value of port P1.
pub fn readP1() u8 {
    return sfr_get_p1();
}

/// Set a single bit on port P1 (read-modify-write).
pub fn setP1Bit(bit: u3) void {
    sfr_set_p1(sfr_get_p1() | (@as(u8, 1) << bit));
}

/// Clear a single bit on port P1 (read-modify-write).
pub fn clearP1Bit(bit: u3) void {
    sfr_set_p1(sfr_get_p1() & ~(@as(u8, 1) << bit));
}

/// Read a single bit from port P1.
pub fn readP1Bit(bit: u3) bool {
    return (sfr_get_p1() >> bit) & 1 != 0;
}

// --- C extern SFR accessors (defined in sfr_access.c) ---

extern fn sfr_set_p1(val: u8) void;
extern fn sfr_get_p1() u8;
