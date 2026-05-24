//! RAM-backed data component: stores every owned ERD's bytes in one packed
//! `storage` array. Per-ERD byte offsets are computed at comptime from the
//! ERD slice, so comptime-dispatched `read`/`write`/`modify` compile to
//! direct loads/stores into `storage` even through the higher-level
//! `SystemData` wrappers.
//!
//! `write` does change-detection — a no-op when the new bytes match the old —
//! and publishes to subscribers only when bytes change. `modify` skips
//! change-detection (the caller asserts the value changed) and publishes
//! unconditionally; preferred for struct ERDs with many fields where
//! `write`'s value-copy + compare would balloon code size.

const erd_core = @import("erd_core");
const std = @import("std");
const Erd = erd_core.Erd;
const Subscription = erd_core.Subscription;
const DataComponentSubscription = erd_core.data_component.subscription_mixin.DataComponentSubscription;

/// Construct a RAM-backed data component with packed byte-array storage.
pub fn RamDataComponent(comptime erds: []const Erd) type {
    return struct {
        const Self = @This();

        /// Indicates this component supports writes.
        pub const supports_write = true;
        const Subs = DataComponentSubscription(erds);

        // TODO: Add a flag that reorders fields to efficiently pack this
        // and another that guarantees alignment for faster R/W.
        storage: [storeSize()]u8 align(@alignOf(usize)) = undefined,
        subs: Subs = .{},

        /// Initialize storage to zero.
        pub fn init() Self {
            var self = Self{};
            @memset(self.storage[0..], 0);
            return self;
        }

        const ram_offsets = blk: {
            var _ram_offsets: [erds.len]usize = undefined;
            var cur_offset = 0;
            for (erds, 0..) |erd, i| {
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
                size += @sizeOf(erd.T);
            }
            return size;
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
                self.publish(idx, &data, publisher);
            }
        }

        /// Modify a struct ERD in-place and always publish. Skips change detection
        /// since the caller guarantees the modification always produces a new value.
        /// Debug-asserts that the value actually changed.
        pub fn modify(self: *Self, erd: Erd, comptime modifier: *const fn (*erd.T) void, publisher: *anyopaque) void {
            const idx = erd.data_component_idx;
            const ptr: *align(1) erd.T = @ptrCast(self.storage[ram_offsets[idx]..]);

            var value: erd.T = ptr.*;
            const before = value;
            modifier(&value);
            std.debug.assert(!std.meta.eql(before, value));
            ptr.* = value;

            if (erd.subs > 0) {
                self.publish(idx, ptr, publisher);
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
                self.publish(data_component_idx, data, publisher);
            }
        }

        // noinline so the dispatch logic is shared across all call sites.
        // Resolves per-type lookup tables then delegates to the shared Subscription.publish.
        // TODO: Add the option to binary search and avoid a large chunk of this cost
        noinline fn publish(self: *Self, data_component_idx: u16, data: *const anyopaque, publisher: *anyopaque) void {
            const offset = Subs.sub_offsets[data_component_idx];
            const count = subs_from_idx[data_component_idx];
            Subscription.publish(
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
