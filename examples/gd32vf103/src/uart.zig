//! Minimal USART0 driver for GD32VF103 debug output.
//! Configures USART0 on PA9 (TX) at 115200 baud using the default 8MHz
//! IRC8M internal oscillator. Only transmit is implemented.

const gpio = @import("gpio.zig");

// zlinter-disable declaration_naming - hardware register names follow GD32VF103 convention

/// RCU APB2 clock enable register.
const RCU_APB2EN: *volatile u32 = @ptrFromInt(0x40021018);

/// USART0 status register.
const USART0_STAT: *volatile u32 = @ptrFromInt(0x40013800);
/// USART0 data register.
const USART0_DATA: *volatile u32 = @ptrFromInt(0x40013804);
/// USART0 baud rate register.
const USART0_BAUD: *volatile u32 = @ptrFromInt(0x40013808);
/// USART0 control register 0.
const USART0_CTL0: *volatile u32 = @ptrFromInt(0x4001380C);

// zlinter-enable declaration_naming

// zlinter-disable declaration_naming - hardware bit-field names

/// TBE (Transmit Buffer Empty) flag in STAT register.
const STAT_TBE: u32 = 1 << 7;
/// UEN (USART Enable) bit in CTL0.
const CTL0_UEN: u32 = 1 << 13;
/// TEN (Transmit Enable) bit in CTL0.
const CTL0_TEN: u32 = 1 << 3;

// zlinter-enable declaration_naming

/// Initialize USART0: enable clocks, configure PA9 as alt-func TX,
/// set baud rate to 115200 at 8MHz, enable transmitter.
pub fn init() void {
    // Enable GPIOA and USART0 clocks in RCU APB2EN
    // Bit 2 = PAEN (GPIOA), bit 14 = USART0EN
    RCU_APB2EN.* |= (1 << 2) | (1 << 14);

    // Configure PA9 as alternate-function push-pull output at 10MHz
    gpio.configurePin(.a, 9, .output_10mhz, .alt_push_pull_or_pull);

    // Baud rate: 8_000_000 / 115200 ~= 69
    USART0_BAUD.* = 69;

    // Enable USART and transmitter
    USART0_CTL0.* = CTL0_UEN | CTL0_TEN;
}

/// Write a single byte, blocking until the TX buffer is empty.
pub fn putc(c: u8) void {
    while (USART0_STAT.* & STAT_TBE == 0) {}
    USART0_DATA.* = c;
}

/// Write a string to USART0.
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
