const std = @import("std");
const Erd = @import("erd.zig").Erd;

const RamDataComponent = @This();

// ERD definitions
const RamErdDefinition = struct {
    application_version: Erd = .{ .T = u32 },
    some_bool: Erd = .{ .T = bool },
    unaligned_u16: Erd = .{ .T = u16 },
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
    var size: usize = 0;
    inline for (std.meta.fieldNames(RamErdDefinition)) |erd_field_name| {
        size += @sizeOf(@field(erds, erd_field_name).T);
    }
    return size;
}

var storage = std.mem.zeroes([store_size()]u8);

pub fn read(self: RamDataComponent, erd: Erd) erd.T {
    _ = self;
    const idx = erd.idx;
    const result: erd.T =
        @bitCast(storage[ram_offsets[idx] .. ram_offsets[idx] + @sizeOf(erd.T)].*);
    return result;
}

pub fn write(self: RamDataComponent, erd: Erd, data: erd.T) void {
    _ = self;
    const idx = erd.idx;
    storage[ram_offsets[idx] .. ram_offsets[idx] + @sizeOf(erd.T)].* = @bitCast(data);
}
