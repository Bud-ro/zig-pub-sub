//! Application-level wiring for the STM32F103 firmware.
//!
//! Binds ERD definitions to concrete data components, sets up the erd_core
//! TimerModule with a 500ms LED blink timer and a 1-second uptime counter.

const erd_core = @import("erd_core");
const hardware = @import("hardware.zig");
const system_erds = @import("system_erds.zig");

/// Concrete RAM data component type for STM32F103.
pub const RamDataComponent = erd_core.data_component.Ram(&system_erds.ram_definitions);

/// Aggregate of all data components for STM32F103.
pub const Components = struct {
    ram: RamDataComponent,
};

/// Fully instantiated SystemData type for STM32F103.
pub const SystemData = erd_core.SystemData(system_erds.ErdDefinitions, system_erds.ErdEnum, system_erds.erd, Components);

var system_data: SystemData = undefined;
var timer_module: erd_core.timer.TimerModule = .{};
var led_blink_timer: erd_core.timer.Timer = .{};
var uptime_timer: erd_core.timer.Timer = .{};

/// Tick counter incremented by the main loop's simple delay.
var tick_count: u32 = 0;

/// Initialize SystemData, wire subscriptions, and start timers.
pub fn init() void {
    system_data = SystemData.init(.{ .ram = RamDataComponent.init() });

    system_data.subscribe(.erd_led_state, null, onLedStateChanged);

    timer_module.startPeriodic(&led_blink_timer, 500, null, onLedBlink);
    timer_module.startPeriodic(&uptime_timer, 1000, null, onUptimeTick);
}

/// Run one iteration of the main loop: advance time and execute ready timers.
///
/// Uses a simple busy-wait delay to approximate 1ms ticks. At 8 MHz HSI
/// with no flash wait states this is roughly 800 iterations per ms.
pub fn run() void {
    delay(800);
    tick_count += 1;
    timer_module.incrementCurrentTime(1);
    while (timer_module.run()) {}
}

fn onLedStateChanged(_: ?*anyopaque, args: ?*const anyopaque, _: *anyopaque) void {
    const on_change: *const erd_core.system_data.OnChangeArgs = @ptrCast(@alignCast(args.?));
    const led_state: *const bool = @ptrCast(@alignCast(on_change.data));
    hardware.setLed(led_state.*);
}

fn onLedBlink(_: ?*anyopaque, _: *erd_core.timer.TimerModule, _: *erd_core.timer.Timer) void {
    const current = system_data.read(.erd_led_state);
    system_data.write(.erd_led_state, !current);
}

fn onUptimeTick(_: ?*anyopaque, _: *erd_core.timer.TimerModule, _: *erd_core.timer.Timer) void {
    const current = system_data.read(.erd_uptime_seconds);
    system_data.write(.erd_uptime_seconds, current +% 1);
}

/// Simple busy-wait delay loop.
fn delay(count: u32) void {
    var i: u32 = 0;
    while (i < count) : (i += 1) {
        asm volatile ("nop");
    }
}
