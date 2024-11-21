//! This module provides a RAM data component, which stores data in a packed array.
//! `comptime` makes it so ERD reads and writes are direct,
//! even when performed through higher level abstractions like system_data

const std = @import("std");
const Erd = @import("erd.zig").Erd;

const RamDataComponent = @This();

// TODO: Add a flag that reorders fields to efficiently pack this
// and another that guarantees alignment for faster R/W.
storage: [store_size()]u8 = undefined,

pub fn init() RamDataComponent {
    var ram_data_component = RamDataComponent{};
    @memset(ram_data_component.storage[0..], 0);
    return ram_data_component;
}

const WellPackedStruct = struct {
    a: u8,
    b: u8,
    c: u16,
};

const PaddedStruct = struct {
    a: u8,
    b: u16,
    c: bool,
    d: u32,
};

const PackedFr = packed struct {
    a: u5,
    b: u5,
    c: u5,
    d: u5,
    e: u1,
    f: u1,
    g: u1,
};

// ERD definitions
const RamErdDefinition = struct {
    // zig fmt: off
    application_version: Erd = .{ .T = u32              },
    some_bool:           Erd = .{ .T = bool             },
    unaligned_u16:       Erd = .{ .T = u16              },
    well_packed:         Erd = .{ .T = WellPackedStruct },
    padded:              Erd = .{ .T = PaddedStruct     },
    actually_packed_fr:  Erd = .{ .T = PackedFr         },
    // zig fmt: on
};
pub const erds = blk: {
    var _erds = RamErdDefinition{};
    for (std.meta.fieldNames(RamErdDefinition), 0..) |erd_field_name, i| {
        @field(_erds, erd_field_name).idx = i;
    }

    break :blk _erds;
};

const num_erds = std.meta.fields(RamErdDefinition).len;
const ram_offsets = blk: {
    var _ram_offsets: [num_erds]usize = undefined;
    var cur_offset = 0;
    for (std.meta.fieldNames(RamErdDefinition), 0..) |erd_field_name, i| {
        _ram_offsets[i] = cur_offset;
        cur_offset += @sizeOf(@field(erds, erd_field_name).T);
    }

    break :blk _ram_offsets;
};

pub fn store_size() usize {
    comptime {
        var size: usize = 0;
        for (std.meta.fieldNames(RamErdDefinition)) |erd_field_name| {
            size += @sizeOf(@field(erds, erd_field_name).T);
        }
        return size;
    }
}

pub fn read(self: *RamDataComponent, erd: Erd) erd.T {
    const idx = erd.idx;

    return std.mem.bytesAsValue(erd.T, self.storage[ram_offsets[idx] .. ram_offsets[idx] + @sizeOf(erd.T)]).*;
}

pub fn write(self: *RamDataComponent, erd: Erd, data: erd.T) void {
    const idx = erd.idx;

    self.storage[ram_offsets[idx] .. ram_offsets[idx] + @sizeOf(erd.T)].* = std.mem.toBytes(data);
}
