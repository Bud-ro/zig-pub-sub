//! Application-level wiring for the PIC32MX270 firmware.
//! Binds ERD definitions to concrete data components, sets up the erd_core
//! TimerModule, and runs a tick-driven main loop.

const erd_core = @import("erd_core");
const hardware = @import("hardware.zig");
const system_erds = @import("system_erds.zig");

/// Concrete RAM data component type for PIC32MX.
pub const RamDataComponent = erd_core.data_component.Ram(&system_erds.ram_definitions);

/// Aggregate of all data components for PIC32MX.
pub const Components = struct {
    ram: RamDataComponent,
};

/// Fully instantiated SystemData type for PIC32MX.
pub const SystemData = erd_core.SystemData(system_erds.ErdDefinitions, system_erds.ErdEnum, system_erds.erd, Components);

/// Top-level PIC32MX application state with timers and system data.
pub const Application = struct {
    system_data: SystemData,
    timer_module: erd_core.timer.TimerModule,
    led_blink_timer: erd_core.timer.Timer,
    uptime_timer: erd_core.timer.Timer,
};

/// Initialize SystemData, wire subscriptions, and start periodic timers.
/// Takes a pointer to a static `Application` owned by the caller.
pub fn init(app: *Application) void {
    app.* = .{
        .system_data = SystemData.init(.{ .ram = RamDataComponent.init() }),
        .timer_module = .{},
        .led_blink_timer = .{},
        .uptime_timer = .{},
    };

    app.system_data.subscribe(.erd_led_state, null, onLedStateChanged);

    app.timer_module.startPeriodic(&app.led_blink_timer, 500, app, onLedBlink);
    app.timer_module.startPeriodic(&app.uptime_timer, 1000, app, onUptimeTick);
}

/// Advance timers by one millisecond and run any expired callbacks.
pub fn tick(app: *Application) void {
    app.timer_module.incrementCurrentTime(1);
    while (app.timer_module.run()) {}
}

fn onLedStateChanged(_: ?*anyopaque, args: ?*const anyopaque, _: *anyopaque) void {
    const on_change: *const erd_core.system_data.OnChangeArgs = @ptrCast(@alignCast(args.?));
    const led_state: *const bool = @ptrCast(@alignCast(on_change.data));
    hardware.setLed(led_state.*);
}

fn onLedBlink(ctx: ?*anyopaque, _: *erd_core.timer.TimerModule, _: *erd_core.timer.Timer) void {
    const app: *Application = @ptrCast(@alignCast(ctx.?));
    const current = app.system_data.read(.erd_led_state);
    app.system_data.write(.erd_led_state, !current);
}

fn onUptimeTick(ctx: ?*anyopaque, _: *erd_core.timer.TimerModule, _: *erd_core.timer.Timer) void {
    const app: *Application = @ptrCast(@alignCast(ctx.?));
    const current = app.system_data.read(.erd_uptime_seconds);
    app.system_data.write(.erd_uptime_seconds, current +% 1);
}
