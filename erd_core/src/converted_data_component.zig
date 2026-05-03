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

        read_functions: [erds.len]*const anyopaque = initFunctions(),
        subs: Subs = .{},
        system_data_ref: *anyopaque = undefined,
        is_fully_initialized: bool = false,

        fn initFunctions() [erds.len]*const anyopaque {
            var fns: [erds.len]*const anyopaque = undefined;
            for (erd_mappings) |mapping| {
                fns[mapping.erd.data_component_idx] = mapping.fn_ptr;
            }
            return fns;
        }

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
            const fnPtr: *const fn (*erd.T, *anyopaque) void = @ptrCast(self.read_functions[erd.data_component_idx]);
            var temp: erd.T = undefined;
            fnPtr(&temp, self.system_data_ref);
            return temp;
        }

        /// Runtime read using a dynamic data component index.
        pub fn runtimeRead(self: Self, data_component_idx: u16, data: *anyopaque) void {
            std.debug.assert(self.is_fully_initialized);
            const fnPtr: *const fn ([*]u8, *anyopaque) void = @ptrCast(self.read_functions[data_component_idx]);
            fnPtr(@ptrCast(data), self.system_data_ref);
        }

        /// Compile error: converted ERDs do not support writes.
        pub fn write(self: *Self, erd: Erd, data: erd.T) bool {
            _ = self;
            _ = data;
            @compileError("Converted ERD writes are not allowed");
        }

        /// Compile error: converted ERDs do not support runtime writes.
        pub fn runtimeWrite(self: *Self, data_component_idx: u16, data: *const anyopaque) bool {
            _ = self;
            _ = data_component_idx;
            _ = data;
            @compileError("Converted ERD writes are not allowed");
        }

        /// Generate the on-change callback for a converted ERD.
        /// When a dependency changes, this callback recomputes the output
        /// and publishes to subscribers of the converted ERD.
        fn makeCallback(comptime erd_data_component_idx: comptime_int) Subscription.Callback {
            return struct {
                fn cb(context: ?*anyopaque, _: ?*const anyopaque, publisher: *anyopaque) void {
                    const self: *Self = @ptrCast(@alignCast(context.?));
                    const T = erds[erd_data_component_idx].T;
                    const fnPtr: *const fn (*T, *anyopaque) void = @ptrCast(self.read_functions[erd_data_component_idx]);
                    var val: T = undefined;
                    fnPtr(&val, publisher);
                    if (erds[erd_data_component_idx].subs > 0) {
                        self.doPublish(erd_data_component_idx, @ptrCast(&val), publisher);
                    }
                }
            }.cb;
        }

        fn doPublish(self: *Self, comptime erd_data_component_idx: comptime_int, data: *const anyopaque, publisher: *anyopaque) void {
            const offset = Subs.sub_offsets[erd_data_component_idx];
            const count = erds[erd_data_component_idx].subs;
            for (self.subs.slots[offset .. offset + count]) |sub| {
                if (sub.callback) |cb| {
                    const args: Subscription.OnChangeArgs = .{
                        .system_data_idx = erds[erd_data_component_idx].system_data_idx,
                        .data = data,
                    };
                    cb(sub.context, @ptrCast(&args), publisher);
                }
            }
        }
    };
}
