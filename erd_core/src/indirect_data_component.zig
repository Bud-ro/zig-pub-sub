//! This module provides an indirect data component which uses function calls
//! that handle reads. Writes are not supported.
//! If you want code to run on write, then you should use an ERD subscription or the converted data component

const erd_core = @import("erd_core");
const Erd = erd_core.Erd;
const subscription_mixin = erd_core.data_component.subscription_mixin;

pub const Mapping = struct {
    erd: Erd,
    fn_ptr: *const anyopaque,

    pub fn map(comptime erd: Erd, func: *const fn (*erd.T) void) Mapping {
        return .{ .erd = erd, .fn_ptr = func };
    }
};

pub fn IndirectDataComponent(comptime erds: []const Erd, comptime erd_mappings: [erds.len]Mapping) type {
    return struct {
        const Self = @This();

        pub const supports_write = false;

        read_functions: [erds.len]*const anyopaque = initFunctions(),
        subs: subscription_mixin.Unsupported = .{},

        fn initFunctions() [erds.len]*const anyopaque {
            var fns: [erds.len]*const anyopaque = undefined;
            for (erd_mappings) |mapping| {
                fns[mapping.erd.data_component_idx] = mapping.fn_ptr;
            }
            return fns;
        }

        pub fn read(self: Self, erd: Erd) erd.T {
            const fnPtr: *const fn (*erd.T) void = @ptrCast(self.read_functions[erd.data_component_idx]);

            var temp: erd.T = undefined;
            fnPtr(&temp);
            return temp;
        }

        pub fn runtimeRead(self: Self, data_component_idx: u16, data: *anyopaque) void {
            const fnPtr: *const fn ([*]u8) void = @ptrCast(self.read_functions[data_component_idx]);
            fnPtr(@ptrCast(data));
        }

        pub fn write(self: *Self, erd: Erd, data: erd.T, publisher: *anyopaque) void {
            _ = self;
            _ = data;
            _ = publisher;
            @compileError("Indirect ERD writes are not allowed");
        }

        pub fn runtimeWrite(self: *Self, data_component_idx: u16, data: *const anyopaque, publisher: *anyopaque) void {
            _ = self;
            _ = data_component_idx;
            _ = data;
            _ = publisher;
            @compileError("Indirect ERD writes are not allowed");
        }
    };
}
