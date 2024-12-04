const std = @import("std");
const SystemData = @import("system_data.zig");
const SystemErds = @import("system_erds.zig");
const TimerModule = @import("timer.zig").TimerModule;
const Application = @import("application/application.zig");
const Hardware = @import("hardware/hardware.zig");

export fn main() void {
    var system_data = SystemData.init();
    var timer_module = TimerModule.init();
    system_data.write(SystemErds.erd.timer_module, &timer_module);

    var hardware: Hardware = undefined;
    hardware.init(&system_data);

    // Should be initted after hardware
    var application: Application = undefined;
    application.init(&system_data);

    while (true) {
        if (!timer_module.run()) {
            // Sleep
            std.atomic.spinLoopHint();
        }
    }
}
