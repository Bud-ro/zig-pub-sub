//! RAM-backed data component: stores every owned ERD's bytes in one packed
//! `storage` array. Per-ERD byte offsets are computed at comptime from the
//! ERD slice, so comptime-dispatched `read`/`write` compile to
//! direct loads/stores into `storage` even through the higher-level
//! `SystemData` wrappers. `write` publishes when the value actually changed
//! (field-aware for structs, so read-modify-write stays cheap and correct).

const erd_core = @import("erd_core");
const std = @import("std");
const system_data = @import("system_data.zig");
const Erd = erd_core.Erd;
const DataComponentSubscription = erd_core.data_component.subscription_mixin.DataComponentSubscription;

/// Construct a RAM-backed data component with packed byte-array storage.
pub fn RamDataComponent(comptime erds: []const Erd) type {
    return struct {
        const Self = @This();

        /// Indicates this component supports writes.
        pub const supports_write = true;
        const Subs = DataComponentSubscription(erds);

        // TODO: an opt-in flag could auto-reorder fields to minimize padding.
        /// Array of bytes where all ERDs are stored back-to-back.
        ///
        /// Depending on strategy, the ERDs may be aligned or not.
        /// For the best codegen, forward-alignment is recommended. Users are expected
        /// to size optimize by arranging RAM ERDs like they would for a struct.
        ///
        /// `sizeReport` gives info on how efficient `storage` is.
        storage: [storeSize()]u8 align(storageAlign()) = undefined,
        subs: Subs = .{},

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

        /// Write and publish if the value changed. When subs == 0, skips the
        /// comparison entirely. Two strategies:
        /// - structs: field-by-field via std.meta.eql, which lets LLVM fold
        ///   provably-unchanged fields and prove changed fields, so a
        ///   read-modify-write (read, tweak a field, write) compiles to an
        ///   in-place update plus a guaranteed publish -- no full-struct compare
        ///   and no separate "assert changed" path. Ignores padding bytes.
        /// - everything else (and structs std.meta.eql cannot compare, e.g.
        ///   those with an extern union -- see fieldComparable): integer
        ///   comparison via readInt (a single cmp).
        pub fn write(self: *Self, erd: Erd, data: erd.T, publisher: *anyopaque) void {
            const idx = erd.data_component_idx;
            const n = @sizeOf(erd.T);
            const data_bytes = std.mem.toBytes(data);

            if (comptime erd.subs == 0) {
                self.storage[ram_offsets[idx]..][0..n].* = data_bytes;
                return;
            }

            const stored: *[n]u8 = self.storage[ram_offsets[idx]..][0..n];
            // Field-aware change detection for structs: comparing the typed
            // old/new values (not raw bytes) lets LLVM fold provably-unchanged
            // fields and prove changed fields in read-modify-write patterns, so
            // write(read-modify-write) reduces to an in-place update plus a
            // publish that is guaranteed (or a single-field check) -- never a
            // full-struct byte comparison, and with no "assert changed" hack.
            // It also ignores padding bytes (a byte compare would not).
            const changed = if (comptime @typeInfo(erd.T) == .@"struct" and fieldComparable(erd.T))
                !std.meta.eql(@as(erd.T, @bitCast(stored.*)), data)
            else
                bytesChanged(stored, &data_bytes);
            stored.* = data_bytes;

            if (changed) {
                // Most of the time we'll be publishing. This branch hint
                // helps push the optimizer to determine if `changed` is
                // a constant in some situations. (ie: write(read() + 1))
                @branchHint(.likely);
                self.publish(idx, publisher);
            }
        }

        /// True if `std.meta.eql` can compare values of `T` -- i.e. `T` contains
        /// no untagged (bare/extern) union anywhere. Field-aware comparison is
        /// what lets LLVM fold unchanged fields and prove changed fields in
        /// read-modify-write patterns; types it cannot handle fall back to a raw
        /// byte compare.
        fn fieldComparable(T: type) bool {
            return switch (@typeInfo(T)) {
                .int, .float, .bool, .@"enum", .void => true,
                .optional => |o| fieldComparable(o.child),
                .array => |a| fieldComparable(a.child),
                .vector => |v| fieldComparable(v.child),
                .@"struct" => |s| {
                    inline for (s.fields) |f| {
                        if (!fieldComparable(f.type)) return false;
                    }
                    return true;
                },
                .@"union" => |u| {
                    if (u.tag_type == null) return false;
                    inline for (u.fields) |f| {
                        if (!fieldComparable(f.type)) return false;
                    }
                    return true;
                },
                else => false,
            };
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

            // Read the just-written value straight from storage. This is safe
            // to publish as-is assuming forward-alignment was applied.
            const data: *const anyopaque = @ptrCast(self.storage[ram_offsets[data_component_idx]..].ptr);
            system_data.publishOnChange(
                self.subs.slots[offset..][0..count],
                system_data_idx_from_idx[data_component_idx],
                data,
                publisher,
            );
        }

        /// RAM size report for the given `erds` used to construct this type
        pub fn sizeReport(_: *const Self) SizeReport {
            return comptime blk: {
                var payload: usize = 0;
                for (erds) |erd| {
                    payload += @sizeOf(erd.T);
                }
                break :blk SizeReport{
                    .storage_bytes = storeSize(),
                    .payload_bytes = payload,
                };
            };
        }

        /// Description of memory usage for a RAM Data Component.
        ///
        /// Usage varies depending on strategy (packed, forward aligned, auto-arranged, etc.).
        /// Total overhead is given by `storage_bytes - payload_bytes`
        pub const SizeReport = struct {
            /// Actual size of `storage`.
            storage_bytes: usize,
            /// Sum of `@sizeOf` over every ERD. Minimum size for representation.
            payload_bytes: usize,
        };
    };
}

/// Shared noinline comparison so runtimeWrite call sites don't each inline
/// LLVM's multi-tier mem.eql expansion (byte/dword/SSE paths).
noinline fn runtimeBytesEqual(a: [*]const u8, b: [*]const u8, len: usize) bool {
    return std.mem.eql(u8, a[0..len], b[0..len]);
}
