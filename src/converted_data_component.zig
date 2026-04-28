//! A converted data component provides derived ERDs whose values are computed
//! from dependency ERDs. No values are stored — every read recomputes.
//! When a dependency changes, the component publishes to its own subscribers.
//!
//! Unlike other data components, this component manages its own subscriptions.
//! SystemData routes subscribe/unsubscribe calls here instead of using its
//! central subscription array.

const std = @import("std");
const Erd = @import("erd.zig");
const Subscription = @import("subscription.zig");

pub fn ConvertedDataComponent(comptime erds: []const Erd) type {
    return struct {
        const Self = @This();

        pub const component_erds = erds;
        pub const supports_write = false;
        pub const manages_own_subscriptions = true;

        const OnChangeArgs = struct {
            system_data_idx: u16,
            data: *const anyopaque,
        };

        read_functions: [erds.len]*const anyopaque = undefined,
        subscriptions: [total_own_subs()]Subscription = undefined,
        system_data_ref: *anyopaque = undefined,

        pub const ConvertedErdMapping = struct {
            erd: Erd,
            fn_ptr: *const anyopaque,
            dependencies: []const u16,

            pub fn map(comptime erd: Erd, func: *const fn (*erd.T, *anyopaque) void, comptime dependencies: []const u16) ConvertedErdMapping {
                return .{ .erd = erd, .fn_ptr = func, .dependencies = dependencies };
            }
        };

        fn total_own_subs() usize {
            var size: usize = 0;
            for (erds) |erd| {
                size += erd.subs;
            }
            return size;
        }

        const sub_offsets = blk: {
            var _offsets: [erds.len]usize = undefined;
            var cur_offset: usize = 0;
            for (erds, 0..) |erd, i| {
                if (erd.subs != 0) {
                    _offsets[i] = cur_offset;
                }
                cur_offset += erd.subs;
            }
            break :blk _offsets;
        };

        pub fn init(erdMappings: [erds.len]ConvertedErdMapping) Self {
            var self = Self{};
            inline for (erdMappings) |mapping| {
                self.read_functions[mapping.erd.data_component_idx] = mapping.fn_ptr;
            }
            @memset(&self.subscriptions, .{ .context = null, .callback = null });
            return self;
        }

        pub fn set_system_data(self: *Self, sd: *anyopaque) void {
            self.system_data_ref = sd;
        }

        pub fn read(self: Self, erd: Erd) erd.T {
            const fn_ptr: *const fn (*erd.T, *anyopaque) void = @ptrCast(self.read_functions[erd.data_component_idx]);
            var temp: erd.T = undefined;
            fn_ptr(&temp, self.system_data_ref);
            return temp;
        }

        pub fn runtime_read(self: Self, data_component_idx: u16, data: *anyopaque) void {
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

        pub fn make_callback(comptime erd_data_component_idx: comptime_int) Subscription.Callback {
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
                    const args: OnChangeArgs = .{
                        .system_data_idx = erds[erd_data_component_idx].system_data_idx,
                        .data = data,
                    };
                    cb(sub.context, @ptrCast(&args), publisher);
                }
            }
        }
    };
}
