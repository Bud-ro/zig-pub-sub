//! Read-only data component whose values are produced on demand by
//! caller-supplied functions. Each ERD is bound to a `Mapping{ .erd, .fn_ptr }`;
//! `read` (comptime-dispatched) and `runtimeRead` both invoke the mapped
//! function and return its result. No storage, no subscriptions.
//!
//! `modify`/`write`/`runtimeWrite` are `@compileError` stubs since indirect
//! values are not user-mutable. For "run on write" behavior, subscribe to the
//! source ERD or use `ConvertedDataComponent` (which recomputes when its
//! dependencies change).

const erd_core = @import("erd_core");
const erd_mapping = erd_core.erd_mapping;
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

        subs: subscription_mixin.Unsupported = .{},

        /// Comptime function pointer table, lives in .rodata rather than per-instance RAM.
        const read_functions: [erds.len]*const anyopaque = erd_mapping.buildFunctionTable(erds, erd_mappings);

        /// Compute and return the ERD value by calling its mapped function.
        pub fn read(_: Self, erd: Erd) erd.T {
            const fnPtr: *const fn (*erd.T) void = @ptrCast(comptime erd_mapping.fnFromMappings(erd, erd_mappings));
            var temp: erd.T = undefined;
            fnPtr(&temp);
            return temp;
        }

        /// Runtime read using a dynamic data component index.
        pub fn runtimeRead(_: *const Self, data_component_idx: u16, data: *anyopaque) void {
            const fnPtr: *const fn ([*]u8) void = @ptrCast(read_functions[data_component_idx]);
            fnPtr(@ptrCast(data));
        }

        /// Compile error: indirect ERDs do not support modify.
        pub fn modify(_: *Self, erd: Erd, comptime _: *const fn (*erd.T) void, _: *anyopaque) void {
            @compileError("Indirect ERD modifications are not allowed");
        }

        /// Compile error: indirect ERDs do not support writes.
        pub fn write(_: *Self, erd: Erd, _: erd.T, _: *anyopaque) void {
            @compileError("Indirect ERD writes are not allowed");
        }

        /// Compile error: indirect ERDs do not support runtime writes.
        pub fn runtimeWrite(_: *Self, _: u16, _: *const anyopaque, _: *anyopaque) void {
            @compileError("Indirect ERD writes are not allowed");
        }
    };
}
