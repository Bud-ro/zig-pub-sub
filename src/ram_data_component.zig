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

// ERD definitions
const RamErdDefinition = struct {
    // zig fmt: off
    application_version: Erd = .{ .T = u32  },
    some_bool:           Erd = .{ .T = bool },
    unaligned_u16:       Erd = .{ .T = u16  },
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
        else => {
            self.storage[ram_offsets[idx] .. ram_offsets[idx] + @sizeOf(erd.T)].* = @bitCast(data);
        },
    }
}
