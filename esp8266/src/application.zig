const std = @import("std");
const erd_core = @import("erd_core");
const SystemErds = @import("system_erds.zig");
const hardware = @import("hardware.zig");
const sdk = @import("sdk.zig");

pub const RamDataComponent = erd_core.data_component.Ram(&SystemErds.ram_definitions);

pub const Components = struct {
    ram: RamDataComponent,
};

pub const SystemData = erd_core.SystemData(SystemErds.ErdDefinitions, SystemErds.ErdEnum, SystemErds.erd, Components);

pub const Application = struct {
    system_data: SystemData,
    tick_timer: sdk.ETSTimer,
    run_timer: sdk.ETSTimer,
    led_blink_timer: erd_core.timer.Timer,
    uptime_timer: erd_core.timer.Timer,
};

var timer_module: erd_core.timer.TimerModule = .{};

pub fn init() Application {
    var app = Application{
        .system_data = SystemData.init(.{
            .ram = RamDataComponent.init(),
        }),
        .tick_timer = std.mem.zeroes(sdk.ETSTimer),
        .run_timer = std.mem.zeroes(sdk.ETSTimer),
        .led_blink_timer = .{},
        .uptime_timer = .{},
    };

    app.system_data.subscribe(.erd_led_state, null, on_led_state_changed);

    return app;
}

fn on_led_state_changed(_: ?*anyopaque, args: ?*const anyopaque, _: *anyopaque) void {
    if (args) |a| {
        const on_change: *const erd_core.Subscription.OnChangeArgs = @ptrCast(@alignCast(a));
        const led_on: *const bool = @ptrCast(@alignCast(on_change.data));
        hardware.set_led(led_on.*);
    }
}

fn on_led_blink(_: ?*anyopaque, _: *erd_core.timer.TimerModule, _: *erd_core.timer.Timer) void {
    const current = global_app.system_data.read(.erd_led_state);
    global_app.system_data.write(.erd_led_state, !current);
}

fn on_uptime_tick(_: ?*anyopaque, _: *erd_core.timer.TimerModule, _: *erd_core.timer.Timer) void {
    const current = global_app.system_data.read(.erd_uptime_seconds);
    global_app.system_data.write(.erd_uptime_seconds, current +% 1);
}

var global_app: *Application = undefined;

pub fn start(app: *Application) void {
    global_app = app;

    sdk.ets_timer_setfn(&app.tick_timer, tick_callback, null);
    sdk.timer_arm_ms(&app.tick_timer, 1, true);

    sdk.ets_timer_setfn(&app.run_timer, run_callback, null);
    sdk.timer_arm_ms(&app.run_timer, 1, true);

    timer_module.start_periodic(&app.led_blink_timer, 500, null, on_led_blink);
    timer_module.start_periodic(&app.uptime_timer, 1000, null, on_uptime_tick);
}

fn tick_callback(_: ?*anyopaque) callconv(sdk.cc) void {
    timer_module.increment_current_time(1);
}

fn run_callback(_: ?*anyopaque) callconv(sdk.cc) void {
    _ = timer_module.run();
}
