//! Timer module codegen inspection harness
//!
//! Exercises `erd_core.timer.TimerModule` with many call sites of every public
//! API, plus realistic "lots of timers" aggregate functions (app_init / query
//! / control loops). Build as an object and inspect the generated assembly to
//! decide which internal helpers should be `noinline`: TimerModule is a single
//! concrete type (no generic monomorphization), so an inlined helper is
//! duplicated once per call site. Large helpers reached from several sites
//! (insertTimer, removeTimer, tryRemove, the list scans) cost ROM each time
//! they inline; forcing them out-of-line keeps one shared copy.
//!
//! Snapshotted via `zig build codegen-update`; verified via `codegen-check`.

const std = @import("std");
const erd_core = @import("erd_core");
const timer = erd_core.timer;
const TimerModule = timer.TimerModule;
const Timer = timer.Timer;
const Ticks = timer.Ticks;

fn cb0(_: ?*anyopaque, _: *TimerModule, _: *Timer) void {}
fn cb1(_: ?*anyopaque, _: *TimerModule, _: *Timer) void {}
fn cb2(_: ?*anyopaque, _: *TimerModule, _: *Timer) void {}

// ===========================================================================
// Single-call wrappers: one clean snapshot per public API. Anything these
// reach out-of-line shows up in the "called functions" section.
// ===========================================================================

export fn timer_run(tm: *TimerModule) bool {
    return tm.run();
}

export fn timer_start_periodic(tm: *TimerModule, t: *Timer) void {
    tm.startPeriodic(t, 100, null, cb0);
}

export fn timer_start_oneshot(tm: *TimerModule, t: *Timer) void {
    tm.startOneShot(t, 100, null, cb0);
}

export fn timer_stop(tm: *TimerModule, t: *Timer) void {
    tm.stop(t);
}

export fn timer_pause(tm: *TimerModule, t: *Timer) void {
    tm.pause(t);
}

export fn timer_unpause(tm: *TimerModule, t: *Timer) void {
    tm.unpause(t);
}

export fn timer_is_running(tm: *TimerModule, t: *Timer) bool {
    return tm.isRunning(t);
}

export fn timer_is_active(tm: *TimerModule, t: *Timer) bool {
    return tm.isActive(t);
}

export fn timer_is_paused(tm: *TimerModule, t: *Timer) bool {
    return tm.isPaused(t);
}

export fn timer_elapsed(tm: *TimerModule, t: *Timer) Ticks {
    return tm.elapsedTicks(t);
}

export fn timer_remaining(tm: *TimerModule, t: *Timer) Ticks {
    return tm.remainingTicks(t);
}

export fn timer_ticks_since(tm: *TimerModule, t: *Timer) Ticks {
    return tm.ticksSinceLastStarted(t);
}

export fn timer_until_next(tm: *TimerModule) Ticks {
    return tm.ticksUntilNextReady();
}

export fn timer_increment(tm: *TimerModule, ticks: Ticks) void {
    tm.incrementCurrentTime(ticks);
}

// ===========================================================================
// Aggregate "lots of timers" call sites: this is where helpers either inline
// repeatedly (bloat) or share one out-of-line body.
// ===========================================================================

/// Start eight timers: eight startPeriodic/startOneShot call sites, each of
/// which reaches insertTimer and removeTimer.
export fn app_init(tm: *TimerModule, t: *[8]Timer) void {
    tm.startPeriodic(&t[0], 10, null, cb0);
    tm.startPeriodic(&t[1], 20, null, cb1);
    tm.startPeriodic(&t[2], 30, null, cb2);
    tm.startOneShot(&t[3], 40, null, cb0);
    tm.startOneShot(&t[4], 50, null, cb1);
    tm.startOneShot(&t[5], 60, null, cb2);
    tm.startPeriodic(&t[6], 70, null, cb0);
    tm.startOneShot(&t[7], 80, null, cb1);
}

/// Stop eight timers: eight stop call sites, each reaching removeTimer.
export fn app_stop_all(tm: *TimerModule, t: *[8]Timer) void {
    inline for (0..8) |i| tm.stop(&t[i]);
}

/// Pause eight timers: eight pause call sites, each reaching tryRemove.
export fn app_pause_all(tm: *TimerModule, t: *[8]Timer) void {
    inline for (0..8) |i| tm.pause(&t[i]);
}

/// Unpause eight timers: eight unpause call sites, each reaching tryRemove and
/// insertTimer.
export fn app_unpause_all(tm: *TimerModule, t: *[8]Timer) void {
    inline for (0..8) |i| tm.unpause(&t[i]);
}

/// Query remaining ticks for eight timers: eight remainingTicks call sites,
/// each reaching isPaused and remainingTicksActiveTimer.
export fn app_query_remaining(tm: *TimerModule, t: *[8]Timer, out: *[8]Ticks) void {
    inline for (0..8) |i| out[i] = tm.remainingTicks(&t[i]);
}

/// Query running state for eight timers: eight isRunning call sites, each
/// reaching the isActive and isPaused list scans.
export fn app_query_running(tm: *TimerModule, t: *[8]Timer, out: *[8]bool) void {
    inline for (0..8) |i| out[i] = tm.isRunning(&t[i]);
}

/// Drain the module: the run() loop a main loop would use.
export fn run_until_idle(tm: *TimerModule) void {
    while (tm.run()) {}
}

/// Mixed control burst: restart, pause, unpause, stop across several timers.
export fn app_control_burst(tm: *TimerModule, t: *[4]Timer) void {
    tm.startPeriodic(&t[0], 10, null, cb0);
    tm.pause(&t[0]);
    tm.unpause(&t[0]);
    tm.startOneShot(&t[1], 20, null, cb1);
    tm.stop(&t[1]);
    tm.startPeriodic(&t[2], 30, null, cb2);
    tm.startOneShot(&t[3], 40, null, cb0);
    tm.stop(&t[2]);
    tm.stop(&t[3]);
}
