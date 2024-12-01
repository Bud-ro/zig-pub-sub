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
    expiration: Ticks = undefined,
    /// 0 means one-shot
    period: Ticks = undefined,
    ctx: *anyopaque,
    callback: *const fn (ctx: *anyopaque) void,
    next_timer: ?*Timer = null,

    pub fn init(context: *anyopaque, callback: *const fn (ctx: *anyopaque) void) Timer {
        const this = Timer{ .ctx = context, .callback = callback };
        return this;
    }
};

pub const TimerModule = struct {
    current_time: Ticks,
    /// `timers` is a singly linked list
    timers: ?*Timer,

    pub fn init() TimerModule {
        // TODO: Pass in a comptime known parameter for max number of timers
        // after struct of array timers are implemented
        const timer_module = TimerModule{ .current_time = 0, .timers = null };
        return timer_module;
    }

    /// Services the callbacks for a single expired timer
    /// Returns `true` if a `Timer` expired, otherwise returns `false`
    pub fn run(self: *TimerModule) bool {
        var current_timer = self.timers;
        while (current_timer) |timer| {
            // TODO: Will we ever have issues if an interrupt increments self.current_time
            // but we're in the middle of reading it?
            //
            // TODO: Try an `@atomicLoad`?
            if (timer.expiration <= self.current_time) {
                timer.callback(timer.ctx);
                if (timer.period != 0) {
                    const new_time = self.current_time; // TODO: Do we need volatile or something like that here?
                    timer.expiration = new_time + timer.period; // Start the new timer
                    // Shift the timer to where it will expire after everything
                    self.remove_timer(timer);
                    self.insert_timer(timer);
                } else {
                    self.remove_timer(timer);
                }
                return true; // Only perform one timer callback per RTC
            }
            current_timer = timer.next_timer;
        }
        return false;
    }

    pub fn start_one_shot(self: *TimerModule, timer: *Timer, duration: Ticks) void {
        timer.*.expiration = self.current_time + duration;
        timer.*.period = 0;

        self.insert_timer(timer);
    }

    pub fn start_periodic(self: *TimerModule, timer: *Timer, period: Ticks) void {
        timer.*.expiration = self.current_time + period;
        timer.*.period = period;

        self.insert_timer(timer);
    }

    fn insert_timer(self: *TimerModule, timer: *Timer) void {
        if (self.timers) |list_head| {
            // Insert after timers with equal or less expiration time.
            var timer_to_insert_after: *Timer = list_head;
            while (timer_to_insert_after.next_timer) |next| {
                if (next.expiration <= timer.expiration) {
                    timer_to_insert_after = next;
                } else {
                    break;
                }
            }
            timer.next_timer = timer_to_insert_after.next_timer;
            timer_to_insert_after.*.next_timer = timer;
        } else {
            // Empty list.
            self.timers = timer;
            timer.next_timer = null; // TODO: Remove this
        }
    }

    fn remove_timer(self: *TimerModule, timer: *Timer) void {
        if (self.timers) |list_head| {
            if (list_head == timer) {
                self.timers = list_head.next_timer;
                timer.next_timer = null;
                return;
            }

            var node: *Timer = list_head;
            while (node.next_timer) |next| {
                if (next == timer) {
                    node.next_timer = next.next_timer;
                    timer.*.next_timer = null;
                    break;
                }
            }
        } else {
            // Empty list
            // This is a bug
            unreachable;
        }
    }

    /// Called in the interrupt context, this can happen while a call to `run` is happening.
    pub fn increment_current_time(self: *TimerModule, ticks_to_increment_by: Ticks) void {
        // TODO: See if this works. Or try @atomicStore
        // @atomicRmw(Ticks, &self.current_time, .Add, ticks_to_increment_by, .monotonic);
        self.current_time += ticks_to_increment_by;
    }
};
