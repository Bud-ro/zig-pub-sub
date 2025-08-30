//! `Subscription` is a callback that takes a reference to SystemData, (optional) user provided context, and the on-change data.
//! `Subscription`s are stored in `comptime` sized arrays.
//!
//! The identity of a `Subscription` is solely based on its callback pointer
//! `Subscription`s with the same identity cannot exist in the same subscription list.
//! However `Subscription`s with the same identity may exist in separate subscription lists.

const SystemData = @import("system_data.zig");

const Subscription = @This();
// TODO: Consider making this generic so that any T can be used in place of SystemData
pub const SubscriptionCallback = *const fn (context: ?*anyopaque, args: *const SystemData.OnChangeArgs, system_data: *SystemData) void;

context: ?*anyopaque,
callback: ?SubscriptionCallback,
