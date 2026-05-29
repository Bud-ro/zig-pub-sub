//! Wire publisher: subscribes to a comptime-known set of ERDs in a SystemData
//! and republishes each change as `(erd_number, big-endian bytes)` to its own
//! pool of downstream subscribers (e.g. UART transmitter, telemetry logger).
//!
//! Lives in `erd_schema` because it depends on the comptime swap rules from
//! `erd_swap`. It is an ordinary application component: it does not touch the
//! ERD table, does not modify `SystemData`, and does not require any new field
//! on `Erd`. Users bump `.subs += 1` on the ERDs they want monitored.
//!
//! Dispatch is shared across all watched ERDs: one handler function reaches a
//! sorted descriptor table by binary search on `system_data_idx`, copies the
//! value into a stack-local buffer, applies a per-ERD comptime-specialized
//! native->big-endian conversion (`erd_swap.SwapRules(T).applyToBig`, which
//! also handles the active tagged-union variant), and republishes via
//! `Subscription.publish` with `OnChangeArgs{erd_number, be_bytes}`.
//!
//! Usage:
//! ```
//! const Wire = WirePublisher(SD, &.{ erds.temperature, erds.humidity }, 2);
//! var wire = Wire.init();
//! wire.postSystemDataInit(&sd);
//! wire.subscribe(null, uartCallback);
//! ```

const erd_core = @import("erd_core");
const swap = @import("erd_swap.zig");
const Erd = erd_core.Erd;
const Subscription = erd_core.Subscription;

/// Comptime descriptor for a single watched ERD: the system_data_idx that
/// identifies its incoming on-change event, the public erd_number to publish
/// outward, the byte count, and a pointer to a per-ERD comptime-specialized
/// native->big-endian conversion. A flat swap-rule table cannot be used here
/// because tagged-union ERDs need a runtime tag-dependent variant swap, which
/// only the type-specialized `SwapRules(T).applyToBig` can express.
///
/// `swapToBig` is null for ERDs whose value is wire-identical to native order
/// (u8/bool, all-byte structs, `[N]u8`): the handler then skips the indirect
/// call entirely instead of dispatching to a no-op conversion.
const Descriptor = struct {
    system_data_idx: u16,
    erd_number: u16,
    size: u16,
    swapToBig: ?*const fn (buf: []u8) void,
};

/// Build a wire-publisher type that watches the given ERDs in `SD` and
/// republishes them as big-endian bytes to up to `n_subs` downstream listeners.
pub fn WirePublisher(SD: type, comptime watched_erds: []const Erd, n_subs: comptime_int) type {
    comptime validate(watched_erds);
    const built = comptime build(watched_erds);

    return struct {
        const Self = @This();

        /// Args delivered to downstream subscribers. The byte slice points into
        /// a stack-local buffer in the handler and is only valid for the
        /// duration of the callback; subscribers must consume or copy.
        pub const OnChangeArgs = struct {
            erd_number: u16,
            be_bytes: []const u8,
        };

        const descriptors: [built.descriptors.len]Descriptor = built.descriptors[0..built.descriptors.len].*;
        const max_size: usize = built.max_size;

        subs: [n_subs]Subscription = @splat(.{ .context = null, .callback = null }),

        /// Construct a zero-initialized publisher with no downstream subscribers.
        pub fn init() Self {
            return .{};
        }

        /// Subscribe to every watched ERD in `sd`. Must be called after `sd`
        /// is at its final memory location (it stashes `self` as the context).
        pub fn postSystemDataInit(self: *Self, sd: *SD) void {
            inline for (watched_erds) |erd| {
                const erd_enum: SD.ErdEnumType = @enumFromInt(erd.system_data_idx);
                sd.subscribe(erd_enum, @ptrCast(self), handler);
            }
        }

        /// Add a downstream subscriber. Deduplicates by callback identity.
        pub fn subscribe(self: *Self, context: ?*anyopaque, cb: Subscription.Callback) void {
            Subscription.subscribe(&self.subs, context, cb);
        }

        /// Remove a downstream subscriber by callback identity.
        pub fn unsubscribe(self: *Self, cb: Subscription.Callback) void {
            Subscription.unsubscribe(&self.subs, cb);
        }

        /// Shared subscription callback installed on every watched ERD. The
        /// SD-side subscription dedupes by callback identity per-ERD-slot-pool;
        /// since each watched ERD has its own slot pool, the same `handler`
        /// function can subscribe to all of them without dedup collisions. The
        /// `args.system_data_idx` distinguishes which ERD just fired.
        ///
        /// Public so codegen snapshots and white-box tests can invoke the
        /// dispatch/swap/republish core directly: the live call from
        /// `SystemData` is indirect (through a `Subscription.Callback` pointer)
        /// and so is invisible to call-graph-following tools. Not part of the
        /// stable API.
        pub fn handler(context: ?*anyopaque, args: ?*const anyopaque, publisher: *anyopaque) void {
            const self: *Self = @ptrCast(@alignCast(context.?));
            const change: *const erd_core.system_data.OnChangeArgs = @ptrCast(@alignCast(args.?));

            const desc = binarySearch(change.system_data_idx) orelse return;

            // Copy the native-endian bytes into a stack-local buffer sized to
            // the largest watched ERD, then convert to big-endian in-place via
            // this ERD's specialized conversion (handles tagged-union variants).
            var buf: [max_size]u8 = undefined;
            const src: [*]const u8 = @ptrCast(change.data);
            @memcpy(buf[0..desc.size], src[0..desc.size]);
            if (desc.swapToBig) |swapToBig| swapToBig(buf[0..desc.size]);

            publishWire(&self.subs, desc.erd_number, buf[0..desc.size], publisher);
        }

        /// Shared noinline dispatcher for wire-publisher-shaped publishes.
        /// Takes the args fields individually (rather than the struct by
        /// value) so callers stay tail-callable -- mirroring the pattern
        /// `system_data.publishOnChange` uses for the OnChangeArgs case.
        noinline fn publishWire(slots: []Subscription, erd_number: u16, be_bytes: []const u8, publisher: *anyopaque) void {
            const out: OnChangeArgs = .{ .erd_number = erd_number, .be_bytes = be_bytes };
            for (slots) |*sub| {
                const cb = sub.callback orelse continue;
                cb(sub.context, @ptrCast(&out), publisher);
            }
        }

        fn binarySearch(idx: u16) ?*const Descriptor {
            var lo: usize = 0;
            var hi: usize = descriptors.len;
            while (lo < hi) {
                const mid = lo + (hi - lo) / 2;
                const cur = descriptors[mid].system_data_idx;
                if (cur == idx) return &descriptors[mid];
                if (cur < idx) {
                    lo = mid + 1;
                } else {
                    hi = mid;
                }
            }
            return null;
        }
    };
}

fn validate(comptime watched: []const Erd) void {
    var seen: [watched.len]u16 = undefined;
    for (watched, 0..) |erd, i| {
        if (erd.erd_number == null) {
            @compileError("WirePublisher watched ERD has null erd_number");
        }
        if (erd.subs == 0) {
            @compileError("WirePublisher watched ERD must have subs > 0; bump its `.subs` and rebuild");
        }
        if (@typeInfo(erd.T) == .@"union") {
            @compileError("WirePublisher cannot serialize a bare union ERD '" ++ @typeName(erd.T) ++
                "': there is no tag to select the active variant. Wrap it in an extern struct " ++
                "{ tag, payload } so the variant is known at swap time.");
        }
        for (seen[0..i]) |prev_idx| {
            if (prev_idx == erd.system_data_idx) {
                @compileError("WirePublisher watched_erds contains a duplicate ERD");
            }
        }
        seen[i] = erd.system_data_idx;
    }
}

const Built = struct {
    descriptors: []const Descriptor,
    max_size: usize,
};

fn build(comptime watched: []const Erd) Built {
    // Sort indices by system_data_idx so the descriptor table is monotonic
    // for binary search. Selection sort: comptime, N is small.
    var order: [watched.len]usize = undefined;
    for (0..watched.len) |i| order[i] = i;
    for (0..watched.len) |i| {
        var min_j = i;
        for (i + 1..watched.len) |j| {
            if (watched[order[j]].system_data_idx < watched[order[min_j]].system_data_idx) {
                min_j = j;
            }
        }
        const tmp = order[i];
        order[i] = order[min_j];
        order[min_j] = tmp;
    }

    var descs: [watched.len]Descriptor = undefined;
    var max_size: usize = 0;
    for (order, 0..) |src_idx, i| {
        const erd = watched[src_idx];
        descs[i] = .{
            .system_data_idx = erd.system_data_idx,
            .erd_number = erd.erd_number.?,
            .size = @sizeOf(erd.T),
            .swapToBig = if (swap.needsSwap(erd.T)) &swap.SwapRules(erd.T).applyToBig else null,
        };
        if (@sizeOf(erd.T) > max_size) max_size = @sizeOf(erd.T);
    }

    const frozen_descs = descs;
    return .{
        .descriptors = &frozen_descs,
        .max_size = max_size,
    };
}
