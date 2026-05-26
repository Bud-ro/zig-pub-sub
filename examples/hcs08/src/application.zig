//! Application-level wiring for the MC9S08QE8 firmware.
//! Binds ERD definitions to concrete data components, sets up the erd_core
//! TimerModule for a 500ms LED blink and 1s uptime counter, and wires
//! the erd_led_state subscription to the hardware LED driver.

const erd_core = @import("erd_core");
const hardware = @import("hardware.zig");
const system_erds = @import("system_erds.zig");
const uart = @import("uart.zig");

/// Concrete RAM data component type for HCS08.
pub const RamDataComponent = erd_core.data_component.Ram(&system_erds.ram_definitions);

/// Aggregate of all data components for HCS08.
pub const Components = struct {
    ram: RamDataComponent,
};

/// Fully instantiated SystemData type for HCS08.
pub const SystemData = erd_core.SystemData(system_erds.ErdDefinitions, system_erds.ErdEnum, system_erds.erd, Components);

/// Top-level HCS08 application state with timers and system data.
pub const Application = struct {
    system_data: SystemData,
    led_blink_timer: erd_core.timer.Timer,
    uptime_timer: erd_core.timer.Timer,
};

var timer_module: erd_core.timer.TimerModule = .{};

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

/// Advance the timer module by one millisecond and run any expired callbacks.
/// Call this from the main super-loop at ~1ms intervals.
pub fn tick() void {
    timer_module.incrementCurrentTime(1);
    while (timer_module.run()) {}
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

    uart.puts("uptime: ");
    uart.dec(current +% 1);
    uart.puts("s\r\n");
}
