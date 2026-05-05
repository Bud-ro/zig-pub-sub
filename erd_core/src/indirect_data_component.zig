//! This module provides an indirect data component which uses function calls
//! that handle reads. Writes are not supported.
//! If you want code to run on write, then you should use an ERD subscription or the converted data component

const erd_core = @import("erd_core");
const Erd = erd_core.Erd;
const subscription_mixin = erd_core.data_component.subscription_mixin;

/// Binds an indirect ERD to its read function pointer.
pub const Mapping = struct {
    erd: Erd,
    fn_ptr: *const anyopaque,

    /// Create a mapping from an ERD to its read function.
    pub fn map(comptime erd: Erd, func: *const fn (*erd.T) void) Mapping {
        return .{ .erd = erd, .fn_ptr = func };
    }
};

/// Read-only data component that computes values via function pointers.
pub fn IndirectDataComponent(comptime erds: []const Erd, comptime erd_mappings: [erds.len]Mapping) type {
    return struct {
        const Self = @This();

        /// Indicates this component does not support writes.
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

        /// Compute and return the ERD value by calling its mapped function.
        pub fn read(self: Self, erd: Erd) erd.T {
            const fnPtr: *const fn (*erd.T) void = @ptrCast(self.read_functions[erd.data_component_idx]);

            var temp: erd.T = undefined;
            fnPtr(&temp);
            return temp;
        }

        /// Runtime read using a dynamic data component index.
        pub fn runtimeRead(self: Self, data_component_idx: u16, data: *anyopaque) void {
            const fnPtr: *const fn ([*]u8) void = @ptrCast(self.read_functions[data_component_idx]);
            fnPtr(@ptrCast(data));
        }

        /// Compile error: indirect ERDs do not support modify.
        pub fn modify(self: *Self, erd: Erd, comptime modifier: *const fn (*erd.T) void, publisher: *anyopaque) void {
            _ = self;
            _ = modifier;
            _ = publisher;
            @compileError("Indirect ERD modifications are not allowed");
        }

        /// Compile error: indirect ERDs do not support writes.
        pub fn write(self: *Self, erd: Erd, data: erd.T, publisher: *anyopaque) void {
            _ = self;
            _ = data;
            _ = publisher;
            @compileError("Indirect ERD writes are not allowed");
        }

        /// Compile error: indirect ERDs do not support runtime writes.
        pub fn runtimeWrite(self: *Self, data_component_idx: u16, data: *const anyopaque, publisher: *anyopaque) void {
            _ = self;
            _ = data_component_idx;
            _ = data;
            _ = publisher;
            @compileError("Indirect ERD writes are not allowed");
        }
    };
}
