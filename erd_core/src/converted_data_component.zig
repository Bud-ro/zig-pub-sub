//! A data component for derived ERDs whose values are computed from other ERDs.
//!
//! Each converted ERD declares a compute function and a list of dependency ERDs.
//! Reads always recompute (no stored values). When a dependency changes, the
//! component recomputes and publishes to its own subscribers.
//!
//! After constructing a SystemData that contains this component, call
//! `postSystemDataInit` to wire up the SystemData back-pointer and dependency
//! subscriptions. Public APIs assert that `postSystemDataInit` has been called.

const erd_core = @import("erd_core");
const erd_mapping = erd_core.erd_mapping;
const std = @import("std");
const Erd = erd_core.Erd;
const Subscription = erd_core.Subscription;
const DataComponentSubscription = erd_core.data_component.subscription_mixin.DataComponentSubscription;

/// Binds a converted ERD to its compute function and dependency list.
pub const Mapping = struct {
    erd: Erd,
    fn_ptr: *const anyopaque,
    /// ERDs this converted ERD depends on. `postSystemDataInit` subscribes to each.
    dependencies: []const Erd,

    /// Create a mapping from an ERD to its compute function and dependencies.
    /// The compute function writes its result into the provided pointer,
    /// reading source values from the SystemData pointer.
    pub fn map(comptime erd: Erd, func: *const fn (*erd.T, *anyopaque) void, comptime dependencies: []const Erd) Mapping {
        return .{ .erd = erd, .fn_ptr = func, .dependencies = dependencies };
    }
};

/// A data component that provides derived ERDs whose values are computed from
/// dependency ERDs. Parameterized by the ERDs it owns and their mappings.
pub fn ConvertedDataComponent(comptime erds: []const Erd, comptime erd_mappings: [erds.len]Mapping) type {
    return struct {
        const Self = @This();

        /// Indicates this component does not support direct writes.
        pub const supports_write = false;
        const Subs = DataComponentSubscription(erds);

        subs: Subs = .{},
        /// Back-pointer to the owning SystemData. Set by `postSystemDataInit`.
        /// Undefined until then; `read`/`runtimeRead` debug-assert that it has been wired up.
        system_data_ref: *anyopaque = undefined,
        /// Latched true by `postSystemDataInit`. Read paths assert it so a missing
        /// init call surfaces immediately in safety builds instead of dereferencing
        /// `system_data_ref` while it is still `undefined`.
        is_fully_initialized: bool = false,

        /// Comptime function pointer table, lives in .rodata rather than per-instance RAM.
        const read_functions: [erds.len]*const anyopaque = erd_mapping.buildFunctionTable(erds, erd_mappings);

        /// Wire up the SystemData back-pointer and subscribe to all dependency ERDs.
        /// Must be called after the SystemData is at its final memory location.
        pub fn postSystemDataInit(self: *Self, sd: anytype) void {
            self.system_data_ref = @ptrCast(sd);
            inline for (erd_mappings) |mapping| {
                const callback = makeCallback(mapping.erd.data_component_idx);
                inline for (mapping.dependencies) |dep| {
                    sd.subscribe(@enumFromInt(dep.system_data_idx), @ptrCast(self), callback);
                }
            }
            self.is_fully_initialized = true;
        }

        /// Recompute and return the value of a converted ERD.
        pub fn read(self: Self, erd: Erd) erd.T {
            std.debug.assert(self.is_fully_initialized);
            const fnPtr: *const fn (*erd.T, *anyopaque) void = @ptrCast(comptime erd_mapping.fnFromMappings(erd, erd_mappings));
            var temp: erd.T = undefined;
            fnPtr(&temp, self.system_data_ref);
            return temp;
        }

        /// Runtime read using a dynamic data component index.
        pub fn runtimeRead(self: *const Self, data_component_idx: u16, data: *anyopaque) void {
            std.debug.assert(self.is_fully_initialized);
            const fnPtr: *const fn ([*]u8, *anyopaque) void = @ptrCast(read_functions[data_component_idx]);
            fnPtr(@ptrCast(data), self.system_data_ref);
        }

        /// Compile error: converted ERDs do not support modify.
        pub fn modify(_: *Self, erd: Erd, comptime _: *const fn (*erd.T) void, _: *anyopaque) void {
            @compileError("Converted ERD modifications are not allowed");
        }

        /// Compile error: converted ERDs do not support writes.
        pub fn write(_: *Self, erd: Erd, _: erd.T, _: *anyopaque) void {
            @compileError("Converted ERD writes are not allowed");
        }

        /// Compile error: converted ERDs do not support runtime writes.
        pub fn runtimeWrite(_: *Self, _: u16, _: *const anyopaque, _: *anyopaque) void {
            @compileError("Converted ERD writes are not allowed");
        }

        /// Generate the on-change callback for a converted ERD.
        /// When a dependency changes, this callback recomputes the output
        /// and publishes to subscribers of the converted ERD.
        fn makeCallback(erd_data_component_idx: comptime_int) Subscription.Callback {
            const erd = erds[erd_data_component_idx];
            return struct {
                fn cb(context: ?*anyopaque, _: ?*const anyopaque, publisher: *anyopaque) void {
                    const self: *Self = @ptrCast(@alignCast(context.?));
                    const fnPtr: *const fn (*erd.T, *anyopaque) void = @ptrCast(comptime erd_mapping.fnFromMappings(erd, erd_mappings));
                    var val: erd.T = undefined;
                    fnPtr(&val, publisher);
                    if (erd.subs > 0) {
                        const offset = Subs.sub_offsets[erd_data_component_idx];
                        Subscription.publish(
                            self.subs.slots[offset..][0..erd.subs],
                            erd.system_data_idx,
                            @ptrCast(&val),
                            publisher,
                        );
                    }
                }
            }.cb;
        }
    };
}
