//! Application-level wiring for the ESP32-C3 firmware.
//! Binds ERD definitions to concrete data components, sets up the erd_core
//! TimerModule, and runs the main super-loop with SYSTIMER-based ticking.

const erd_core = @import("erd_core");
const hardware = @import("hardware.zig");
const system_erds = @import("system_erds.zig");

/// Concrete RAM data component type for ESP32-C3.
pub const RamDataComponent = erd_core.data_component.Ram(&system_erds.ram_definitions);

/// Aggregate of all data components for ESP32-C3.
pub const Components = struct {
    ram: RamDataComponent,
};

/// Fully instantiated SystemData type for ESP32-C3.
pub const SystemData = erd_core.SystemData(system_erds.ErdDefinitions, system_erds.ErdEnum, system_erds.erd, Components);

/// Top-level ESP32-C3 application state with timers and system data.
pub const Application = struct {
    system_data: SystemData,
    led_blink_timer: erd_core.timer.Timer,
    uptime_timer: erd_core.timer.Timer,
};

var timer_module: erd_core.timer.TimerModule = .{};

// SYSTIMER registers for millisecond tick source
// zlinter-disable declaration_naming - hardware register names
const SYSTIMER_BASE = 0x60023000;
const SYSTIMER_CONF_REG: *volatile u32 = @ptrFromInt(SYSTIMER_BASE + 0x00);
const SYSTIMER_UNIT0_OP_REG: *volatile u32 = @ptrFromInt(SYSTIMER_BASE + 0x04);
const SYSTIMER_UNIT0_VALUE_LO_REG: *volatile u32 = @ptrFromInt(SYSTIMER_BASE + 0x08);
const SYSTIMER_UNIT0_VALUE_HI_REG: *volatile u32 = @ptrFromInt(SYSTIMER_BASE + 0x0C);
// zlinter-enable declaration_naming

/// Read the 52-bit SYSTIMER counter. The counter runs at 16 MHz (default).
/// Returns the count value; each tick is 62.5 ns (16 MHz).
fn readSystimerCount() u64 {
    // Latch the counter by writing 1 to TIMER_UNIT0_UPDATE
    SYSTIMER_UNIT0_OP_REG.* = (1 << 30);
    // Wait for latch to complete (bit 29 = TIMER_UNIT0_VALUE_VALID)
    while (SYSTIMER_UNIT0_OP_REG.* & (1 << 29) == 0) {}
    const lo: u64 = SYSTIMER_UNIT0_VALUE_LO_REG.*;
    const hi: u64 = SYSTIMER_UNIT0_VALUE_HI_REG.*;
    return (hi << 32) | lo;
}

/// SYSTIMER ticks per millisecond at 16 MHz.
const ticks_per_ms: u64 = 16_000;

/// Initialize SystemData, wire subscriptions, and start timers.
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

/// Main super-loop. Polls the SYSTIMER and feeds erd_core's TimerModule
/// one tick per millisecond, then runs any expired timer callbacks.
pub fn run() noreturn {
    // Enable SYSTIMER clock
    SYSTIMER_CONF_REG.* |= 1;

    var last_count = readSystimerCount();

    while (true) {
        const now = readSystimerCount();
        const elapsed = now -% last_count;

        if (elapsed >= ticks_per_ms) {
            const ms: u32 = @truncate(elapsed / ticks_per_ms);
            last_count += @as(u64, ms) * ticks_per_ms;
            timer_module.incrementCurrentTime(ms);
            while (timer_module.run()) {}
        }
    }
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
