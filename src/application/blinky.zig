//! Periodically toggles a GPIO

const std = @import("std");
const Timer = @import("../timer.zig").Timer;
const Ticks = @import("../timer.zig").Ticks;
const TimerModule = @import("../timer.zig").TimerModule;

const Blinky = @This();

current_state: bool = undefined,
timer: Timer = undefined,

fn blink_period_expired(ctx: ?*anyopaque, _timer_module: *TimerModule, _timer: *Timer) void {
    _ = _timer_module;
    _ = _timer;
    const self: *Blinky = @ptrCast(@alignCast(ctx.?));
    _ = self;
    // self.current_state = !self.current_state;

    // const state: u1 = @intFromBool(self.current_state);
    // PORTBDATA.* = (@as(u8, state) << 7);
}

pub fn init(self: *Blinky, timer_module: *TimerModule, period: Ticks) void {
    self.*.current_state = false;
    self.timer.init(self, blink_period_expired);

    timer_module.start_periodic(&self.timer, period);
}
