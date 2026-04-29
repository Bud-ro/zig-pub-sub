//! A data component for derived ERDs whose values are computed from other ERDs.
//!
//! Each converted ERD declares a compute function and a list of dependency ERDs.
//! Reads always recompute (no stored values). When a dependency changes, the
//! component recomputes and publishes to its own subscribers.
//!
//! After constructing a SystemData that contains this component, call
//! `post_system_data_init` to wire up the SystemData back-pointer and dependency
//! subscriptions. Public APIs assert that `post_system_data_init` has been called.

const std = @import("std");
const Erd = @import("erd.zig");
const Subscription = @import("subscription.zig");

/// Binds a converted ERD to its compute function and dependency list.
pub const ConvertedErdMapping = struct {
    erd: Erd,
    fn_ptr: *const anyopaque,
    /// ERDs this converted ERD depends on. `post_system_data_init` subscribes to each.
    dependencies: []const Erd,

    /// Create a mapping from an ERD to its compute function and dependencies.
    /// The compute function writes its result into the provided pointer,
    /// reading source values from the SystemData pointer.
    pub fn map(comptime erd: Erd, func: *const fn (*erd.T, *anyopaque) void, comptime dependencies: []const Erd) ConvertedErdMapping {
        return .{ .erd = erd, .fn_ptr = func, .dependencies = dependencies };
    }
};

/// A data component that provides derived ERDs whose values are computed from
/// dependency ERDs. Parameterized by the ERDs it owns and their mappings.
pub fn ConvertedDataComponent(comptime erds: []const Erd, comptime erd_mappings: [erds.len]ConvertedErdMapping) type {
    return struct {
        const Self = @This();

        pub const supports_write = false;
        pub const supports_subscriptions = true;

        read_functions: [erds.len]*const anyopaque = undefined,
        subscriptions: [total_own_subs()]Subscription = undefined,
        system_data_ref: *anyopaque = undefined,
        is_fully_initialized: bool = false,

        fn total_own_subs() usize {
            var size: usize = 0;
            for (erds) |erd| {
                size += erd.subs;
            }
            return size;
        }

        pub const sub_offsets = blk: {
            var _offsets: [erds.len]usize = undefined;
            var cur_offset: usize = 0;
            for (erds, 0..) |erd, i| {
                _offsets[i] = cur_offset;
                cur_offset += erd.subs;
            }
            break :blk _offsets;
        };

        pub fn init() Self {
            var self = Self{};
            inline for (erd_mappings) |mapping| {
                self.read_functions[mapping.erd.data_component_idx] = mapping.fn_ptr;
            }
            @memset(&self.subscriptions, .{ .context = null, .callback = null });
            return self;
        }

        /// Wire up the SystemData back-pointer and subscribe to all dependency ERDs.
        /// Must be called after the SystemData is at its final memory location.
        pub fn post_system_data_init(self: *Self, sd: anytype) void {
            self.system_data_ref = @ptrCast(sd);
            inline for (erd_mappings) |mapping| {
                const callback = make_callback(mapping.erd.data_component_idx);
                inline for (mapping.dependencies) |dep| {
                    sd.subscribe(@enumFromInt(dep.system_data_idx), @ptrCast(self), callback);
                }
            }
            self.is_fully_initialized = true;
        }

        /// Recompute and return the value of a converted ERD.
        pub fn read(self: Self, erd: Erd) erd.T {
            std.debug.assert(self.is_fully_initialized);
            const fn_ptr: *const fn (*erd.T, *anyopaque) void = @ptrCast(self.read_functions[erd.data_component_idx]);
            var temp: erd.T = undefined;
            fn_ptr(&temp, self.system_data_ref);
            return temp;
        }

        pub fn runtime_read(self: Self, data_component_idx: u16, data: *anyopaque) void {
            std.debug.assert(self.is_fully_initialized);
            const fn_ptr: *const fn ([*]u8, *anyopaque) void = @ptrCast(self.read_functions[data_component_idx]);
            fn_ptr(@ptrCast(data), self.system_data_ref);
        }

        pub fn write(self: *Self, erd: Erd, data: erd.T) bool {
            _ = self;
            _ = data;
            @compileError("Converted ERD writes are not allowed");
        }

        pub fn runtime_write(self: *Self, data_component_idx: u16, data: *const anyopaque) bool {
            _ = self;
            _ = data_component_idx;
            _ = data;
            @compileError("Converted ERD writes are not allowed");
        }

        pub fn subscribe(self: *Self, erd: Erd, context: ?*anyopaque, fn_ptr: Subscription.Callback) void {
            std.debug.assert(erd.subs > 0);
            const offset = sub_offsets[erd.data_component_idx];
            var first_free: ?*Subscription = null;

            for (self.subscriptions[offset .. offset + erd.subs]) |*sub| {
                if (first_free == null and sub.callback == null) {
                    first_free = sub;
                }
                if (sub.callback == fn_ptr) {
                    return;
                }
            }

            if (first_free == null) {
                @panic("Converted ERD oversubscribed!");
            }

            first_free.?.context = context;
            first_free.?.callback = fn_ptr;
        }

        pub fn unsubscribe(self: *Self, erd: Erd, fn_ptr: Subscription.Callback) void {
            std.debug.assert(erd.subs > 0);
            const offset = sub_offsets[erd.data_component_idx];

            for (self.subscriptions[offset .. offset + erd.subs]) |*sub| {
                if (sub.callback == fn_ptr) {
                    sub.callback = null;
                    return;
                }
            }
        }

        /// Generate the on-change callback for a converted ERD.
        /// When a dependency changes, this callback recomputes the output
        /// and publishes to subscribers of the converted ERD.
        fn make_callback(comptime erd_data_component_idx: comptime_int) Subscription.Callback {
            return struct {
                fn cb(context: ?*anyopaque, _: ?*const anyopaque, publisher: *anyopaque) void {
                    const self: *Self = @ptrCast(@alignCast(context.?));
                    const T = erds[erd_data_component_idx].T;
                    const fn_ptr: *const fn (*T, *anyopaque) void = @ptrCast(self.read_functions[erd_data_component_idx]);
                    var val: T = undefined;
                    fn_ptr(&val, publisher);
                    if (erds[erd_data_component_idx].subs > 0) {
                        self.do_publish(erd_data_component_idx, @ptrCast(&val), publisher);
                    }
                }
            }.cb;
        }

        fn do_publish(self: *Self, comptime erd_data_component_idx: comptime_int, data: *const anyopaque, publisher: *anyopaque) void {
            const offset = sub_offsets[erd_data_component_idx];
            const count = erds[erd_data_component_idx].subs;
            for (self.subscriptions[offset .. offset + count]) |sub| {
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
