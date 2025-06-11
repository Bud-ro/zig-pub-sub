//! This module provides a RAM data component, which stores data in a packed array.
//! `comptime` makes it so ERD reads and writes are direct,
//! even when performed through higher level abstractions like system_data

const std = @import("std");
const Erd = @import("erd.zig");
const SystemErds = @import("system_erds.zig");

const RamDataComponent = @This();

// TODO: Add a flag that reorders fields to efficiently pack this
// and another that guarantees alignment for faster R/W.
storage: [store_size()]u8 align(@alignOf(usize)) = undefined,

pub fn init() RamDataComponent {
    var ram_data_component = RamDataComponent{};
    @memset(ram_data_component.storage[0..], 0);
    return ram_data_component;
}

const num_ram_erds = SystemErds.ram_definitions.len;
const ram_offsets = blk: {
    var _ram_offsets: [num_ram_erds]usize = undefined;
    var cur_offset = 0;
    for (SystemErds.ram_definitions, 0..) |erd, i| {
        _ram_offsets[i] = cur_offset;
        cur_offset += @sizeOf(erd.T);
    }

    break :blk _ram_offsets;
};
const data_size: [num_ram_erds]u16 = blk: {
    var _data_size: [num_ram_erds]u16 = undefined;

    for (SystemErds.ram_definitions, 0..) |erd, i| {
        _data_size[i] = @sizeOf(erd.T);
    }

    break :blk _data_size;
};

fn store_size() usize {
    var size: usize = 0;
    for (SystemErds.ram_definitions) |erd| {
        size += @sizeOf(erd.T);
    }
    return size;
}

pub fn read(self: RamDataComponent, erd: Erd) erd.T {
    const idx = erd.data_component_idx;

    var value: erd.T = undefined;
    @memcpy(std.mem.asBytes(&value), self.storage[ram_offsets[idx] .. ram_offsets[idx] + @sizeOf(erd.T)]);
    return value;
}

pub fn runtime_read(self: RamDataComponent, data_component_idx: u16, data: *anyopaque) void {
    var data_slice: [*]u8 = @ptrCast(data);
    const size = data_size[data_component_idx];

    @memcpy(data_slice[0..size], self.storage[ram_offsets[data_component_idx] .. ram_offsets[data_component_idx] + size]);
}

pub fn write(self: *RamDataComponent, erd: Erd, data: erd.T) bool {
    const idx = erd.data_component_idx;

    const data_bytes = std.mem.toBytes(data);

    const data_changed = !std.mem.eql(u8, &data_bytes, self.storage[ram_offsets[idx] .. ram_offsets[idx] + @sizeOf(erd.T)]);
    self.storage[ram_offsets[idx] .. ram_offsets[idx] + @sizeOf(erd.T)].* = data_bytes;

    return data_changed;
}

pub fn runtime_write(self: *RamDataComponent, data_component_idx: u16, data: *const anyopaque) bool {
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
// const ram_fields: [num_ram_erds]std.builtin.Type.StructField = blk: {
//     var _fields: [num_ram_erds]std.builtin.Type.StructField = undefined;
//
//     for (SystemErds.ram_definitions, 0..) |erd, i| {
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
