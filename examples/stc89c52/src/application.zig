//! Application-level wiring for the STC89C52RC firmware.
//! Binds ERD definitions to concrete data components, sets up the erd_core
//! TimerModule, and runs a cooperative super-loop driven by a software tick.

const erd_core = @import("erd_core");
const hardware = @import("hardware.zig");
const system_erds = @import("system_erds.zig");

/// Concrete RAM data component type for STC89C52.
pub const RamDataComponent = erd_core.data_component.Ram(&system_erds.ram_definitions);

/// Aggregate of all data components for STC89C52.
pub const Components = struct {
    ram: RamDataComponent,
};

/// Fully instantiated SystemData type for STC89C52.
pub const SystemData = erd_core.SystemData(system_erds.ErdDefinitions, system_erds.ErdEnum, system_erds.erd, Components);

/// Top-level STC89C52 application state with timers and system data.
pub const Application = struct {
    system_data: SystemData,
    led_blink_timer: erd_core.timer.Timer,
    uptime_timer: erd_core.timer.Timer,
};

/// Shared timer module instance, advanced by the main super-loop.
pub var timer_module: erd_core.timer.TimerModule = .{};

/// Initialize SystemData, wire subscriptions, and start periodic timers.
/// Takes a pointer to a static `Application` owned by the caller.
pub fn init(app: *Application) void {
    app.* = .{
        .system_data = SystemData.init(.{ .ram = RamDataComponent.init() }),
        .led_blink_timer = .{},
        .uptime_timer = .{},
    };

    app.system_data.subscribe(.erd_led_state, null, onLedStateChanged);

    timer_module.startPeriodic(&app.led_blink_timer, 500, app, onLedBlink);
    timer_module.startPeriodic(&app.uptime_timer, 1000, app, onUptimeTick);
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
