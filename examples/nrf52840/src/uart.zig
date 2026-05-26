//! Minimal UARTE0 driver for debug output on the nRF52840-DK.
//! Uses the EasyDMA-based UARTE peripheral in single-byte polling mode.
//! TX pin: P0.06 (active on DK board).

const gpio = @import("gpio.zig");

// zlinter-disable declaration_naming - hardware register names follow nRF52840 convention

const UARTE0_BASE: u32 = 0x40002000;

/// Trigger TX start.
const TASKS_STARTTX: *volatile u32 = @ptrFromInt(UARTE0_BASE + 0x008);
/// TX complete event.
const EVENTS_ENDTX: *volatile u32 = @ptrFromInt(UARTE0_BASE + 0x120);
/// Peripheral enable register. Write 8 to enable UARTE.
const ENABLE: *volatile u32 = @ptrFromInt(UARTE0_BASE + 0x500);
/// Pin select for TXD. Write pin number, bit 31 = 0 for connected.
const PSEL_TXD: *volatile u32 = @ptrFromInt(UARTE0_BASE + 0x50C);
/// TX buffer pointer (must be in RAM).
const TXD_PTR: *volatile u32 = @ptrFromInt(UARTE0_BASE + 0x544);
/// TX buffer length.
const TXD_MAXCNT: *volatile u32 = @ptrFromInt(UARTE0_BASE + 0x548);
/// Baud rate register. 0x01D7E000 = 115200 baud.
const BAUDRATE: *volatile u32 = @ptrFromInt(UARTE0_BASE + 0x524);
/// UART config (parity, stop bits, flow control).
const CONFIG: *volatile u32 = @ptrFromInt(UARTE0_BASE + 0x56C);

// zlinter-enable declaration_naming

/// TX pin on the nRF52840-DK.
const TX_PIN: u5 = 6; // zlinter-disable-current-line declaration_naming

/// Single-byte RAM buffer for EasyDMA TX transfers.
var tx_byte: u8 = 0;

/// Initialize UARTE0: configure TX pin, 115200 baud, 8N1, no flow control.
pub fn init() void {
    gpio.configOutput(TX_PIN);
    gpio.setPin(TX_PIN); // idle high

    PSEL_TXD.* = TX_PIN; // connect, bit 31 = 0
    BAUDRATE.* = 0x01D7E000; // 115200
    CONFIG.* = 0; // no parity, 1 stop bit, no flow control
    ENABLE.* = 8; // enable UARTE
}

/// Write a single byte, blocking until the TX transfer completes.
pub fn putc(c: u8) void {
    tx_byte = c;
    TXD_PTR.* = @intFromPtr(&tx_byte);
    TXD_MAXCNT.* = 1;
    EVENTS_ENDTX.* = 0;
    TASKS_STARTTX.* = 1;
    while (EVENTS_ENDTX.* == 0) {}
}

/// Write a string to UARTE0.
pub fn puts(s: []const u8) void {
    for (s) |c| putc(c);
}

/// Write an unsigned 32-bit integer as decimal.
pub fn dec(val: u32) void {
    if (val == 0) {
        putc('0');
        return;
    }
    var buf: [10]u8 = undefined;
    var n = val;
    var i: u8 = 0;
    while (n > 0) : (i += 1) {
        buf[i] = @truncate(n % 10 + '0');
        n /= 10;
    }
    while (i > 0) {
        i -= 1;
        putc(buf[i]);
    }
}

/// Write a signed 32-bit integer as decimal.
pub fn sdec(val: i32) void {
    if (val < 0) putc('-');
    dec(@abs(val));
}
