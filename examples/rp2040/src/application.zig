//! Application-level wiring for the RP2040 firmware.
//! Binds ERD definitions to concrete data components, sets up the erd_core
//! TimerModule, and runs a tick-based run-to-completion loop with LED blink
//! (500ms) and uptime counter (1s) timers.

const erd_core = @import("erd_core");
const hardware = @import("hardware.zig");
const system_erds = @import("system_erds.zig");

/// Concrete RAM data component type for RP2040.
pub const RamDataComponent = erd_core.data_component.Ram(&system_erds.ram_definitions);

/// Aggregate of all data components for RP2040.
pub const Components = struct {
    ram: RamDataComponent,
};

/// Fully instantiated SystemData type for RP2040.
pub const SystemData = erd_core.SystemData(system_erds.ErdDefinitions, system_erds.ErdEnum, system_erds.erd, Components);

/// Top-level RP2040 application state with timers and system data.
pub const Application = struct {
    system_data: SystemData,
    timer_module: erd_core.timer.TimerModule,
    led_blink_timer: erd_core.timer.Timer,
    uptime_timer: erd_core.timer.Timer,
    tick_counter: u32,
};

/// Initialize SystemData, wire subscriptions, and start periodic timers.
/// Takes a pointer to a static `Application` owned by the caller.
pub fn init(app: *Application) void {
    app.* = .{
        .system_data = SystemData.init(.{ .ram = RamDataComponent.init() }),
        .timer_module = .{},
        .led_blink_timer = .{},
        .uptime_timer = .{},
        .tick_counter = 0,
    };

    app.system_data.subscribe(.erd_led_state, null, onLedStateChanged);

    app.timer_module.startPeriodic(&app.led_blink_timer, 500, app, onLedBlink);
    app.timer_module.startPeriodic(&app.uptime_timer, 1000, app, onUptimeTick);
}

/// Run one iteration of the main loop.
/// Increments the tick counter (approximately 1ms per call via busy-wait)
/// and drains all ready timers.
pub fn run(app: *Application) void {
    delay(tick_delay_cycles);
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

/// Approximate busy-wait delay. The ring oscillator runs at roughly 6.5MHz.
/// Each loop iteration is about 4 cycles (sub, cmp, branch + nop), so
/// ~1625 iterations gives approximately 1ms.
const tick_delay_cycles: u32 = 1625;

fn delay(count: u32) void {
    var i: u32 = 0;
    while (i < count) : (i += 1) {
        asm volatile ("nop");
    }
}
