//! Timer Module
//! This is a performant, light-weight, and somewhat general-purpose software scheduler intended for groups of tasks which can all run on one thread.
//! Each task (`Timer`) weighs in at 20 bytes of RAM on a 32-bit system for ReleaseFast/Small builds. `Timer`s inside the `TimerModule` form
//! a sorted linked list where the front `Timer` is the next to expire. The intended usage is for clients to statically allocate `Timer`s.
//! All of this make it ideal for single-threaded embedded systems.
//!
//! After initialization, user code should enter a main-loop that runs the `TimerModule` until exhaustion, and then sleeps:
//! ```
//! while(true)
//! {
//!     const timer_module_did_work = timer_module.run();
//!     if(!timer_module_did_work)
//!     {
//!         _WFI();
//!     }
//! }
//! ```
//!
//! Additionally, user-code must advance the time via `timer_module.incrementCurrentTime(ticks);`.
//! Ideally this should be done via an interrupt.
//!
//! Guarantees:
//! This is not intended for high accuracy applications. Timer drift will happen since tasks take real time to occur, and `Timer`s are designed to
//! re-start from the latest time. You use a different scheduler to guarantee those high accuracy tasks do not drift, and then use `TimerModule`
//! in a task of that high accuracy scheduler to strike a balance between throughput and accuracy.
//!
//! To formally list the guarantees:
//! - Throughput: `TimerModule` is primarily designed for high-throughput so that embedded systems may return to sleep as soon as possible.
//! - Wait time: There are no guarantees here. A long running task (> 1ms) can delay every other `Timer` for as long as it runs.
//!   It is up to users to design their system with short tasks, or to break up tasks.
//! - Latency: In an idle system, as soon as a `Timer` expires it will almost immediately be executed.
//! - Fairness: `Timer`s are always put after existing `Timer`s that would expire before or at the same time.
//!   This ensures no single task can starve the system (including 0 tick periodic `Timer`s)
//!

const sometimes = @import("sometimes");
const std = @import("std");

/// A tick is typically 1 millisecond. Can be longer. Smaller time-scales aren't practical
/// due to implied timing constraints that cannot be guaranteed in such a system.
/// u32 allows for ~50 day timers which is plenty.
pub const Ticks = u32;

/// A single software timer node in the TimerModule's sorted linked list.
pub const Timer = struct {
    timer_data: TimerData = undefined,
    duration: Ticks = undefined,
    /// ctx is an `?*align(2) anyopaque` pointer where the lowest bit
    /// is used to store `isPeriodic`. Supports full u32 timer range and `fn elapsedTicks`
    ctx: usize = undefined,
    callback: ?TimerCallback = null,
    node: std.SinglyLinkedList.Node = .{},

    /// Timer state: either an absolute expiration tick or remaining ticks when paused.
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
    /// Callback invoked when the timer expires.
    pub const TimerCallback = *const fn (ctx: ?*anyopaque, _timer_module: *TimerModule, _timer: *Timer) void;

    fn isPeriodic(self: *Timer) bool {
        return (self.ctx & 1) == 1;
    }

    fn setIsPeriodic(self: *Timer, state: bool) void {
        if (state) {
            self.ctx |= @as(usize, 1);
        } else {
            self.ctx &= ~@as(usize, 1);
        }
    }

    fn getCtxPtr(self: *Timer) ?*anyopaque {
        return @ptrFromInt(self.ctx & ~@as(usize, 1));
    }
};

/// Tick-based software scheduler using sorted linked lists of Timer nodes.
pub const TimerModule = struct {
    current_time: Ticks = 0,
    active_timers: std.SinglyLinkedList = .{},
    paused_timers: std.SinglyLinkedList = .{},

    /// Services the callbacks for a single expired timer
    /// Returns `true` if a `Timer` expired, otherwise returns `false`
    pub fn run(self: *TimerModule) bool {
        const time_at_start_of_rtc = self.safelyGetCurrentTime();

        if (self.active_timers.first) |next_expiring| {
            var timer: *Timer = @fieldParentPtr("node", next_expiring);

            // Expired timers will have a `distance` in the range of [0, longest_delay_before_servicing_timer]
            // This calculation loops over from `std.math.maxInt(Ticks)` to 0.
            const distance = time_at_start_of_rtc -% timer.timer_data.expiration;
            const timer_is_expired = distance <= Timer.longest_delay_before_servicing_timer;
            sometimes.assert(&@src(), distance == Timer.longest_delay_before_servicing_timer);
            sometimes.assert(&@src(), distance == Timer.longest_delay_before_servicing_timer + 1); // max ticks timer

            var front_node: ?*std.SinglyLinkedList.Node = null;
            if (timer_is_expired) {
                if (!timer.isPeriodic()) {
                    // One-shot timers should not be considered running during their callback
                    front_node = self.active_timers.popFirst().?;
                }

                const savedCallback = timer.callback;
                timer.callback = null;
                savedCallback.?(timer.getCtxPtr(), self, timer);

                // Timer was not manually restarted during the callback
                if (timer.callback == null) {
                    if (front_node == null) {
                        front_node = self.active_timers.popFirst().?;
                        std.debug.assert(front_node == next_expiring);
                    }
                    if (timer.isPeriodic()) {
                        self.insertTimer(timer, timer.duration);
                        timer.callback = savedCallback; // Don't forget to restore the callback!
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
    pub fn startOneShot(self: *TimerModule, timer: *Timer, duration: Ticks, ctx: ?*align(2) anyopaque, callback: Timer.TimerCallback) void {
        sometimes.assert(&@src(), self.active_timers.first == &timer.node); // Re-starting a periodic as a one-shot
        if (timer.callback != null or self.active_timers.first == &timer.node) {
            self.removeTimer(timer);
        }
        std.debug.assert(duration <= Timer.max_ticks);

        timer.ctx = @intFromPtr(ctx);
        timer.callback = callback;
        timer.duration = duration;
        timer.setIsPeriodic(false);

        self.insertTimer(timer, duration);
    }

    /// Starts a periodic timer, with first expiration set to current time + period
    /// NOTE: `ctx` must be align(2) to allow an `bool` due to optimization reasons
    /// If you get an error, declare your variable as `align(2)` or use a container
    /// struct with larger alignment
    pub fn startPeriodic(self: *TimerModule, timer: *Timer, period: Ticks, ctx: ?*align(2) anyopaque, callback: Timer.TimerCallback) void {
        sometimes.assert(&@src(), self.active_timers.first == &timer.node); // Re-starting a periodic as a periodic
        if (timer.callback != null or self.active_timers.first == &timer.node) {
            self.removeTimer(timer);
        }

        std.debug.assert(period <= Timer.max_ticks);

        timer.ctx = @intFromPtr(ctx);
        timer.callback = callback;
        timer.duration = period;
        timer.setIsPeriodic(true);

        self.insertTimer(timer, period);
    }

    /// Stops an active or paused timer
    pub fn stop(self: *TimerModule, timer: *Timer) void {
        timer.setIsPeriodic(false);
        if (timer.callback != null) {
            self.removeTimer(timer);
        }
    }

    /// Pauses a timer
    /// If the timer is already paused or is not started then this does nothing
    /// NOTE: It is invalid to pause a timer from its own callback.
    pub fn pause(self: *TimerModule, timer: *Timer) void {
        if (timer.callback == null) {
            return;
        }

        const was_active = tryRemove(&self.active_timers, &timer.node);
        if (was_active) {
            timer.timer_data = Timer.TimerData{ .remaining_ticks_if_paused = remainingTicksActiveTimer(timer, self.safelyGetCurrentTime()) };
            self.paused_timers.prepend(&timer.node); // Order doesn't matter, pause list should be relatively small
        } else {
            // Do nothing, it was already paused or not started
            std.debug.assert(self.isPaused(timer) or !self.isRunning(timer));
        }
    }

    /// Unpauses a timer
    /// If the timer is already active or is not present then this does nothing
    pub fn unpause(self: *TimerModule, timer: *Timer) void {
        if (timer.callback == null) {
            return;
        }

        const was_paused = tryRemove(&self.paused_timers, &timer.node);
        if (was_paused) {
            self.insertTimer(timer, timer.timer_data.remaining_ticks_if_paused);
        } else {
            // Do nothing, it was already active or not started
            std.debug.assert(self.isActive(timer) or !self.isRunning(timer));
        }
    }

    /// Returns true if a timer is active or paused
    pub fn isRunning(self: *TimerModule, timer: *Timer) bool {
        return isActive(self, timer) or isPaused(self, timer);
    }

    /// Returns true if a timer is active
    pub fn isActive(self: *TimerModule, timer: *Timer) bool {
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
    pub fn isPaused(self: *TimerModule, timer: *Timer) bool {
        var current_elem = self.paused_timers.first;
        while (current_elem != null) {
            if (current_elem == &timer.node) {
                return true;
            }
            current_elem = current_elem.?.next;
        }
        return false;
    }

    /// Returns the elapsed ticks for a timer. Does not report overdue ticks.
    /// Use `ticksSinceLastStarted` instead if overdue ticks need to be counted.
    pub fn elapsedTicks(timer_module: *TimerModule, timer: *Timer) Ticks {
        if (timer.callback == null) {
            return 0;
        } else {
            return timer.duration - timer_module.remainingTicks(timer);
        }
    }

    /// For a timer that has been started at least once, returns the ticks since it was last started.
    /// Result is undefined for timers that have never been started or were started `Timer.max_ticks` ticks ago.
    /// NOTE: Periodic timers automatically re-**start** themselves.
    pub fn ticksSinceLastStarted(timer_module: *TimerModule, timer: *Timer) Ticks {
        if (isPaused(timer_module, timer)) {
            @panic("It is invalid to get ticksSinceLastStarted for a paused timer");
        }

        const timer_start = timer.timer_data.expiration -% timer.duration;
        return timer_module.safelyGetCurrentTime() -% timer_start;
    }

    fn remainingTicksActiveTimer(timer: *Timer, current_time: Ticks) Ticks {
        if ((timer.timer_data.expiration -% current_time) <= Timer.max_ticks) {
            const duration = timer.timer_data.expiration -% current_time;
            return duration;
        } else {
            return 0;
        }
    }

    /// Returns the remaining ticks on a timer, returns 0 if the timer is not running
    pub fn remainingTicks(timer_module: *TimerModule, timer: *Timer) Ticks {
        if (timer.callback == null) {
            return 0;
        } else {
            if (isPaused(timer_module, timer)) {
                return timer.timer_data.remaining_ticks_if_paused;
            } else {
                return remainingTicksActiveTimer(timer, timer_module.safelyGetCurrentTime());
            }
        }
    }

    /// Returns `remainingTicks` for the head of the linked list
    pub fn ticksUntilNextReady(timer_module: *TimerModule) Ticks {
        if (timer_module.active_timers.first) |firstNode| {
            const timer: *Timer = @fieldParentPtr("node", firstNode);
            return remainingTicksActiveTimer(timer, timer_module.safelyGetCurrentTime());
        } else {
            @branchHint(.cold);
            return std.math.maxInt(Ticks); // > max_ticks, signals that no timers exist
        }
    }

    /// Inserts a timer after all other timers with equal or less remaining ticks
    /// Inserting after timers with equal remaining ticks improves fairness
    fn insertTimer(self: *TimerModule, timer: *Timer, ticks: Ticks) void {
        std.debug.assert(ticks <= Timer.max_ticks);

        const current_time = self.safelyGetCurrentTime();
        timer.timer_data = Timer.TimerData{ .expiration = current_time +% ticks };

        if (self.active_timers.first) |head| {
            const head_timer: *Timer = @fieldParentPtr("node", head);
            const head_remaining_ticks = remainingTicksActiveTimer(head_timer, current_time);

            if (ticks < head_remaining_ticks) {
                self.active_timers.prepend(&timer.node);
            } else {
                var node_to_insert_after = head;
                while (node_to_insert_after.next) |next| {
                    const _timer: *Timer = @fieldParentPtr("node", next);
                    const next_remaining_ticks = remainingTicksActiveTimer(_timer, current_time);
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
    fn tryRemove(list: *std.SinglyLinkedList, node: *std.SinglyLinkedList.Node) bool {
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
    fn removeTimer(self: *TimerModule, timer: *Timer) void {
        std.debug.assert(timer.callback != null or self.active_timers.first == &timer.node);
        const removed_from_active = tryRemove(&self.active_timers, &timer.node);
        if (!removed_from_active) {
            const removed_from_paused = tryRemove(&self.paused_timers, &timer.node);
            // If we fail to remove something, check that we didn't screw up and that it's the the user's fault
            // for failing to initialize their memory. All they lose out on is a bit of performance on init so no need
            // to hard-fault.
            if (!removed_from_paused) {
                std.debug.assert(timer.callback != null);
            }
        }

        timer.callback = null;
    }

    /// Can be called in the interrupt context. NOTE: this can happen while a call to `run` is happening.
    pub fn incrementCurrentTime(self: *TimerModule, ticks_to_increment_by: Ticks) void {
        self.current_time +%= ticks_to_increment_by;
    }

    /// Repeatedly reads the current_time until two consecutive reads are identical
    pub fn safelyGetCurrentTime(self: *const TimerModule) Ticks {
        // TODO: A lot of embedded platforms won't support atomic access to a u32.
        // The natural way to do so would be via a spin-loop, I just need to figure out
        // how to specify that to where it isn't optimized away.
        return @atomicLoad(Ticks, &self.current_time, .monotonic);
    }
};
