//! Hardware Initialization

const SystemData = @import("../system_data.zig");
const SystemErds = @import("../system_erds.zig");
const peripherals = @import("atmega2560.zig").peripherals;

const Hardware = @This();

pub fn init(self: *Hardware, system_data: *SystemData) void {
    _ = self;
    _ = system_data;

    // Set PORTB7 direction = out
    peripherals.PORTB.*.DDRB = (1 << 7);
    // Set PORTB7 to value
    peripherals.PORTB.*.PORTB = (1 << 7);
}
