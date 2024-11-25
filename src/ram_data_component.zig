//! This module provides a RAM data component, which stores data in a packed array.
//! `comptime` makes it so ERD reads and writes are direct,
//! even when performed through higher level abstractions like system_data

const std = @import("std");
const Erd = @import("erd.zig");
const SystemErds = @import("system_erds.zig");

const RamDataComponent = @This();

// TODO: Add a flag that reorders fields to efficiently pack this
// and another that guarantees alignment for faster R/W.
storage: [store_size()]u8 = undefined,

pub fn init() RamDataComponent {
    var ram_data_component = RamDataComponent{};
    @memset(ram_data_component.storage[0..], 0);
    return ram_data_component;
}

const num_ram_erds = SystemErds.ram_definitions.len;
const ram_offsets = blk: {
    // TODO: Change this to Erd.ErdHandle
    var _ram_offsets: [num_ram_erds]usize = undefined;
    var cur_offset = 0;
    for (SystemErds.ram_definitions, 0..) |erd, i| {
        _ram_offsets[i] = cur_offset;
        cur_offset += @sizeOf(erd.T);
    }

    break :blk _ram_offsets;
};

fn store_size() usize {
    comptime {
        var size: usize = 0;
        for (SystemErds.ram_definitions) |erd| {
            size += @sizeOf(erd.T);
        }
        return size;
    }
}

pub fn read(self: RamDataComponent, erd: Erd) erd.T {
    const idx = erd.data_component_idx;

    return std.mem.bytesAsValue(erd.T, self.storage[ram_offsets[idx] .. ram_offsets[idx] + @sizeOf(erd.T)]).*;
}

pub fn write(self: *RamDataComponent, erd: Erd, data: erd.T) bool {
    const idx = erd.data_component_idx;

    const buf = self.storage[ram_offsets[idx] .. ram_offsets[idx] + @sizeOf(erd.T)];
    const data_bytes = std.mem.toBytes(data);

    const data_changed = !std.mem.eql(u8, buf, &data_bytes);
    buf.* = data_bytes;

    return data_changed;
}
