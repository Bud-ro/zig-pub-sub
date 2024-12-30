//! This module provides a RAM data component, which stores data in a packed array.
//! `comptime` makes it so ERD reads and writes are direct,
//! even when performed through higher level abstractions like system_data

const std = @import("std");
const Erd = @import("erd.zig");
const SystemErds = @import("system_erds.zig");

const RamDataComponent = @This();

const StoreStruct = blk: {
    var fields: [num_ram_erds]std.builtin.Type.StructField = undefined;
    for (SystemErds.ram_definitions, 0..) |erd, i| {
        // Fields have the name of "_number"
        const fieldName = std.fmt.comptimePrint("_{}", .{erd.data_component_idx});
        fields[i] = .{
            .name = fieldName,
            .type = erd.T,
            .default_value = null,
            .is_comptime = false,
            // Proper alignment is the default. If you want denser memory
            // then set alignment to 1.
            .alignment = 0,
        };
    }

    const ram_data_struct = @Type(.{
        .@"struct" = .{
            .layout = .auto,
            .fields = fields[0..],
            .decls = &[_]std.builtin.Type.Declaration{},
            .is_tuple = false,
        },
    });

    break :blk ram_data_struct;
};

/// Internal Storage using a comptime defined struct
storage: StoreStruct = undefined,

pub fn init() RamDataComponent {
    var ram_data_component = RamDataComponent{};
    ram_data_component.storage = std.mem.zeroInit(@TypeOf(ram_data_component.storage), .{});
    return ram_data_component;
}

const num_ram_erds = SystemErds.ram_definitions.len;

pub fn read(self: RamDataComponent, erd: Erd) erd.T {
    const fieldName = std.fmt.comptimePrint("_{}", .{erd.data_component_idx});

    return @field(self.storage, fieldName);
}

pub fn write(self: *RamDataComponent, erd: Erd, data: erd.T) bool {
    const fieldName = std.fmt.comptimePrint("_{}", .{erd.data_component_idx});

    const current: erd.T = @field(self.storage, fieldName);
    // TODO: Watch this closely, it might lead to a fair bit of code bloat
    const data_changed = !std.meta.eql(current, data);
    @field(self.storage, fieldName) = data;

    return data_changed;
}
