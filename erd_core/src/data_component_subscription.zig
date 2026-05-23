//! Subscription storage and dispatch mixin for data components.
//!
//! Every data component must have a `subs` field of one of these types so that
//! SystemData can uniformly route subscribe/unsubscribe calls.
//!
//! ```
//! // Component that supports subscriptions:
//! subs: DataComponentSubscription(erds) = .{},
//!
//! // Component that does not:
//! subs: Unsupported = .{},
//! ```

const erd_core = @import("erd_core");
const std = @import("std");
const Erd = erd_core.Erd;
const Subscription = erd_core.Subscription;

/// Validates that every component in `Components` has a `subs` field.
pub fn validateComponents(Components: type) void {
    for (std.meta.fields(Components)) |field| {
        if (!@hasField(field.type, "subs")) {
            @compileError(std.fmt.comptimePrint("Component {s} must have a subs field (use DataComponentSubscription or Unsupported)", .{field.name}));
        }
    }
}

/// Subscription slot storage with subscribe/unsubscribe dispatch.
/// Parameterized by the ERD slice to compute slot counts and offsets at comptime.
pub fn DataComponentSubscription(comptime erds: []const Erd) type {
    return struct {
        const Self = @This();
        /// Whether this component supports subscriptions.
        pub const supported = true;

        /// Comptime-computed offsets into the flat subscription slot array per ERD.
        pub const sub_offsets = blk: {
            var _offsets: [erds.len]usize = undefined;
            var cur_offset: usize = 0;
            for (erds, 0..) |erd, i| {
                _offsets[i] = cur_offset;
                cur_offset += erd.subs;
            }
            break :blk _offsets;
        };

        slots: [totalSubSlots()]Subscription = @splat(.{ .context = null, .callback = null }),

        fn totalSubSlots() usize {
            var size: usize = 0;
            for (erds) |erd| {
                size += erd.subs;
            }
            return size;
        }

        /// Add a subscription callback for an ERD. Deduplicates by callback identity.
        pub fn subscribe(self: *Self, erd: Erd, context: ?*anyopaque, fn_ptr: Subscription.Callback) void {
            std.debug.assert(erd.subs > 0);
            self.subscribeInner(sub_offsets[erd.data_component_idx], erd.subs, context, fn_ptr);
        }

        // noinline so callsites compile to argument setup + jump, not a full inlined scan/dedup loop.
        noinline fn subscribeInner(self: *Self, offset: usize, count: usize, context: ?*anyopaque, fn_ptr: Subscription.Callback) void {
            Subscription.subscribe(self.slots[offset..][0..count], context, fn_ptr);
        }

        /// Remove a subscription callback for an ERD by identity.
        pub fn unsubscribe(self: *Self, erd: Erd, fn_ptr: Subscription.Callback) void {
            std.debug.assert(erd.subs > 0);
            self.unsubscribeInner(sub_offsets[erd.data_component_idx], erd.subs, fn_ptr);
        }

        // noinline so callsites compile to argument setup + jump, not a full inlined scan loop.
        noinline fn unsubscribeInner(self: *Self, offset: usize, count: usize, fn_ptr: Subscription.Callback) void {
            Subscription.unsubscribe(self.slots[offset..][0..count], fn_ptr);
        }
    };
}

/// Stub for components that do not support subscriptions.
/// Any attempt to subscribe or unsubscribe is a compile error.
pub const Unsupported = struct { // zlinter-disable-current-line declaration_naming
    /// Whether this component supports subscriptions.
    pub const supported = false;
    /// Empty offset array for interface compatibility.
    pub const sub_offsets = [_]usize{};

    /// Compile error: this component does not support subscriptions.
    pub fn subscribe(_: *@This(), _: Erd, _: ?*anyopaque, _: Subscription.Callback) void {
        @compileError("This component does not support subscriptions");
    }

    /// Compile error: this component does not support unsubscribe.
    pub fn unsubscribe(_: *@This(), _: Erd, _: Subscription.Callback) void {
        @compileError("This component does not support subscriptions");
    }
};
