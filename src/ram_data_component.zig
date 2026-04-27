//! This module provides a RAM data component, which stores data in a packed array.
//! `comptime` makes it so ERD reads and writes are direct,
//! even when performed through higher level abstractions like system_data

const std = @import("std");
const Erd = @import("erd.zig");

pub fn RamDataComponent(comptime erds: []const Erd) type {
    return struct {
        const Self = @This();

        pub const component_erds = erds;
        pub const supports_write = true;

        // TODO: Add a flag that reorders fields to efficiently pack this
        // and another that guarantees alignment for faster R/W.
        storage: [store_size()]u8 align(@alignOf(usize)) = undefined,

        pub fn init() Self {
            var ram_data_component = Self{};
            @memset(ram_data_component.storage[0..], 0);
            return ram_data_component;
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

        fn store_size() usize {
            var size: usize = 0;
            for (erds) |erd| {
                size += @sizeOf(erd.T);
            }
            return size;
        }

        pub fn read(self: Self, erd: Erd) erd.T {
            const idx = erd.data_component_idx;

            var value: erd.T = undefined;
            @memcpy(std.mem.asBytes(&value), self.storage[ram_offsets[idx] .. ram_offsets[idx] + @sizeOf(erd.T)]);
            return value;
        }

        pub fn runtime_read(self: Self, data_component_idx: u16, data: *anyopaque) void {
            var data_slice: [*]u8 = @ptrCast(data);
            const size = data_size[data_component_idx];

            @memcpy(data_slice[0..size], self.storage[ram_offsets[data_component_idx] .. ram_offsets[data_component_idx] + size]);
        }

        pub fn write_no_compare(self: *Self, erd: Erd, data: erd.T) void {
            const idx = erd.data_component_idx;
            self.storage[ram_offsets[idx] .. ram_offsets[idx] + @sizeOf(erd.T)].* = std.mem.toBytes(data);
        }

        pub fn runtime_write(self: *Self, data_component_idx: u16, data: *const anyopaque) bool {
            const idx = data_component_idx;

            var data_slice: [*]const u8 = @ptrCast(data);
            const size = data_size[data_component_idx];

            const data_changed = !std.mem.eql(u8, data_slice[0..size], self.storage[ram_offsets[idx] .. ram_offsets[idx] + size]);

            @memcpy(self.storage[ram_offsets[idx] .. ram_offsets[idx] + size], data_slice[0..size]);

            return data_changed;
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
