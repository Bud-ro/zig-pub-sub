//! Subscription is a linked list item used to store a callback
//! It is stored local to a module in static memory.

const SystemData = @import("system_data.zig");

const Subscription = @This();
const SubscriptionCallback = *const fn (*SystemData) void;

callback: SubscriptionCallback = undefined,
next_sub: ?*Subscription = null,
