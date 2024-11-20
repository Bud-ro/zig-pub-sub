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

const WellPackedStruct = extern struct {
    a: u8,
    b: u8,
    c: u16,
};

const PaddedStruct = extern struct {
    a: u8,
    b: u16,
    c: u8,
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

    const result: erd.T = switch (@typeInfo(erd.T)) {
        .Bool => blk: {
            break :blk self.storage[ram_offsets[idx]] != 0;
        },
        .Struct => |_struct| blk: {
            if (_struct.backing_integer) |backing_integer| {
                // TODO: This code for packed structs is probably incorrect on the basis
                // that @sizeOf(u24) = 4 for example. This will need to be revisited in the future
                // if it is deemed that packed structs should seriously be considered for use
                //
                // Packed structs have no issues if their bitsize is a multiple of 8 however, and could use the below code
                // TODO: Consider checking for this and deferring to that branch
                const byte_multiple_bits = @sizeOf(backing_integer) * 8;
                const widened_int = std.meta.Int(.unsigned, byte_multiple_bits);
                const representative_bytes: widened_int = @bitCast(self.storage[ram_offsets[idx] .. ram_offsets[idx] + @sizeOf(erd.T)].*);
                break :blk @bitCast(@as(backing_integer, @truncate(representative_bytes)));
            } else {
                break :blk @as(erd.T, @bitCast(self.storage[ram_offsets[idx] .. ram_offsets[idx] + @sizeOf(erd.T)].*));
            }
        },
        else => blk: {
            break :blk @as(erd.T, @bitCast(self.storage[ram_offsets[idx] .. ram_offsets[idx] + @sizeOf(erd.T)].*));
        },
    };

    return result;
}

pub fn write(self: *RamDataComponent, erd: Erd, data: erd.T) void {
    const idx = erd.idx;

    switch (@typeInfo(erd.T)) {
        .Bool => {
            self.storage[ram_offsets[idx]] = @intFromBool(data);
        },
        .Struct => |_struct| {
            if (_struct.backing_integer) |backing_integer| {
                const byte_multiple_bits = @sizeOf(backing_integer) * 8;
                const widened_int = std.meta.Int(.unsigned, byte_multiple_bits);
                self.storage[ram_offsets[idx] .. ram_offsets[idx] + @sizeOf(erd.T)].* =
                    @bitCast(@as(widened_int, @intCast(@as(backing_integer, @bitCast(data)))));
            } else {
                self.storage[ram_offsets[idx] .. ram_offsets[idx] + @sizeOf(erd.T)].* = @bitCast(data);
            }
        },
        else => {
            self.storage[ram_offsets[idx] .. ram_offsets[idx] + @sizeOf(erd.T)].* = @bitCast(data);
        },
    }
}
