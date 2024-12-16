//! Periodically toggles a GPIO

const std = @import("std");
const Timer = @import("../timer.zig").Timer;
const Ticks = @import("../timer.zig").Ticks;
const TimerModule = @import("../timer.zig").TimerModule;
const bcm2711_lpa = @import("../hardware/bcm2711_lpa.zig");

const Blinky = @This();

timer: Timer = undefined,
led_state: bool = false,

fn blink_period_expired(ctx: ?*anyopaque, _timer_module: *TimerModule, _timer: *Timer) void {
    _ = _timer_module;
    _ = _timer;
    const self: *Blinky = @ptrCast(@alignCast(ctx.?));

    if (self.led_state) {
        bcm2711_lpa.peripherals.GPIO.GPSET0 |= (1 << 27);
    } else {
        bcm2711_lpa.peripherals.GPIO.GPCLR0 |= (1 << 27);
    }

    self.*.led_state = !self.led_state;
}

pub fn init(self: *Blinky, timer_module: *TimerModule, period: Ticks) void {
    self.timer.init(self, blink_period_expired);

    timer_module.start_periodic(&self.timer, period);
}
