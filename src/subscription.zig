//! Subscription is a callback that takes a reference to SystemData.
//! Subscriptions are stored in `comptime` sized arrays.
//! It is a runtime error if the same subscription is added to the same list multiple times.
//! The same Subscription can be added to different subscription lists however.

const SystemData = @import("system_data.zig");

const Subscription = @This();
pub const SubscriptionCallback = *const fn (*SystemData) void;

callback: ?SubscriptionCallback,
