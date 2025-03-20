//! This module provides an indirect data component which uses function calls
//! that handle reads. Writes are not supported.
//! If you want code to run on write, then you should use an ERD subscription or the converted data component

const std = @import("std");
const Erd = @import("erd.zig");
const SystemErds = @import("system_erds.zig");

const IndirectDataComponent = @This();

const num_erds = SystemErds.indirect_definitions.len;

read_functions: [num_erds](*addrspace(.flash) const anyopaque) = undefined,

pub const IndirectErdMapping = struct {
    erd: Erd,
    fn_ptr: *addrspace(.flash) const anyopaque,

    /// Compile-time guarantees a valid mapping
    pub fn map(erd: Erd, func: *addrspace(.flash) const fn () erd.T) IndirectErdMapping {
        return .{ .erd = erd, .fn_ptr = @ptrCast(func) };
    }
};

pub fn init(erdMappings: [num_erds]IndirectErdMapping) IndirectDataComponent {
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
    const fn_ptr: *const fn () erd.T = @ptrCast(self.read_functions[erd.data_component_idx]);
    return fn_ptr();
}

pub fn write(self: IndirectDataComponent, erd: Erd, data: erd.T) void {
    _ = self;
    _ = data;
    @compileError("Indirect ERD writes are not allowed");
}
