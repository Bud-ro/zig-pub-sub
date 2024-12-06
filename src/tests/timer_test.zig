const std = @import("std");
const timer = @import("../timer.zig");
const TimerModule = timer.TimerModule;
const Timer = timer.Timer;

fn timer_callback(ctx: ?*anyopaque, _timer_module: *TimerModule, _timer: *Timer) void {
    _ = _timer_module;
    _ = _timer;
    const local_ctx: *u32 = @ptrCast(@alignCast(ctx.?));
    local_ctx.* += 1;
}

fn stop_timer_callback(ctx: ?*anyopaque, _timer_module: *TimerModule, _timer: *Timer) void {
    _ = ctx;
    _ = _timer_module.stop(_timer);
}

test "empty timer run does nothing" {
    var timer_module = TimerModule.init();

    try std.testing.expectEqual(false, timer_module.run());
}

test "timer periodic run" {
    var timer_module = TimerModule.init();

    var local_ctx: u32 = 0;
    var timer1: Timer = .{ .ctx = &local_ctx, .callback = timer_callback };

    timer_module.start_periodic(&timer1, 50);
    try std.testing.expectEqual(false, timer_module.run());

    timer_module.increment_current_time(49);
    try std.testing.expectEqual(false, timer_module.run());

    timer_module.increment_current_time(1);
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(1, local_ctx);
}

test "stopping periodic timer during callback" {
    var timer_module = TimerModule.init();

    var timer1: Timer = .{ .ctx = null, .callback = stop_timer_callback };

    timer_module.start_periodic(&timer1, 50);

    timer_module.increment_current_time(50);
    try std.testing.expectEqual(true, timer_module.run());

    timer_module.increment_current_time(50);
    try std.testing.expectEqual(false, timer_module.run());
}

test "multiple periodics" {
    var timer_module = TimerModule.init();

    var local_ctx1: u32 = 0;
    var local_ctx2: u32 = 0;
    var timer1: Timer = .{ .ctx = &local_ctx1, .callback = timer_callback };
    var timer2: Timer = .{ .ctx = &local_ctx2, .callback = timer_callback };

    timer_module.start_periodic(&timer1, 50);
    timer_module.start_periodic(&timer2, 50);
    try std.testing.expectEqual(false, timer_module.run());

    timer_module.increment_current_time(50);
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(1, local_ctx1);
    try std.testing.expectEqual(0, local_ctx2);

    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(1, local_ctx1);
    try std.testing.expectEqual(1, local_ctx2);

    try std.testing.expectEqual(false, timer_module.run());
    try std.testing.expectEqual(1, local_ctx1);
    try std.testing.expectEqual(1, local_ctx2);
}

test "multiple repeated periodics" {
    var timer_module = TimerModule.init();

    var local_ctx1: u32 = 0;
    var local_ctx2: u32 = 0;
    var local_ctx3: u32 = 0;
    var timer1: Timer = .{ .ctx = &local_ctx1, .callback = timer_callback };
    var timer2: Timer = .{ .ctx = &local_ctx2, .callback = timer_callback };
    var timer3: Timer = .{ .ctx = &local_ctx3, .callback = timer_callback };

    timer_module.start_periodic(&timer1, 50);
    timer_module.start_periodic(&timer2, 50);
    timer_module.start_periodic(&timer3, 50);

    for (1..10) |i| {
        timer_module.increment_current_time(50);
        try std.testing.expectEqual(true, timer_module.run());
        try std.testing.expectEqual(i, local_ctx1);
        try std.testing.expectEqual(i - 1, local_ctx2);
        try std.testing.expectEqual(i - 1, local_ctx3);

        try std.testing.expectEqual(true, timer_module.run());
        try std.testing.expectEqual(i, local_ctx1);
        try std.testing.expectEqual(i, local_ctx2);
        try std.testing.expectEqual(i - 1, local_ctx3);

        try std.testing.expectEqual(true, timer_module.run());
        try std.testing.expectEqual(i, local_ctx1);
        try std.testing.expectEqual(i, local_ctx2);
        try std.testing.expectEqual(i, local_ctx3);
    }

    try std.testing.expectEqual(false, timer_module.run());
}

test "delayed periodic" {
    var timer_module = TimerModule.init();

    var local_ctx1: u32 = 0;
    var local_ctx2: u32 = 0;
    var timer1: Timer = .{ .ctx = &local_ctx1, .callback = timer_callback };
    var timer2: Timer = .{ .ctx = &local_ctx2, .callback = timer_callback };

    timer_module.start_periodic_delayed(&timer1, 50, 100);
    timer_module.start_periodic(&timer2, 50);
    try std.testing.expectEqual(false, timer_module.run());

    timer_module.increment_current_time(50);
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(0, local_ctx1);
    try std.testing.expectEqual(1, local_ctx2);

    try std.testing.expectEqual(false, timer_module.run());
    try std.testing.expectEqual(0, local_ctx1);
    try std.testing.expectEqual(1, local_ctx2);

    timer_module.increment_current_time(50);

    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(1, local_ctx1);
    try std.testing.expectEqual(1, local_ctx2);

    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(1, local_ctx1);
    try std.testing.expectEqual(2, local_ctx2);

    timer_module.increment_current_time(50);

    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(2, local_ctx1);
    try std.testing.expectEqual(2, local_ctx2);

    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(2, local_ctx1);
    try std.testing.expectEqual(3, local_ctx2);

    try std.testing.expectEqual(false, timer_module.run());
}

test "timer stopping and resuming" {
    var timer_module = TimerModule.init();

    var local_ctx1: u32 = 0;
    var timer1: Timer = .{ .ctx = &local_ctx1, .callback = timer_callback };
    timer_module.start_one_shot(&timer1, 50);

    timer_module.start_one_shot(&timer1, timer_module.stop(&timer1));

    timer_module.increment_current_time(50);
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(1, local_ctx1);

    // This panics
    // _ = timer_module.stop(&timer1);

    timer_module.start_one_shot(&timer1, 50);

    timer_module.increment_current_time(49);
    const remaining = timer_module.stop(&timer1);
    try std.testing.expectEqual(false, timer_module.run());

    timer_module.increment_current_time(1);
    try std.testing.expectEqual(false, timer_module.run());

    timer_module.start_one_shot(&timer1, remaining);
    timer_module.increment_current_time(1);
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(2, local_ctx1);
}
