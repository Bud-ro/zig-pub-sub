//! Allows for the tracking of elapsed time, safely up to std.math.maxInt(Ticks)
//! Reported elapsed ticks saturates at std.math.maxInt(Ticks), and no attempt is made to detect overflow for a singular run
//! (ex: start() -> 51 days -> elapsed() = ~1 day)

const std = @import("std");
const timer = @import("erd_core").timer;
const TimerModule = timer.TimerModule;

const StopWatch = @This();

start_tick: timer.Ticks = undefined,
saved_ticks: timer.Ticks = 0,
running: bool = false,

/// Stops the stopwatch. Elapsed ticks are saved
pub fn stop(this: *StopWatch, timer_module: *const TimerModule) void {
    if (this.running) {
        const elapsedTicks = timer_module.safelyGetCurrentTime() -% this.start_tick;
        if (this.saved_ticks > std.math.maxInt(timer.Ticks) - elapsedTicks) {
            this.saved_ticks = std.math.maxInt(timer.Ticks);
        } else {
            this.saved_ticks += elapsedTicks;
        }

        this.running = false;
    }
}

/// Starts the stopwatch, keeps saved ticks.
pub fn start(this: *StopWatch, timer_module: *const TimerModule) void {
    if (!this.running) {
        this.start_tick = timer_module.safelyGetCurrentTime();
        this.running = true;
    }
}

/// Resets the saved ticks to 0, and elapsed ticks is rebased to 0
pub fn reset(this: *StopWatch, timer_module: *const TimerModule) void {
    this.saved_ticks = 0;
    this.start_tick = timer_module.safelyGetCurrentTime();
}

/// Reports the elapsed + saved ticks
pub fn elapsed(this: *StopWatch, timer_module: *const TimerModule) timer.Ticks {
    if (this.running) {
        const elapsed_ticks_this_run = timer_module.safelyGetCurrentTime() -% this.start_tick;
        if (this.saved_ticks > std.math.maxInt(timer.Ticks) - elapsed_ticks_this_run) {
            return std.math.maxInt(timer.Ticks);
        } else {
            return this.saved_ticks + elapsed_ticks_this_run;
        }
    } else {
        return this.saved_ticks;
    }
}

test "Elapsed ticks non-running" {
    var timer_module: TimerModule = .{};
    var stopwatch: StopWatch = .{};

    try std.testing.expectEqual(0, stopwatch.elapsed(&timer_module));
}

test "Elapsed ticks non-running timer module progresses" {
    var timer_module: TimerModule = .{};
    var stopwatch: StopWatch = .{};

    timer_module.incrementCurrentTime(10);
    try std.testing.expectEqual(0, stopwatch.elapsed(&timer_module));
}

test "Elapsed ticks start" {
    var timer_module: TimerModule = .{};
    var stopwatch: StopWatch = .{};

    stopwatch.start(&timer_module);
    timer_module.incrementCurrentTime(10);
    try std.testing.expectEqual(10, stopwatch.elapsed(&timer_module));

    timer_module.incrementCurrentTime(111);
    try std.testing.expectEqual(121, stopwatch.elapsed(&timer_module));
}

test "Elapsed ticks start/stop/start non-zero timer_module ticks" {
    var timer_module: TimerModule = .{};
    var stopwatch: StopWatch = .{};

    timer_module.incrementCurrentTime(12345);

    stopwatch.start(&timer_module);
    timer_module.incrementCurrentTime(100);
    stopwatch.stop(&timer_module);

    try std.testing.expectEqual(100, stopwatch.elapsed(&timer_module));

    timer_module.incrementCurrentTime(111);
    try std.testing.expectEqual(100, stopwatch.elapsed(&timer_module));

    stopwatch.start(&timer_module);
    try std.testing.expectEqual(100, stopwatch.elapsed(&timer_module));

    timer_module.incrementCurrentTime(1);
    try std.testing.expectEqual(101, stopwatch.elapsed(&timer_module));

    timer_module.incrementCurrentTime(101);
    try std.testing.expectEqual(202, stopwatch.elapsed(&timer_module));
}

test "Redundant start/stop" {
    var timer_module: TimerModule = .{};
    var stopwatch: StopWatch = .{};

    stopwatch.start(&timer_module);
    stopwatch.start(&timer_module);
    stopwatch.start(&timer_module);
    timer_module.incrementCurrentTime(100);
    stopwatch.stop(&timer_module);
    stopwatch.stop(&timer_module);

    try std.testing.expectEqual(100, stopwatch.elapsed(&timer_module));

    stopwatch.start(&timer_module);
    try std.testing.expectEqual(100, stopwatch.elapsed(&timer_module));
}

test "Reset when running" {
    var timer_module: TimerModule = .{};
    var stopwatch: StopWatch = .{};

    stopwatch.start(&timer_module);
    timer_module.incrementCurrentTime(100);
    try std.testing.expectEqual(100, stopwatch.elapsed(&timer_module));

    stopwatch.reset(&timer_module);
    try std.testing.expectEqual(0, stopwatch.elapsed(&timer_module));

    timer_module.incrementCurrentTime(50);
    try std.testing.expectEqual(50, stopwatch.elapsed(&timer_module));
}

test "Reset when stopped" {
    var timer_module: TimerModule = .{};
    var stopwatch: StopWatch = .{};

    stopwatch.start(&timer_module);
    timer_module.incrementCurrentTime(100);

    stopwatch.stop(&timer_module);
    try std.testing.expectEqual(100, stopwatch.elapsed(&timer_module));

    stopwatch.reset(&timer_module);
    try std.testing.expectEqual(0, stopwatch.elapsed(&timer_module));

    timer_module.incrementCurrentTime(50);
    try std.testing.expectEqual(0, stopwatch.elapsed(&timer_module));
}

test "Start after reset from stop" {
    var timer_module: TimerModule = .{};
    var stopwatch: StopWatch = .{};

    stopwatch.start(&timer_module);
    timer_module.incrementCurrentTime(100);

    stopwatch.stop(&timer_module);
    try std.testing.expectEqual(100, stopwatch.elapsed(&timer_module));

    stopwatch.reset(&timer_module);
    try std.testing.expectEqual(0, stopwatch.elapsed(&timer_module));

    stopwatch.start(&timer_module);
    try std.testing.expectEqual(0, stopwatch.elapsed(&timer_module));

    timer_module.incrementCurrentTime(50);
    try std.testing.expectEqual(50, stopwatch.elapsed(&timer_module));
}

test "Uninitialized stopwatch works correctly if reset" {
    var timer_module: TimerModule = .{};
    var stopwatch: StopWatch = .{ .running = undefined, .saved_ticks = undefined, .start_tick = undefined };
    timer_module.incrementCurrentTime(12345);

    // There are no guarantees made about a call at this point
    // try std.testing.expectEqual(0, stopwatch.elapsed(&timer_module));

    stopwatch.reset(&timer_module);
    stopwatch.start(&timer_module);
    timer_module.incrementCurrentTime(100);
    try std.testing.expectEqual(100, stopwatch.elapsed(&timer_module));

    stopwatch.stop(&timer_module);
    timer_module.incrementCurrentTime(50);
    try std.testing.expectEqual(100, stopwatch.elapsed(&timer_module));
}

test "Uninitialized stopwatch works correctly if reset if it happens to not be running" {
    var timer_module: TimerModule = .{};
    var stopwatch: StopWatch = .{ .running = false, .saved_ticks = undefined, .start_tick = undefined };
    timer_module.incrementCurrentTime(12345);

    // There are no guarantees made about a call at this point
    // try std.testing.expectEqual(0, stopwatch.elapsed(&timer_module));

    stopwatch.reset(&timer_module);
    timer_module.incrementCurrentTime(100);
    try std.testing.expectEqual(0, stopwatch.elapsed(&timer_module));

    stopwatch.start(&timer_module);
    timer_module.incrementCurrentTime(100);
    try std.testing.expectEqual(100, stopwatch.elapsed(&timer_module));

    stopwatch.stop(&timer_module);
    timer_module.incrementCurrentTime(50);
    try std.testing.expectEqual(100, stopwatch.elapsed(&timer_module));
}

test "Ticks are tracked correctly at rollover" {
    var timer_module: TimerModule = .{};
    var stopwatch: StopWatch = .{};
    timer_module.incrementCurrentTime(std.math.maxInt(timer.Ticks));

    stopwatch.start(&timer_module);
    timer_module.incrementCurrentTime(1);
    try std.testing.expectEqual(1, stopwatch.elapsed(&timer_module));

    timer_module.incrementCurrentTime(10);
    try std.testing.expectEqual(11, stopwatch.elapsed(&timer_module));

    stopwatch.stop(&timer_module);
    try std.testing.expectEqual(11, stopwatch.elapsed(&timer_module));
}
