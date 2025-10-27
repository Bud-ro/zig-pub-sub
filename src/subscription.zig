//! `Subscription` is a callback that takes a (optional) user provided context, some on-change data, and a pointer to the publishing object.
//! Memory for `Subscription`s are managed by the publisher.
//!
//! The identity of a `Subscription` is solely based on its callback pointer
//! `Subscription`s with the same identity cannot exist in the same subscription list.
//! However `Subscription`s with the same identity may exist in separate subscription lists.

/// Creates a subscription type from an existing type. The type must define OnChangeArgs.
pub fn Concrete(T: type) type {
    return struct {
        pub const SubscriptionCallback = *const fn (context: ?*anyopaque, args: *const T.OnChangeArgs, publisher: *T) void;

        context: ?*anyopaque,
        callback: ?SubscriptionCallback,
    };
}
