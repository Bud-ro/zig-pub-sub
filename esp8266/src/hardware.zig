const sdk = @import("sdk.zig");
const gpio = @import("gpio.zig");

const WDT_CTL: *volatile u32 = @ptrFromInt(0x60000900);

const LED_PIN: u5 = 2;

var tick_timer: sdk.ETSTimer = undefined;

pub fn init() void {
    WDT_CTL.* = 0;

    gpio.set_gpio_func(LED_PIN);
    gpio.set_output(LED_PIN);
    gpio.set_pin(LED_PIN);
}

pub fn start_tick_timer(comptime callback: fn () void) void {
    const wrapper = struct {
        fn f(_: ?*anyopaque) callconv(sdk.cc) void {
            callback();
        }
    };
    tick_timer = std.mem.zeroes(sdk.ETSTimer);
    sdk.ets_timer_setfn(&tick_timer, wrapper.f, null);
    sdk.timer_arm_ms(&tick_timer, 1, true);
}

pub fn set_led(on: bool) void {
    if (on) {
        gpio.clear_pin(LED_PIN);
    } else {
        gpio.set_pin(LED_PIN);
    }
}

const std = @import("std");
