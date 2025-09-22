//! Timer Module and associated typedefs
//! A Timer Module supports:
//! - Starting/Stopping
//! - Periodic Execution
//! - One-shot Execution
//! NOTE: Pausing/Resuming must be implemented by the caller

const std = @import("std");

/// A tick is typically 1 millisecond. Can be longer. Smaller values aren't practical.
pub const Ticks = u32;

pub const Timer = struct {
    // TODO: Swap out `expiration` and `period` with these:
    // data: TimerData,
    // info: packed struct {
    //     /// 0 means one-shot
    //     period: std.meta.Int(.unsigned, @bitSizeOf(Ticks) - 1) = undefined,
    //     is_paused: 1,
    // },
    expiration: Ticks = undefined,
    /// 0 means one-shot
    period: Ticks = undefined,
    ctx: ?*anyopaque = null,
    callback: ?TimerCallback = null,
    node: std.SinglyLinkedList.Node = .{},

    /// This allows for differentiating between expired timers and max duration timers
    /// while not compromising heavily on longest timer length by cutting range in half.
    /// std.math.maxInt(u16) is ~65 seconds. If your system fails to service a timer in
    /// this amount of time then you have WAY larger problems than a dead-locked `TimerModule`.
    pub const longest_delay_before_servicing_timer = std.math.maxInt(u16);
    /// Max `Timer` length when taking into account disambiguation restriction
    pub const max_ticks: Ticks = std.math.maxInt(Ticks) - longest_delay_before_servicing_timer;
    // const TimerData = union {
    //     expiration: Ticks,
    //     remaining_ticks_for_paused_timer: Ticks,
    // };
    const TimerCallback = *const fn (ctx: ?*anyopaque, _timer_module: *TimerModule, _timer: *Timer) void;
};

pub const TimerModule = struct {
    current_time: Ticks = 0,
    timers: std.SinglyLinkedList = .{},

    /// Services the callbacks for a single expired timer
    /// Returns `true` if a `Timer` expired, otherwise returns `false`
    pub fn run(self: *TimerModule) bool {
        const time_at_start_of_rtc = self.safely_get_current_time();

        if (self.timers.first) |next_expiring| {
            var timer: *Timer = @fieldParentPtr("node", next_expiring);

            // Expired timers will have a `distance` in the range of [0, longest_delay_before_servicing_timer]
            // This calculation loops over from `std.math.maxInt(Ticks)` to 0.
            const distance = time_at_start_of_rtc -% timer.expiration;
            const timer_is_expired = distance <= Timer.longest_delay_before_servicing_timer;

            if (timer_is_expired) {
                const _callback = timer.callback;
                timer.callback = null;
                _callback.?(timer.ctx, self, timer);
                if (timer.callback == null) {
                    // Timer was not manually restarted during the callback, thus
                    // it should be at the front of the list and we just need to remove/restart it
                    const front_node = self.timers.popFirst().?;
                    if (timer.period != 0) {
                        std.debug.assert(front_node == next_expiring);
                        self.insert_timer(timer, timer.period);
                        timer.callback = _callback; // Don't forget to restore the callback!
                    }
                }
                return true; // Only perform one timer callback per RTC
            }
            return false; // Timer at head of list is not expired
        }
        return false; // List was empty
    }

    /// Starts a timer that is removed after it expires
    pub fn start_one_shot(self: *TimerModule, timer: *Timer, duration: Ticks, ctx: ?*anyopaque, callback: Timer.TimerCallback) void {
        if (timer.callback != null) {
            self.remove_timer(timer);
        }

        std.debug.assert(duration <= Timer.max_ticks);
        timer.ctx = ctx;
        timer.callback = callback;
        timer.period = 0;

        self.insert_timer(timer, duration);
    }

    /// Starts a periodic timer, with first expiration set to current time + period
    pub fn start_periodic(self: *TimerModule, timer: *Timer, period: Ticks, ctx: ?*anyopaque, callback: Timer.TimerCallback) void {
        @call(.always_inline, start_periodic_delayed, .{ self, timer, period, period, ctx, callback });
    }

    /// Starts a periodic timer with a custom delay for the first expiration
    /// NOTE: an `initial_delay` of 0 does not immediately run the callback TODO: maybe it should/could?
    pub fn start_periodic_delayed(
        self: *TimerModule,
        timer: *Timer,
        period: Ticks,
        initial_delay: Ticks,
        ctx: ?*anyopaque,
        callback: Timer.TimerCallback,
    ) void {
        if (timer.callback != null) {
            self.remove_timer(timer);
        }

        std.debug.assert(initial_delay <= Timer.max_ticks);
        std.debug.assert(period <= Timer.max_ticks);
        std.debug.assert(period != 0);
        timer.ctx = ctx;
        timer.callback = callback;
        timer.period = period;

        self.insert_timer(timer, initial_delay);
    }

    /// Stops a timer
    pub fn stop(self: *TimerModule, timer: *Timer) void {
        timer.period = 0;
        if (timer.callback != null) {
            self.remove_timer(timer);
        }
    }

    fn remaining_ticks(timer: *Timer, current_time: Ticks) Ticks {
        if ((timer.expiration -% current_time) < Timer.longest_delay_before_servicing_timer) {
            const duration = timer.expiration -% current_time;
            return duration;
        } else {
            return 0;
        }
    }

    /// Inserts a timer after all other timers with equal or less remaining ticks
    /// Inserting after timers with equal remaining ticks improves fairness
    fn insert_timer(self: *TimerModule, timer: *Timer, ticks: Ticks) void {
        std.debug.assert(ticks <= Timer.max_ticks);

        const current_time = self.safely_get_current_time();
        timer.expiration = current_time +% ticks;

        if (self.timers.first) |head| {
            const head_timer: *Timer = @fieldParentPtr("node", head);
            const head_remaining_ticks = remaining_ticks(head_timer, current_time);

            if (ticks < head_remaining_ticks) {
                self.timers.prepend(&timer.node);
            } else {
                var node_to_insert_after = head;
                while (node_to_insert_after.next) |next| {
                    const _timer: *Timer = @fieldParentPtr("node", next);
                    const next_remaining_ticks = remaining_ticks(_timer, current_time);
                    if (next_remaining_ticks <= ticks) {
                        node_to_insert_after = next;
                    } else {
                        break;
                    }
                }
                node_to_insert_after.insertAfter(&timer.node);
            }
        } else {
            // Empty list.
            self.timers.prepend(&timer.node);
        }
    }

    /// If this is called, a timer MUST be in the list
    fn remove_timer(self: *TimerModule, timer: *Timer) void {
        self.timers.remove(&timer.node);
        timer.callback = null;
    }

    /// Called in the interrupt context, this can happen while a call to `run` is happening.
    pub fn increment_current_time(self: *TimerModule, ticks_to_increment_by: Ticks) void {
        // TODO: See if this works. Or try @atomicStore
        // @atomicRmw(Ticks, &self.current_time, .Add, ticks_to_increment_by, .monotonic);
        self.current_time +%= ticks_to_increment_by;
    }

    /// Repeatedly reads the current_time until two consecutive reads are identical
    fn safely_get_current_time(self: *TimerModule) Ticks {
        var current_time = self.current_time;
        while (current_time != self.current_time) {
            // TODO: Make sure this doesn't get optimized out
            current_time = self.current_time;
        }
        return current_time;
    }
};
