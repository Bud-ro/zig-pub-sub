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

fn timer1_callback(ctx: ?*anyopaque, _: *TimerModule, _: *Timer) void {
    var calls: *std.ArrayList(u8) = @ptrCast(@alignCast(ctx.?));
    calls.appendAssumeCapacity(1);
}

fn timer2_callback(ctx: ?*anyopaque, _: *TimerModule, _: *Timer) void {
    var calls: *std.ArrayList(u8) = @ptrCast(@alignCast(ctx.?));
    calls.appendAssumeCapacity(2);
}

fn timer3_callback(ctx: ?*anyopaque, _: *TimerModule, _: *Timer) void {
    var calls: *std.ArrayList(u8) = @ptrCast(@alignCast(ctx.?));
    calls.appendAssumeCapacity(3);
}

fn timer_callback(ctx: ?*anyopaque, _: *TimerModule, _: *Timer) void {
    const local_ctx: *u32 = @ptrCast(@alignCast(ctx.?));
    local_ctx.* += 1;
}

fn stop_timer_callback(_: ?*anyopaque, _timer_module: *TimerModule, _timer: *Timer) void {
    _timer_module.stop(_timer);
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

test "timer pause/resume with different remaining ticks" {
    var timer_module = TimerModule{};

    var local_ctx1: u32 = 0;
    var timer1 = Timer{};

    timer_module.start_periodic(&timer1, 50, &local_ctx1, timer_callback);

    timer_module.increment_current_time(20);
    timer_module.pause(&timer1);
    try std.testing.expectEqual(false, timer_module.run());

    timer_module.increment_current_time(30);
    try std.testing.expectEqual(false, timer_module.run());

    timer_module.unpause(&timer1);
    try expect_timer_expires_after_exactly(&timer_module, 30);
    try std.testing.expectEqual(1, local_ctx1);
}

test "timer pause/resume at last moment" {
    var timer_module = TimerModule{};

    var local_ctx1: u32 = 0;
    var timer1 = Timer{};

    timer_module.start_one_shot(&timer1, 50, &local_ctx1, timer_callback);
    timer_module.increment_current_time(50 + Timer.longest_delay_before_servicing_timer);
    timer_module.pause(&timer1);

    try std.testing.expectEqual(false, timer_module.run());

    timer_module.unpause(&timer1);
    timer_module.increment_current_time(Timer.longest_delay_before_servicing_timer);
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

    timer_module.start_one_shot(&timer1, 50, &local_ctx1, timer_callback);
    timer_module.increment_current_time(50 + Timer.longest_delay_before_servicing_timer + 1);
    timer_module.pause(&timer1);

    try std.testing.expectEqual(false, timer_module.run());

    timer_module.unpause(&timer1);
    try expect_timer_expires_after_exactly(&timer_module, Timer.max_ticks);
    try std.testing.expectEqual(1, local_ctx1);
}

test "can pause timer during one-shot callback" {
    var timer_module = TimerModule{};

    var local_ctx: u32 = 0;
    var timer1 = Timer{};
    var timer2 = Timer{};

    const A = struct {
        fn pause_the_timer(ctx: ?*anyopaque, _timer_module: *TimerModule, _: *Timer) void {
            const to_pause: *Timer = @ptrCast(@alignCast(ctx));
            _timer_module.pause(to_pause);
        }
    };

    timer_module.start_one_shot(&timer1, 50, &timer2, A.pause_the_timer);
    timer_module.start_one_shot(&timer2, 50, &local_ctx, timer_callback);

    try expect_timer_expires_after_exactly(&timer_module, 50);
    try std.testing.expectEqual(false, timer_module.run());
    try std.testing.expectEqual(0, local_ctx);

    try std.testing.expectEqual(false, timer_module.is_active(&timer2));
    try std.testing.expectEqual(true, timer_module.is_paused(&timer2));
    try std.testing.expectEqual(true, timer_module.is_running(&timer2));

    timer_module.unpause(&timer2);
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(1, local_ctx);

    try std.testing.expectEqual(false, timer_module.is_active(&timer2));
    try std.testing.expectEqual(false, timer_module.is_paused(&timer2));
    try std.testing.expectEqual(false, timer_module.is_running(&timer2));
}

test "can pause timer during periodic callback" {
    var timer_module = TimerModule{};

    var local_ctx: u32 = 0;
    var timer1 = Timer{};
    var timer2 = Timer{};

    const A = struct {
        fn pause_the_timer(ctx: ?*anyopaque, _timer_module: *TimerModule, _: *Timer) void {
            const to_pause: *Timer = @ptrCast(@alignCast(ctx));
            _timer_module.pause(to_pause);
        }
    };

    timer_module.start_periodic(&timer1, 50, &timer2, A.pause_the_timer);
    timer_module.start_periodic(&timer2, 50, &local_ctx, timer_callback);

    try expect_timer_expires_after_exactly(&timer_module, 50);
    try std.testing.expectEqual(false, timer_module.run());
    try std.testing.expectEqual(0, local_ctx);

    timer_module.unpause(&timer2);
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(1, local_ctx);

    try expect_timer_expires_after_exactly(&timer_module, 50);
    try std.testing.expectEqual(false, timer_module.run());
    try std.testing.expectEqual(1, local_ctx);

    try expect_timer_expires_after_exactly(&timer_module, 50);
    try std.testing.expectEqual(false, timer_module.run());
    try std.testing.expectEqual(1, local_ctx);

    timer_module.unpause(&timer2);
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(2, local_ctx);
}

test "is running tests" {
    var timer_module = TimerModule{};

    var test_failed align(2) = false;
    var timer1 = Timer{};
    var timer2 = Timer{};

    const A = struct {
        fn self_is_running_during_callback(ctx: ?*anyopaque, _timer_module: *TimerModule, _timer: *Timer) void {
            const failed: *bool = @ptrCast(ctx);
            if (!_timer_module.is_running(_timer)) {
                failed.* = true;
            }
        }
    };

    try std.testing.expectEqual(false, timer_module.is_running(&timer1));
    try std.testing.expectEqual(false, timer_module.is_running(&timer2));

    timer_module.start_periodic(&timer2, 50, &test_failed, A.self_is_running_during_callback);
    timer_module.start_one_shot(&timer1, 50, &test_failed, A.self_is_running_during_callback);

    timer_module.increment_current_time(50);
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(false, timer_module.run());

    // You can sprinkle this throughout the test to find out exactly where it fails (if it does)
    try std.testing.expectEqual(false, test_failed);
}

test "is active" {
    var timer_module = TimerModule{};

    var test_failed align(2) = false;
    var timer1 = Timer{};
    var timer2 = Timer{};

    const A = struct {
        fn self_is_running_during_callback(ctx: ?*anyopaque, _timer_module: *TimerModule, _timer: *Timer) void {
            const failed: *bool = @ptrCast(ctx);
            if (!_timer_module.is_active(_timer)) {
                failed.* = true;
            }
        }
    };

    try std.testing.expectEqual(false, timer_module.is_active(&timer1));
    try std.testing.expectEqual(false, timer_module.is_active(&timer2));

    timer_module.start_one_shot(&timer1, 50, &test_failed, A.self_is_running_during_callback);
    timer_module.start_periodic(&timer2, 50, &test_failed, A.self_is_running_during_callback);

    timer_module.increment_current_time(50);
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(false, timer_module.run());

    // You can sprinkle this throughout the test to find out exactly where it fails (if it does)
    try std.testing.expectEqual(false, test_failed);
}

// EXTRA tests
test "One shot with null callback" {
    // var timer_module = TimerModule{};
    // var timer1 = Timer{};
    // var context: u32 = 0;

    // TODO: This is a compile error, make sure to test for that if Zig ever allows for it
    return error.SkipZigTest;
    // timer_module.start_one_shot(&timer1, 0, &context, null);
}

test "Periodic with null callback" {
    // var timer_module = TimerModule{};
    // var timer1 = Timer{};
    // var context: u32 = 0;

    // TODO: This is a compile error, make sure to test for that if Zig ever allows for it
    return error.SkipZigTest;
    // timer_module.start_periodic(&timer1, 0, &context, null);
}

test "IsRunning" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};
    var timer2 = Timer{};

    try std.testing.expect(!timer_module.is_running(&timer1));
    try std.testing.expect(!timer_module.is_running(&timer2));

    timer_module.start_one_shot(&timer1, 1, &calls, timer1_callback);

    try std.testing.expect(timer_module.is_running(&timer1));
    try std.testing.expect(!timer_module.is_running(&timer2));

    timer_module.start_one_shot(&timer2, 1, &calls, timer2_callback);

    try std.testing.expect(timer_module.is_running(&timer1));
    try std.testing.expect(timer_module.is_running(&timer2));

    timer_module.stop(&timer1);

    try std.testing.expect(!timer_module.is_running(&timer1));
    try std.testing.expect(timer_module.is_running(&timer2));

    timer_module.stop(&timer2);
    try std.testing.expect(!timer_module.is_running(&timer1));
    try std.testing.expect(!timer_module.is_running(&timer2));

    try std.testing.expectEqualSlices(u8, &[_]u8{}, calls.items);
}

test "Ticks until next ready is max int when no timers are in list" {
    var timer_module = TimerModule{};
    try std.testing.expectEqual(std.math.maxInt(timer.Ticks), timer_module.ticks_until_next_ready());
}

test "Ticks until next ready timer" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};
    var timer2 = Timer{};

    timer_module.start_one_shot(&timer1, 7, &calls, timer1_callback);
    try std.testing.expectEqual(7, timer_module.ticks_until_next_ready());

    timer_module.start_one_shot(&timer2, 4, &calls, timer2_callback);
    try std.testing.expectEqual(4, timer_module.ticks_until_next_ready());

    timer_module.increment_current_time(1);
    try std.testing.expectEqual(3, timer_module.ticks_until_next_ready());

    timer_module.increment_current_time(1);
    try std.testing.expectEqual(2, timer_module.ticks_until_next_ready());

    try std.testing.expectEqualSlices(u8, &[_]u8{}, calls.items);
}

test "Timer module run expire" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.start_one_shot(&timer1, 1, &calls, timer1_callback);

    try expect_timer_expires_after_exactly(&timer_module, 1);
    try std.testing.expectEqualSlices(u8, &[_]u8{1}, calls.items);
}

test "oneshot multiple simultaneous" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};
    var timer2 = Timer{};

    timer_module.start_one_shot(&timer1, 1, &calls, timer1_callback);
    timer_module.start_one_shot(&timer2, 1, &calls, timer2_callback);

    timer_module.increment_current_time(1);

    while (timer_module.run()) {}

    try std.testing.expect(!timer_module.is_running(&timer1));
    try std.testing.expect(!timer_module.is_running(&timer2));

    try std.testing.expectEqualSlices(u8, &[_]u8{ 1, 2 }, calls.items);
}

test "remaining ticks" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.start_periodic(&timer1, 10, &calls, timer1_callback);
    try std.testing.expectEqual(10, timer_module.remaining_ticks(&timer1));

    timer_module.increment_current_time(5);
    _ = timer_module.run();

    try std.testing.expectEqual(5, timer_module.remaining_ticks(&timer1));

    timer_module.increment_current_time(5);
    _ = timer_module.run();

    try std.testing.expectEqual(10, timer_module.remaining_ticks(&timer1));

    try std.testing.expectEqualSlices(u8, &[_]u8{1}, calls.items);
}

test "remaining ticks should not underflow" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.start_periodic(&timer1, 10, &calls, timer1_callback);
    timer_module.increment_current_time(5);

    _ = timer_module.run();
    timer_module.increment_current_time(10);

    try std.testing.expectEqual(0, timer_module.remaining_ticks(&timer1));
    try std.testing.expectEqualSlices(u8, &[_]u8{}, calls.items);
}

test "remaining_ticks zero if not running" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.start_periodic(&timer1, 10, &calls, timer1_callback);
    timer_module.stop(&timer1);

    try std.testing.expectEqual(0, timer_module.remaining_ticks(&timer1));
    try std.testing.expectEqualSlices(u8, &[_]u8{}, calls.items);
}

test "restart one shot from callback" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    const A = struct {
        fn restart_with_context(ctx: ?*anyopaque, _timer_module: *TimerModule, _timer: *Timer) void {
            var _calls: *std.ArrayList(u8) = @ptrCast(@alignCast(ctx));
            _calls.appendAssumeCapacity(11);
            _timer_module.start_one_shot(_timer, 0, _calls, timer1_callback);
        }
    };

    timer_module.start_one_shot(&timer1, 0, &calls, A.restart_with_context);

    try std.testing.expect(timer_module.run());
    try std.testing.expectEqualSlices(u8, &[_]u8{11}, calls.items);

    try std.testing.expect(timer_module.run());
    try std.testing.expectEqualSlices(u8, &[_]u8{ 11, 1 }, calls.items);

    try std.testing.expect(!timer_module.run());
}

test "restart periodic from callback" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    const A = struct {
        fn restart_with_context(ctx: ?*anyopaque, _timer_module: *TimerModule, _timer: *Timer) void {
            var _calls: *std.ArrayList(u8) = @ptrCast(@alignCast(ctx));
            _calls.appendAssumeCapacity(13);
            _timer_module.start_periodic(_timer, 1, _calls, timer1_callback);
        }
    };

    timer_module.start_periodic(&timer1, 1, &calls, A.restart_with_context);

    timer_module.increment_current_time(1);
    try std.testing.expect(timer_module.run());
    try std.testing.expectEqualSlices(u8, &[_]u8{13}, calls.items);

    timer_module.increment_current_time(1);
    try std.testing.expect(timer_module.run());
    try std.testing.expectEqualSlices(u8, &[_]u8{ 13, 1 }, calls.items);
}

test "Overflow handling" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.increment_current_time(std.math.maxInt(timer.Ticks) - 5);
    timer_module.start_one_shot(&timer1, 10, &calls, timer1_callback);

    for (0..9) |_| {
        timer_module.increment_current_time(1);
        try std.testing.expect(!timer_module.run());
    }

    try expect_timer_expires_after_exactly(&timer_module, 1);
    try std.testing.expectEqualSlices(u8, &[_]u8{1}, calls.items);
}

test "Stop timer from callback" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.start_one_shot(&timer1, 0, null, stop_timer_callback);
    try std.testing.expect(timer_module.run());

    try std.testing.expect(!timer_module.is_running(&timer1));
}

test "Start periodic timer from callback" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    const A = struct {
        fn start_periodic_callback(ctx: ?*anyopaque, _timer_module: *TimerModule, _timer: *Timer) void {
            _timer_module.start_periodic(_timer, 1, @alignCast(ctx), start_periodic_callback);
        }
    };

    for (0..100) |_| {
        timer_module.start_periodic(&timer1, 1, null, A.start_periodic_callback);

        timer_module.increment_current_time(1);
        try std.testing.expect(timer_module.run());

        timer_module.increment_current_time(1);
        try std.testing.expect(timer_module.run());

        timer_module.increment_current_time(1);
        try std.testing.expect(timer_module.run());

        timer_module.increment_current_time(1);
        try std.testing.expect(timer_module.run());

        timer_module.increment_current_time(1);
        try std.testing.expect(timer_module.run());
    }
}

test "is_paused start" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.start_one_shot(&timer1, 1, null, timer1_callback);
    try std.testing.expect(!timer_module.is_paused(&timer1));
    try std.testing.expect(timer_module.is_running(&timer1));
}

test "is_paused pause" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.start_one_shot(&timer1, 1, null, timer1_callback);

    timer_module.pause(&timer1);
    try std.testing.expect(timer_module.is_paused(&timer1));
    try std.testing.expect(timer_module.is_running(&timer1));
    try std.testing.expect(!timer_module.is_active(&timer1));
}

test "is_paused pause multiple times" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.start_one_shot(&timer1, 1, null, timer1_callback);

    timer_module.pause(&timer1);
    timer_module.pause(&timer1);
    try std.testing.expect(timer_module.is_paused(&timer1));
    try std.testing.expect(timer_module.is_running(&timer1));
    try std.testing.expect(!timer_module.is_active(&timer1));
}

test "is_paused stop when paused" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.start_one_shot(&timer1, 1, null, timer1_callback);

    timer_module.pause(&timer1);
    timer_module.stop(&timer1);

    try std.testing.expect(!timer_module.is_paused(&timer1));
    try std.testing.expect(!timer_module.is_running(&timer1));
    try std.testing.expect(!timer_module.is_active(&timer1));
}

test "is_paused resume" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.start_one_shot(&timer1, 1, null, timer1_callback);

    timer_module.pause(&timer1);
    timer_module.unpause(&timer1);

    try std.testing.expect(!timer_module.is_paused(&timer1));
    try std.testing.expect(timer_module.is_running(&timer1));
    try std.testing.expect(timer_module.is_active(&timer1));
}

test "is_paused stop after resume" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.start_one_shot(&timer1, 1, null, timer1_callback);

    timer_module.pause(&timer1);
    timer_module.unpause(&timer1);
    timer_module.stop(&timer1);

    try std.testing.expect(!timer_module.is_paused(&timer1));
    try std.testing.expect(!timer_module.is_running(&timer1));
    try std.testing.expect(!timer_module.is_active(&timer1));
}

test "pause one shot timer" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.start_one_shot(&timer1, 2, null, timer1_callback);
    timer_module.pause(&timer1);

    timer_module.increment_current_time(3);
    try std.testing.expect(!timer_module.run());
}

test "pause stop when pause one shot timer" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.start_one_shot(&timer1, 2, null, timer1_callback);
    timer_module.pause(&timer1);
    timer_module.stop(&timer1);

    timer_module.increment_current_time(3);
    try std.testing.expect(!timer_module.run());
}

test "pause start when pause one shot timer is paused" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.start_one_shot(&timer1, 2, &calls, timer1_callback);
    timer_module.increment_current_time(1);
    timer_module.pause(&timer1);

    timer_module.start_one_shot(&timer1, 2, &calls, timer1_callback);
    timer_module.increment_current_time(1);
    try std.testing.expect(!timer_module.run());

    timer_module.increment_current_time(1);
    try std.testing.expect(timer_module.run());

    try std.testing.expectEqualSlices(u8, &[_]u8{1}, calls.items);
}

test "resume one shot timer" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.start_one_shot(&timer1, 5, &calls, timer1_callback);
    timer_module.increment_current_time(1);
    try std.testing.expect(!timer_module.run());

    timer_module.pause(&timer1);
    timer_module.increment_current_time(3);
    try std.testing.expect(!timer_module.run());

    timer_module.unpause(&timer1);
    timer_module.increment_current_time(3);
    try std.testing.expect(!timer_module.run());

    timer_module.increment_current_time(1);
    try std.testing.expect(timer_module.run());

    try std.testing.expect(!timer_module.is_paused(&timer1));
    try std.testing.expect(!timer_module.is_active(&timer1));
    try std.testing.expect(!timer_module.is_running(&timer1));

    try std.testing.expectEqualSlices(u8, &[_]u8{1}, calls.items);
}

test "resume stop when one shot timer is resumed" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.start_one_shot(&timer1, 2, null, timer1_callback);
    timer_module.pause(&timer1);
    timer_module.unpause(&timer1);

    timer_module.stop(&timer1);
    timer_module.increment_current_time(3);
    try std.testing.expect(!timer_module.run());
}

test "pause periodic timer" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.start_periodic(&timer1, 1, &calls, timer1_callback);

    try expect_timer_expires_after_exactly(&timer_module, 1);

    timer_module.pause(&timer1);

    timer_module.increment_current_time(1);
    try std.testing.expect(!timer_module.run());
    try std.testing.expectEqualSlices(u8, &[_]u8{1}, calls.items);
}

test "pause stop when periodic timer is paused" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.start_periodic(&timer1, 1, &calls, timer1_callback);
    try expect_timer_expires_after_exactly(&timer_module, 1);

    timer_module.pause(&timer1);

    timer_module.increment_current_time(1);
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

    timer_module.start_periodic(&timer1, 2, &calls, timer1_callback);
    timer_module.increment_current_time(1);
    try std.testing.expect(!timer_module.run());

    timer_module.pause(&timer1);
    timer_module.unpause(&timer1);

    try expect_timer_expires_after_exactly(&timer_module, 1);
    try std.testing.expectEqualSlices(u8, &[_]u8{1}, calls.items);
}

test "resume ticks are accurate" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.start_one_shot(&timer1, 5, &calls, timer1_callback);
    timer_module.increment_current_time(2);
    timer_module.pause(&timer1);

    timer_module.increment_current_time(1);
    try std.testing.expectEqual(3, timer_module.remaining_ticks(&timer1));
    timer_module.unpause(&timer1);
    try std.testing.expectEqual(3, timer_module.remaining_ticks(&timer1));

    timer_module.increment_current_time(2);
    try std.testing.expect(!timer_module.run());
    try std.testing.expectEqual(1, timer_module.remaining_ticks(&timer1));

    try expect_timer_expires_after_exactly(&timer_module, 1);
    try std.testing.expectEqual(0, timer_module.remaining_ticks(&timer1));
    try std.testing.expectEqualSlices(u8, &[_]u8{1}, calls.items);
}

test "invalid pause ignored" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.pause(&timer1);
    timer_module.start_one_shot(&timer1, 1, null, timer1_callback);
    timer_module.pause(&timer1);

    timer_module.pause(&timer1);

    timer_module.stop(&timer1);
    timer_module.pause(&timer1);
}

test "resume while not running ignored" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.unpause(&timer1);
    timer_module.increment_current_time(1);
    try std.testing.expect(!timer_module.run());

    timer_module.start_periodic(&timer1, 1, null, timer1_callback);
    timer_module.stop(&timer1);
    timer_module.unpause(&timer1);
    try std.testing.expect(!timer_module.run());
}

test "resume while not paused ignored" {
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.increment_current_time(10000);
    timer_module.start_periodic(&timer1, 1, null, timer1_callback);
    timer_module.unpause(&timer1);
    try std.testing.expectEqual(1, timer_module.remaining_ticks(&timer1));
}

test "should not interfere with non-paused timers" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};
    var timer2 = Timer{};

    timer_module.start_one_shot(&timer1, 1, &calls, timer1_callback);
    timer_module.start_one_shot(&timer2, 1, &calls, timer2_callback);
    timer_module.pause(&timer1);

    try expect_timer_expires_after_exactly(&timer_module, 1);
    try std.testing.expectEqualSlices(u8, &[_]u8{2}, calls.items);
}

test "resuming a timer should not interfere with timers that expire sooner" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};
    var timer2 = Timer{};

    timer_module.start_one_shot(&timer1, 9, &calls, timer1_callback);
    timer_module.start_one_shot(&timer2, 10, &calls, timer2_callback);

    timer_module.pause(&timer1);
    timer_module.increment_current_time(5);
    timer_module.unpause(&timer1);

    try expect_timer_expires_after_exactly(&timer_module, 5);
    try std.testing.expectEqualSlices(u8, &[_]u8{2}, calls.items);
}

test "should handle paused timers properly when inserting timers into queue" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};
    var timer2 = Timer{};
    var timer3 = Timer{};

    timer_module.start_one_shot(&timer1, 500, &calls, timer1_callback);
    timer_module.start_one_shot(&timer2, 600, &calls, timer2_callback);

    timer_module.pause(&timer1);
    timer_module.increment_current_time(500);

    timer_module.start_one_shot(&timer3, 400, &calls, timer3_callback);

    try expect_timer_expires_after_exactly(&timer_module, 100);
    try expect_timer_expires_after_exactly(&timer_module, 300);
    try std.testing.expectEqualSlices(u8, &[_]u8{ 2, 3 }, calls.items);
}

test "should account for pending ticks with max timer" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    timer_module.start_one_shot(&timer1, Timer.max_ticks, &calls, timer1_callback);

    timer_module.increment_current_time(1);
    try std.testing.expect(!timer_module.run());

    timer_module.pause(&timer1);
    timer_module.increment_current_time(5);

    timer_module.unpause(&timer1);
    timer_module.increment_current_time(1);
    try std.testing.expect(!timer_module.run());
}

test "does not attempt to compensate for time source drift" {
    var call_buffer: [20]u8 = .{0} ** 20;
    var calls: std.ArrayList(u8) = .initBuffer(&call_buffer);
    var timer_module = TimerModule{};
    var timer1 = Timer{};

    const A = struct {
        fn timer1_callback_with_passage_of_time(ctx: ?*anyopaque, _timer_module: *TimerModule, _timer: *Timer) void {
            // NOTE: 7 ms is a (hopefully) unrealistic amount of time for `callback` to take
            _timer_module.increment_current_time(7);
            timer1_callback(ctx, _timer_module, _timer);
        }
    };

    timer_module.start_periodic(&timer1, 250, &calls, A.timer1_callback_with_passage_of_time);

    for (0..10) |_| {
        try expect_timer_expires_after_exactly(&timer_module, 250);
    }

    try std.testing.expectEqualSlices(u8, &[_]u8{ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }, calls.items);
}
