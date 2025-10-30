//! `Subscription` allows publishers to send events to multiple subscribers.
//! On publish, each client's callback will receive user provided context (optional), args associated with the publication, and a pointer to the publisher.
//! `Subscription`s are owned by the publisher, typically in a `comptime` sized array or slice.
//!
//! The identity of a `Subscription` is solely based on its callback pointer.
//! `Subscription`s with the same identity cannot be known to the same publisher.
//! However `Subscription`s with the same identity may subscribe to several source.

const SystemData = @import("system_data.zig");

const Subscription = @This();
pub const SubscriptionCallback = *const fn (context: ?*anyopaque, args: ?*const anyopaque, publisher: *anyopaque) void;

context: ?*anyopaque,
callback: ?SubscriptionCallback,
