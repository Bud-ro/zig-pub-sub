const std = @import("std");
const SystemData = @import("system_data.zig");
const SystemErds = @import("system_erds.zig");
const TimerModule = @import("timer.zig").TimerModule;

pub export fn main() void {
    var system_data = SystemData.init();
    var timer_module = TimerModule.init();
    system_data.write(SystemErds.erd.timer_module, &timer_module);

    while (true) {
        // const no_timers_expired = !timer_module.run();
        // if (no_timers_expired) {
        //     asm volatile ("sleep");
        // }
    }
}
