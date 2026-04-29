//! File dedicated to fuzz testing the timer module

const std = @import("std");
const timer = @import("../timer.zig");
const TimerModule = timer.TimerModule;
const Timer = timer.Timer;

const TimerAction = enum {
    start_oneshot_timer,
    start_periodic_timer,
    stop_timer,
    pause_timer,
    unpause_timer,
    run_timer_module, // In practice all this does is add a LOT more weight to `elapse_time_and_run_timer_module{ .duration = 0 }`
    elapse_time_and_run_timer_module,
};

const TimerActionData = union(TimerAction) {
    start_oneshot_timer: struct {
        idx: u8,
        duration: timer.Ticks,
        ctx: *align(2) anyopaque,
        callback: Timer.TimerCallback,
    },
    start_periodic_timer: struct {
        idx: u8,
        duration: timer.Ticks,
        ctx: *align(2) anyopaque,
        callback: Timer.TimerCallback,
    },
    stop_timer: struct {
        idx: u8,
    },
    pause_timer: struct {
        idx: u8,
    },
    unpause_timer: struct {
        idx: u8,
    },
    run_timer_module: struct { count: u8 },
    elapse_time_and_run_timer_module: struct { ticks_to_elapse: u16, count: u8 },
};

const max_actions = 10000;
const max_timers = 10;

var actions: [max_actions]TimerActionData = undefined;
var timers: [max_timers]Timer = [_]Timer{.{}} ** max_timers;
const callbacks = [_]Timer.TimerCallback{
    do_nothing_callback,
    stop_some_timer,
    pause_some_timer,
    resume_some_timer,
    start_some_timer_as_oneshot,
    start_some_timer_as_periodic,
};

fn timer_module_fuzz(rng: *std.Random) !void {
    var timer_module = TimerModule{};

    for (&actions) |*_action| {
        const idx = rng.intRangeAtMost(u8, 0, timers.len - 1);
        const duration = rng.intRangeAtMost(timer.Ticks, 0, Timer.longest_delay_before_servicing_timer); // Restricted to short timers for higher quality (low-effort) fuzzing
        // TODO: Keep track of the expected durations, and elapse [0, ticks_until_next_ready + longest_delay_before_servicing_timer]
        const timer_elapse_duration = rng.intRangeAtMost(u16, 0, Timer.longest_delay_before_servicing_timer);
        const run_count = rng.intRangeAtMost(u8, timers.len, std.math.maxInt(u8));
        const callback = callbacks[rng.intRangeAtMost(u8, 0, callbacks.len - 1)];

        const new_action = rng.enumValue(TimerAction);
        _action.* = switch (new_action) {
            .start_oneshot_timer => TimerActionData{ .start_oneshot_timer = .{ .idx = idx, .duration = duration, .ctx = rng, .callback = callback } },
            .start_periodic_timer => TimerActionData{ .start_periodic_timer = .{ .idx = idx, .duration = duration, .ctx = rng, .callback = callback } },
            .stop_timer => TimerActionData{ .stop_timer = .{ .idx = idx } },
            .pause_timer => TimerActionData{ .pause_timer = .{ .idx = idx } },
            .unpause_timer => TimerActionData{ .unpause_timer = .{ .idx = idx } },
            .run_timer_module => TimerActionData{ .run_timer_module = .{ .count = run_count } },
            .elapse_time_and_run_timer_module => TimerActionData{ .elapse_time_and_run_timer_module = .{ .ticks_to_elapse = timer_elapse_duration, .count = run_count } },
        };
    }

    for (&actions) |_action| {
        switch (_action) {
            .start_oneshot_timer => |data| timer_module.start_one_shot(&timers[data.idx], data.duration, data.ctx, data.callback),
            .start_periodic_timer => |data| timer_module.start_periodic(&timers[data.idx], data.duration, data.ctx, data.callback),
            .stop_timer => |data| timer_module.stop(&timers[data.idx]),
            .pause_timer => |data| timer_module.pause(&timers[data.idx]),
            .unpause_timer => |data| timer_module.unpause(&timers[data.idx]),
            .run_timer_module => |data| {
                for (0..data.count) |_| {
                    _ = timer_module.run();
                }
            },
            .elapse_time_and_run_timer_module => |data| {
                timer_module.increment_current_time(data.ticks_to_elapse);
                for (0..data.count) |_| {
                    _ = timer_module.run();
                }
            },
        }
    }
}

const sometimes_enabled = @import("sometimes").config.enable_sometimes;

test "fuzz testing timer module" {
    if (sometimes_enabled) {
        // Don't want fuzzing to affect coverage results, also a significant slowdown is incurred
        return error.SkipZigTest;
    }
    var prng = std.Random.DefaultPrng.init(std.testing.random_seed);
    var random = prng.random();

    const test_case_count = 100;
    for (0..test_case_count) |_| {
        try timer_module_fuzz(&random);
    }
}

fn do_nothing_callback(_: ?*anyopaque, _: *TimerModule, _: *Timer) void {}

fn stop_some_timer(ctx: ?*anyopaque, _timer_module: *TimerModule, _: *Timer) void {
    const rng: *std.Random = @ptrCast(@alignCast(ctx));
    const some_timer: *Timer = &timers[rng.intRangeAtMost(u8, 0, timers.len - 1)];
    _timer_module.stop(some_timer);
}
fn pause_some_timer(ctx: ?*anyopaque, _timer_module: *TimerModule, _: *Timer) void {
    const rng: *std.Random = @ptrCast(@alignCast(ctx));
    const some_timer: *Timer = &timers[rng.intRangeAtMost(u8, 0, timers.len - 1)];
    _timer_module.pause(some_timer);
}
fn resume_some_timer(ctx: ?*anyopaque, _timer_module: *TimerModule, _: *Timer) void {
    const rng: *std.Random = @ptrCast(@alignCast(ctx));
    const some_timer: *Timer = &timers[rng.intRangeAtMost(u8, 0, timers.len - 1)];
    _timer_module.unpause(some_timer);
}

fn start_some_timer_as_oneshot(ctx: ?*anyopaque, _timer_module: *TimerModule, _: *Timer) void {
    const rng: *std.Random = @ptrCast(@alignCast(ctx));

    const some_timer: *Timer = &timers[rng.intRangeAtMost(u8, 0, timers.len - 1)];
    const duration = rng.intRangeAtMost(timer.Ticks, 0, Timer.longest_delay_before_servicing_timer);
    const callback = callbacks[rng.intRangeAtMost(u8, 0, callbacks.len - 1)];

    _timer_module.start_one_shot(some_timer, duration, rng, callback);
}
fn start_some_timer_as_periodic(ctx: ?*anyopaque, _timer_module: *TimerModule, _: *Timer) void {
    const rng: *std.Random = @ptrCast(@alignCast(ctx));

    const some_timer: *Timer = &timers[rng.intRangeAtMost(u8, 0, timers.len - 1)];
    const duration = rng.intRangeAtMost(timer.Ticks, 0, Timer.longest_delay_before_servicing_timer);
    const callback = callbacks[rng.intRangeAtMost(u8, 0, callbacks.len - 1)];

    _timer_module.start_one_shot(some_timer, duration, rng, callback);
}
