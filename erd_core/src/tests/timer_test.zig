// zlinter-disable declaration_naming
const std = @import("std");
const timer = @import("erd_core").timer;
const TimerModule = timer.TimerModule;
const Timer = timer.Timer;

fn expectTimerExpiresAfterExactly(timer_module: *TimerModule, ticks: timer.Ticks) !void {
    try std.testing.expectEqual(false, timer_module.run()); // If this fails then there's already an expired timer

    timer_module.incrementCurrentTime(ticks - 1);
    try std.testing.expectEqual(false, timer_module.run());

    timer_module.incrementCurrentTime(1);
    try std.testing.expectEqual(true, timer_module.run());
}

fn timer1Callback(ctx: ?*anyopaque, _: *TimerModule, _: *Timer) void {
    var calls: *std.ArrayList(u8) = @ptrCast(@alignCast(ctx.?));
    calls.appendAssumeCapacity(1);
}

fn timer2Callback(ctx: ?*anyopaque, _: *TimerModule, _: *Timer) void {
    var calls: *std.ArrayList(u8) = @ptrCast(@alignCast(ctx.?));
    calls.appendAssumeCapacity(2);
}

fn timer3Callback(ctx: ?*anyopaque, _: *TimerModule, _: *Timer) void {
    var calls: *std.ArrayList(u8) = @ptrCast(@alignCast(ctx.?));
    calls.appendAssumeCapacity(3);
}

fn timer4Callback(ctx: ?*anyopaque, _: *TimerModule, _: *Timer) void {
    var calls: *std.ArrayList(u8) = @ptrCast(@alignCast(ctx.?));
    calls.appendAssumeCapacity(4);
}

fn timerCallback(ctx: ?*anyopaque, _: *TimerModule, _: *Timer) void {
    const local_ctx: *u32 = @ptrCast(@alignCast(ctx.?));
    local_ctx.* += 1;
}

fn stopTimerCallback(_: ?*anyopaque, _timer_module: *TimerModule, _timer: *Timer) void {
    _timer_module.stop(_timer);
}

test "timer periodic run" {
    var timer_module = TimerModule{};

    var local_ctx: u32 = 0;
    var timer1 = Timer{};

    timer_module.startPeriodic(&timer1, 50, &local_ctx, timerCallback);
    try std.testing.expectEqual(false, timer_module.run());

    try expectTimerExpiresAfterExactly(&timer_module, 50);
    try std.testing.expectEqual(1, local_ctx);
}

test "0 tick periodic" {
    var timer_module = TimerModule{};

    var local_ctx: u32 = 0;
    var timer1 = Timer{};

    timer_module.startPeriodic(&timer1, 0, &local_ctx, timerCallback);
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(1, local_ctx);

    for (2..100) |i| {
        try std.testing.expectEqual(true, timer_module.run());
        try std.testing.expectEqual(i, local_ctx);
    }
}

test "stopping periodic timer during callback" {
    var timer_module = TimerModule{};

    var timer1 = Timer{};

    timer_module.startPeriodic(&timer1, 50, null, stopTimerCallback);

    timer_module.incrementCurrentTime(50);
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expect(!timer_module.isRunning(&timer1));

    timer_module.incrementCurrentTime(50);
    try std.testing.expectEqual(false, timer_module.run());
}

test "multiple periodics" {
    var timer_module = TimerModule{};

    var local_ctx1: u32 = 0;
    var local_ctx2: u32 = 0;
    var timer1 = Timer{};
    var timer2 = Timer{};

    timer_module.startPeriodic(&timer1, 50, &local_ctx1, timerCallback);
    timer_module.startPeriodic(&timer2, 50, &local_ctx2, timerCallback);
    try std.testing.expectEqual(false, timer_module.run());

    timer_module.incrementCurrentTime(50);
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

    timer_module.startPeriodic(&timer1, 50, &local_ctx1, timerCallback);
    timer_module.startPeriodic(&timer2, 50, &local_ctx2, timerCallback);
    timer_module.startPeriodic(&timer3, 50, &local_ctx3, timerCallback);

    for (1..10) |i| {
        timer_module.incrementCurrentTime(50);
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

test "timer stopping" {
    var timer_module = TimerModule{};

    var local_ctx1: u32 = 0;
    var timer1 = Timer{};
    timer_module.startOneShot(&timer1, 50, &local_ctx1, timerCallback);

    timer_module.stop(&timer1);
    timer_module.startOneShot(&timer1, 50, &local_ctx1, timerCallback);

    timer_module.incrementCurrentTime(50);
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(1, local_ctx1);

    timer_module.startOneShot(&timer1, 50, &local_ctx1, timerCallback);
}

test "overflow with one-shots" {
    var timer_module = TimerModule{};
    timer_module.incrementCurrentTime(std.math.maxInt(timer.Ticks));

    var local_ctx1: u32 = 0;
    var local_ctx2: u32 = 0;
    var timer1 = Timer{};
    var timer2 = Timer{};

    timer_module.startOneShot(&timer1, 50, &local_ctx1, timerCallback);
    timer_module.startOneShot(&timer2, 50, &local_ctx2, timerCallback);

    try std.testing.expectEqual(false, timer_module.run());

    try expectTimerExpiresAfterExactly(&timer_module, 50);
    try std.testing.expectEqual(1, local_ctx1);
    try std.testing.expectEqual(0, local_ctx2);

    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(1, local_ctx1);
    try std.testing.expectEqual(1, local_ctx2);
}

test "overflow with periodics" {
    var timer_module = TimerModule{};
    timer_module.incrementCurrentTime(std.math.maxInt(timer.Ticks) - 27);

    var local_ctx1: u32 = 0;
    var local_ctx2: u32 = 0;
    var timer1 = Timer{};
    var timer2 = Timer{};

    timer_module.startPeriodic(&timer1, 27, &local_ctx1, timerCallback);
    timer_module.startPeriodic(&timer2, 50, &local_ctx2, timerCallback);

    try std.testing.expectEqual(false, timer_module.run());

    try expectTimerExpiresAfterExactly(&timer_module, 27);
    try std.testing.expectEqual(1, local_ctx1);
    try std.testing.expectEqual(0, local_ctx2);

    try expectTimerExpiresAfterExactly(&timer_module, 23);
    try std.testing.expectEqual(1, local_ctx1);
    try std.testing.expectEqual(1, local_ctx2);
}

test "max tick one-shot" {
    var timer_module = TimerModule{};

    var local_ctx1: u32 = 0;
    var timer1 = Timer{};

    timer_module.startOneShot(&timer1, Timer.max_ticks, &local_ctx1, timerCallback);
    try expectTimerExpiresAfterExactly(&timer_module, Timer.max_ticks);
    try std.testing.expectEqual(1, local_ctx1);
}

test "max tick periodic" {
    var timer_module = TimerModule{};

    var local_ctx1: u32 = 0;
    var timer1 = Timer{};

    timer_module.startPeriodic(&timer1, Timer.max_ticks, &local_ctx1, timerCallback);
    try expectTimerExpiresAfterExactly(&timer_module, Timer.max_ticks);
    try std.testing.expectEqual(1, local_ctx1);

    try expectTimerExpiresAfterExactly(&timer_module, Timer.max_ticks);
    try std.testing.expectEqual(2, local_ctx1);
}

test "max tick at wrap-around" {
    var timer_module = TimerModule{};

    var local_ctx1: u32 = 0;
    var local_ctx2: u32 = 0;
    var timer1 = Timer{};
    var timer2 = Timer{};
    timer_module.incrementCurrentTime(std.math.maxInt(timer.Ticks));

    timer_module.startOneShot(&timer1, Timer.max_ticks, &local_ctx1, timerCallback);
    timer_module.startOneShot(&timer2, Timer.max_ticks, &local_ctx2, timerCallback);

    try std.testing.expectEqual(false, timer_module.run());

    timer_module.incrementCurrentTime(1);
    try std.testing.expectEqual(false, timer_module.run());

    try expectTimerExpiresAfterExactly(&timer_module, Timer.max_ticks - 1);
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
    timer_module.incrementCurrentTime(std.math.maxInt(timer.Ticks));

    timer_module.startPeriodic(&timer1, 50, &local_ctx1, timerCallback);
    try std.testing.expectEqual(false, timer_module.run());

    timer_module.incrementCurrentTime(Timer.longest_delay_before_servicing_timer + 50);
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(1, local_ctx1);

    try expectTimerExpiresAfterExactly(&timer_module, 50);
    try std.testing.expectEqual(2, local_ctx1);

    timer_module.incrementCurrentTime(Timer.longest_delay_before_servicing_timer + 51);
    try std.testing.expectEqual(false, timer_module.run());

    // NOTE: At this point this is now a `max_ticks` timer:
    try expectTimerExpiresAfterExactly(&timer_module, Timer.max_ticks);
    try std.testing.expectEqual(3, local_ctx1);
}

test "Can insert timer after a timer with special delay value" {
    var timer_module = TimerModule{};

    var local_ctx1: u32 = 0;
    var local_ctx2: u32 = 0;
    var timer1 = Timer{};
    var timer2 = Timer{};

    timer_module.startOneShot(&timer1, Timer.longest_delay_before_servicing_timer, &local_ctx1, timerCallback);
    timer_module.startOneShot(&timer2, Timer.longest_delay_before_servicing_timer, &local_ctx2, timerCallback);

    try std.testing.expectEqual(false, timer_module.run());

    timer_module.incrementCurrentTime(Timer.longest_delay_before_servicing_timer);
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(1, local_ctx1);
    try std.testing.expectEqual(0, local_ctx2);

    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(1, local_ctx1);
    try std.testing.expectEqual(1, local_ctx2);

    timer_module.startOneShot(&timer1, Timer.longest_delay_before_servicing_timer, &local_ctx1, timerCallback);
    timer_module.startOneShot(&timer2, Timer.longest_delay_before_servicing_timer + 1, &local_ctx2, timerCallback);

    timer_module.incrementCurrentTime(Timer.longest_delay_before_servicing_timer);
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(2, local_ctx1);
    try std.testing.expectEqual(1, local_ctx2);

    try std.testing.expectEqual(false, timer_module.run());
    try std.testing.expectEqual(2, local_ctx1);
    try std.testing.expectEqual(1, local_ctx2);

    try expectTimerExpiresAfterExactly(&timer_module, 1);
    try std.testing.expectEqual(2, local_ctx1);
    try std.testing.expectEqual(2, local_ctx2);
}

test "Can insert a timer before a timer with special delay value" {
    var timer_module = TimerModule{};

    var local_ctx1: u32 = 0;
    var local_ctx2: u32 = 0;
    var timer1 = Timer{};
    var timer2 = Timer{};

    timer_module.startOneShot(&timer1, Timer.longest_delay_before_servicing_timer, &local_ctx1, timerCallback);
    timer_module.startOneShot(&timer2, Timer.longest_delay_before_servicing_timer - 1, &local_ctx2, timerCallback);

    timer_module.incrementCurrentTime(Timer.longest_delay_before_servicing_timer - 1);
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(0, local_ctx1);
    try std.testing.expectEqual(1, local_ctx2);

    timer_module.incrementCurrentTime(1);
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(1, local_ctx1);
    try std.testing.expectEqual(1, local_ctx2);
}

test "timer pause/resume immediately" {
    var timer_module = TimerModule{};

    var local_ctx1: u32 = 0;
    var timer1 = Timer{};

    timer_module.pause(&timer1);

    timer_module.startPeriodic(&timer1, 50, &local_ctx1, timerCallback);

    try expectTimerExpiresAfterExactly(&timer_module, 50);
    try std.testing.expectEqual(1, local_ctx1);

    timer_module.pause(&timer1);
    timer_module.incrementCurrentTime(50);
    try std.testing.expectEqual(false, timer_module.run());

    timer_module.incrementCurrentTime(Timer.longest_delay_before_servicing_timer);
    try std.testing.expectEqual(false, timer_module.run());

    timer_module.unpause(&timer1);
    try expectTimerExpiresAfterExactly(&timer_module, 50);
    try std.testing.expectEqual(2, local_ctx1);
}

test "timer pause/resume with different remaining ticks" {
    var timer_module = TimerModule{};

    var local_ctx1: u32 = 0;
    var timer1 = Timer{};

    timer_module.startPeriodic(&timer1, 50, &local_ctx1, timerCallback);

    timer_module.incrementCurrentTime(20);
    timer_module.pause(&timer1);
    try std.testing.expectEqual(false, timer_module.run());

    timer_module.incrementCurrentTime(30);
    try std.testing.expectEqual(false, timer_module.run());

    timer_module.unpause(&timer1);
    try expectTimerExpiresAfterExactly(&timer_module, 30);
    try std.testing.expectEqual(1, local_ctx1);
}

test "timer pause/resume at last moment" {
    var timer_module = TimerModule{};

    var local_ctx1: u32 = 0;
    var timer1 = Timer{};

    timer_module.startOneShot(&timer1, 50, &local_ctx1, timerCallback);
    timer_module.incrementCurrentTime(50 + Timer.longest_delay_before_servicing_timer);
    timer_module.pause(&timer1);

    try std.testing.expectEqual(false, timer_module.run());

    timer_module.unpause(&timer1);
    timer_module.incrementCurrentTime(Timer.longest_delay_before_servicing_timer);
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(1, local_ctx1);
}

test "timer pause one tick too late results in max_tick timer" {
    // NOTE: This test more-so documents a failure mode rather than required behavior.
    // It's not expected that user code would ever run into this condition.
    // Reminder: only extremely slow software encounters `Timer.longest_delay_before_servicing_timer`
    // as a limit. I will hunt you down if you hack around this limit by pausing and unpausing expired timers
    // at the front of your list.
    var timer_module = TimerModule{};

    var local_ctx1: u32 = 0;
    var timer1 = Timer{};

    timer_module.startOneShot(&timer1, 50, &local_ctx1, timerCallback);
    timer_module.incrementCurrentTime(50 + Timer.longest_delay_before_servicing_timer + 1);
    timer_module.pause(&timer1);

    try std.testing.expectEqual(false, timer_module.run());

    timer_module.unpause(&timer1);
    try expectTimerExpiresAfterExactly(&timer_module, Timer.max_ticks);
    try std.testing.expectEqual(1, local_ctx1);
}

test "can pause timer during one-shot callback" {
    var timer_module = TimerModule{};

    var local_ctx: u32 = 0;
    var timer1 = Timer{};
    var timer2 = Timer{};

    const A = struct {
        fn pauseTheTimer(ctx: ?*anyopaque, _timer_module: *TimerModule, _: *Timer) void {
            const to_pause: *Timer = @ptrCast(@alignCast(ctx));
            _timer_module.pause(to_pause);
        }
    };

    timer_module.startOneShot(&timer1, 50, &timer2, A.pauseTheTimer);
    timer_module.startOneShot(&timer2, 50, &local_ctx, timerCallback);

    try expectTimerExpiresAfterExactly(&timer_module, 50);
    try std.testing.expectEqual(false, timer_module.run());
    try std.testing.expectEqual(0, local_ctx);

    try std.testing.expectEqual(false, timer_module.isActive(&timer2));
    try std.testing.expectEqual(true, timer_module.isPaused(&timer2));
    try std.testing.expectEqual(true, timer_module.isRunning(&timer2));

    timer_module.unpause(&timer2);
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(1, local_ctx);

    try std.testing.expectEqual(false, timer_module.isActive(&timer2));
    try std.testing.expectEqual(false, timer_module.isPaused(&timer2));
    try std.testing.expectEqual(false, timer_module.isRunning(&timer2));
}

test "can pause timer during periodic callback" {
    var timer_module = TimerModule{};

    var local_ctx: u32 = 0;
    var timer1 = Timer{};
    var timer2 = Timer{};

    const A = struct {
        fn pauseTheTimer(ctx: ?*anyopaque, _timer_module: *TimerModule, _: *Timer) void {
            const to_pause: *Timer = @ptrCast(@alignCast(ctx));
            _timer_module.pause(to_pause);
        }
    };

    timer_module.startPeriodic(&timer1, 50, &timer2, A.pauseTheTimer);
    timer_module.startPeriodic(&timer2, 50, &local_ctx, timerCallback);

    try expectTimerExpiresAfterExactly(&timer_module, 50);
    try std.testing.expectEqual(false, timer_module.run());
    try std.testing.expectEqual(0, local_ctx);

    timer_module.unpause(&timer2);
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(1, local_ctx);

    try expectTimerExpiresAfterExactly(&timer_module, 50);
    try std.testing.expectEqual(false, timer_module.run());
    try std.testing.expectEqual(1, local_ctx);

    try expectTimerExpiresAfterExactly(&timer_module, 50);
    try std.testing.expectEqual(false, timer_module.run());
    try std.testing.expectEqual(1, local_ctx);

    timer_module.unpause(&timer2);
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(2, local_ctx);
}

test "One shot with null callback" {
    // zlinter-disable no_comment_out_code
    // var timer_module = TimerModule{};
    // var timer1 = Timer{};
    // var context: u32 = 0;

    return error.SkipZigTest; // Test for compile error
    // timer_module.startOneShot(&timer1, 0, &context, null);
    // zlinter-enable no_comment_out_code
}

test "Periodic with null callback" {
    // zlinter-disable no_comment_out_code
    // var timer_module = TimerModule{};
    // var timer1 = Timer{};
    // var context: u32 = 0;

    return error.SkipZigTest; // Test for compile error
    // timer_module.startPeriodic(&timer1, 0, &context, null);
    // zlinter-enable no_comment_out_code
}

test "IsRunning" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};
    var timer2 = Timer{};

    try std.testing.expect(!timer_module.isRunning(&timer1));
    try std.testing.expect(!timer_module.isRunning(&timer2));

    timer_module.startOneShot(&timer1, 1, &calls, timer1Callback);

    try std.testing.expect(timer_module.isRunning(&timer1));
    try std.testing.expect(!timer_module.isRunning(&timer2));

    timer_module.startOneShot(&timer2, 1, &calls, timer2Callback);

    try std.testing.expect(timer_module.isRunning(&timer1));
    try std.testing.expect(timer_module.isRunning(&timer2));

    timer_module.stop(&timer1);

    try std.testing.expect(!timer_module.isRunning(&timer1));
    try std.testing.expect(timer_module.isRunning(&timer2));

    timer_module.stop(&timer2);
    try std.testing.expect(!timer_module.isRunning(&timer1));
    try std.testing.expect(!timer_module.isRunning(&timer2));

    try std.testing.expectEqualSlices(u8, &[_]u8{}, calls.items);
}

test "Ticks until next ready is max int when no timers are in list" {
    var timer_module = TimerModule{};
    try std.testing.expectEqual(std.math.maxInt(timer.Ticks), timer_module.ticksUntilNextReady());
}

test "Ticks until next ready timer" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};
    var timer2 = Timer{};

    timer_module.startOneShot(&timer1, 7, &calls, timer1Callback);
    try std.testing.expectEqual(7, timer_module.ticksUntilNextReady());

    timer_module.startOneShot(&timer2, 4, &calls, timer2Callback);
    try std.testing.expectEqual(4, timer_module.ticksUntilNextReady());

    timer_module.incrementCurrentTime(1);
    try std.testing.expectEqual(3, timer_module.ticksUntilNextReady());

    timer_module.incrementCurrentTime(1);
    try std.testing.expectEqual(2, timer_module.ticksUntilNextReady());

    try std.testing.expectEqualSlices(u8, &[_]u8{}, calls.items);
}

test "Timer module run expire" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.startOneShot(&timer1, 1, &calls, timer1Callback);

    try expectTimerExpiresAfterExactly(&timer_module, 1);
    try std.testing.expectEqualSlices(u8, &[_]u8{1}, calls.items);
}

test "oneshot multiple simultaneous" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};
    var timer2 = Timer{};

    timer_module.startOneShot(&timer1, 1, &calls, timer1Callback);
    timer_module.startOneShot(&timer2, 1, &calls, timer2Callback);

    timer_module.incrementCurrentTime(1);

    while (timer_module.run()) {}

    try std.testing.expect(!timer_module.isRunning(&timer1));
    try std.testing.expect(!timer_module.isRunning(&timer2));

    try std.testing.expectEqualSlices(u8, &[_]u8{ 1, 2 }, calls.items);
}

test "remaining ticks" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.startPeriodic(&timer1, 10, &calls, timer1Callback);
    try std.testing.expectEqual(10, timer_module.remainingTicks(&timer1));

    timer_module.incrementCurrentTime(5);
    _ = timer_module.run();

    try std.testing.expectEqual(5, timer_module.remainingTicks(&timer1));

    timer_module.incrementCurrentTime(5);
    _ = timer_module.run();

    try std.testing.expectEqual(10, timer_module.remainingTicks(&timer1));

    try std.testing.expectEqualSlices(u8, &[_]u8{1}, calls.items);
}

test "remaining ticks should not underflow" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.startPeriodic(&timer1, 10, &calls, timer1Callback);
    timer_module.incrementCurrentTime(5);

    _ = timer_module.run();
    timer_module.incrementCurrentTime(10);

    try std.testing.expectEqual(0, timer_module.remainingTicks(&timer1));
    try std.testing.expectEqualSlices(u8, &[_]u8{}, calls.items);
}

test "remainingTicks zero if not running" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.startPeriodic(&timer1, 10, &calls, timer1Callback);
    timer_module.stop(&timer1);

    try std.testing.expectEqual(0, timer_module.remainingTicks(&timer1));
    try std.testing.expectEqualSlices(u8, &[_]u8{}, calls.items);
}

test "restart one shot from callback" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    const A = struct {
        fn restartWithContext(ctx: ?*anyopaque, _timer_module: *TimerModule, _timer: *Timer) void {
            var _calls: *std.ArrayList(u8) = @ptrCast(@alignCast(ctx));
            _calls.appendAssumeCapacity(11);
            _timer_module.startOneShot(_timer, 0, _calls, restartWithContext);
        }
    };

    timer_module.startOneShot(&timer1, 0, &calls, A.restartWithContext);

    try std.testing.expect(timer_module.run());
    try std.testing.expectEqualSlices(u8, &[_]u8{11}, calls.items);

    try std.testing.expect(timer_module.run());
    try std.testing.expectEqualSlices(u8, &[_]u8{ 11, 11 }, calls.items);

    try std.testing.expect(timer_module.run());
    try std.testing.expectEqualSlices(u8, &[_]u8{ 11, 11, 11 }, calls.items);

    try std.testing.expect(timer_module.run());
    try std.testing.expectEqualSlices(u8, &[_]u8{ 11, 11, 11, 11 }, calls.items);
}

test "restart periodic from callback" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    const A = struct {
        fn restartWithContext(ctx: ?*anyopaque, _timer_module: *TimerModule, _timer: *Timer) void {
            var _calls: *std.ArrayList(u8) = @ptrCast(@alignCast(ctx));
            _calls.appendAssumeCapacity(13);
            _timer_module.startPeriodic(_timer, 1, _calls, timer1Callback);
        }
    };

    timer_module.startPeriodic(&timer1, 1, &calls, A.restartWithContext);

    timer_module.incrementCurrentTime(1);
    try std.testing.expect(timer_module.run());
    try std.testing.expectEqualSlices(u8, &[_]u8{13}, calls.items);

    timer_module.incrementCurrentTime(1);
    try std.testing.expect(timer_module.run());
    try std.testing.expectEqualSlices(u8, &[_]u8{ 13, 1 }, calls.items);
}

test "Overflow handling" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.incrementCurrentTime(std.math.maxInt(timer.Ticks) - 5);
    timer_module.startOneShot(&timer1, 10, &calls, timer1Callback);

    for (0..9) |_| {
        timer_module.incrementCurrentTime(1);
        try std.testing.expect(!timer_module.run());
    }

    try expectTimerExpiresAfterExactly(&timer_module, 1);
    try std.testing.expectEqualSlices(u8, &[_]u8{1}, calls.items);
}

test "Stop timer from callback" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.startOneShot(&timer1, 0, null, stopTimerCallback);
    try std.testing.expect(timer_module.run());

    try std.testing.expect(!timer_module.isRunning(&timer1));
}

test "Start periodic timer from callback" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    const A = struct {
        fn startPeriodicCallback(ctx: ?*anyopaque, _timer_module: *TimerModule, _timer: *Timer) void {
            _timer_module.startPeriodic(_timer, 1, @alignCast(ctx), startPeriodicCallback);
        }
    };

    for (0..100) |_| {
        timer_module.startPeriodic(&timer1, 1, null, A.startPeriodicCallback);

        timer_module.incrementCurrentTime(1);
        try std.testing.expect(timer_module.run());

        timer_module.incrementCurrentTime(1);
        try std.testing.expect(timer_module.run());

        timer_module.incrementCurrentTime(1);
        try std.testing.expect(timer_module.run());

        timer_module.incrementCurrentTime(1);
        try std.testing.expect(timer_module.run());

        timer_module.incrementCurrentTime(1);
        try std.testing.expect(timer_module.run());
    }
}

test "isPaused start" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.startOneShot(&timer1, 1, null, timer1Callback);
    try std.testing.expect(!timer_module.isPaused(&timer1));
    try std.testing.expect(timer_module.isRunning(&timer1));
}

test "isPaused pause" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.startOneShot(&timer1, 1, null, timer1Callback);

    timer_module.pause(&timer1);
    try std.testing.expect(timer_module.isPaused(&timer1));
    try std.testing.expect(timer_module.isRunning(&timer1));
    try std.testing.expect(!timer_module.isActive(&timer1));
}

test "isPaused pause multiple times" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.startOneShot(&timer1, 1, null, timer1Callback);

    timer_module.pause(&timer1);
    timer_module.pause(&timer1);
    try std.testing.expect(timer_module.isPaused(&timer1));
    try std.testing.expect(timer_module.isRunning(&timer1));
    try std.testing.expect(!timer_module.isActive(&timer1));
}

test "isPaused stop when paused" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.startOneShot(&timer1, 1, null, timer1Callback);

    timer_module.pause(&timer1);
    timer_module.stop(&timer1);

    try std.testing.expect(!timer_module.isPaused(&timer1));
    try std.testing.expect(!timer_module.isRunning(&timer1));
    try std.testing.expect(!timer_module.isActive(&timer1));
}

test "isPaused resume" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.startOneShot(&timer1, 1, null, timer1Callback);

    timer_module.pause(&timer1);
    timer_module.unpause(&timer1);

    try std.testing.expect(!timer_module.isPaused(&timer1));
    try std.testing.expect(timer_module.isRunning(&timer1));
    try std.testing.expect(timer_module.isActive(&timer1));
}

test "isPaused stop after resume" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.startOneShot(&timer1, 1, null, timer1Callback);

    timer_module.pause(&timer1);
    timer_module.unpause(&timer1);
    timer_module.stop(&timer1);

    try std.testing.expect(!timer_module.isPaused(&timer1));
    try std.testing.expect(!timer_module.isRunning(&timer1));
    try std.testing.expect(!timer_module.isActive(&timer1));
}

test "pause one shot timer" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.startOneShot(&timer1, 2, null, timer1Callback);
    timer_module.pause(&timer1);

    timer_module.incrementCurrentTime(3);
    try std.testing.expect(!timer_module.run());
}

test "pause stop when pause one shot timer" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.startOneShot(&timer1, 2, null, timer1Callback);
    timer_module.pause(&timer1);
    timer_module.stop(&timer1);

    timer_module.incrementCurrentTime(3);
    try std.testing.expect(!timer_module.run());
}

test "pause start when pause one shot timer is paused" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.startOneShot(&timer1, 2, &calls, timer1Callback);
    timer_module.incrementCurrentTime(1);
    timer_module.pause(&timer1);

    timer_module.startOneShot(&timer1, 2, &calls, timer1Callback);
    timer_module.incrementCurrentTime(1);
    try std.testing.expect(!timer_module.run());

    timer_module.incrementCurrentTime(1);
    try std.testing.expect(timer_module.run());

    try std.testing.expectEqualSlices(u8, &[_]u8{1}, calls.items);
}

test "resume one shot timer" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.startOneShot(&timer1, 5, &calls, timer1Callback);
    timer_module.incrementCurrentTime(1);
    try std.testing.expect(!timer_module.run());

    timer_module.pause(&timer1);
    timer_module.incrementCurrentTime(3);
    try std.testing.expect(!timer_module.run());

    timer_module.unpause(&timer1);
    timer_module.incrementCurrentTime(3);
    try std.testing.expect(!timer_module.run());

    timer_module.incrementCurrentTime(1);
    try std.testing.expect(timer_module.run());

    try std.testing.expect(!timer_module.isPaused(&timer1));
    try std.testing.expect(!timer_module.isActive(&timer1));
    try std.testing.expect(!timer_module.isRunning(&timer1));

    try std.testing.expectEqualSlices(u8, &[_]u8{1}, calls.items);
}

test "resume stop when one shot timer is resumed" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.startOneShot(&timer1, 2, null, timer1Callback);
    timer_module.pause(&timer1);
    timer_module.unpause(&timer1);

    timer_module.stop(&timer1);
    timer_module.incrementCurrentTime(3);
    try std.testing.expect(!timer_module.run());
}

test "pause periodic timer" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.startPeriodic(&timer1, 1, &calls, timer1Callback);

    try expectTimerExpiresAfterExactly(&timer_module, 1);

    timer_module.pause(&timer1);

    timer_module.incrementCurrentTime(1);
    try std.testing.expect(!timer_module.run());
    try std.testing.expectEqualSlices(u8, &[_]u8{1}, calls.items);
}

test "pause stop when periodic timer is paused" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.startPeriodic(&timer1, 1, &calls, timer1Callback);
    try expectTimerExpiresAfterExactly(&timer_module, 1);

    timer_module.pause(&timer1);

    timer_module.incrementCurrentTime(1);
    try std.testing.expect(!timer_module.run());

    timer_module.stop(&timer1);
    try std.testing.expect(!timer_module.run());

    try std.testing.expectEqualSlices(u8, &[_]u8{1}, calls.items);
}

test "resume periodic timer" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.startPeriodic(&timer1, 2, &calls, timer1Callback);
    timer_module.incrementCurrentTime(1);
    try std.testing.expect(!timer_module.run());

    timer_module.pause(&timer1);
    timer_module.unpause(&timer1);

    try expectTimerExpiresAfterExactly(&timer_module, 1);
    try std.testing.expectEqualSlices(u8, &[_]u8{1}, calls.items);
}

test "resume ticks are accurate" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.startOneShot(&timer1, 5, &calls, timer1Callback);
    timer_module.incrementCurrentTime(2);
    timer_module.pause(&timer1);

    timer_module.incrementCurrentTime(1);
    try std.testing.expectEqual(3, timer_module.remainingTicks(&timer1));
    timer_module.unpause(&timer1);
    try std.testing.expectEqual(3, timer_module.remainingTicks(&timer1));

    timer_module.incrementCurrentTime(2);
    try std.testing.expect(!timer_module.run());
    try std.testing.expectEqual(1, timer_module.remainingTicks(&timer1));

    try expectTimerExpiresAfterExactly(&timer_module, 1);
    try std.testing.expectEqual(0, timer_module.remainingTicks(&timer1));
    try std.testing.expectEqualSlices(u8, &[_]u8{1}, calls.items);
}

test "invalid pause ignored" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.pause(&timer1);
    timer_module.startOneShot(&timer1, 1, null, timer1Callback);
    timer_module.pause(&timer1);

    timer_module.pause(&timer1);

    timer_module.stop(&timer1);
    timer_module.pause(&timer1);
}

test "resume while not running ignored" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.unpause(&timer1);
    timer_module.incrementCurrentTime(1);
    try std.testing.expect(!timer_module.run());

    timer_module.startPeriodic(&timer1, 1, null, timer1Callback);
    timer_module.stop(&timer1);
    timer_module.unpause(&timer1);
    try std.testing.expect(!timer_module.run());
}

test "resume while not paused ignored" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.incrementCurrentTime(10000);
    timer_module.startPeriodic(&timer1, 1, null, timer1Callback);
    timer_module.unpause(&timer1);
    try std.testing.expectEqual(1, timer_module.remainingTicks(&timer1));
}

test "should not interfere with non-paused timers" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};
    var timer2 = Timer{};

    timer_module.startOneShot(&timer1, 1, &calls, timer1Callback);
    timer_module.startOneShot(&timer2, 1, &calls, timer2Callback);
    timer_module.pause(&timer1);

    try expectTimerExpiresAfterExactly(&timer_module, 1);
    try std.testing.expectEqualSlices(u8, &[_]u8{2}, calls.items);
}

test "resuming a timer should not interfere with timers that expire sooner" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};
    var timer2 = Timer{};

    timer_module.startOneShot(&timer1, 9, &calls, timer1Callback);
    timer_module.startOneShot(&timer2, 10, &calls, timer2Callback);

    timer_module.pause(&timer1);
    timer_module.incrementCurrentTime(5);
    timer_module.unpause(&timer1);

    try expectTimerExpiresAfterExactly(&timer_module, 5);
    try std.testing.expectEqualSlices(u8, &[_]u8{2}, calls.items);
}

test "should handle paused timers properly when inserting timers into queue" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};
    var timer2 = Timer{};
    var timer3 = Timer{};

    timer_module.startOneShot(&timer1, 500, &calls, timer1Callback);
    timer_module.startOneShot(&timer2, 600, &calls, timer2Callback);

    timer_module.pause(&timer1);
    timer_module.incrementCurrentTime(500);

    timer_module.startOneShot(&timer3, 400, &calls, timer3Callback);

    try expectTimerExpiresAfterExactly(&timer_module, 100);
    try expectTimerExpiresAfterExactly(&timer_module, 300);
    try std.testing.expectEqualSlices(u8, &[_]u8{ 2, 3 }, calls.items);
}

test "should account for pending ticks with max timer" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.startOneShot(&timer1, Timer.max_ticks, &calls, timer1Callback);

    timer_module.incrementCurrentTime(1);
    try std.testing.expect(!timer_module.run());

    timer_module.pause(&timer1);
    timer_module.incrementCurrentTime(5);

    timer_module.unpause(&timer1);
    timer_module.incrementCurrentTime(1);
    try std.testing.expect(!timer_module.run());
}

test "does not attempt to compensate for time source drift" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    const A = struct {
        fn timer1CallbackWithPassageOfTime(ctx: ?*anyopaque, _timer_module: *TimerModule, _timer: *Timer) void {
            // NOTE: 7 ms is a (hopefully) unrealistic amount of time for `callback` to take
            _timer_module.incrementCurrentTime(7);
            timer1Callback(ctx, _timer_module, _timer);
        }
    };

    timer_module.startPeriodic(&timer1, 250, &calls, A.timer1CallbackWithPassageOfTime);

    for (0..10) |i| {
        try std.testing.expectEqual(257 * i, timer_module.current_time);
        try expectTimerExpiresAfterExactly(&timer_module, 250);
    }

    try std.testing.expectEqualSlices(u8, &[_]u8{ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }, calls.items);
}

test "timers are not starved when timers are already expired" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};
    var timer2 = Timer{};
    var timer3 = Timer{};
    var timer4 = Timer{};

    timer_module.startOneShot(&timer1, 5, &calls, timer1Callback);
    timer_module.startOneShot(&timer2, 5, &calls, timer2Callback);
    timer_module.startOneShot(&timer3, 5, &calls, timer3Callback);
    timer_module.startOneShot(&timer4, 7, &calls, timer4Callback);

    timer_module.incrementCurrentTime(5);
    _ = timer_module.run();
    try std.testing.expectEqualSlices(u8, &[_]u8{1}, calls.items);

    timer_module.incrementCurrentTime(1);
    _ = timer_module.run();
    try std.testing.expectEqualSlices(u8, &[_]u8{ 1, 2 }, calls.items);

    timer_module.incrementCurrentTime(5);
    _ = timer_module.run();
    try std.testing.expectEqualSlices(u8, &[_]u8{ 1, 2, 3 }, calls.items);

    timer_module.startOneShot(&timer1, 50, &calls, timer1Callback);
    timer_module.incrementCurrentTime(1);
    _ = timer_module.run();
    try std.testing.expectEqualSlices(u8, &[_]u8{ 1, 2, 3, 4 }, calls.items);
}

test "stopped timers can be stopped" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.stop(&timer1);

    timer_module.startOneShot(&timer1, 5, null, timer1Callback);
    timer_module.stop(&timer1);
    timer_module.stop(&timer1);
}

test "can pause timer with 0 ticks" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.startOneShot(&timer1, 0, null, timer1Callback);
    timer_module.pause(&timer1);

    try std.testing.expect(!timer_module.run());

    timer_module.incrementCurrentTime(1);
    try std.testing.expect(!timer_module.run());
}

test "should pause an expired timer that has not been run" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};
    var timer2 = Timer{};

    timer_module.startOneShot(&timer1, 0, &calls, timer1Callback);
    timer_module.startOneShot(&timer2, 0, &calls, timer2Callback);

    try std.testing.expect(timer_module.run());
    try std.testing.expectEqualSlices(u8, &[_]u8{1}, calls.items);

    timer_module.pause(&timer2);
    try std.testing.expect(!timer_module.run());
}

test "accounts for overflow in remaining ticks for not yet ran timer" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    const ticks = 7;

    timer_module.incrementCurrentTime(std.math.maxInt(timer.Ticks) - 5);
    timer_module.startOneShot(&timer1, ticks, null, timer1Callback);

    timer_module.incrementCurrentTime(4);
    try std.testing.expectEqual(ticks - 4, timer_module.remainingTicks(&timer1));

    timer_module.incrementCurrentTime(1);
    try std.testing.expectEqual(ticks - 5, timer_module.remainingTicks(&timer1));

    timer_module.incrementCurrentTime(1);
    try std.testing.expectEqual(ticks - 6, timer_module.remainingTicks(&timer1));

    timer_module.incrementCurrentTime(1);
    try std.testing.expectEqual(ticks - 7, timer_module.remainingTicks(&timer1));

    timer_module.incrementCurrentTime(1);
    try std.testing.expectEqual(ticks - 7, timer_module.remainingTicks(&timer1));

    timer_module.incrementCurrentTime(1);
    try std.testing.expectEqual(ticks - 7, timer_module.remainingTicks(&timer1));

    timer_module.incrementCurrentTime(1);
    try std.testing.expectEqual(ticks - 7, timer_module.remainingTicks(&timer1));
}

test "periodic timers can be started and resumed and expire multiple times after" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.startPeriodic(&timer1, 3, &calls, timer1Callback);

    try expectTimerExpiresAfterExactly(&timer_module, 3);

    timer_module.pause(&timer1);
    timer_module.incrementCurrentTime(5);
    timer_module.unpause(&timer1);

    try expectTimerExpiresAfterExactly(&timer_module, 3);
    try expectTimerExpiresAfterExactly(&timer_module, 3);
    try expectTimerExpiresAfterExactly(&timer_module, 3);

    try std.testing.expectEqualSlices(u8, &[_]u8{ 1, 1, 1, 1 }, calls.items);
}

test "one shot timer should not be running inside its callback" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};
    var isRunning: bool align(2) = false;

    const A = struct {
        fn isTimerRunning(ctx: ?*anyopaque, _timer_module: *TimerModule, _timer: *Timer) void {
            const answer: *bool = @ptrCast(@alignCast(ctx));
            answer.* = _timer_module.isRunning(_timer);
        }
    };

    timer_module.startOneShot(&timer1, 0, &isRunning, A.isTimerRunning);
    try std.testing.expect(timer_module.run());
    try std.testing.expect(!isRunning);
}

test "one shot timer should be running when restarted inside its callback" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};
    var isRunning: bool align(2) = false;

    const A = struct {
        fn isTimerRunning(ctx: ?*anyopaque, _timer_module: *TimerModule, _timer: *Timer) void {
            const answer: *align(2) bool = @ptrCast(@alignCast(ctx));
            _timer_module.startOneShot(_timer, 0, answer, isTimerRunning);
            answer.* = _timer_module.isRunning(_timer);
        }
    };

    timer_module.startOneShot(&timer1, 0, &isRunning, A.isTimerRunning);
    try std.testing.expect(timer_module.run());
    try std.testing.expect(isRunning);
}

test "periodic timer should be running inside its callback" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};
    var isRunning: bool align(2) = false;

    const A = struct {
        fn isTimerRunning(ctx: ?*anyopaque, _timer_module: *TimerModule, _timer: *Timer) void {
            const answer: *bool = @ptrCast(@alignCast(ctx));
            answer.* = _timer_module.isRunning(_timer);
        }
    };

    timer_module.startPeriodic(&timer1, 5, &isRunning, A.isTimerRunning);
    try expectTimerExpiresAfterExactly(&timer_module, 5);
    try std.testing.expect(isRunning);
}

test "can start a currently paused timer when there are multiple paused timers" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};
    var timer2 = Timer{};
    var timer3 = Timer{};

    timer_module.startOneShot(&timer1, 2, &calls, timer1Callback);
    timer_module.startOneShot(&timer2, 4, &calls, timer2Callback);
    timer_module.startOneShot(&timer3, 3, &calls, timer3Callback);

    timer_module.pause(&timer1);
    timer_module.pause(&timer2);
    timer_module.pause(&timer3);

    timer_module.startOneShot(&timer2, 1, &calls, timer2Callback);
    timer_module.unpause(&timer1);
    timer_module.unpause(&timer3);

    try expectTimerExpiresAfterExactly(&timer_module, 1);
    try std.testing.expectEqualSlices(u8, &[_]u8{2}, calls.items);

    try expectTimerExpiresAfterExactly(&timer_module, 1);
    try std.testing.expectEqualSlices(u8, &[_]u8{ 2, 1 }, calls.items);

    try expectTimerExpiresAfterExactly(&timer_module, 1);
    try std.testing.expectEqualSlices(u8, &[_]u8{ 2, 1, 3 }, calls.items);
}

test "periodic timer with max ticks starts correctly when there are pending ticks" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.startPeriodic(&timer1, Timer.max_ticks, null, timer1Callback);
    timer_module.incrementCurrentTime(1);
    try std.testing.expect(!timer_module.run());
}

test "periodic timer with max ticks and long runtime restarts correctly" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    const A = struct {
        fn callback(_: ?*anyopaque, _timer_module: *TimerModule, _: *Timer) void {
            _timer_module.incrementCurrentTime(Timer.longest_delay_before_servicing_timer); // unrealistic
        }
    };

    timer_module.startPeriodic(&timer1, Timer.max_ticks, null, A.callback);
    timer_module.incrementCurrentTime(Timer.max_ticks - 1);

    try expectTimerExpiresAfterExactly(&timer_module, 1);
    try std.testing.expectEqual(Timer.max_ticks, timer_module.remainingTicks(&timer1));

    for (0..10) |_| {
        try expectTimerExpiresAfterExactly(&timer_module, Timer.max_ticks);
        try std.testing.expectEqual(Timer.max_ticks, timer_module.remainingTicks(&timer1));
    }
}

test "elapsed ticks" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    try std.testing.expectEqual(0, timer_module.elapsedTicks(&timer1));

    timer_module.startPeriodic(&timer1, 10, &calls, timer1Callback);
    try std.testing.expectEqual(0, timer_module.elapsedTicks(&timer1));

    timer_module.incrementCurrentTime(3);
    try std.testing.expectEqual(3, timer_module.elapsedTicks(&timer1));

    timer_module.incrementCurrentTime(3);
    try std.testing.expectEqual(6, timer_module.elapsedTicks(&timer1));

    timer_module.incrementCurrentTime(3);
    try std.testing.expectEqual(9, timer_module.elapsedTicks(&timer1));

    timer_module.incrementCurrentTime(3);
    try std.testing.expectEqual(10, timer_module.elapsedTicks(&timer1));

    try std.testing.expect(timer_module.run());

    try std.testing.expectEqual(0, timer_module.elapsedTicks(&timer1));

    timer_module.incrementCurrentTime(9);
    try std.testing.expectEqual(9, timer_module.elapsedTicks(&timer1));
}

test "elapsed ticks for paused timer" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.startPeriodic(&timer1, 10, null, timer1Callback);

    timer_module.pause(&timer1);
    try std.testing.expectEqual(0, timer_module.elapsedTicks(&timer1));

    timer_module.incrementCurrentTime(10);
    try std.testing.expectEqual(0, timer_module.elapsedTicks(&timer1));

    timer_module.unpause(&timer1);
    timer_module.incrementCurrentTime(3);
    timer_module.pause(&timer1);
    try std.testing.expectEqual(3, timer_module.elapsedTicks(&timer1));

    timer_module.incrementCurrentTime(11);
    try std.testing.expectEqual(3, timer_module.elapsedTicks(&timer1));

    timer_module.unpause(&timer1);
    timer_module.incrementCurrentTime(11);
    try std.testing.expectEqual(10, timer_module.elapsedTicks(&timer1));

    timer_module.pause(&timer1);
    try std.testing.expectEqual(10, timer_module.elapsedTicks(&timer1));
}

test "elapsed ticks for max ticks timer that is overdue by longest_delay_before_servicing_timer" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.startOneShot(&timer1, Timer.max_ticks, null, timer1Callback);
    timer_module.incrementCurrentTime(Timer.max_ticks);
    try std.testing.expectEqual(Timer.max_ticks, timer_module.elapsedTicks(&timer1));

    timer_module.incrementCurrentTime(Timer.longest_delay_before_servicing_timer);
    try std.testing.expectEqual(std.math.maxInt(timer.Ticks), Timer.max_ticks + Timer.longest_delay_before_servicing_timer);

    try std.testing.expectEqual(Timer.max_ticks, timer_module.elapsedTicks(&timer1));
}

test "elapsed ticks does not account for overdue ticks of a timer that is run" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};
    var timer2 = Timer{};

    timer_module.startOneShot(&timer1, 5, &calls, timer1Callback);
    timer_module.startOneShot(&timer2, 5, &calls, timer2Callback);

    timer_module.incrementCurrentTime(6);
    try std.testing.expect(timer_module.run());
    try std.testing.expectEqualSlices(u8, &[_]u8{1}, calls.items);

    try std.testing.expectEqual(0, timer_module.elapsedTicks(&timer1));
    try std.testing.expectEqual(5, timer_module.elapsedTicks(&timer2));
}

test "ticks since last started running timer" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.startOneShot(&timer1, 10, null, timer1Callback);
    try std.testing.expectEqual(0, timer_module.ticksSinceLastStarted(&timer1));

    timer_module.incrementCurrentTime(7);
    try std.testing.expectEqual(7, timer_module.ticksSinceLastStarted(&timer1));
}

test "ticks since last started overdue timer" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.startOneShot(&timer1, 10, null, timer1Callback);
    timer_module.incrementCurrentTime(15);
    try std.testing.expectEqual(15, timer_module.ticksSinceLastStarted(&timer1));
}

fn ticksSinceLastStartedReporter(ctx: ?*anyopaque, _timer_module: *TimerModule, _timer: *Timer) void {
    const ticksSinceLastStarted: *timer.Ticks = @ptrCast(@alignCast(ctx));
    ticksSinceLastStarted.* = _timer_module.ticksSinceLastStarted(_timer);
}

test "ticks since last started overdue one-shot timer during a callback" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    var observed_ticks_since_started: timer.Ticks = undefined;

    timer_module.startOneShot(&timer1, 10, &observed_ticks_since_started, ticksSinceLastStartedReporter);
    timer_module.incrementCurrentTime(15);

    try std.testing.expect(timer_module.run());
    try std.testing.expectEqual(15, observed_ticks_since_started);
}

test "ticks since last started overdue periodic timer during a callback" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    var observed_ticks_since_started: timer.Ticks = undefined;

    timer_module.startPeriodic(&timer1, 10, &observed_ticks_since_started, ticksSinceLastStartedReporter);
    timer_module.incrementCurrentTime(17);

    try std.testing.expect(timer_module.run());
    try std.testing.expectEqual(17, observed_ticks_since_started);
}

test "ticks since last started overflow condition" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    var observed_ticks_since_started: timer.Ticks = undefined;

    timer_module.incrementCurrentTime(std.math.maxInt(timer.Ticks) - 10);

    timer_module.startPeriodic(&timer1, 20, &observed_ticks_since_started, ticksSinceLastStartedReporter);
    timer_module.incrementCurrentTime(27);

    try std.testing.expectEqual(27, timer_module.ticksSinceLastStarted(&timer1));

    timer_module.incrementCurrentTime(1);
    try std.testing.expect(timer_module.run());
    try std.testing.expectEqual(28, observed_ticks_since_started);
}

test "restart periodic as one-shot" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    const A = struct {
        fn callback(_: ?*anyopaque, _timer_module: *TimerModule, _timer: *Timer) void {
            _timer_module.startOneShot(_timer, 0, null, callback);
        }
    };

    timer_module.startPeriodic(&timer1, 20, null, A.callback);
    try expectTimerExpiresAfterExactly(&timer_module, 20);

    try std.testing.expect(timer_module.run());
}

// NOTE:
//   The below tests are for documenting behavior. The behaviors are not that important.
//   Feel free to change any of them to a *reasonable alternative* for optimization reasons.
//   Tests will explicitly note if a behavior is completely invalid, and thus any result is allowed.

test "elapsed ticks from a callback" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};
    var timer2 = Timer{};

    var observed_elapsed_ticks: timer.Ticks = undefined;

    const A = struct {
        fn callback(ctx: ?*anyopaque, _timer_module: *TimerModule, _timer: *Timer) void {
            const observed: *timer.Ticks = @ptrCast(@alignCast(ctx));
            observed.* = _timer_module.elapsedTicks(_timer);
        }
    };

    timer_module.startOneShot(&timer1, 5, &observed_elapsed_ticks, A.callback);
    timer_module.startOneShot(&timer2, 13, &observed_elapsed_ticks, A.callback);

    // 0 or 5 is reasonable
    try expectTimerExpiresAfterExactly(&timer_module, 5);
    try std.testing.expectEqual(observed_elapsed_ticks, 0);

    // 0 or 13 is reasonable
    try expectTimerExpiresAfterExactly(&timer_module, 8);
    try std.testing.expectEqual(observed_elapsed_ticks, 0);
}

test "ticks since last started called without starting the timer" {
    return error.SkipZigTest; // This test actually depends on optimization level as well

    // zlinter-disable no_comment_out_code
    // var timer_module = TimerModule{};
    // var timer1 = Timer{};

    // // This is 100% dependent on the default value of timer.duration and timer.timer_data.
    // try std.testing.expectEqual(0, timer_module.ticksSinceLastStarted(&timer1));

    // timer_module.incrementCurrentTime(123);
    // try std.testing.expectEqual(123, timer_module.ticksSinceLastStarted(&timer1));
    // zlinter-enable no_comment_out_code
}
