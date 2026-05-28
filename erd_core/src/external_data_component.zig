//! External data component for serializing ERD changes to the outside world.
//!
//! `ExternalDataComponent` subscribes individually to each external ERD that
//! has subscription slots. Costs one subscription slot per monitored ERD.
//!
//! Only monitors ERDs with `.published = true`. That field requires a non-null
//! `erd_number` (compile error otherwise). ERDs without `.published` are never
//! published over the wire, even if they have an `erd_number`.

const erd_core = @import("erd_core");
const Erd = erd_core.Erd;
const Subscription = erd_core.Subscription;

/// Function type for sending ERD data externally.
/// Called with the public ERD handle, a pointer to the raw bytes, and the byte count.
pub const SendFn = *const fn (erd_number: u16, data: []const u8) void;

fn validateExternalErds(comptime erds: []const Erd) void {
    for (erds) |erd| {
        if (erd.published and erd.erd_number == null) {
            @compileError("ERD marked .published = true must have a non-null erd_number");
        }
    }
}

/// External data component that subscribes individually to each external ERD.
///
/// RAM cost: one subscription slot per ERD with `.published = true` and `subs > 0`.
///
/// After constructing a SystemData that contains this component's subscriptions,
/// call `postSystemDataInit` to wire up subscriptions.
pub fn ExternalDataComponent(comptime erds: []const Erd) type {
    comptime validateExternalErds(erds);

    return struct {
        const Self = @This();

        sendFn: SendFn,

        /// Number of ERDs this component monitors.
        pub const monitored_count = countMonitored();

        fn countMonitored() usize {
            var count: usize = 0;
            for (erds) |erd| {
                if (erd.published and erd.subs > 0) {
                    count += 1;
                }
            }
            return count;
        }

        /// Initialize with the send function to call on ERD changes.
        pub fn init(sendFn: SendFn) Self {
            return .{ .sendFn = sendFn };
        }

        /// Wire up subscriptions to all external ERDs. Must be called after
        /// SystemData is at its final memory location.
        pub fn postSystemDataInit(self: *Self, sd: anytype) void {
            inline for (erds) |erd| {
                if (erd.published and erd.subs > 0) {
                    const cb = makeCallback(erd);
                    sd.subscribe(@enumFromInt(erd.system_data_idx), @ptrCast(self), cb);
                }
            }
        }

        fn makeCallback(comptime erd: Erd) Subscription.Callback {
            return struct {
                fn cb(context: ?*anyopaque, args: ?*const anyopaque, _: *anyopaque) void {
                    const self: *Self = @ptrCast(@alignCast(context.?));
                    const on_change: *const Subscription.OnChangeArgs = @ptrCast(@alignCast(args.?));
                    const ptr: [*]const u8 = @ptrCast(on_change.data);
                    self.sendFn(erd.erd_number.?, ptr[0..@sizeOf(erd.T)]);
                }
            }.cb;
        }
    };
}
