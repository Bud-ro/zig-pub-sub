//! Hardware Initialization

const std = @import("std");
const SystemData = @import("../system_data.zig");
const SystemErds = @import("../system_erds.zig");
const atmega2560 = @import("atmega2560.zig");

const Hardware = @This();
const TimerModule = @import("../timer.zig").TimerModule;

var timer_module: *TimerModule = undefined;

// Put interrupt handlers here with same name from the vector table
pub const interrupts = struct {
    // System Tick
    pub fn TIMER1_COMPB() void {
        asm volatile ("cli");
        timer_module.increment_current_time(1);
        // atmega2560.peripherals.TC1.TCNT1 = 0;
        // atmega2560.peripherals.TC1.OCR1B = OCR1B;
        // atmega2560.peripherals.TC1.TIMSK1.modify(.{ .OCIE1B = 1 });
        asm volatile ("sei");
    }
};

// f_OC = f_clk / (2 * N (1 + OCR1A))
// => OCR1A = f_clk / (2*N*f_OC) - 1
const desired_freq = 1000; // Hz
const OCR1B = atmega2560.CPU_FREQ / (2 * 8 * desired_freq) - 1; // std.math.maxInt(u16) / 2;

fn setup_system_tick() void {
    atmega2560.peripherals.TC1.OCR1B = OCR1B;
    // /8 prescalar
    // .RUNNING_CLK_8 = 0x2
    // Can't .modify for some reason
    atmega2560.peripherals.TC1.TCCR1A.raw = 0;
    atmega2560.peripherals.TC1.TCCR1A.modify(.{ .WGM1 = 0x2, .COM1B = 1 });
    atmega2560.peripherals.TC1.TCCR1B.raw = 0x2;
    // atmega2560.peripherals.TC1.TCCR1C.raw = 0x2;
    atmega2560.peripherals.TC1.TIFR1.modify(.{ .OCF1B = 1 });
    // Enable capture compare interrupt
    atmega2560.peripherals.TC1.TIMSK1.modify(.{ .OCIE1B = 1 });
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
