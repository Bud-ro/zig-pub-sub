//! Minimal SCI1 UART driver for debug output on the RX130.
//! Configured for 9600 baud at the default 32 MHz PCLK.
//! TX pin: P2.6 via MPC (SCI1 TXD1).

const gpio = @import("gpio.zig");

// zlinter-disable declaration_naming - hardware register names follow RX130 datasheet
const SCI1_SMR: *volatile u8 = @ptrFromInt(0x0008A020);
const SCI1_BRR: *volatile u8 = @ptrFromInt(0x0008A021);
const SCI1_SCR: *volatile u8 = @ptrFromInt(0x0008A022);
const SCI1_TDR: *volatile u8 = @ptrFromInt(0x0008A023);
const SCI1_SSR: *volatile u8 = @ptrFromInt(0x0008A024);
const SCI1_SCMR: *volatile u8 = @ptrFromInt(0x0008A026);

/// MPC write-protect register. Write 0x00 to unlock, 0x01 to lock.
const MPC_PWPR: *volatile u8 = @ptrFromInt(0x0008C11F);
/// MPC P26PFS: pin function select for P2.6.
const MPC_P26PFS: *volatile u8 = @ptrFromInt(0x0008C196);

/// MSTP(SCI1) is bit 30 of SYSTEM.MSTPCRB.
const SYSTEM_MSTPCRB: *volatile u32 = @ptrFromInt(0x00080014);
// zlinter-enable declaration_naming

/// SCR bit masks.
const SCR_TE: u8 = 1 << 5; // zlinter-disable-current-line declaration_naming
/// SSR bit masks.
const SSR_TDRE: u8 = 1 << 7; // zlinter-disable-current-line declaration_naming

/// Initialize SCI1 for 9600 baud 8N1 TX-only operation.
pub fn init() void {
    // Clear SCI1 module-stop bit (MSTPCRB bit 30)
    SYSTEM_MSTPCRB.* &= ~(@as(u32, 1) << 30);

    // Disable TX/RX before configuration
    SCI1_SCR.* = 0x00;

    // 8N1, CKS=0 (PCLK/1), asynchronous mode
    SCI1_SMR.* = 0x00;

    // BRR = PCLK / (64 * baud) - 1 = 32000000 / (64 * 9600) - 1 = 51
    SCI1_BRR.* = 51;

    // Smart card mode register: non-smart-card mode
    SCI1_SCMR.* = 0xF2;

    // Configure P2.6 as SCI1 TXD1 via MPC
    MPC_PWPR.* = 0x00; // unlock MPC writes (clear B0WI)
    MPC_P26PFS.* = 0x0A; // select SCI1 TXD1
    MPC_PWPR.* = 0x80; // lock MPC writes (set B0WI)
    gpio.setPeripheralMode(.port2, 6);

    // Enable transmitter
    SCI1_SCR.* = SCR_TE;
}

/// Write a single byte, blocking until the transmit data register is empty.
pub fn putc(c: u8) void {
    while (SCI1_SSR.* & SSR_TDRE == 0) {}
    SCI1_TDR.* = c;
}

/// Write a string to UART.
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
