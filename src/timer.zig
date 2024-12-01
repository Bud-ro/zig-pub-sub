//! Timer Module and associated typedefs
//! A Timer Module supports:
//! - Starting/Stopping
//! - Pausing/Resuming
//! - Periodic Execution
//! - One-shot Execution

const std = @import("std");

/// u64 so we never have to deal with wrap around, even if you're defining 1 tick = 1 microsecond/nanosecond
pub const Ticks = u64;

pub const Timer = struct {
    /// An expiration time of `std.math.maxInt(Ticks)` is used to denote that the timer never expires.
    /// This is compatible with both an array/SoA of timers approach as well as linked lists.
    /// Linked lists have the benefit of being able to remove the timer from the linked list though
    expiration: Ticks,
    /// 0 means one-shot
    period: Ticks,
    ctx: *anyopaque,
    callback: *const fn (ctx: *anyopaque) void,
};

pub const TimerModule = struct {
    current_time: Ticks,

    pub fn init() TimerModule {
        // TODO: Pass in a comptime known parameter for max number of timers
        // after struct of array timers are implemented
        const timer_module = TimerModule{ .current_time = 0 };
        return timer_module;
    }

    /// Services the callbacks for a single expired timer
    /// Returns `true` if a `Timer` expired, otherwise returns `false`
    pub fn run(self: *TimerModule) bool {
        _ = self;
    }

    /// Called in the interrupt context, this can happen while a call to `run` is happening.
    pub fn increment_current_time(self: *TimerModule, ticks_to_increment_by: Ticks) void {
        // TODO: See if this works. Or try @atomicStore
        // @atomicRmw(Ticks, &self.current_time, .Add, ticks_to_increment_by, .monotonic);
        self.current_time += ticks_to_increment_by;
    }
};
