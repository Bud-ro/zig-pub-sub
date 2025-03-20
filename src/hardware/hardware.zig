//! Hardware Initialization

const std = @import("std");
const SystemData = @import("../system_data.zig");
const SystemErds = @import("../system_erds.zig");
const atmega2560 = @import("atmega2560.zig");

const Hardware = @This();
const TimerModule = @import("../timer.zig").TimerModule;

var timer_module: *TimerModule = undefined;
var t: u16 = 0;

// Put interrupt handlers here with same name from the vector table
// pub const interrupts = struct {
//     // System Tick
//     pub fn TIMER0_COMPA() void {
//         // timer_module.increment_current_time(1000);
//         // atmega2560.peripherals.PORTB.*.PORTB = 0;
//         t += 1;
//         if (t >= 1000) {
//             atmega2560.peripherals.PORTB.*.PORTB ^= 1 << 7;
//             t -= 1000;
//         }
//     }
// };

// f_OC = f_clk / (2 * N (1 + OCR1A))
// => OCR1A = f_clk / (2*N*f_OC) - 1
const desired_freq = 1000; // Hz
const OCR0A = 16000000 / (64 * desired_freq) - 1;

fn setup_system_tick() void {
    atmega2560.peripherals.TC0.TCCR0A.raw = (1 << 1);
    atmega2560.peripherals.TC0.TCCR0B.raw = 0x3;
    atmega2560.peripherals.TC0.OCR0A = OCR0A;

    // Enable timer compare interrupt
    atmega2560.peripherals.TC0.TIMSK0.raw |= (1 << 1);
}

fn setup_heartbeat_led() void {
    // Set PORTB7 direction = out
    atmega2560.peripherals.PORTB.*.DDRB |= (1 << 7);
    // Set PORTB7 to value
    atmega2560.peripherals.PORTB.*.PORTB = 0x00;
}

pub fn init(self: *Hardware, system_data: *SystemData) void {
    _ = self;
    _ = system_data;

    setup_heartbeat_led();
    setup_system_tick();
}
