const std = @import("std");
const SystemData = @import("../system_data.zig");
const SystemErds = @import("../system_erds.zig");
const Subscription = @import("../subscription.zig");

test "ram data component read and write" {
    var system_data = SystemData.init();
    // Should zero init
    try std.testing.expectEqual(0, system_data.read(SystemErds.erd.application_version));

    const new_application_version: u32 = 0x12345678;
    system_data.write(SystemErds.erd.application_version, new_application_version);
    try std.testing.expectEqual(new_application_version, system_data.read(SystemErds.erd.application_version));
}

test "runtime read/write matches data components" {
    var system_data = SystemData.init();
    var ver: u32 = undefined;
    system_data.runtime_read(SystemErds.erd.application_version.system_data_idx, &ver);
    try std.testing.expectEqual(0, ver);

    system_data.write(SystemErds.erd.application_version, 1234);
    system_data.runtime_read(SystemErds.erd.application_version.system_data_idx, &ver);
    try std.testing.expectEqual(1234, ver);

    var should_be_42: u16 = undefined;
    system_data.runtime_read(SystemErds.erd.always_42.system_data_idx, &should_be_42);
    system_data.runtime_read(SystemErds.erd.always_42.system_data_idx, &ver);
    try std.testing.expectEqual(42, should_be_42);
}

test "indirect data component read and a note on reads" {
    var system_data = SystemData.init();
    try std.testing.expectEqual(42, system_data.read(SystemErds.erd.always_42));

    // This does not work:
    // src\system_data.zig:49:31: error: reached unreachable code
    //     .Indirect => comptime unreachable,
    // system_data.write(SystemErds.erd.always_42, 43);
}

fn ExampleDo(system_data: *SystemData) !void {
    try std.testing.expectEqual(42, system_data.read(SystemErds.erd.always_42));

    const new_application_version: u32 = 0x87654321;
    system_data.write(SystemErds.erd.application_version, new_application_version);
}

test "mutable system_data passing without error" {
    var system_data = SystemData.init();

    try ExampleDo(&system_data);
    try std.testing.expectEqual(0x87654321, system_data.read(SystemErds.erd.application_version));
}

var persisted_system_data: *SystemData = undefined;
fn ExampleCallbackEffect() !void {
    try std.testing.expectEqual(42, persisted_system_data.read(SystemErds.erd.always_42));

    const new_application_version: u32 = 0xCAFEBABE;
    persisted_system_data.write(SystemErds.erd.application_version, new_application_version);
}

fn ExampleInit(system_data: *SystemData) void {
    if (!@inComptime()) {
        persisted_system_data = system_data;
    } else {
        @compileError("This NEEDS to be able to be runtime");
    }
}

test "retain reference to system_data" {
    var system_data = SystemData.init();

    ExampleInit(&system_data);

    try ExampleCallbackEffect();
    try std.testing.expectEqual(0xCAFEBABE, system_data.read(SystemErds.erd.application_version));
}

fn turn_off_some_bool_and_increment_application_version(_: ?*anyopaque, _: *const anyopaque, system_data: *SystemData) void {
    system_data.write(SystemErds.erd.some_bool, false);
    system_data.write(SystemErds.erd.application_version, system_data.read(SystemErds.erd.application_version) + 1);
}

test "subscription_test" {
    var system_data = SystemData.init();
    // system_data.subscribe(SystemErds.erd.some_bool, null, null); // This is a compile error!

    system_data.subscribe(SystemErds.erd.some_bool, null, turn_off_some_bool_and_increment_application_version);
    // Subscriptions can be stored on the stack if it lives through all of its callbacks.
    // defer pattern only makes sense if you stack initialize this. Here it's to show that it's safe to call unsub multiple times
    defer system_data.unsubscribe(SystemErds.erd.some_bool, turn_off_some_bool_and_increment_application_version);

    system_data.write(SystemErds.erd.some_bool, true);
    try std.testing.expectEqual(false, system_data.read(SystemErds.erd.some_bool));
    try std.testing.expectEqual(2, system_data.read(SystemErds.erd.application_version));

    system_data.unsubscribe(SystemErds.erd.some_bool, turn_off_some_bool_and_increment_application_version);
    system_data.write(SystemErds.erd.some_bool, true);
    try std.testing.expectEqual(true, system_data.read(SystemErds.erd.some_bool));
    try std.testing.expectEqual(2, system_data.read(SystemErds.erd.application_version));
}

fn forward_context(context: ?*anyopaque, _: *const anyopaque, system_data: *SystemData) void {
    const a: *u8 = @ptrCast(context.?);

    system_data.write(SystemErds.erd.unaligned_u16, a.*);
}

test "subscription with context" {
    var system_data = SystemData.init();

    var a: u8 = 17;
    system_data.subscribe(SystemErds.erd.some_bool, &a, forward_context);
    system_data.write(SystemErds.erd.some_bool, true);

    try std.testing.expectEqual(17, system_data.read(SystemErds.erd.unaligned_u16));
}

fn context_must_match_args(context: ?*anyopaque, args: *const anyopaque, system_data: *SystemData) void {
    const a: *u16 = @alignCast(@ptrCast(context.?));
    const b: *const u16 = @alignCast(@ptrCast(args));

    system_data.write(SystemErds.erd.some_bool, a.* == b.*);
}

test "subscription with args" {
    var system_data = SystemData.init();

    var a: u16 = 1;
    system_data.subscribe(SystemErds.erd.unaligned_u16, &a, context_must_match_args);
    system_data.write(SystemErds.erd.unaligned_u16, 1);
    try std.testing.expect(true == system_data.read(SystemErds.erd.some_bool));

    system_data.write(SystemErds.erd.unaligned_u16, 2);
    try std.testing.expect(false == system_data.read(SystemErds.erd.some_bool));

    a = 2;
    system_data.write(SystemErds.erd.unaligned_u16, 2);
    // Stays false because no publish
    try std.testing.expect(false == system_data.read(SystemErds.erd.some_bool));
}

fn bump_some_u16(_: ?*anyopaque, _: *const anyopaque, system_data: *SystemData) void {
    system_data.write(SystemErds.erd.unaligned_u16, system_data.read(SystemErds.erd.unaligned_u16) + 1);
}

test "double sub test" {
    var system_data = SystemData.init();
    system_data.subscribe(SystemErds.erd.some_bool, null, turn_off_some_bool_and_increment_application_version);
    system_data.subscribe(SystemErds.erd.some_bool, null, bump_some_u16);

    system_data.write(SystemErds.erd.some_bool, true);
    try std.testing.expectEqual(false, system_data.read(SystemErds.erd.some_bool));
    try std.testing.expectEqual(2, system_data.read(SystemErds.erd.application_version));
    try std.testing.expectEqual(2, system_data.read(SystemErds.erd.unaligned_u16));

    system_data.unsubscribe(SystemErds.erd.some_bool, turn_off_some_bool_and_increment_application_version);
    system_data.write(SystemErds.erd.some_bool, true);
    try std.testing.expectEqual(true, system_data.read(SystemErds.erd.some_bool));
    try std.testing.expectEqual(2, system_data.read(SystemErds.erd.application_version));
    try std.testing.expectEqual(3, system_data.read(SystemErds.erd.unaligned_u16));
}

fn whatever(_: ?*anyopaque, _: *const anyopaque, _: *SystemData) void {}

test "exact subscription enforcement" {
    var system_data = SystemData.init();

    system_data.subscribe(SystemErds.erd.some_bool, null, whatever);
    system_data.subscribe(SystemErds.erd.some_bool, null, bump_some_u16);
    system_data.subscribe(SystemErds.erd.some_bool, null, turn_off_some_bool_and_increment_application_version);
    system_data.subscribe(SystemErds.erd.unaligned_u16, null, whatever);

    // TODO: Move this test into the Application test file
    // and replace all of the above with `application.init`
    try system_data.verify_all_subs_are_saturated();
}

fn scratch_allocating(_: ?*anyopaque, args: *const anyopaque, system_data: *SystemData) void {
    const val: *const u16 = @alignCast(@ptrCast(args));
    const allocated = system_data.scratch_alloc(u32, val.*);
    for (allocated, 1..) |*item, i| {
        item.* = @intCast(i);
    }

    system_data.write(SystemErds.erd.application_version, allocated[allocated.len - 1]);
}

test "scratch allocations" {
    var system_data: SystemData = .init();

    system_data.subscribe(SystemErds.erd.unaligned_u16, null, scratch_allocating);
    system_data.write(SystemErds.erd.unaligned_u16, 7);
    try std.testing.expectEqual(7, system_data.read(SystemErds.erd.application_version));

    system_data.scratch_reset();

    system_data.write(SystemErds.erd.unaligned_u16, 5);
    try std.testing.expectEqual(5, system_data.read(SystemErds.erd.application_version));

    const more_allocation = system_data.scratch_alloc(u8, system_data.read(SystemErds.erd.application_version));
    try std.testing.expect(system_data.scratch.ownsSlice(more_allocation));

    system_data.scratch_reset();
    // NOTE: Notice how this does not fail!
    // One must be very careful since this data is now considered freed, but there's no runtime check on it.
    system_data.write(SystemErds.erd.application_version, more_allocation[0]);
    try std.testing.expectEqual(0b10101010, system_data.read(SystemErds.erd.application_version));
}
