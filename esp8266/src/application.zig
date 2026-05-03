//! Application-level wiring for the ESP8266 firmware.
//! Binds ERD definitions to concrete data components, sets up the erd_core
//! TimerModule, and bridges SDK software timers to erd_core's tick-based scheduler.

const erd_core = @import("erd_core");
const hardware = @import("hardware.zig");
const sdk = @import("sdk.zig");
const std = @import("std");
const system_erds = @import("system_erds.zig");

pub const RamDataComponent = erd_core.data_component.Ram(&system_erds.ram_definitions);

pub const Components = struct {
    ram: RamDataComponent,
};

pub const SystemData = erd_core.SystemData(system_erds.ErdDefinitions, system_erds.ErdEnum, system_erds.erd, Components);

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

    app.system_data.subscribe(.erd_led_state, null, on_led_state_changed);

    sdk.ets_timer_setfn(&app.tick_timer, tick_and_run_callback, null);
    sdk.timer_arm_ms(&app.tick_timer, 1, true);

    timer_module.start_periodic(&app.led_blink_timer, 500, app, on_led_blink);
    timer_module.start_periodic(&app.uptime_timer, 1000, app, on_uptime_tick);
}

fn on_led_state_changed(_: ?*anyopaque, args: ?*const anyopaque, _: *anyopaque) void {
    const on_change: *const erd_core.Subscription.OnChangeArgs = @ptrCast(@alignCast(args.?));
    const led_state: *const bool = @ptrCast(@alignCast(on_change.data));
    hardware.set_led(led_state.*);
}

fn on_led_blink(ctx: ?*anyopaque, _: *erd_core.timer.TimerModule, _: *erd_core.timer.Timer) void {
    const app: *Application = @ptrCast(@alignCast(ctx.?));
    const current = app.system_data.read(.erd_led_state);
    app.system_data.write(.erd_led_state, !current);
}

fn on_uptime_tick(ctx: ?*anyopaque, _: *erd_core.timer.TimerModule, _: *erd_core.timer.Timer) void {
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
fn tick_and_run_callback(_: ?*anyopaque) callconv(sdk.cc) void {
    timer_module.increment_current_time(1);
    while (timer_module.run()) {}
}
