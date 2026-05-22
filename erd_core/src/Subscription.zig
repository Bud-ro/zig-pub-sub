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

// Identity-only test callbacks (zlinter requires a comment inside empty blocks).
fn cbA(_: ?*anyopaque, _: ?*const anyopaque, _: *anyopaque) void {
    // intentionally empty
}
fn cbB(_: ?*anyopaque, _: ?*const anyopaque, _: *anyopaque) void {
    // intentionally empty
}
fn cbC(_: ?*anyopaque, _: ?*const anyopaque, _: *anyopaque) void {
    // intentionally empty
}

const empty: Self = .{ .context = null, .callback = null };

const CountingState = struct {
    invocations: u32 = 0,
    last_system_data_idx: u16 = 0,
    last_data: ?*const anyopaque = null,
    last_publisher: ?*anyopaque = null,
    last_context: ?*anyopaque = null,
};

fn countingCallback(context: ?*anyopaque, args: ?*const anyopaque, publisher: *anyopaque) void {
    const state: *CountingState = @ptrCast(@alignCast(context.?));
    const change: *const OnChangeArgs = @ptrCast(@alignCast(args));
    state.invocations += 1;
    state.last_system_data_idx = change.system_data_idx;
    state.last_data = change.data;
    state.last_publisher = publisher;
    state.last_context = context;
}

fn countingCallback2(context: ?*anyopaque, args: ?*const anyopaque, publisher: *anyopaque) void {
    countingCallback(context, args, publisher);
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
    var state_a: CountingState = .{};
    var state_b: CountingState = .{};
    var slots = [_]Self{
        .{ .context = &state_a, .callback = countingCallback },
        empty,
        .{ .context = &state_b, .callback = countingCallback2 },
    };
    var payload: u32 = 0xABCD;
    var publisher: u32 = 0;

    publish(&slots, 7, &payload, &publisher);

    try expectEqual(1, state_a.invocations);
    try expectEqual(1, state_b.invocations);
    try expectEqual(@as(*anyopaque, &publisher), state_a.last_publisher);
    try expectEqual(@as(*anyopaque, &state_a), state_a.last_context);
    try expectEqual(7, state_a.last_system_data_idx);
    try expectEqual(@as(*const anyopaque, &payload), state_a.last_data);
}

test "publish tolerates a hole created by unsubscribe" {
    var state_a: CountingState = .{};
    var state_c: CountingState = .{};
    var slots = [_]Self{empty} ** 3;

    subscribe(&slots, &state_a, countingCallback);
    subscribe(&slots, null, cbB);
    subscribe(&slots, &state_c, countingCallback2);
    unsubscribe(&slots, cbB);

    try expectEqual(null, slots[1].callback);

    var payload: u32 = 0;
    var publisher: u32 = 0;
    publish(&slots, 0, &payload, &publisher);

    try expectEqual(1, state_a.invocations);
    try expectEqual(1, state_c.invocations);
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
