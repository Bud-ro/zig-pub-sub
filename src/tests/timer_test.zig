const std = @import("std");
const timer = @import("../timer.zig");
const TimerModule = timer.TimerModule;
const Timer = timer.Timer;

fn expect_timer_expires_after_exactly(timer_module: *TimerModule, ticks: timer.Ticks) !void {
    try std.testing.expectEqual(false, timer_module.run()); // If this fails then there's already an expired timer

    timer_module.increment_current_time(ticks - 1);
    try std.testing.expectEqual(false, timer_module.run());

    timer_module.increment_current_time(1);
    try std.testing.expectEqual(true, timer_module.run());
}

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

test "timer periodic run" {
    var timer_module = TimerModule{};

    var local_ctx: u32 = 0;
    var timer1 = Timer{};

    timer_module.start_periodic(&timer1, 50, &local_ctx, timer_callback);
    try std.testing.expectEqual(false, timer_module.run());

    try expect_timer_expires_after_exactly(&timer_module, 50);
    try std.testing.expectEqual(1, local_ctx);
}

test "stopping periodic timer during callback" {
    var timer_module = TimerModule{};

    var timer1 = Timer{};

    timer_module.start_periodic(&timer1, 50, null, stop_timer_callback);

    timer_module.increment_current_time(50);
    try std.testing.expectEqual(true, timer_module.run());

    timer_module.increment_current_time(50);
    try std.testing.expectEqual(false, timer_module.run());
}

test "multiple periodics" {
    var timer_module = TimerModule{};

    var local_ctx1: u32 = 0;
    var local_ctx2: u32 = 0;
    var timer1 = Timer{};
    var timer2 = Timer{};

    timer_module.start_periodic(&timer1, 50, &local_ctx1, timer_callback);
    timer_module.start_periodic(&timer2, 50, &local_ctx2, timer_callback);
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
    var timer_module = TimerModule{};

    var local_ctx1: u32 = 0;
    var local_ctx2: u32 = 0;
    var local_ctx3: u32 = 0;
    var timer1 = Timer{};
    var timer2 = Timer{};
    var timer3 = Timer{};

    timer_module.start_periodic(&timer1, 50, &local_ctx1, timer_callback);
    timer_module.start_periodic(&timer2, 50, &local_ctx2, timer_callback);
    timer_module.start_periodic(&timer3, 50, &local_ctx3, timer_callback);

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
    var timer_module = TimerModule{};

    var local_ctx1: u32 = 0;
    var local_ctx2: u32 = 0;
    var timer1 = Timer{};
    var timer2 = Timer{};

    timer_module.start_periodic_delayed(&timer1, 50, 100, &local_ctx1, timer_callback);
    timer_module.start_periodic(&timer2, 50, &local_ctx2, timer_callback);
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

test "timer stopping" {
    var timer_module = TimerModule{};

    var local_ctx1: u32 = 0;
    var timer1 = Timer{};
    timer_module.start_one_shot(&timer1, 50, &local_ctx1, timer_callback);

    timer_module.stop(&timer1);
    timer_module.start_one_shot(&timer1, 50, &local_ctx1, timer_callback);

    timer_module.increment_current_time(50);
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(1, local_ctx1);

    timer_module.start_one_shot(&timer1, 50, &local_ctx1, timer_callback);
}

test "overflow with one-shots" {
    var timer_module = TimerModule{};
    timer_module.increment_current_time(std.math.maxInt(timer.Ticks));

    var local_ctx1: u32 = 0;
    var local_ctx2: u32 = 0;
    var timer1 = Timer{};
    var timer2 = Timer{};

    timer_module.start_one_shot(&timer1, 50, &local_ctx1, timer_callback);
    timer_module.start_one_shot(&timer2, 50, &local_ctx2, timer_callback);

    try std.testing.expectEqual(false, timer_module.run());

    try expect_timer_expires_after_exactly(&timer_module, 50);
    try std.testing.expectEqual(1, local_ctx1);
    try std.testing.expectEqual(0, local_ctx2);

    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(1, local_ctx1);
    try std.testing.expectEqual(1, local_ctx2);
}

test "overflow with periodics" {
    var timer_module = TimerModule{};
    timer_module.increment_current_time(std.math.maxInt(timer.Ticks) - 27);

    var local_ctx1: u32 = 0;
    var local_ctx2: u32 = 0;
    var timer1 = Timer{};
    var timer2 = Timer{};

    timer_module.start_periodic(&timer1, 27, &local_ctx1, timer_callback);
    timer_module.start_periodic(&timer2, 50, &local_ctx2, timer_callback);

    try std.testing.expectEqual(false, timer_module.run());

    try expect_timer_expires_after_exactly(&timer_module, 27);
    try std.testing.expectEqual(1, local_ctx1);
    try std.testing.expectEqual(0, local_ctx2);

    try expect_timer_expires_after_exactly(&timer_module, 23);
    try std.testing.expectEqual(1, local_ctx1);
    try std.testing.expectEqual(1, local_ctx2);
}

test "max tick one-shot" {
    var timer_module = TimerModule{};

    var local_ctx1: u32 = 0;
    var timer1 = Timer{};

    timer_module.start_one_shot(&timer1, Timer.max_ticks, &local_ctx1, timer_callback);
    try expect_timer_expires_after_exactly(&timer_module, Timer.max_ticks);
    try std.testing.expectEqual(1, local_ctx1);
}

test "max tick periodic" {
    var timer_module = TimerModule{};

    var local_ctx1: u32 = 0;
    var timer1 = Timer{};

    timer_module.start_periodic(&timer1, Timer.max_ticks, &local_ctx1, timer_callback);
    try expect_timer_expires_after_exactly(&timer_module, Timer.max_ticks);
    try std.testing.expectEqual(1, local_ctx1);

    try expect_timer_expires_after_exactly(&timer_module, Timer.max_ticks);
    try std.testing.expectEqual(2, local_ctx1);
}

test "max tick at wrap-around" {
    var timer_module = TimerModule{};

    var local_ctx1: u32 = 0;
    var local_ctx2: u32 = 0;
    var timer1 = Timer{};
    var timer2 = Timer{};
    timer_module.increment_current_time(std.math.maxInt(timer.Ticks));

    timer_module.start_one_shot(&timer1, Timer.max_ticks, &local_ctx1, timer_callback);
    timer_module.start_one_shot(&timer2, Timer.max_ticks, &local_ctx2, timer_callback);

    try std.testing.expectEqual(false, timer_module.run());

    timer_module.increment_current_time(1);
    try std.testing.expectEqual(false, timer_module.run());

    try expect_timer_expires_after_exactly(&timer_module, Timer.max_ticks - 1);
    try std.testing.expectEqual(1, local_ctx1);
    try std.testing.expectEqual(0, local_ctx2);

    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(1, local_ctx1);
    try std.testing.expectEqual(1, local_ctx2);
}

test "Deadlock example test" {
    var timer_module = TimerModule{};

    var local_ctx1: u32 = 0;
    var timer1 = Timer{};
    timer_module.increment_current_time(std.math.maxInt(timer.Ticks));

    timer_module.start_periodic(&timer1, 50, &local_ctx1, timer_callback);
    try std.testing.expectEqual(false, timer_module.run());

    timer_module.increment_current_time(Timer.longest_delay_before_servicing_timer + 50);
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(1, local_ctx1);

    try expect_timer_expires_after_exactly(&timer_module, 50);
    try std.testing.expectEqual(2, local_ctx1);

    timer_module.increment_current_time(Timer.longest_delay_before_servicing_timer + 51);
    try std.testing.expectEqual(false, timer_module.run());

    // NOTE: At this point this is now a `max_ticks` timer:
    try expect_timer_expires_after_exactly(&timer_module, Timer.max_ticks);
    try std.testing.expectEqual(3, local_ctx1);
}

test "Can insert timer after a timer with special delay value" {
    var timer_module = TimerModule{};

    var local_ctx1: u32 = 0;
    var local_ctx2: u32 = 0;
    var timer1 = Timer{};
    var timer2 = Timer{};

    timer_module.start_one_shot(&timer1, Timer.longest_delay_before_servicing_timer, &local_ctx1, timer_callback);
    timer_module.start_one_shot(&timer2, Timer.longest_delay_before_servicing_timer, &local_ctx2, timer_callback);

    try std.testing.expectEqual(false, timer_module.run());

    timer_module.increment_current_time(Timer.longest_delay_before_servicing_timer);
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(1, local_ctx1);
    try std.testing.expectEqual(0, local_ctx2);

    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(1, local_ctx1);
    try std.testing.expectEqual(1, local_ctx2);

    timer_module.start_one_shot(&timer1, Timer.longest_delay_before_servicing_timer, &local_ctx1, timer_callback);
    timer_module.start_one_shot(&timer2, Timer.longest_delay_before_servicing_timer + 1, &local_ctx2, timer_callback);

    timer_module.increment_current_time(Timer.longest_delay_before_servicing_timer);
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(2, local_ctx1);
    try std.testing.expectEqual(1, local_ctx2);

    try std.testing.expectEqual(false, timer_module.run());
    try std.testing.expectEqual(2, local_ctx1);
    try std.testing.expectEqual(1, local_ctx2);

    try expect_timer_expires_after_exactly(&timer_module, 1);
    try std.testing.expectEqual(2, local_ctx1);
    try std.testing.expectEqual(2, local_ctx2);
}

test "Can insert a timer before a timer with special delay value" {
    var timer_module = TimerModule{};

    var local_ctx1: u32 = 0;
    var local_ctx2: u32 = 0;
    var timer1 = Timer{};
    var timer2 = Timer{};

    timer_module.start_one_shot(&timer1, Timer.longest_delay_before_servicing_timer, &local_ctx1, timer_callback);
    timer_module.start_one_shot(&timer2, Timer.longest_delay_before_servicing_timer - 1, &local_ctx2, timer_callback);

    timer_module.increment_current_time(Timer.longest_delay_before_servicing_timer - 1);
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(0, local_ctx1);
    try std.testing.expectEqual(1, local_ctx2);

    timer_module.increment_current_time(1);
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(1, local_ctx1);
    try std.testing.expectEqual(1, local_ctx2);
}

test "timer pause/resume immediately" {
    var timer_module = TimerModule{};

    var local_ctx1: u32 = 0;
    var timer1 = Timer{};

    timer_module.pause(&timer1);

    timer_module.start_periodic(&timer1, 50, &local_ctx1, timer_callback);

    try expect_timer_expires_after_exactly(&timer_module, 50);
    try std.testing.expectEqual(1, local_ctx1);

    timer_module.pause(&timer1);
    timer_module.increment_current_time(50);
    try std.testing.expectEqual(false, timer_module.run());

    timer_module.increment_current_time(Timer.longest_delay_before_servicing_timer);
    try std.testing.expectEqual(false, timer_module.run());

    timer_module.unpause(&timer1);
    try expect_timer_expires_after_exactly(&timer_module, 50);
    try std.testing.expectEqual(2, local_ctx1);
}
