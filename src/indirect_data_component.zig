//! This module provides an indirect data component which uses function calls
//! that handle reads. Writes are not supported.
//! If you want code to run on write, then you should use an ERD subscription or the converted data component

const std = @import("std");
const Erd = @import("erd.zig");
const SystemErds = @import("system_erds.zig");

const IndirectDataComponent = @This();

const num_indirect_erds = SystemErds.indirect_definitions.len;

read_functions: [num_indirect_erds](*const anyopaque) = undefined,

pub const IndirectErdMapping = struct {
    erd: Erd,
    fn_ptr: *const anyopaque,

    /// Compile-time guarantees a valid mapping
    pub fn map(erd: Erd, func: *const fn (*erd.T) void) IndirectErdMapping {
        return .{ .erd = erd, .fn_ptr = func };
    }
};

pub fn init(erdMappings: [num_indirect_erds]IndirectErdMapping) IndirectDataComponent {
    var indirect_data_component = IndirectDataComponent{};

    inline for (erdMappings) |mapping| {
        comptime {
            std.debug.assert(mapping.erd.owner == .Indirect);
        }
        indirect_data_component.read_functions[mapping.erd.data_component_idx] = mapping.fn_ptr;
    }
    return indirect_data_component;
}

pub fn read(self: IndirectDataComponent, erd: Erd) erd.T {
    const fn_ptr: *const fn (*erd.T) void = @ptrCast(self.read_functions[erd.data_component_idx]);

    var temp: erd.T = undefined;
    fn_ptr(&temp);
    return temp;
}

pub fn runtime_read(self: IndirectDataComponent, data_component_idx: u16, data: *anyopaque) void {
    const fn_ptr: *const fn ([*]u8) void = @ptrCast(self.read_functions[data_component_idx]);
    fn_ptr(@ptrCast(data));
}

pub fn write(self: *IndirectDataComponent, erd: Erd, data: erd.T) bool {
    _ = self;
    _ = data;
    @compileError("Indirect ERD writes are not allowed");
}

pub fn runtime_write(self: *IndirectDataComponent, data_component_idx: u16, data: *const anyopaque) bool {
    _ = self;
    _ = data_component_idx;
    _ = data;
    @compileError("Indirect ERD writes are not allowed");
}
