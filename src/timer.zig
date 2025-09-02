//! Timer Module and associated typedefs
//! A Timer Module supports:
//! - Starting/Stopping
//! - Periodic Execution
//! - One-shot Execution
//! NOTE: Pausing/Resuming must be implemented by the caller

const std = @import("std");

/// u64 so we never have to deal with wrap around, even if you're defining 1 tick = 1 microsecond/nanosecond
pub const Ticks = u64;

pub const Timer = struct {
    /// The tick at which this timer expires. This has the benefit of not requiring us to
    /// Current code ignores wrap around by using u64, TODO: Fix that.
    expiration: Ticks = undefined,
    /// 0 means one-shot
    period: Ticks = undefined,
    ctx: ?*anyopaque = null,
    callback: ?TimerCallback = null,
    node: std.SinglyLinkedList.Node = .{},

    const TimerCallback = *const fn (ctx: ?*anyopaque, _timer_module: *TimerModule, _timer: *Timer) void;
};

pub const TimerModule = struct {
    current_time: Ticks = 0,
    timers: std.SinglyLinkedList = .{},

    /// Services the callbacks for a single expired timer
    /// Returns `true` if a `Timer` expired, otherwise returns `false`
    pub fn run(self: *TimerModule) bool {
        var current_timer_node = self.timers.first;
        while (current_timer_node) |node| {
            var timer: *Timer = @fieldParentPtr("node", node);
            // TODO: Will we ever have issues if an interrupt increments self.current_time
            // but we're in the middle of reading it?
            //
            // TODO: Do the consecutive read trick
            if (timer.expiration <= self.current_time) {
                timer.callback.?(timer.ctx, self, timer);
                if (timer.callback != null) { // Timer was not stopped during the callback
                    if (timer.period != 0) { // Periodic timer
                        timer.expiration = self.current_time + timer.period;
                        const front_node = self.timers.popFirst().?;
                        std.debug.assert(front_node == node);
                        self.insert_timer(timer);
                    } else if (timer.expiration > self.current_time) {
                        // One-shot started, do nothing
                        // TODO: This does NOT work if the one-shot restarted is a 0 tick, but that also seems problematic
                        // so do we need to handle that case?
                    } else {
                        self.remove_timer(timer);
                    }
                }
                return true; // Only perform one timer callback per RTC
            }
            current_timer_node = node.next;
        }

        return false; // List was empty
    }

    /// Starts a timer that is removed after it expires
    pub fn start_one_shot(self: *TimerModule, timer: *Timer, duration: Ticks, ctx: ?*anyopaque, callback: Timer.TimerCallback) void {
        if (timer.callback != null) {
            self.remove_timer(timer);
        }

        timer.ctx = ctx;
        timer.callback = callback;
        timer.expiration = self.current_time + duration;
        timer.period = 0;

        self.insert_timer(timer);
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

        std.debug.assert(period != 0);
        timer.ctx = ctx;
        timer.callback = callback;
        timer.expiration = self.current_time + initial_delay;
        timer.period = period;

        self.insert_timer(timer);
    }

    /// Stops a timer
    pub fn stop(self: *TimerModule, timer: *Timer) void {
        if (timer.callback != null) {
            self.remove_timer(timer);
        }
    }

    /// Inserts a timer after all other timers with equal or less remaining ticks
    /// Inserting after timers with equal remaining ticks improves fairness
    fn insert_timer(self: *TimerModule, timer: *Timer) void {
        if (self.timers.first) |head| {
            const head_timer: *Timer = @fieldParentPtr("node", head);
            if (timer.expiration < head_timer.expiration) {
                self.timers.prepend(&timer.node);
            } else {
                var node_to_insert_after = head;
                while (node_to_insert_after.next) |next| {
                    const _timer: *Timer = @fieldParentPtr("node", next);
                    if (_timer.expiration <= timer.expiration) {
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
        self.current_time += ticks_to_increment_by;
    }
};
