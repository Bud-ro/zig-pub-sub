//! Periodically toggles a GPIO

const std = @import("std");
const Timer = @import("../timer.zig").Timer;
const Ticks = @import("../timer.zig").Ticks;
const TimerModule = @import("../timer.zig").TimerModule;
const peripherals = @import("../hardware/atmega2560.zig").peripherals;

const Blinky = @This();

timer: Timer = undefined,

fn blink_period_expired(ctx: ?*anyopaque, _timer_module: *TimerModule, _timer: *Timer) void {
    _ = _timer_module;
    _ = _timer;
    const self: *Blinky = @ptrCast(@alignCast(ctx.?));
    _ = self;

    peripherals.PORTB.*.PORTB ^= 1 << 7;
}

pub fn init(self: *Blinky, timer_module: *TimerModule, period: Ticks) void {
    self.timer.init(self, blink_period_expired);

    timer_module.start_periodic(&self.timer, period);
}
