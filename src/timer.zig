//! Timer Module and associated typedefs
//! A Timer Module supports:
//! - Starting/Stopping
//! - Pausing/Unpausing
//! - Periodic Execution
//! - One-shot Execution

const std = @import("std");

/// A tick is typically 1 millisecond. Can be longer. Smaller values aren't practical.
pub const Ticks = u32;

// TODO: Looks like we need to gain 1 bit of information (and delete `start_periodic_delayed`) if we want
// to support `timer_module.elapsed_ticks()`. This is because we can use `period` to calculate elapsed ticks
// with `timer.period - remaining_ticks(&timer)`, but for one-shots or for a one-shot we can use those `period`
// bits to store the one-shot "period", allowing us to again do `timer.duration - remaining_ticks(&timer)`
// (duration is an alias for period)
//
// Deleting `start_periodic_delayed` also isn't strictly necessary if we switch to storing a `start_ticks`
// and simply derive `period` from `expiration - start_ticks`.

// We can do that by storing `is_periodic: bool` on a pointer that MUST be at least align(2).
// I'd rather not do that on `node` since then I'd have to write a whole linked list (and suffer from slower code).
// So the remaining options are:
// - Rely on the linker and somehow enforce `TimerCallback` to be align(2). Would be pretty clever if that was possible.
// - Force align(2) onto `ctx`.
// - Suck it up and write a linked list
// The first one is awful and impossible, the 2nd is doable but will occasionally confuse users,
// The 3rd doesn't impose anything on the outside world, but it's decently slower

pub const Timer = struct {
    timer_data: TimerData = undefined,
    /// 0 means one-shot
    period: Ticks = undefined,
    ctx: ?*align(2) anyopaque = null,
    callback: ?TimerCallback = null,
    node: std.SinglyLinkedList.Node = .{},

    pub const TimerData = union {
        /// The tick at which the timer expires
        expiration: Ticks,
        /// If the timer is in paused_timers, the number of remaining ticks
        remaining_ticks_if_paused: Ticks,
    };

    /// This allows for differentiating between expired timers and max duration timers
    /// while not compromising heavily on longest timer length by cutting range in half.
    /// std.math.maxInt(u16) is ~65 seconds. If your system fails to service a timer in
    /// this amount of time then you have WAY larger problems than a dead-locked `TimerModule`.
    pub const longest_delay_before_servicing_timer = std.math.maxInt(u16);
    /// Max `Timer` length when taking into account disambiguation restriction
    pub const max_ticks: Ticks = std.math.maxInt(Ticks) - longest_delay_before_servicing_timer;
    const TimerCallback = *const fn (ctx: ?*anyopaque, _timer_module: *TimerModule, _timer: *Timer) void;
};

pub const TimerModule = struct {
    current_time: Ticks = 0,
    active_timers: std.SinglyLinkedList = .{},
    paused_timers: std.SinglyLinkedList = .{},

    /// Services the callbacks for a single expired timer
    /// Returns `true` if a `Timer` expired, otherwise returns `false`
    pub fn run(self: *TimerModule) bool {
        const time_at_start_of_rtc = self.safely_get_current_time();

        if (self.active_timers.first) |next_expiring| {
            var timer: *Timer = @fieldParentPtr("node", next_expiring);

            // Expired timers will have a `distance` in the range of [0, longest_delay_before_servicing_timer]
            // This calculation loops over from `std.math.maxInt(Ticks)` to 0.
            const distance = time_at_start_of_rtc -% timer.timer_data.expiration;
            const timer_is_expired = distance <= Timer.longest_delay_before_servicing_timer;

            if (timer_is_expired) {
                const _callback = timer.callback;
                timer.callback = null;
                _callback.?(timer.ctx, self, timer);
                if (timer.callback == null) {
                    // Timer was not manually restarted during the callback, thus
                    // it should be at the front of the list and we just need to remove/restart it
                    const front_node = self.active_timers.popFirst().?;
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
    /// NOTE: `ctx` must be align(2) to allow an `bool` due to optimization reasons
    /// If you get an error, declare your variable as `align(2)` or use a container
    /// struct with larger alignment
    pub fn start_one_shot(self: *TimerModule, timer: *Timer, duration: Ticks, ctx: ?*align(2) anyopaque, callback: Timer.TimerCallback) void {
        if (timer.callback != null or self.active_timers.first == &timer.node) {
            self.remove_timer(timer);
        }

        std.debug.assert(duration <= Timer.max_ticks);
        timer.ctx = ctx;
        timer.callback = callback;
        timer.period = 0;

        self.insert_timer(timer, duration);
    }

    /// Starts a periodic timer, with first expiration set to current time + period
    /// NOTE: `ctx` must be align(2) to allow an `bool` due to optimization reasons
    /// If you get an error, declare your variable as `align(2)` or use a container
    /// struct with larger alignment
    pub fn start_periodic(self: *TimerModule, timer: *Timer, period: Ticks, ctx: ?*align(2) anyopaque, callback: Timer.TimerCallback) void {
        @call(.always_inline, start_periodic_delayed, .{ self, timer, period, period, ctx, callback });
    }

    /// Starts a periodic timer with a custom delay for the first expiration
    /// NOTE: an `initial_delay` of 0 does not immediately run the callback TODO: maybe it should/could?
    pub fn start_periodic_delayed(
        self: *TimerModule,
        timer: *Timer,
        period: Ticks,
        initial_delay: Ticks,
        ctx: ?*align(2) anyopaque,
        callback: Timer.TimerCallback,
    ) void {
        if (timer.callback != null or self.active_timers.first == &timer.node) {
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

    /// Stops an active or paused timer
    pub fn stop(self: *TimerModule, timer: *Timer) void {
        timer.period = 0;
        if (timer.callback != null) {
            self.remove_timer(timer);
        }
    }

    /// Pauses a timer
    /// If the timer is already paused or is not started then this does nothing
    pub fn pause(self: *TimerModule, timer: *Timer) void {
        if (timer.callback == null) {
            return;
        }

        const was_active = try_remove(&self.active_timers, &timer.node);
        if (was_active) {
            timer.timer_data = Timer.TimerData{ .remaining_ticks_if_paused = remaining_ticks_active_timer(timer, self.safely_get_current_time()) };
            self.paused_timers.prepend(&timer.node); // Order doesn't matter, pause list should be relatively small
        } else {
            // Do nothing, it was already paused
        }
    }

    // TODO: Rename this to `resume` once the keyword is removed
    /// Unpauses a timer
    /// If the timer is already active or is not present then this does nothing
    pub fn unpause(self: *TimerModule, timer: *Timer) void {
        if (timer.callback == null) {
            return;
        }

        const was_paused = try_remove(&self.paused_timers, &timer.node);
        if (was_paused) {
            self.insert_timer(timer, timer.timer_data.remaining_ticks_if_paused);
        } else {
            // Do nothing, it was already active
        }
    }

    /// Returns true if a timer is active or paused
    pub fn is_running(self: *TimerModule, timer: *Timer) bool {
        return is_active(self, timer) or is_paused(self, timer);
    }

    /// Returns true if a timer is active
    pub fn is_active(self: *TimerModule, timer: *Timer) bool {
        var current_elem = self.active_timers.first;
        while (current_elem != null) {
            if (current_elem == &timer.node) {
                return true;
            }
            current_elem = current_elem.?.next;
        }
        return false;
    }

    /// Returns true if a timer is paused
    pub fn is_paused(self: *TimerModule, timer: *Timer) bool {
        var current_elem = self.paused_timers.first;
        while (current_elem != null) {
            if (current_elem == &timer.node) {
                return true;
            }
            current_elem = current_elem.?.next;
        }
        return false;
    }

    fn remaining_ticks_active_timer(timer: *Timer, current_time: Ticks) Ticks {
        if ((timer.timer_data.expiration -% current_time) <= Timer.max_ticks) {
            const duration = timer.timer_data.expiration -% current_time;
            return duration;
        } else {
            return 0;
        }
    }

    /// Returns the remaining ticks on a timer, returns 0 if the timer is not running
    pub fn remaining_ticks(timer_module: *TimerModule, timer: *Timer) Ticks {
        if (timer.callback == null) {
            return 0;
        } else {
            if (is_paused(timer_module, timer)) {
                return timer.timer_data.remaining_ticks_if_paused;
            } else {
                return remaining_ticks_active_timer(timer, timer_module.safely_get_current_time());
            }
        }
    }

    /// Returns `remaining_ticks` for the head of the linked list
    pub fn ticks_until_next_ready(timer_module: *TimerModule) Ticks {
        if (timer_module.active_timers.first) |firstNode| {
            const timer: *Timer = @fieldParentPtr("node", firstNode);
            return remaining_ticks_active_timer(timer, timer_module.safely_get_current_time());
        } else {
            @branchHint(.cold);
            return std.math.maxInt(Ticks); // > max_ticks, signals that no timers exist
        }
    }

    /// Inserts a timer after all other timers with equal or less remaining ticks
    /// Inserting after timers with equal remaining ticks improves fairness
    fn insert_timer(self: *TimerModule, timer: *Timer, ticks: Ticks) void {
        std.debug.assert(ticks <= Timer.max_ticks);

        const current_time = self.safely_get_current_time();
        timer.timer_data = Timer.TimerData{ .expiration = current_time +% ticks };

        if (self.active_timers.first) |head| {
            const head_timer: *Timer = @fieldParentPtr("node", head);
            const head_remaining_ticks = remaining_ticks_active_timer(head_timer, current_time);

            if (ticks < head_remaining_ticks) {
                self.active_timers.prepend(&timer.node);
            } else {
                var node_to_insert_after = head;
                while (node_to_insert_after.next) |next| {
                    const _timer: *Timer = @fieldParentPtr("node", next);
                    const next_remaining_ticks = remaining_ticks_active_timer(_timer, current_time);
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
            self.active_timers.prepend(&timer.node);
        }
    }

    /// std.SinglyLinkedList remove, but returns a bool and is valid to call when the node isn't in the list
    fn try_remove(list: *std.SinglyLinkedList, node: *std.SinglyLinkedList.Node) bool {
        if (list.first == null) {
            return false;
        } else if (list.first == node) {
            list.first = node.next;
            return true;
        } else {
            var current_elm = list.first.?;
            while (current_elm.next) |next| {
                if (next == node) {
                    current_elm.next = node.next;
                    return true;
                }
                current_elm = next;
            }
            return false;
        }
    }

    /// If this is called, a timer MUST be in either the active list or paused list
    fn remove_timer(self: *TimerModule, timer: *Timer) void {
        std.debug.assert(timer.callback != null or self.active_timers.first == &timer.node);
        const removed_from_active = try_remove(&self.active_timers, &timer.node);
        if (!removed_from_active) {
            const removed_from_paused = try_remove(&self.paused_timers, &timer.node);
            std.debug.assert(removed_from_paused);
        }

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
