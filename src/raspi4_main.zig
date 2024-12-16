const std = @import("std");
const SystemData = @import("system_data.zig");
const SystemErds = @import("system_erds.zig");
const TimerModule = @import("timer.zig").TimerModule;
const bcm2711 = @import("hardware/bcm2711_lpa.zig");

pub export fn main() void {
    var system_data = SystemData.init();
    var timer_module = TimerModule.init();
    system_data.write(SystemErds.erd.timer_module, &timer_module);

    bcm2711.peripherals.GPIO.GPFSEL2 |= (0b001 << 21); // Set GPIO 27 as output

    while (true) {
        const no_more_timers_to_expire_this_tick = !timer_module.run();
        if (no_more_timers_to_expire_this_tick) {
            std.atomic.spinLoopHint();
        }
    }
}
