const std = @import("std");
const Erd = @import("erd.zig").Erd;

const RamDataComponent = @This();

storage: [store_size()]u8,

pub fn init() RamDataComponent {
    const ram_data_component = RamDataComponent{ .storage = std.mem.zeroes([store_size()]u8) };
    return ram_data_component;
}

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

pub fn read(self: *RamDataComponent, erd: Erd) erd.T {
    const idx = erd.idx;

    const result: erd.T = switch (@typeInfo(erd.T)) {
        .Bool => blk: {
            break :blk @as(u8, @bitCast(self.storage[ram_offsets[idx] .. ram_offsets[idx] + @sizeOf(erd.T)].*)) != 0;
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
            self.storage[ram_offsets[idx] .. ram_offsets[idx] + @sizeOf(erd.T)].* = @bitCast(@as(u8, @intFromBool(data)));
        },
        else => {
            self.storage[ram_offsets[idx] .. ram_offsets[idx] + @sizeOf(erd.T)].* = @bitCast(data);
        },
    }
}
