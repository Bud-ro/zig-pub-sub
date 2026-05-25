//! `Subscription` provides slot storage and subscribe/unsubscribe machinery
//! for publishers that want to deliver events to multiple subscribers.
//! `Subscription`s are owned by the publisher, typically in a `comptime` sized
//! array or slice.
//!
//! Each publisher owns its own args type and its own dispatch helper (see
//! e.g. `system_data.publishOnChange` and the wire-publisher equivalent),
//! both of which call subscribers through `Subscription.Callback`. The args
//! pointer delivered to each subscriber is opaque from `Subscription`'s
//! perspective: subscribers cast based on the publisher they subscribed to.
//! Args live only for the duration of dispatch; callbacks must not retain
//! the pointer.
//!
//! The identity of a `Subscription` is solely based on its callback pointer.
//! `Subscription`s with the same identity cannot be known to the same publisher.
//! However `Subscription`s with the same identity may subscribe to several sources.
//!
//! NOTE: Identical Code Folding may break this assumption. If tests/subscriptions
//!       don't work at higher levels of optimization then try ensuring uniqueness
//!       or disabling ICF outright.

/// Function pointer type for subscription callbacks.
pub const Callback = *const fn (context: ?*anyopaque, args: ?*const anyopaque, publisher: *anyopaque) void;

context: ?*anyopaque,
callback: ?Callback,

const Self = @This();

/// Add a subscription callback. Deduplicates by callback identity (a
/// second subscribe with the same `callback` keeps the original `context`
/// and does NOT consume another slot). Panics if `slots` is full.
/// Shared across all DataComponentSubscription instantiations to avoid monomorphization.
pub noinline fn subscribe(slots: []Self, context: ?*anyopaque, callback: Callback) void {
    var first_free: ?*Self = null;

    for (slots) |*sub| {
        if (first_free == null and sub.callback == null) {
            first_free = sub;
        }
        if (sub.callback == callback) {
            return;
        }
    }

    const slot = first_free orelse @panic("ERD oversubscribed!");
    slot.* = .{ .context = context, .callback = callback };
}

/// Remove a subscription callback by identity. No-op if the callback isn't
/// present in `slots` (and no-op when `slots` is empty).
/// Shared across all DataComponentSubscription instantiations to avoid monomorphization.
pub noinline fn unsubscribe(slots: []Self, callback: Callback) void {
    for (slots) |*sub| {
        if (sub.callback == callback) {
            sub.callback = null;
            return;
        }
    }
}

const std = @import("std");
const expectEqual = std.testing.expectEqual;

// Each test callback increments its own counter. The counters double as the
// observation hook for publish-related tests below, and -- because the tests
// read them -- the writes cannot be eliminated as dead. Writing to distinct
// global addresses also keeps each callback's compiled body byte-distinct,
// which is what defeats linker-level identical-code-folding (e.g. lld
// `--icf=all` under -O3). Without that, ICF would collapse byte-identical
// empty callbacks into a single address and silently break the identity-
// based subscribe/unsubscribe assertions here. Real subscribers writing
// byte-identical callbacks for the same ERD is vanishingly rare, so the
// library itself does not need to guard against this -- it is a test-only
// concern.
var cb_a_calls: u32 = 0;
var cb_b_calls: u32 = 0;
var cb_c_calls: u32 = 0;

fn cbA(_: ?*anyopaque, _: ?*const anyopaque, _: *anyopaque) void {
    cb_a_calls += 1;
}
fn cbB(_: ?*anyopaque, _: ?*const anyopaque, _: *anyopaque) void {
    cb_b_calls += 1;
}
fn cbC(_: ?*anyopaque, _: ?*const anyopaque, _: *anyopaque) void {
    cb_c_calls += 1;
}

const empty: Self = .{ .context = null, .callback = null };

test "subscribe stores callback in first free slot" {
    var slots = [_]Self{empty} ** 3;

    subscribe(&slots, null, cbA);

    try expectEqual(cbA, slots[0].callback);
    try expectEqual(null, slots[1].callback);
    try expectEqual(null, slots[2].callback);
}

test "subscribe deduplicates by callback identity" {
    var slots = [_]Self{empty} ** 3;
    var ctx_a: u32 = 1;
    var ctx_b: u32 = 2;

    subscribe(&slots, &ctx_a, cbA);
    subscribe(&slots, &ctx_b, cbA);

    try expectEqual(cbA, slots[0].callback);
    try expectEqual(@as(*anyopaque, &ctx_a), slots[0].context);
    try expectEqual(null, slots[1].callback);
}

test "subscribe fills earliest free slot after gap" {
    var slots = [_]Self{
        .{ .context = null, .callback = cbA },
        empty,
        .{ .context = null, .callback = cbC },
    };

    subscribe(&slots, null, cbB);

    try expectEqual(cbB, slots[1].callback);
}

test "subscribe stores callback and context" {
    var slots = [_]Self{empty} ** 2;
    var ctx: u8 = 42;

    subscribe(&slots, &ctx, cbA);

    try expectEqual(@as(*anyopaque, &ctx), slots[0].context);
    try expectEqual(cbA, slots[0].callback);
}

test "unsubscribe clears matching callback only" {
    var slots = [_]Self{
        .{ .context = null, .callback = cbA },
        .{ .context = null, .callback = cbB },
        .{ .context = null, .callback = cbC },
    };

    unsubscribe(&slots, cbB);

    try expectEqual(cbA, slots[0].callback);
    try expectEqual(null, slots[1].callback);
    try expectEqual(cbC, slots[2].callback);
}

test "unsubscribe is a no-op when callback is not present" {
    var slots = [_]Self{ .{ .context = null, .callback = cbA }, empty };

    unsubscribe(&slots, cbB);

    try expectEqual(cbA, slots[0].callback);
    try expectEqual(null, slots[1].callback);
}

test "subscribe then unsubscribe then subscribe reuses slot" {
    var slots = [_]Self{empty} ** 2;

    subscribe(&slots, null, cbA);
    unsubscribe(&slots, cbA);
    subscribe(&slots, null, cbB);

    try expectEqual(cbB, slots[0].callback);
    try expectEqual(null, slots[1].callback);
}

test "unsubscribe on empty slot slice is a no-op" {
    var slots = [_]Self{};
    unsubscribe(&slots, cbA);
    // No assertion needed: must simply not panic / OOB.
}
