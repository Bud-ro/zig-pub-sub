const std = @import("std");
const Erd = @import("erd.zig").Erd;
const ErdType = @import("erd.zig").ErdType;

const RamDataComponent = @This();

// ERD definitions
const RamErdDefinition = struct {
    application_version: Erd = .{ .erd_handle = 0x0000, .T = u32 },
};
pub const erds = RamErdDefinition{};

// const erd = RamErdDefinition{};

const num_erds = std.meta.fields(RamErdDefinition).len;
const ram_offsets = blk: {
    var _ram_offsets: [num_erds]usize = undefined;
    var cur_offset = 0;
    for (std.meta.fieldNames(RamErdDefinition), 0..) |erdName, i| {
        _ram_offsets[i] = cur_offset;
        cur_offset += @sizeOf(@field(erds, erdName).T);
    }

    break :blk _ram_offsets;
};

pub fn store_size() usize {
    var size: usize = 0;
    inline for (std.meta.fieldNames(RamErdDefinition)) |erdName| {
        size += @sizeOf(@field(erds, erdName).T);
    }
    return size;
}

var storage = std.mem.zeroes([store_size()]u8);

pub fn read(self: RamDataComponent, erd: Erd) ErdType(erd) {
    _ = self;
    const result: ErdType(erd) =
        @bitCast(storage[ram_offsets[erd.erd_handle] .. ram_offsets[erd.erd_handle] + @sizeOf(erd.T)].*);
    return result;
}

pub fn write(self: RamDataComponent, erd: Erd, data: ErdType(erd)) void {
    _ = self;
    storage[ram_offsets[erd.erd_handle] .. ram_offsets[erd.erd_handle] + @sizeOf(erd.T)].* = @bitCast(data);
}
