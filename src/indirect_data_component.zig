//! This module provides an indirect data component which uses function calls
//! that handle reads. Writes are not supported.
//! If you want code to run on write, then you should use an ERD subscription

const std = @import("std");
const Erd = @import("erd.zig").Erd;

const IndirectDataComponent = @This();

const num_erds = std.meta.fields(IndirectErdDefinition).len;

// TODO: Find a better way to do this other than type erasing the functions
// OR if you do type erase functions, at least make sure that it's safe on init
// By making it a compile error to pair functions that don't return an ERD's type
read_functions: [num_erds](*const anyopaque) = undefined,

pub const IndirectErdMapping = struct {
    erd: Erd,
    fn_ptr: *const anyopaque,
};

pub fn init(erdMappings: []const IndirectErdMapping) IndirectDataComponent {
    var indirect_data_component = IndirectDataComponent{};
    // Inline-for is here to guarantee that ERDs don't make it to run time
    // TODO: Verify that the ERDs passed in exactly match our ERD definitions
    inline for (erdMappings) |mapping| {
        indirect_data_component.read_functions[mapping.erd.idx] = mapping.fn_ptr;
    }
    return indirect_data_component;
}

// ERD definitions
const IndirectErdDefinition = struct {
    // zig fmt: off
    always_42:            Erd = .{ .T = u16  },
    another_erd_plus_one: Erd = .{ .T = u16  },
    // zig fmt: on
};
pub const erds = blk: {
    var _erds = IndirectErdDefinition{};
    for (std.meta.fieldNames(IndirectErdDefinition), 0..) |erd_field_name, i| {
        @field(_erds, erd_field_name).idx = i;
    }

    break :blk _erds;
};

pub fn read(self: IndirectDataComponent, erd: Erd) erd.T {
    const fn_ptr: *const fn () erd.T = @ptrCast(self.read_functions[erd.idx]);
    return fn_ptr();
}

pub fn write(self: IndirectDataComponent, erd: Erd, data: erd.T) void {
    _ = self;
    _ = data;
    @compileError("Indirect ERD writes are not allowed");
}
