//! Application-level wiring for the nRF52840-DK firmware.
//! Binds ERD definitions to concrete data components, sets up the erd_core
//! TimerModule, and runs the main super-loop with SysTick-driven timing.

const erd_core = @import("erd_core");
const hardware = @import("hardware.zig");
const system_erds = @import("system_erds.zig");

/// Concrete RAM data component type for nRF52840.
pub const RamDataComponent = erd_core.data_component.Ram(&system_erds.ram_definitions);

/// Aggregate of all data components for nRF52840.
pub const Components = struct {
    ram: RamDataComponent,
};

/// Fully instantiated SystemData type for nRF52840.
pub const SystemData = erd_core.SystemData(system_erds.ErdDefinitions, system_erds.ErdEnum, system_erds.erd, Components);

/// Top-level nRF52840 application state with timers and system data.
pub const Application = struct {
    system_data: SystemData,
    timer_module: erd_core.timer.TimerModule,
    led_blink_timer: erd_core.timer.Timer,
    uptime_timer: erd_core.timer.Timer,
};

/// Global application instance. Stored at file scope so the SysTick handler
/// can access the timer module without passing context through the NVIC.
var app: Application = undefined;

/// SysTick reload value for 1ms tick at 64MHz (nRF52840 default HFCLK).
const SYSTICK_RELOAD: u24 = 64_000 - 1; // zlinter-disable-current-line declaration_naming

// Cortex-M SysTick registers (part of the ARM core, not nRF-specific).
// zlinter-disable declaration_naming - ARM core register names
const SYST_CSR: *volatile u32 = @ptrFromInt(0xE000E010);
const SYST_RVR: *volatile u32 = @ptrFromInt(0xE000E014);
const SYST_CVR: *volatile u32 = @ptrFromInt(0xE000E018);
// zlinter-enable declaration_naming

/// Initialize SystemData, wire subscriptions, configure SysTick, and start timers.
pub fn init() void {
    app = .{
        .system_data = SystemData.init(.{ .ram = RamDataComponent.init() }),
        .timer_module = .{},
        .led_blink_timer = .{},
        .uptime_timer = .{},
    };

    app.system_data.subscribe(.erd_led_state, null, onLedStateChanged);

    app.timer_module.startPeriodic(&app.led_blink_timer, 500, &app, onLedBlink);
    app.timer_module.startPeriodic(&app.uptime_timer, 1000, &app, onUptimeTick);

    // Configure SysTick for 1ms interrupts
    SYST_RVR.* = SYSTICK_RELOAD;
    SYST_CVR.* = 0;
    SYST_CSR.* = 0x07; // enable, interrupt, processor clock
}

/// Main run-to-completion loop. Called repeatedly from the reset handler.
pub fn run() void {
    while (app.timer_module.run()) {}
    asm volatile ("wfi");
}

fn onLedStateChanged(_: ?*anyopaque, args: ?*const anyopaque, _: *anyopaque) void {
    const on_change: *const erd_core.system_data.OnChangeArgs = @ptrCast(@alignCast(args.?));
    const led_state: *const bool = @ptrCast(@alignCast(on_change.data));
    hardware.setLed(led_state.*);
}

fn onLedBlink(ctx: ?*anyopaque, _: *erd_core.timer.TimerModule, _: *erd_core.timer.Timer) void {
    const self: *Application = @ptrCast(@alignCast(ctx.?));
    const current = self.system_data.read(.erd_led_state);
    self.system_data.write(.erd_led_state, !current);
}

fn onUptimeTick(ctx: ?*anyopaque, _: *erd_core.timer.TimerModule, _: *erd_core.timer.Timer) void {
    const self: *Application = @ptrCast(@alignCast(ctx.?));
    const current = self.system_data.read(.erd_uptime_seconds);
    self.system_data.write(.erd_uptime_seconds, current +% 1);
}

/// SysTick interrupt handler. Increments the timer module tick counter by 1ms.
pub fn sysTickHandler() callconv(.{ .arm_aapcs = .{} }) void {
    app.timer_module.incrementCurrentTime(1);
}
