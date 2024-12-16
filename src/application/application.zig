//! Contains the structure and initialization of the application

const SystemData = @import("../system_data.zig");
const SystemErds = @import("../system_erds.zig");

const Blinky = @import("blinky.zig");

const Application = @This();

blinky: Blinky = undefined,

pub fn init(self: *Application, system_data: *SystemData) void {
    const timer_module = system_data.read(SystemErds.erd.timer_module).?;

    self.blinky.init(timer_module, 1000);
}
