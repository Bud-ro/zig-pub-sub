//! ATmega328P (Arduino Uno) firmware entry point.
//! Initializes hardware peripherals and erd_core application wiring, then
//! enters a run-to-completion super-loop driven by Timer0 1ms ticks.

const application = @import("application.zig");
const hardware = @import("hardware.zig");
const uart = @import("uart.zig");

var app: application.Application = undefined;

/// AVR IO register helper.
fn ioReg(comptime addr: u16) *volatile u8 {
    return @ptrFromInt(addr);
}

// Timer0 registers
// zlinter-disable declaration_naming - hardware register names follow AVR convention
const TCCR0A = ioReg(0x44);
const TCCR0B = ioReg(0x45);
const OCR0A = ioReg(0x47);
const TIFR0 = ioReg(0x35);

/// OCR0A compare match flag in TIFR0.
const OCF0A: u8 = 1 << 1;
// zlinter-enable declaration_naming

/// Initialize Timer0 in CTC mode for 1ms ticks.
/// At 16MHz with prescaler /64: 250KHz tick rate, 250 counts = 1ms.
fn initTimer0() void {
    TCCR0A.* = 0x02; // WGM01: CTC mode (clear on OCR0A match)
    TCCR0B.* = 0x03; // CS01|CS00: prescaler /64
    OCR0A.* = 249; // 250 counts (0-249) = 1ms at 250KHz
}

/// Block until the next Timer0 compare match (1ms period).
/// Clears the OCF0A flag by writing 1 to it (AVR convention).
fn waitForTick() void {
    while ((TIFR0.* & OCF0A) == 0) {}
    TIFR0.* = OCF0A;
}

/// Entry point. Initializes all hardware and runs the super-loop.
export fn main() noreturn {
    hardware.init();
    uart.init();
    initTimer0();

    uart.puts("ATmega328P ready\r\n");

    application.init(&app);

    while (true) {
        waitForTick();
        application.tick(&app);
    }
}
