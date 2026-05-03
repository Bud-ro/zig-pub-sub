//! `Subscription` allows publishers to send events to multiple subscribers.
//! On publish, each client's callback will receive user provided context (optional), args associated with the publication, and a pointer to the publisher.
//! `Subscription`s are owned by the publisher, typically in a `comptime` sized array or slice.
//!
//! The identity of a `Subscription` is solely based on its callback pointer.
//! `Subscription`s with the same identity cannot be known to the same publisher.
//! However `Subscription`s with the same identity may subscribe to several source.

pub const Callback = *const fn (context: ?*anyopaque, args: ?*const anyopaque, publisher: *anyopaque) void;

pub const OnChangeArgs = struct {
    system_data_idx: u16,
    data: *const anyopaque,
};

context: ?*anyopaque,
callback: ?Callback,
