const std = @import("std");
const timer = @import("../timer.zig");
const TimerModule = timer.TimerModule;
const Timer = timer.Timer;

fn timer_callback(ctx: *anyopaque) void {
    const local_ctx: *u32 = @ptrCast(@alignCast(ctx));
    local_ctx.* += 1;
}

test "timer periodic run" {
    var timer_module = TimerModule.init();

    var local_ctx: u32 = 0;
    var timer1 = Timer.init(&local_ctx, timer_callback);

    timer_module.start_periodic(&timer1, 50);
    try std.testing.expectEqual(false, timer_module.run());

    timer_module.increment_current_time(49);
    try std.testing.expectEqual(false, timer_module.run());

    timer_module.increment_current_time(1);
    try std.testing.expectEqual(true, timer_module.run());
    try std.testing.expectEqual(1, local_ctx);
}

test "multiple periodics" {
    var timer_module = TimerModule.init();

    var local_ctx1: u32 = 0;
    var local_ctx2: u32 = 0;
    var timer1 = Timer.init(&local_ctx1, timer_callback);
    var timer2 = Timer.init(&local_ctx2, timer_callback);

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
    var timer1 = Timer.init(&local_ctx1, timer_callback);
    var timer2 = Timer.init(&local_ctx2, timer_callback);
    var timer3 = Timer.init(&local_ctx3, timer_callback);

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
