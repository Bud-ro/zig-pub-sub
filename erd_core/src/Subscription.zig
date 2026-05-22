//! `Subscription` allows publishers to send events to multiple subscribers.
//! On publish, each client's callback will receive user provided context (optional), args associated with the publication, and a pointer to the publisher.
//! `Subscription`s are owned by the publisher, typically in a `comptime` sized array or slice.
//!
//! The identity of a `Subscription` is solely based on its callback pointer.
//! `Subscription`s with the same identity cannot be known to the same publisher.
//! However `Subscription`s with the same identity may subscribe to several source.

/// Function pointer type for subscription callbacks.
pub const Callback = *const fn (context: ?*anyopaque, args: ?*const anyopaque, publisher: *anyopaque) void;

/// Payload delivered to on-change callbacks with the ERD index and data pointer.
pub const OnChangeArgs = struct {
    system_data_idx: u16,
    data: *const anyopaque,
};

context: ?*anyopaque,
callback: ?Callback,

const Self = @This();

/// Dispatch on-change callbacks to a contiguous subscription slot range.
/// Shared across all DataComponent instantiations to avoid monomorphization.
pub noinline fn publish(slots: []Self, system_data_idx: u16, data: *const anyopaque, publisher: *anyopaque) void {
    for (slots) |sub| {
        if (sub.callback) |cb| {
            const args: OnChangeArgs = .{
                .system_data_idx = system_data_idx,
                .data = data,
            };
            cb(sub.context, @ptrCast(&args), publisher);
        }
    }
}

/// Add a subscription callback. Deduplicates by callback identity.
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

    if (first_free == null) {
        @panic("ERD oversubscribed!");
    }

    first_free.?.context = context;
    first_free.?.callback = callback;
}

/// Remove a subscription callback by identity.
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

const CapturedArgs = struct {
    invocations: u32 = 0,
    system_data_idx: u16 = 0,
    data: ?*const anyopaque = null,
    publisher: ?*anyopaque = null,
    context_seen: ?*anyopaque = null,
};

fn capturingCallback(context: ?*anyopaque, args: ?*const anyopaque, publisher: *anyopaque) void {
    const captured: *CapturedArgs = @ptrCast(@alignCast(context.?));
    const change: *const OnChangeArgs = @ptrCast(@alignCast(args));
    captured.invocations += 1;
    captured.system_data_idx = change.system_data_idx;
    captured.data = change.data;
    captured.publisher = publisher;
    captured.context_seen = context;
}

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

test "publish invokes every populated slot, skips empty slots" {
    cb_a_calls = 0;
    cb_c_calls = 0;
    var slots = [_]Self{
        .{ .context = null, .callback = cbA },
        empty,
        .{ .context = null, .callback = cbC },
    };
    var payload: u8 = 0;
    var publisher: u8 = 0;

    publish(&slots, 0, &payload, &publisher);

    try expectEqual(1, cb_a_calls);
    try expectEqual(1, cb_c_calls);
}

test "publish passes system_data_idx, data, publisher, and context to callback" {
    var captured: CapturedArgs = .{};
    var slots = [_]Self{.{ .context = &captured, .callback = capturingCallback }};
    var payload: u32 = 0xABCD;
    var publisher: u32 = 0;

    publish(&slots, 7, &payload, &publisher);

    try expectEqual(1, captured.invocations);
    try expectEqual(7, captured.system_data_idx);
    try expectEqual(@as(*const anyopaque, &payload), captured.data);
    try expectEqual(@as(*anyopaque, &publisher), captured.publisher);
    try expectEqual(@as(*anyopaque, &captured), captured.context_seen);
}

test "publish tolerates a hole created by unsubscribe" {
    cb_a_calls = 0;
    cb_b_calls = 0;
    cb_c_calls = 0;
    var slots = [_]Self{empty} ** 3;

    subscribe(&slots, null, cbA);
    subscribe(&slots, null, cbB);
    subscribe(&slots, null, cbC);
    unsubscribe(&slots, cbB);

    try expectEqual(null, slots[1].callback);

    var payload: u8 = 0;
    var publisher: u8 = 0;
    publish(&slots, 0, &payload, &publisher);

    try expectEqual(1, cb_a_calls);
    try expectEqual(0, cb_b_calls);
    try expectEqual(1, cb_c_calls);
}

test "publish on empty slot slice does nothing" {
    var slots = [_]Self{};
    var publisher: u32 = 0;
    publish(&slots, 0, &publisher, &publisher);
}

test "subscribe then unsubscribe then subscribe reuses slot" {
    var slots = [_]Self{empty} ** 2;

    subscribe(&slots, null, cbA);
    unsubscribe(&slots, cbA);
    subscribe(&slots, null, cbB);

    try expectEqual(cbB, slots[0].callback);
    try expectEqual(null, slots[1].callback);
}
