//! Measures the throughput and latency of your TimerModule by fully occupying the CPU.
//! A periodic 0-tick `Timer` is repeatedly run when `enable_erd` is `true`, and each
//! run increments a counter and keeps track of the worst latency that tick. Every 1 tick
//! the counter is reset and all stats are updated. Stats are written into `output_erd` every tick.
//!
//! Ideal stats are:
//! `average_throughput_per_tick` & `maximum_throughput_per_tick` = infinity
//!   - If you're doing absolutely nothing you might get 1/10th of your clock frequency.
//! `average_latency` = 0
//! `maximum_latency` = 1

const std = @import("std");
const SystemData = @import("../system_data.zig");
const SystemErds = @import("../system_erds.zig");
const Erd = @import("../erd.zig");
const timer = @import("../timer.zig");
const Timer = timer.Timer;
const TimerModule = timer.TimerModule;

const TimerModuleStats = @This();

pub const StatMeasurement = struct {
    average_throughput_per_tick: u32,
    maximum_throughput_per_tick: u32,
    average_latency: timer.Ticks,
    maximum_latency: timer.Ticks,
};

system_data: *SystemData,
timer_module: *TimerModule,
throughput_timer: Timer,
save_measurement_timer: Timer,
current_throughput: u32,
highest_latency_this_tick: timer.Ticks,
enable_erd_idx: u16,
output_erd_idx: u16,

fn save_measurement(ctx: ?*anyopaque, _: *TimerModule, _: *Timer) void {
    const self: *TimerModuleStats = @ptrCast(@alignCast(ctx));

    var current_stats: StatMeasurement = undefined;
    self.system_data.runtime_read(self.output_erd_idx, &current_stats);

    const updated_stats = StatMeasurement{
        .average_throughput_per_tick = (current_stats.average_throughput_per_tick + self.current_throughput) / 2, // Effectively an EWMA
        .maximum_throughput_per_tick = @max(current_stats.maximum_throughput_per_tick, self.current_throughput),
        .average_latency = (current_stats.average_latency + self.highest_latency_this_tick) / 2, // Effectively an EWMA
        .maximum_latency = @max(current_stats.maximum_latency, self.highest_latency_this_tick),
    };
    self.system_data.runtime_write(self.output_erd_idx, &updated_stats);

    self.current_throughput = 0;
    self.highest_latency_this_tick = 0;
}

fn measure_throughput(ctx: ?*anyopaque, timer_module: *TimerModule, _: *Timer) void {
    const self: *TimerModuleStats = @ptrCast(@alignCast(ctx));

    self.current_throughput += 1;
    const latency = timer_module.ticks_since_last_started(&self.throughput_timer);
    self.highest_latency_this_tick = @max(latency, self.highest_latency_this_tick);
}

fn on_enable_change(ctx: ?*anyopaque, args: *const SystemData.OnChangeArgs, system_data: *SystemData) void {
    const self: *TimerModuleStats = @ptrCast(@alignCast(ctx));
    const is_enabled: *const bool = @ptrCast(args.data);

    if (is_enabled.*) {
        self.current_throughput = 0;
        self.highest_latency_this_tick = 0;

        const clear_stats = std.mem.zeroes(StatMeasurement);
        system_data.runtime_write(self.output_erd_idx, &clear_stats);

        self.timer_module.start_periodic(&self.throughput_timer, 0, self, measure_throughput);
        self.timer_module.start_periodic(&self.save_measurement_timer, 1, self, save_measurement);
    } else {
        self.timer_module.stop(&self.throughput_timer);
        self.timer_module.stop(&self.save_measurement_timer);
    }
}

// TODO: runtime_subscribe
// Inner init is here to make an attempt at forcing call-sites to not inline all of this code.
// It feels more likely because of the `comptime` arguments.
fn inner_init(
    self: *TimerModuleStats,
    system_data: *SystemData,
    timer_module: *TimerModule,
    enable_erd_idx: u16,
    output_erd_idx: u16,
) void {
    self.system_data = system_data;
    self.timer_module = timer_module;
    self.enable_erd_idx = enable_erd_idx;
    self.output_erd_idx = output_erd_idx;

    var is_enabled: bool = undefined;
    system_data.runtime_read(enable_erd_idx, &is_enabled);

    const init_data: SystemData.OnChangeArgs = .{ .data = &is_enabled, .system_data_idx = enable_erd_idx };
    on_enable_change(self, &init_data, system_data);
}

pub fn init(
    self: *TimerModuleStats,
    system_data: *SystemData,
    timer_module: *TimerModule,
    comptime enable_erd: SystemErds.ErdEnum,
    comptime output_erd: SystemErds.ErdEnum,
) void {
    comptime {
        std.debug.assert(SystemErds.erd_from_enum(enable_erd).T == bool);
        std.debug.assert(SystemErds.erd_from_enum(output_erd).T == StatMeasurement);
    }

    system_data.subscribe(enable_erd, self, on_enable_change);

    self.inner_init(
        system_data,
        timer_module,
        SystemErds.erd_from_enum(enable_erd).system_data_idx,
        SystemErds.erd_from_enum(output_erd).system_data_idx,
    );
}

test "does nothing if disabled" {
    var system_data: SystemData = .init();
    var timer_module: TimerModule = .{};
    var instance: TimerModuleStats = undefined;

    instance.init(&system_data, &timer_module, .erd_some_bool, .erd_timer_stats);
    timer_module.increment_current_time(1);
    try std.testing.expect(!timer_module.run());
}

test "stats are initialized to zero if enabled" {
    var system_data: SystemData = .init();
    var timer_module: TimerModule = .{};
    var instance: TimerModuleStats = undefined;

    const initial_stats: StatMeasurement = .{ .average_latency = 5, .average_throughput_per_tick = 3, .maximum_latency = 1, .maximum_throughput_per_tick = 11 };
    system_data.write(.erd_timer_stats, initial_stats);
    instance.init(&system_data, &timer_module, .erd_some_bool, .erd_timer_stats);

    try std.testing.expectEqual(initial_stats, system_data.read(.erd_timer_stats));
    system_data.write(.erd_some_bool, true);
    try std.testing.expectEqual(std.mem.zeroes(StatMeasurement), system_data.read(.erd_timer_stats));
}

test "throughput is measured" {
    var system_data: SystemData = .init();
    var timer_module: TimerModule = .{};
    var instance: TimerModuleStats = undefined;

    system_data.write(.erd_some_bool, true);
    instance.init(&system_data, &timer_module, .erd_some_bool, .erd_timer_stats);

    for (0..99) |_| {
        try std.testing.expect(timer_module.run());
    }
    try std.testing.expectEqual(std.mem.zeroes(StatMeasurement), system_data.read(.erd_timer_stats));

    timer_module.increment_current_time(1);
    try std.testing.expect(timer_module.run());
    try std.testing.expectEqual(std.mem.zeroes(StatMeasurement), system_data.read(.erd_timer_stats));

    try std.testing.expect(timer_module.run());
    try std.testing.expectEqual(50, system_data.read(.erd_timer_stats).average_throughput_per_tick);
    try std.testing.expectEqual(100, system_data.read(.erd_timer_stats).maximum_throughput_per_tick);

    for (0..98) |_| {
        try std.testing.expect(timer_module.run());
    }

    timer_module.increment_current_time(1);
    try std.testing.expect(timer_module.run());
    try std.testing.expect(timer_module.run());
    try std.testing.expectEqual(74, system_data.read(.erd_timer_stats).average_throughput_per_tick);
    try std.testing.expectEqual(100, system_data.read(.erd_timer_stats).maximum_throughput_per_tick);

    for (0..100) |_| {
        try std.testing.expect(timer_module.run());
    }

    timer_module.increment_current_time(1);
    try std.testing.expect(timer_module.run());
    try std.testing.expect(timer_module.run());
    try std.testing.expectEqual(87, system_data.read(.erd_timer_stats).average_throughput_per_tick);
    try std.testing.expectEqual(101, system_data.read(.erd_timer_stats).maximum_throughput_per_tick);
}

test "latency is measured" {
    var system_data: SystemData = .init();
    var timer_module: TimerModule = .{};
    var instance: TimerModuleStats = undefined;

    system_data.write(.erd_some_bool, true);
    instance.init(&system_data, &timer_module, .erd_some_bool, .erd_timer_stats);

    try std.testing.expectEqual(std.mem.zeroes(StatMeasurement), system_data.read(.erd_timer_stats));

    for (0..10) |_| {
        timer_module.increment_current_time(1);
        try std.testing.expect(timer_module.run());
        try std.testing.expect(timer_module.run());
        try std.testing.expectEqual(0, system_data.read(.erd_timer_stats).average_latency);
        try std.testing.expectEqual(1, system_data.read(.erd_timer_stats).maximum_latency);
    }

    timer_module.increment_current_time(10);
    try std.testing.expect(timer_module.run());
    try std.testing.expect(timer_module.run());
    try std.testing.expectEqual(5, system_data.read(.erd_timer_stats).average_latency);
    try std.testing.expectEqual(10, system_data.read(.erd_timer_stats).maximum_latency);

    timer_module.increment_current_time(10);
    try std.testing.expect(timer_module.run());
    try std.testing.expect(timer_module.run());
    try std.testing.expectEqual(7, system_data.read(.erd_timer_stats).average_latency);
    try std.testing.expectEqual(10, system_data.read(.erd_timer_stats).maximum_latency);

    timer_module.increment_current_time(10);
    try std.testing.expect(timer_module.run());
    try std.testing.expect(timer_module.run());
    try std.testing.expectEqual(8, system_data.read(.erd_timer_stats).average_latency);
    try std.testing.expectEqual(10, system_data.read(.erd_timer_stats).maximum_latency);

    timer_module.increment_current_time(10);
    try std.testing.expect(timer_module.run());
    try std.testing.expect(timer_module.run());
    try std.testing.expectEqual(9, system_data.read(.erd_timer_stats).average_latency);
    try std.testing.expectEqual(10, system_data.read(.erd_timer_stats).maximum_latency);

    timer_module.increment_current_time(10);
    try std.testing.expect(timer_module.run());
    try std.testing.expect(timer_module.run());
    try std.testing.expectEqual(9, system_data.read(.erd_timer_stats).average_latency);
    try std.testing.expectEqual(10, system_data.read(.erd_timer_stats).maximum_latency);
}
