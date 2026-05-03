//! Application-level wiring for the ESP8266 firmware.
//! Binds ERD definitions to concrete data components, sets up the erd_core
//! TimerModule, and bridges SDK software timers to erd_core's tick-based scheduler.

const erd_core = @import("erd_core");
const hardware = @import("hardware.zig");
const sdk = @import("sdk.zig");
const std = @import("std");
const system_erds = @import("system_erds.zig");

/// Concrete RAM data component type for ESP8266.
pub const RamDataComponent = erd_core.data_component.Ram(&system_erds.ram_definitions);

/// Aggregate of all data components for ESP8266.
pub const Components = struct {
    ram: RamDataComponent,
};

/// Fully instantiated SystemData type for ESP8266.
pub const SystemData = erd_core.SystemData(system_erds.ErdDefinitions, system_erds.ErdEnum, system_erds.erd, Components);

/// Top-level ESP8266 application state with timers and system data.
pub const Application = struct {
    system_data: SystemData,
    tick_timer: sdk.ETSTimer,
    led_blink_timer: erd_core.timer.Timer,
    uptime_timer: erd_core.timer.Timer,
};

var timer_module: erd_core.timer.TimerModule = .{};

/// Initialize SystemData, wire subscriptions, and start the timer system.
/// Takes a pointer to a static `Application` owned by the caller.
pub fn init(app: *Application) void {
    app.* = .{
        .system_data = SystemData.init(.{ .ram = RamDataComponent.init() }),
        .tick_timer = std.mem.zeroes(sdk.ETSTimer),
        .led_blink_timer = .{},
        .uptime_timer = .{},
    };

    app.system_data.subscribe(.erd_led_state, null, onLedStateChanged);

    sdk.ets_timer_setfn(&app.tick_timer, tickAndRunCallback, null);
    sdk.timerArmMs(&app.tick_timer, 1, true);

    timer_module.startPeriodic(&app.led_blink_timer, 500, app, onLedBlink);
    timer_module.startPeriodic(&app.uptime_timer, 1000, app, onUptimeTick);
}

fn onLedStateChanged(_: ?*anyopaque, args: ?*const anyopaque, _: *anyopaque) void {
    const on_change: *const erd_core.Subscription.OnChangeArgs = @ptrCast(@alignCast(args.?));
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

/// Equivalent to super-loop, AKA:
/// `while(true){ const did_work = timer_module.run(); if(!did_work){ _WFI(); } }`.
/// Since we don't own the Wi-Fi stack and the SDK has its own software timers,
/// this is simply to demonstrate how you would use `erd_core`'s timers.
///
/// The semantics of these software schedulers are just slightly different enough
/// that you might justify this. But it also lets you write code that's automatically
/// portable to other `erd_core` systems.
///
/// In order to not starve the SDK you should really put each major sub-system
/// on its own `timer_module`, but this is fine for demonstration.
fn tickAndRunCallback(_: ?*anyopaque) callconv(sdk.cc) void {
    timer_module.incrementCurrentTime(1);
    while (timer_module.run()) {}
}
