//! Hardware Initialization

const SystemData = @import("../system_data.zig");
const SystemErds = @import("../system_erds.zig");
const peripherals = @import("atmega2560.zig").peripherals;

const Hardware = @This();

// Put interrupt handlers here with same name from the vector table
pub const interrupts = struct {
    // Pin Change Interrupt Source 0
    // pub fn PCINT0() void {}
};

pub fn init(self: *Hardware, system_data: *SystemData) void {
    _ = self;
    _ = system_data;

    // Set PORTB7 direction = out
    peripherals.PORTB.*.DDRB = (1 << 7);
    // Set PORTB7 to value
    peripherals.PORTB.*.PORTB = (1 << 7);
}
