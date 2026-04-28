//! This module provides an indirect data component which uses function calls
//! that handle reads. Writes are not supported.
//! If you want code to run on write, then you should use an ERD subscription or the converted data component

const std = @import("std");
const Erd = @import("erd.zig");
const Subscription = @import("subscription.zig");

pub fn IndirectDataComponent(comptime erds: []const Erd) type {
    return struct {
        const Self = @This();

        pub const component_erds = erds;
        pub const supports_write = false;
        pub const supports_subscriptions = true;

        read_functions: [erds.len](*const anyopaque) = undefined,

        pub const IndirectErdMapping = struct {
            erd: Erd,
            fn_ptr: *const anyopaque,

            pub fn map(comptime erd: Erd, func: *const fn (*erd.T) void) IndirectErdMapping {
                return .{ .erd = erd, .fn_ptr = func };
            }
        };

        pub const sub_offsets = [_]usize{0} ** erds.len;

        pub fn init(erdMappings: [erds.len]IndirectErdMapping) Self {
            var self = Self{};

            inline for (erdMappings) |mapping| {
                self.read_functions[mapping.erd.data_component_idx] = mapping.fn_ptr;
            }
            return self;
        }

        pub fn read(self: Self, erd: Erd) erd.T {
            const fn_ptr: *const fn (*erd.T) void = @ptrCast(self.read_functions[erd.data_component_idx]);

            var temp: erd.T = undefined;
            fn_ptr(&temp);
            return temp;
        }

        pub fn runtime_read(self: Self, data_component_idx: u16, data: *anyopaque) void {
            const fn_ptr: *const fn ([*]u8) void = @ptrCast(self.read_functions[data_component_idx]);
            fn_ptr(@ptrCast(data));
        }

        pub fn write(self: *Self, erd: Erd, data: erd.T, publisher: *anyopaque) void {
            _ = self;
            _ = data;
            _ = publisher;
            @compileError("Indirect ERD writes are not allowed");
        }

        pub fn runtime_write(self: *Self, data_component_idx: u16, data: *const anyopaque, publisher: *anyopaque) void {
            _ = self;
            _ = data_component_idx;
            _ = data;
            _ = publisher;
            @compileError("Indirect ERD writes are not allowed");
        }

        pub fn subscribe(_: *Self, _: Erd, _: ?*anyopaque, _: Subscription.Callback) void {
            @compileError("Indirect ERDs do not support subscriptions");
        }

        pub fn unsubscribe(_: *Self, _: Erd, _: Subscription.Callback) void {
            @compileError("Indirect ERDs do not support subscriptions");
        }
    };
}
