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
