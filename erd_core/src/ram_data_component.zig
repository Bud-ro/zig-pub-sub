//! This module provides a RAM data component, which stores data in a packed array.
//! `comptime` makes it so ERD reads and writes are direct,
//! even when performed through higher level abstractions like system_data

const erd_core = @import("erd_core");
const std = @import("std");
const Erd = erd_core.Erd;
const Subscription = erd_core.Subscription;
const DataComponentSubscription = erd_core.data_component.subscription_mixin.DataComponentSubscription;

pub fn RamDataComponent(comptime erds: []const Erd) type {
    return struct {
        const Self = @This();

        pub const supports_write = true;
        const Subs = DataComponentSubscription(erds);

        // TODO: Add a flag that reorders fields to efficiently pack this
        // and another that guarantees alignment for faster R/W.
        storage: [storeSize()]u8 align(@alignOf(usize)) = undefined,
        subs: Subs = .{},

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

        pub fn read(self: Self, erd: Erd) erd.T {
            const idx = erd.data_component_idx;

            var value: erd.T = undefined;
            @memcpy(std.mem.asBytes(&value), self.storage[ram_offsets[idx] .. ram_offsets[idx] + @sizeOf(erd.T)]);
            return value;
        }

        pub fn runtimeRead(self: Self, data_component_idx: u16, data: *anyopaque) void {
            var data_slice: [*]u8 = @ptrCast(data);
            const size = data_size[data_component_idx];

            @memcpy(data_slice[0..size], self.storage[ram_offsets[data_component_idx] .. ram_offsets[data_component_idx] + size]);
        }

        /// Write and publish if the value changed. When subs == 0, skips comparison entirely.
        /// Uses two comparison strategies depending on type size:
        /// - ≤ 8 bytes: integer comparison via readInt (single cmp instruction)
        /// - > 8 bytes: typed comparison via std.meta.eql, which lets LLVM see
        ///   field-level relationships and eliminate unchanged field comparisons
        ///   in read-modify-write patterns
        pub fn write(self: *Self, erd: Erd, data: erd.T, publisher: *anyopaque) void {
            const idx = erd.data_component_idx;
            const n = @sizeOf(erd.T);
            const data_bytes = std.mem.toBytes(data);

            if (erd.subs == 0) {
                self.storage[ram_offsets[idx]..][0..n].* = data_bytes;
                return;
            }

            const changed = if (n <= 8) blk: {
                const stored: *[n]u8 = self.storage[ram_offsets[idx]..][0..n];
                const data_changed = bytesChanged(stored, &data_bytes);
                stored.* = data_bytes;
                break :blk data_changed;
            } else blk: {
                const old = self.read(erd);
                self.storage[ram_offsets[idx]..][0..n].* = data_bytes;
                break :blk !std.meta.eql(old, data);
            };

            if (changed) {
                self.publish(erd.data_component_idx, &data, publisher);
            }
        }

        fn bytesChanged(a: anytype, b: anytype) bool {
            const len = @typeInfo(@TypeOf(a.*)).array.len;
            const Int = std.meta.Int(.unsigned, len * 8);
            return std.mem.readInt(Int, a, .little) != std.mem.readInt(Int, b, .little);
        }

        pub fn writeNoCompare(self: *Self, erd: Erd, data: erd.T) void {
            const idx = erd.data_component_idx;
            self.storage[ram_offsets[idx] .. ram_offsets[idx] + @sizeOf(erd.T)].* = std.mem.toBytes(data);
        }

        pub fn runtimeWrite(self: *Self, data_component_idx: u16, data: *const anyopaque, publisher: *anyopaque) void {
            const idx = data_component_idx;

            const data_slice: [*]const u8 = @ptrCast(data);
            const size = data_size[data_component_idx];

            const data_changed = !std.mem.eql(u8, data_slice[0..size], self.storage[ram_offsets[idx] .. ram_offsets[idx] + size]);

            @memcpy(self.storage[ram_offsets[idx] .. ram_offsets[idx] + size], data_slice[0..size]);

            if (data_changed and subs_from_idx[data_component_idx] != 0) {
                self.publish(data_component_idx, data, publisher);
            }
        }

        // noinline so the dispatch logic is shared across all call sites.
        // Create .rodata that is indexed by `system_data_idx`
        // The size of this is 4*numErds which means this will reach well over 4kB of ROM.
        // TODO: Add the option to binary search and avoid a large chunk of this cost
        noinline fn publish(self: *Self, data_component_idx: u16, data: *const anyopaque, publisher: *anyopaque) void {
            const offset = Subs.sub_offsets[data_component_idx];
            const count = subs_from_idx[data_component_idx];
            for (self.subs.slots[offset .. offset + count]) |sub| {
                if (sub.callback) |cb| {
                    const args: Subscription.OnChangeArgs = .{
                        .system_data_idx = system_data_idx_from_idx[data_component_idx],
                        .data = data,
                    };
                    cb(sub.context, @ptrCast(&args), publisher);
                }
            }
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
