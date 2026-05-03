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
const timer = @import("erd_core").timer;
const Timer = timer.Timer;
const TimerModule = timer.TimerModule;

/// Throughput and latency measurement results for the timer module.
pub const StatMeasurement = struct {
    average_throughput_per_tick: u32,
    maximum_throughput_per_tick: u32,
    average_latency: timer.Ticks,
    maximum_latency: timer.Ticks,
};

/// Measures timer module throughput and latency by occupying the CPU with a 0-tick timer.
pub fn TimerModuleStats(comptime SystemDataType: type) type {
    return struct {
        const Self = @This();

        system_data: *SystemDataType,
        timer_module: *TimerModule,
        throughput_timer: Timer,
        save_measurement_timer: Timer,
        current_throughput: u32,
        highest_latency_this_tick: timer.Ticks,
        enable_erd_idx: u16,
        output_erd_idx: u16,

        fn saveMeasurement(ctx: ?*anyopaque, _: *TimerModule, _: *Timer) void {
            const self: *Self = @ptrCast(@alignCast(ctx));

            var current_stats: StatMeasurement = undefined;
            self.system_data.runtimeRead(self.output_erd_idx, &current_stats);

            const updated_stats = StatMeasurement{
                .average_throughput_per_tick = (current_stats.average_throughput_per_tick + self.current_throughput) / 2, // Effectively an EWMA
                .maximum_throughput_per_tick = @max(current_stats.maximum_throughput_per_tick, self.current_throughput),
                .average_latency = (current_stats.average_latency + self.highest_latency_this_tick) / 2, // Effectively an EWMA
                .maximum_latency = @max(current_stats.maximum_latency, self.highest_latency_this_tick),
            };
            self.system_data.runtimeWrite(self.output_erd_idx, &updated_stats);

            self.current_throughput = 0;
            self.highest_latency_this_tick = 0;
        }

        fn measureThroughput(ctx: ?*anyopaque, timer_module: *TimerModule, _: *Timer) void {
            const self: *Self = @ptrCast(@alignCast(ctx));

            self.current_throughput += 1;
            const latency = timer_module.ticksSinceLastStarted(&self.throughput_timer);
            self.highest_latency_this_tick = @max(latency, self.highest_latency_this_tick);
        }

        fn onEnableChange(ctx: ?*anyopaque, _args: ?*const anyopaque, publisher: *anyopaque) void {
            const args: *const SystemDataType.OnChangeArgs = @ptrCast(@alignCast(_args.?));
            var system_data: *SystemDataType = @ptrCast(@alignCast(publisher));
            const self: *Self = @ptrCast(@alignCast(ctx));
            const is_enabled: *const bool = @ptrCast(args.data);

            if (is_enabled.*) {
                self.current_throughput = 0;
                self.highest_latency_this_tick = 0;

                const clear_stats = std.mem.zeroes(StatMeasurement);
                system_data.runtimeWrite(self.output_erd_idx, &clear_stats);

                self.timer_module.startPeriodic(&self.throughput_timer, 0, self, measureThroughput);
                self.timer_module.startPeriodic(&self.save_measurement_timer, 1, self, saveMeasurement);
            } else {
                self.timer_module.stop(&self.throughput_timer);
                self.timer_module.stop(&self.save_measurement_timer);
            }
        }

        // TODO: runtime_subscribe
        fn innerInit(
            self: *Self,
            system_data: *SystemDataType,
            timer_module: *TimerModule,
            enable_erd_idx: u16,
            output_erd_idx: u16,
        ) void {
            self.system_data = system_data;
            self.timer_module = timer_module;
            self.enable_erd_idx = enable_erd_idx;
            self.output_erd_idx = output_erd_idx;

            var is_enabled: bool = undefined;
            system_data.runtimeRead(enable_erd_idx, &is_enabled);

            const init_data: SystemDataType.OnChangeArgs = .{ .data = &is_enabled, .system_data_idx = enable_erd_idx };
            onEnableChange(self, &init_data, system_data);
        }

        /// Initialize the stats module and wire up the enable ERD subscription.
        pub fn init(
            self: *Self,
            system_data: *SystemDataType,
            timer_module: *TimerModule,
            comptime enable_erd: SystemDataType.ErdEnumType,
            comptime output_erd: SystemDataType.ErdEnumType,
        ) void {
            comptime {
                std.debug.assert(SystemDataType.erdFromEnum(enable_erd).T == bool);
                std.debug.assert(SystemDataType.erdFromEnum(output_erd).T == StatMeasurement);
            }

            system_data.subscribe(enable_erd, self, onEnableChange);

            self.innerInit(
                system_data,
                timer_module,
                SystemDataType.erdFromEnum(enable_erd).system_data_idx,
                SystemDataType.erdFromEnum(output_erd).system_data_idx,
            );
        }
    };
}

const erd_core = @import("erd_core");
const Erd = erd_core.Erd;
const SystemDataTestDouble = erd_core.testing.SystemDataTestDouble;

const TestSystem = SystemDataTestDouble.create(struct {
    enable: Erd = SystemDataTestDouble.ramErd(bool, .{ .subs = 1 }),
    stats: Erd = SystemDataTestDouble.ramErd(StatMeasurement, .{}),
});
const TestSystemData = TestSystem.SystemData;
const TestTimerModuleStats = TimerModuleStats(TestSystemData);

test "does nothing if disabled" {
    var system_data: TestSystemData = TestSystem.init();
    var timer_module: TimerModule = .{};
    var instance: TestTimerModuleStats = undefined;

    instance.init(&system_data, &timer_module, .enable, .stats);
    timer_module.incrementCurrentTime(1);
    try std.testing.expect(!timer_module.run());
}

test "stats are initialized to zero if enabled" {
    var system_data: TestSystemData = TestSystem.init();
    var timer_module: TimerModule = .{};
    var instance: TestTimerModuleStats = undefined;

    const initial_stats: StatMeasurement = .{ .average_latency = 5, .average_throughput_per_tick = 3, .maximum_latency = 1, .maximum_throughput_per_tick = 11 };
    system_data.write(.stats, initial_stats);
    instance.init(&system_data, &timer_module, .enable, .stats);

    try std.testing.expectEqual(initial_stats, system_data.read(.stats));
    system_data.write(.enable, true);
    try std.testing.expectEqual(std.mem.zeroes(StatMeasurement), system_data.read(.stats));
}

test "throughput is measured" {
    var system_data: TestSystemData = TestSystem.init();
    var timer_module: TimerModule = .{};
    var instance: TestTimerModuleStats = undefined;

    system_data.write(.enable, true);
    instance.init(&system_data, &timer_module, .enable, .stats);

    for (0..99) |_| {
        try std.testing.expect(timer_module.run());
    }
    try std.testing.expectEqual(std.mem.zeroes(StatMeasurement), system_data.read(.stats));

    timer_module.incrementCurrentTime(1);
    try std.testing.expect(timer_module.run());
    try std.testing.expectEqual(std.mem.zeroes(StatMeasurement), system_data.read(.stats));

    try std.testing.expect(timer_module.run());
    try std.testing.expectEqual(50, system_data.read(.stats).average_throughput_per_tick);
    try std.testing.expectEqual(100, system_data.read(.stats).maximum_throughput_per_tick);

    for (0..98) |_| {
        try std.testing.expect(timer_module.run());
    }

    timer_module.incrementCurrentTime(1);
    try std.testing.expect(timer_module.run());
    try std.testing.expect(timer_module.run());
    try std.testing.expectEqual(74, system_data.read(.stats).average_throughput_per_tick);
    try std.testing.expectEqual(100, system_data.read(.stats).maximum_throughput_per_tick);

    for (0..100) |_| {
        try std.testing.expect(timer_module.run());
    }

    timer_module.incrementCurrentTime(1);
    try std.testing.expect(timer_module.run());
    try std.testing.expect(timer_module.run());
    try std.testing.expectEqual(87, system_data.read(.stats).average_throughput_per_tick);
    try std.testing.expectEqual(101, system_data.read(.stats).maximum_throughput_per_tick);
}

test "latency is measured" {
    var system_data: TestSystemData = TestSystem.init();
    var timer_module: TimerModule = .{};
    var instance: TestTimerModuleStats = undefined;

    system_data.write(.enable, true);
    instance.init(&system_data, &timer_module, .enable, .stats);

    try std.testing.expectEqual(std.mem.zeroes(StatMeasurement), system_data.read(.stats));

    for (0..10) |_| {
        timer_module.incrementCurrentTime(1);
        try std.testing.expect(timer_module.run());
        try std.testing.expect(timer_module.run());
        try std.testing.expectEqual(0, system_data.read(.stats).average_latency);
        try std.testing.expectEqual(1, system_data.read(.stats).maximum_latency);
    }

    timer_module.incrementCurrentTime(10);
    try std.testing.expect(timer_module.run());
    try std.testing.expect(timer_module.run());
    try std.testing.expectEqual(5, system_data.read(.stats).average_latency);
    try std.testing.expectEqual(10, system_data.read(.stats).maximum_latency);

    timer_module.incrementCurrentTime(10);
    try std.testing.expect(timer_module.run());
    try std.testing.expect(timer_module.run());
    try std.testing.expectEqual(7, system_data.read(.stats).average_latency);
    try std.testing.expectEqual(10, system_data.read(.stats).maximum_latency);

    timer_module.incrementCurrentTime(10);
    try std.testing.expect(timer_module.run());
    try std.testing.expect(timer_module.run());
    try std.testing.expectEqual(8, system_data.read(.stats).average_latency);
    try std.testing.expectEqual(10, system_data.read(.stats).maximum_latency);

    timer_module.incrementCurrentTime(10);
    try std.testing.expect(timer_module.run());
    try std.testing.expect(timer_module.run());
    try std.testing.expectEqual(9, system_data.read(.stats).average_latency);
    try std.testing.expectEqual(10, system_data.read(.stats).maximum_latency);

    timer_module.incrementCurrentTime(10);
    try std.testing.expect(timer_module.run());
    try std.testing.expect(timer_module.run());
    try std.testing.expectEqual(9, system_data.read(.stats).average_latency);
    try std.testing.expectEqual(10, system_data.read(.stats).maximum_latency);
}
