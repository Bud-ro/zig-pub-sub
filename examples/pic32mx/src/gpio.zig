//! Register-level GPIO driver for PIC32MX270F256B.
//! PIC32MX uses PORT A and PORT B with SET/CLR/INV atomic register variants.
//! Each base register has companion registers at fixed offsets:
//!   CLR = base + 0x04, SET = base + 0x08, INV = base + 0x0C

// zlinter-disable declaration_naming - hardware register names follow PIC32 convention

// --- PORT A ---
const TRISACLR: *volatile u32 = @ptrFromInt(0xBF886004);
const TRISASET: *volatile u32 = @ptrFromInt(0xBF886008);
const PORTA: *volatile u32 = @ptrFromInt(0xBF886010);
const LATASET: *volatile u32 = @ptrFromInt(0xBF886028);
const LATACLR: *volatile u32 = @ptrFromInt(0xBF886024);
const LATAINV: *volatile u32 = @ptrFromInt(0xBF88602C);

// --- PORT B ---
const TRISBCLR: *volatile u32 = @ptrFromInt(0xBF886044);
const TRISBSET: *volatile u32 = @ptrFromInt(0xBF886048);
const PORTB: *volatile u32 = @ptrFromInt(0xBF886050);
const LATBSET: *volatile u32 = @ptrFromInt(0xBF886068);
const LATBCLR: *volatile u32 = @ptrFromInt(0xBF886064);
const LATBINV: *volatile u32 = @ptrFromInt(0xBF88606C);

// zlinter-enable declaration_naming

// --- PORT A operations ---

/// Configure a PORT A pin as output (clear TRISA bit).
pub fn setOutputA(pin: u5) void {
    TRISACLR.* = @as(u32, 1) << pin;
}

/// Configure a PORT A pin as input (set TRISA bit).
pub fn setInputA(pin: u5) void {
    TRISASET.* = @as(u32, 1) << pin;
}

/// Drive a PORT A pin high.
pub fn setPinA(pin: u5) void {
    LATASET.* = @as(u32, 1) << pin;
}

/// Drive a PORT A pin low.
pub fn clearPinA(pin: u5) void {
    LATACLR.* = @as(u32, 1) << pin;
}

/// Toggle a PORT A pin.
pub fn togglePinA(pin: u5) void {
    LATAINV.* = @as(u32, 1) << pin;
}

/// Read the current level of a PORT A pin.
pub fn readPinA(pin: u5) bool {
    return (PORTA.* >> pin) & 1 != 0;
}

// --- PORT B operations ---

/// Configure a PORT B pin as output (clear TRISB bit).
pub fn setOutputB(pin: u5) void {
    TRISBCLR.* = @as(u32, 1) << pin;
}

/// Configure a PORT B pin as input (set TRISB bit).
pub fn setInputB(pin: u5) void {
    TRISBSET.* = @as(u32, 1) << pin;
}

/// Drive a PORT B pin high.
pub fn setPinB(pin: u5) void {
    LATBSET.* = @as(u32, 1) << pin;
}

/// Drive a PORT B pin low.
pub fn clearPinB(pin: u5) void {
    LATBCLR.* = @as(u32, 1) << pin;
}

/// Toggle a PORT B pin.
pub fn togglePinB(pin: u5) void {
    LATBINV.* = @as(u32, 1) << pin;
}

/// Read the current level of a PORT B pin.
pub fn readPinB(pin: u5) bool {
    return (PORTB.* >> pin) & 1 != 0;
}
