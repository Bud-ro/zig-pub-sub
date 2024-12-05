//! Hardware Initialization

const std = @import("std");
const SystemData = @import("../system_data.zig");
const SystemErds = @import("../system_erds.zig");
const atmega2560 = @import("atmega2560.zig");

const Hardware = @This();
const TimerModule = @import("../timer.zig").TimerModule;

var timer_module: *TimerModule = undefined;
var t: u8 = 0;

// Put interrupt handlers here with same name from the vector table
pub const interrupts = struct {
    // System Tick
    pub fn TIMER4_COMPA() void {
        // timer_module.increment_current_time(1);
        var data = atmega2560.peripherals.PORTB.*.PORTB;
        data ^= 1 << 7;
        atmega2560.peripherals.PORTB.*.PORTB = data;
    }
};

// f_OC = f_clk / (2 * N (1 + OCR1A))
// => OCR1A = f_clk / (2*N*f_OC) - 1
const desired_freq = 1; // Hz
const OCR4A = 16000000 / (1024 * desired_freq) - 1; // std.math.maxInt(u16) / 2;

fn setup_system_tick() void {
    // /8 prescalar
    // .RUNNING_CLK_8 = 0x2
    atmega2560.peripherals.TC4.TCCR4A.raw = 0;
    atmega2560.peripherals.TC4.TCCR4B.raw = 0;
    atmega2560.peripherals.TC4.TCNT4 = 0;

    atmega2560.peripherals.TC4.OCR4A = OCR4A;

    // turn on CTC mode
    atmega2560.peripherals.TC4.TCCR4B.raw |= 0b01000;
    // Set CS12 and CS10 bits for 1024 prescaler
    atmega2560.peripherals.TC4.TCCR4B.raw |= 0b101;
    // Enable timer compare interrupt
    atmega2560.peripherals.TC4.TIMSK4.raw |= 0b10;
}

fn setup_heartbeat_led() void {
    // Set PORTB7 direction = out
    atmega2560.peripherals.PORTB.*.DDRB = (1 << 7);
    // Set PORTB7 to value
    atmega2560.peripherals.PORTB.*.PORTB = (0 << 7);
}

pub fn init(self: *Hardware, system_data: *SystemData) void {
    _ = self;

    timer_module = system_data.read(SystemErds.erd.timer_module).?;

    asm volatile ("cli");
    setup_system_tick();
    setup_heartbeat_led();
    asm volatile ("sei");
}
