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
        ///   and no separate "assert changed" path. (When LLVM keeps the compare
        ///   field-level it also ignores padding; for fully-traceable values it
        ///   may fold to a byte compare instead -- either way it never misses a
        ///   real change.)
        /// - everything else (primitives, float-bearing types, and structs
        ///   std.meta.eql cannot compare, e.g. those with an extern union --
        ///   see fieldComparable): integer comparison via readInt (a single
        ///   cmp). Floats deliberately take this bit-exact path so a
        ///   struct-embedded float behaves the same as a scalar float ERD
        ///   (std.meta.eql would compare floats with `==`, treating +0.0 and
        ///   -0.0 as equal and any NaN as unequal -- inconsistent and a missed
        ///   publish for a real +0.0 -> -0.0 change).
        pub fn write(self: *Self, erd: Erd, data: erd.T, publisher: *anyopaque) void {
            const idx = erd.data_component_idx;
            const n = @sizeOf(erd.T);
            const stored: *[n]u8 = self.storage[ram_offsets[idx]..][0..n];

            if (comptime erd.subs == 0) {
                stored.* = std.mem.toBytes(data);
                return;
            }

            if (comptime @typeInfo(erd.T) == .@"struct" and fieldComparable(erd.T)) {
                // Field-aware path for structs: compare the typed old/new values
                // (not raw bytes) so LLVM can fold provably-unchanged fields and
                // prove changed ones, and store the TYPED value (not a
                // pre-materialized byte array). The typed store is essential: a
                // byte-array store coalesces `data` into one opaque word, which
                // severs LLVM's field-level view and forces a full-width
                // reconstruct/compare for register-sized structs (an 8-byte
                // {u32,u32}). Together these reduce a read-modify-write to an
                // in-place field update plus a guaranteed publish -- never a
                // full-struct compare, no "assert changed" hack. When LLVM
                // keeps this field-level the compare also ignores padding; for
                // fully-traceable values it may fold to a byte compare (padding
                // included) -- harmless, since a real field change is always
                // detected either way.
                //
                // The old value is read through a typed (align-1) POINTER rather
                // than `@bitCast(stored.*)`: @bitCast to erd.T requires a
                // guaranteed in-memory layout, so it rejects ordinary
                // auto-layout structs (the common case) at compile time, while a
                // pointer cast + load works for any layout and keeps the same
                // field-level view for LLVM.
                const changed = !std.meta.eql(@as(*align(1) const erd.T, @ptrCast(stored)).*, data);
                @as(*align(1) erd.T, @ptrCast(stored)).* = data;
                if (changed) {
                    // .likely is a block-layout hint (matching the else branch):
                    // it keeps publish as the fall-through so a function with
                    // many inlined writes does not tail-duplicate its
                    // change-checks. On cores without a branch predictor this is
                    // a code-size effect, not a speed one.
                    @branchHint(.likely);
                    // `publish` reads the value back from storage; we just wrote
                    // it there. Subscribers must not write this same ERD from the
                    // callback (it would mutate the bytes being published).
                    // TODO(re-entrancy): forbidding a subscriber from writing its
                    // own ERD is currently only documented, not enforced. Come
                    // back and add a debug-only per-ERD "publishing" guard (in
                    // the spirit of assert_sometimes) so a self-write or a
                    // publish cycle trips an assertion in safety builds. See the
                    // contract note in Subscription.zig.
                    self.publish(idx, publisher);
                }
            } else {
                // Primitives (and structs std.meta.eql cannot compare): a single
                // readInt compare and a byte store -- the typed store gives these
                // no benefit and can cost a byte (e.g. bool masking). The
                // @branchHint keeps publish on the hot path so a function with
                // many inlined writes does not tail-duplicate its change-checks.
                const data_bytes = std.mem.toBytes(data);
                const changed = bytesChanged(stored, &data_bytes);
                stored.* = data_bytes;
                if (changed) {
                    @branchHint(.likely);
                    self.publish(idx, publisher);
                }
            }
        }

        /// True if a value of `T` should use the field-aware std.meta.eql path:
        /// `T` must be std.meta.eql-comparable (no untagged/bare/extern union
        /// anywhere) AND contain no float (floats use the bit-exact byte path
        /// for consistent +0.0/-0.0/NaN handling -- see write). Field-aware
        /// comparison is what lets LLVM fold unchanged fields and prove changed
        /// fields in read-modify-write patterns; everything else falls back to a
        /// raw byte compare.
        fn fieldComparable(T: type) bool {
            return switch (@typeInfo(T)) {
                .int, .bool, .@"enum", .void => true,
                // Floats fall back to the bit-exact byte compare (see write):
                // std.meta.eql compares them with `==`, which is inconsistent
                // with scalar float ERDs and misses a real +0.0 -> -0.0 change.
                .float => false,
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
