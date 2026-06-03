//! RAM-backed data component: stores every owned ERD's bytes in one packed
//! `storage` array. Per-ERD byte offsets are computed at comptime from the
//! ERD slice, so comptime-dispatched `read`/`write`/`modify` compile to
//! direct loads/stores into `storage` even through the higher-level
//! `SystemData` wrappers. `write`'s trigger publishes when data
//! is bit-for-bit different.

const erd_core = @import("erd_core");
const std = @import("std");
const system_data = @import("system_data.zig");
const Erd = erd_core.Erd;
const DataComponentSubscription = erd_core.data_component.subscription_mixin.DataComponentSubscription;

/// Comptime description of how much RAM a RAM data component spends on a given
/// ERD list. Forward-aligning each ERD's offset (so `publish` can hand out a
/// pointer straight into storage) costs alignment padding, and a pessimal
/// declaration order can nearly double the storage (e.g. alternating u8/u64 is
/// 32 bytes for 18 bytes of payload). This report makes that cost visible; see
/// `RamDataComponent.layout` and `RamDataComponent.assertPaddingAtMost`.
pub const RamLayout = struct {
    /// Sum of `@sizeOf` over every ERD -- the irreducible data size.
    payload_bytes: usize,
    /// Actual storage size, each ERD forward-aligned in declaration order.
    storage_bytes: usize,
    /// `storage_bytes - payload_bytes`: alignment padding paid for the declared
    /// order. Zero when ERDs are declared largest-alignment-first.
    padding_bytes: usize,
    /// Storage size achievable by reordering ERDs largest-alignment-first --
    /// the ordering Zig's auto struct layout would pick. The floor on what any
    /// ordering can reach (`packed_bytes - payload_bytes` is the unavoidable
    /// padding, usually 0).
    packed_bytes: usize,
};

/// Compute the `RamLayout` for `erds` at comptime (zero runtime cost).
pub fn ramLayout(comptime erds: []const Erd) RamLayout {
    return comptime blk: {
        var payload: usize = 0;
        var storage: usize = 0;
        for (erds) |erd| {
            storage = std.mem.alignForward(usize, storage, @alignOf(erd.T));
            storage += @sizeOf(erd.T);
            payload += @sizeOf(erd.T);
        }

        // Optimal-ish packing: place ERDs largest-alignment-first (a tiny
        // selection sort). This removes essentially all interior padding and is
        // the order users should prefer when RAM is tight.
        var order: [erds.len]usize = undefined;
        for (0..erds.len) |i| order[i] = i;
        for (0..erds.len) |i| {
            var best = i;
            for (i + 1..erds.len) |j| {
                if (@alignOf(erds[order[j]].T) > @alignOf(erds[order[best]].T)) best = j;
            }
            const tmp = order[i];
            order[i] = order[best];
            order[best] = tmp;
        }
        var packed_size: usize = 0;
        for (order) |idx| {
            packed_size = std.mem.alignForward(usize, packed_size, @alignOf(erds[idx].T));
            packed_size += @sizeOf(erds[idx].T);
        }

        break :blk RamLayout{
            .payload_bytes = payload,
            .storage_bytes = storage,
            .padding_bytes = storage - payload,
            .packed_bytes = packed_size,
        };
    };
}

/// Construct a RAM-backed data component with packed byte-array storage.
pub fn RamDataComponent(comptime erds: []const Erd) type {
    return struct {
        const Self = @This();

        /// Indicates this component supports writes.
        pub const supports_write = true;
        const Subs = DataComponentSubscription(erds);

        // Storage offsets are forward-aligned per ERD (see `ram_offsets`) and
        // the array is aligned to the widest owned ERD, so `&storage[offset]`
        // is always aligned to that ERD's type. This lets `write`/`modify`
        // publish a pointer straight into storage (no aligned stack copy) and
        // lets subscribers `@alignCast` the on-change pointer safely.
        // Order ERDs largest-alignment-first to avoid padding (a pessimal
        // order can nearly double storage). `layout` reports the cost and
        // `assertPaddingAtMost` can fail the build when it grows too large.
        // TODO: an opt-in flag could auto-reorder fields to minimize padding.
        storage: [storeSize()]u8 align(storageAlign()) = undefined,
        subs: Subs = .{},

        /// Comptime RAM-layout report for this component's ERDs (payload vs
        /// alignment padding vs the optimal largest-first packing). Inspect it
        /// in tests/tooling, or gate on it with `assertPaddingAtMost`.
        pub const layout = ramLayout(erds);

        /// Comptime guard: `@compileError` if alignment padding exceeds
        /// `max_bytes`. Call it from your SystemData/app wiring to stay aware of
        /// RAM spent on padding, e.g. `comptime Components.Ram.assertPaddingAtMost(8);`.
        /// The error reports the smaller size reachable by ordering ERDs
        /// largest-alignment-first.
        pub fn assertPaddingAtMost(comptime max_bytes: usize) void {
            comptime {
                if (layout.padding_bytes > max_bytes) {
                    @compileError(std.fmt.comptimePrint(
                        "RAM data component spends {d} padding bytes ({d} storage for {d} of payload), " ++
                            "over the {d}-byte budget. Order ERDs largest-alignment-first to reach {d} bytes.",
                        .{ layout.padding_bytes, layout.storage_bytes, layout.payload_bytes, max_bytes, layout.packed_bytes },
                    ));
                }
            }
        }

        /// Initialize storage to zero.
        pub fn init() Self {
            var self = Self{};
            @memset(self.storage[0..], 0);
            return self;
        }

        const ram_offsets = blk: {
            var _ram_offsets: [erds.len]usize = undefined;
            var cur_offset: usize = 0;
            for (erds, 0..) |erd, i| {
                cur_offset = std.mem.alignForward(usize, cur_offset, @alignOf(erd.T));
                _ram_offsets[i] = cur_offset;
                cur_offset += @sizeOf(erd.T);
            }

            break :blk _ram_offsets;
        };
        const data_size: [erds.len]u16 = blk: {
            var _data_size: [erds.len]u16 = undefined;

            for (erds, 0..) |erd, i| {
                _data_size[i] = @sizeOf(erd.T);
            }

            break :blk _data_size;
        };

        fn storeSize() usize {
            var size: usize = 0;
            for (erds) |erd| {
                size = std.mem.alignForward(usize, size, @alignOf(erd.T));
                size += @sizeOf(erd.T);
            }
            return size;
        }

        /// Alignment for `storage`: the widest alignment of any owned ERD type,
        /// floored at `@alignOf(usize)`. Combined with forward-aligned per-ERD
        /// offsets, this guarantees `&storage[ram_offsets[i]]` is aligned to
        /// `erds[i].T`. The `@alignOf(usize)` floor keeps `storage` at least as
        /// aligned as the `subs` field, so the struct layout (and thus every
        /// load/store offset) matches the pre-alignment version -- otherwise a
        /// component whose widest ERD is narrower than a pointer would let Zig
        /// reorder `subs` ahead of `storage` and shift every offset.
        fn storageAlign() usize {
            var a: usize = @alignOf(usize);
            for (erds) |erd| {
                a = @max(a, @alignOf(erd.T));
            }
            return a;
        }

        const subs_from_idx: [erds.len]u8 = blk: {
            var _subs: [erds.len]u8 = undefined;
            for (erds, 0..) |erd, i| {
                _subs[i] = erd.subs;
            }
            break :blk _subs;
        };

        const system_data_idx_from_idx: [erds.len]u16 = blk: {
            var _idx: [erds.len]u16 = undefined;
            for (erds, 0..) |erd, i| {
                _idx[i] = erd.system_data_idx;
            }
            break :blk _idx;
        };

        /// Read an ERD value from packed storage by comptime index.
        pub fn read(self: Self, erd: Erd) erd.T {
            const idx = erd.data_component_idx;

            var value: erd.T = undefined;
            @memcpy(std.mem.asBytes(&value), self.storage[ram_offsets[idx] .. ram_offsets[idx] + @sizeOf(erd.T)]);
            return value;
        }

        /// Runtime read using a dynamic data component index.
        pub fn runtimeRead(self: *const Self, data_component_idx: u16, data: *anyopaque) void {
            const data_slice: [*]u8 = @ptrCast(data);
            const size = data_size[data_component_idx];

            @memcpy(data_slice[0..size], self.storage[ram_offsets[data_component_idx] .. ram_offsets[data_component_idx] + size]);
        }

        /// Write and publish if the value changed. When subs == 0, skips comparison entirely.
        /// Uses two comparison strategies depending on type size:
        /// - <= 8 bytes: integer comparison via readInt (single cmp instruction)
        /// - > 8 bytes: typed comparison via std.meta.eql, which lets LLVM see
        ///   field-level relationships and eliminate unchanged field comparisons
        ///   in read-modify-write patterns
        pub fn write(self: *Self, erd: Erd, data: erd.T, publisher: *anyopaque) void {
            const idx = erd.data_component_idx;
            const n = @sizeOf(erd.T);
            const data_bytes = std.mem.toBytes(data);

            if (comptime erd.subs == 0) {
                self.storage[ram_offsets[idx]..][0..n].* = data_bytes;
                return;
            }

            const stored: *[n]u8 = self.storage[ram_offsets[idx]..][0..n];
            const changed = bytesChanged(stored, &data_bytes);
            stored.* = data_bytes;

            if (changed) {
                @branchHint(.likely);
                // `publish` reads the value back from storage; we just wrote it
                // there. Subscribers must not write this same ERD from the
                // callback (it would mutate the bytes being published).
                self.publish(idx, publisher);
            }
        }

        /// Modify a struct ERD in-place and always publish. Skips change detection
        /// since the caller guarantees the modification always produces a new value.
        /// Debug-asserts that the value actually changed.
        pub fn modify(self: *Self, erd: Erd, comptime modifier: *const fn (*erd.T) void, publisher: *anyopaque) void {
            const idx = erd.data_component_idx;
            // Forward-aligned storage offset, so this is the natural alignment
            // of erd.T (not align(1)): faster in-place R/W and a publishable
            // aligned pointer.
            const ptr: *erd.T = @ptrCast(@alignCast(self.storage[ram_offsets[idx]..]));

            var value: erd.T = ptr.*;
            const before = value;
            modifier(&value);
            std.debug.assert(!std.meta.eql(before, value));
            ptr.* = value;

            if (erd.subs > 0) {
                self.publish(idx, publisher);
            }
        }

        fn bytesChanged(a: anytype, b: anytype) bool {
            const len = @typeInfo(@TypeOf(a.*)).array.len;
            if (len <= 16) {
                const Int = @Int(.unsigned, len * 8);
                return std.mem.readInt(Int, a, .little) != std.mem.readInt(Int, b, .little);
            }
            inline for (0..len / 8) |i| {
                if (std.mem.readInt(u64, a[i * 8 ..][0..8], .little) !=
                    std.mem.readInt(u64, b[i * 8 ..][0..8], .little)) return true;
            }
            const tail = len % 8;
            if (tail > 0) {
                const Tail = @Int(.unsigned, tail * 8);
                if (std.mem.readInt(Tail, a[len - tail ..][0..tail], .little) !=
                    std.mem.readInt(Tail, b[len - tail ..][0..tail], .little)) return true;
            }
            return false;
        }

        /// Runtime write with change detection using a dynamic data component index.
        pub fn runtimeWrite(self: *Self, data_component_idx: u16, data: *const anyopaque, publisher: *anyopaque) void {
            const idx = data_component_idx;

            const data_slice: [*]const u8 = @ptrCast(data);
            const size = data_size[data_component_idx];

            const data_changed = !runtimeBytesEqual(data_slice, self.storage[ram_offsets[idx]..].ptr, size);

            @memcpy(self.storage[ram_offsets[idx] .. ram_offsets[idx] + size], data_slice[0..size]);

            if (data_changed and subs_from_idx[data_component_idx] != 0) {
                self.publish(data_component_idx, publisher);
            }
        }

        // noinline so the dispatch logic is shared across all call sites.
        // TODO: Add the option to binary search to save space in `subs_from_idx`
        //   for ERDs with no subscribers
        noinline fn publish(self: *Self, data_component_idx: u16, publisher: *anyopaque) void {
            const offset = Subs.sub_offsets[data_component_idx];
            const count = subs_from_idx[data_component_idx];
            // Read the just-written value straight from storage. The offset is
            // forward-aligned, so the pointer is aligned to the ERD type (safe
            // for subscribers to `@alignCast`). Computing it here -- in the one
            // shared publish body -- keeps every write/modify/runtimeWrite call
            // site to "store + call" with no per-site address materialization,
            // and means subscribers always see the canonical in-storage bytes.
            const data: *const anyopaque = @ptrCast(self.storage[ram_offsets[data_component_idx]..].ptr);
            system_data.publishOnChange(
                self.subs.slots[offset..][0..count],
                system_data_idx_from_idx[data_component_idx],
                data,
                publisher,
            );
        }

        // TODO: This is a neat way of gaining automatic optimized alignment, but MAN
        //       it sucks for actually accessing fields, particularly using runtime info
        //       see if it can eventually be used?
        // const ram_fields: [erds.len]std.builtin.Type.StructField = blk: {
        //     var _fields: [erds.len]std.builtin.Type.StructField = undefined;
        //
        //     for (erds, 0..) |erd, i| {
        //         // Fields have the name of "_number"
        //         const fieldName = std.fmt.comptimePrint("_{}", .{erd.data_component_idx});
        //         _fields[i] = .{
        //             .name = fieldName,
        //             .type = erd.T,
        //             .default_value_ptr = null,
        //             .is_comptime = false,
        //             // Proper alignment is the default. If you want denser memory
        //             // then set alignment to 1.
        //             .alignment = 0,
        //         };
        //     }
        //
        //     break :blk _fields;
        // };
        //
        // const StoreStruct = @Type(.{
        //     .@"struct" = .{
        //         .layout = .auto,
        //         .fields = ram_fields[0..],
        //         .decls = &[_]std.builtin.Type.Declaration{},
        //         .is_tuple = false,
        //     },
        // });
    };
}

/// Shared noinline comparison so runtimeWrite call sites don't each inline
/// LLVM's multi-tier mem.eql expansion (byte/dword/SSE paths).
noinline fn runtimeBytesEqual(a: [*]const u8, b: [*]const u8, len: usize) bool {
    return std.mem.eql(u8, a[0..len], b[0..len]);
}
