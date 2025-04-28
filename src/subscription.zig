//! `Subscription` is a callback that takes a reference to SystemData and any user provided context.
//! `Subscription`s are stored in `comptime` sized arrays.
//!
//! The identity of a `Subscription` is solely based on its callback pointer
//! `Subscription`s with the same identity cannot exist in the same subscription list.
//! However `Subscription`s with the same identity may exist in seperate subscription lists.

const SystemData = @import("system_data.zig");

const Subscription = @This();
pub const SubscriptionCallback = *const fn (context: ?*anyopaque, system_data: *SystemData) void;

context: ?*anyopaque,
callback: ?SubscriptionCallback,
