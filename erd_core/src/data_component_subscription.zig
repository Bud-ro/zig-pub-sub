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
pub fn validateComponents(comptime Components: type) void {
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
        pub const supported = true;

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

        pub fn subscribe(self: *Self, erd: Erd, context: ?*anyopaque, fn_ptr: Subscription.Callback) void {
            std.debug.assert(erd.subs > 0);
            const offset = sub_offsets[erd.data_component_idx];
            var first_free: ?*Subscription = null;

            for (self.slots[offset .. offset + erd.subs]) |*sub| {
                if (first_free == null and sub.callback == null) {
                    first_free = sub;
                }
                if (sub.callback == fn_ptr) {
                    return;
                }
            }

            if (first_free == null) {
                @panic("ERD oversubscribed!");
            }

            first_free.?.context = context;
            first_free.?.callback = fn_ptr;
        }

        pub fn unsubscribe(self: *Self, erd: Erd, fn_ptr: Subscription.Callback) void {
            std.debug.assert(erd.subs > 0);
            const offset = sub_offsets[erd.data_component_idx];

            for (self.slots[offset .. offset + erd.subs]) |*sub| {
                if (sub.callback == fn_ptr) {
                    sub.callback = null;
                    return;
                }
            }
        }
    };
}

/// Stub for components that do not support subscriptions.
/// Any attempt to subscribe or unsubscribe is a compile error.
pub const Unsupported = struct { // zlinter-disable-current-line declaration_naming
    pub const supported = false;
    pub const sub_offsets = [_]usize{};

    pub fn subscribe(_: *@This(), _: Erd, _: ?*anyopaque, _: Subscription.Callback) void {
        @compileError("This component does not support subscriptions");
    }

    pub fn unsubscribe(_: *@This(), _: Erd, _: Subscription.Callback) void {
        @compileError("This component does not support subscriptions");
    }
};
