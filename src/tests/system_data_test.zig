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

fn turn_off_some_bool_and_increment_application_version(system_data: *SystemData) void {
    system_data.write(SystemErds.erd.some_bool, false);
    system_data.write(SystemErds.erd.application_version, system_data.read(SystemErds.erd.application_version) + 1);
}

test "subscription_test" {
    var system_data = SystemData.init();
    // system_data.subscribe(SystemErds.erd.some_bool, null); // This is a compile error!

    system_data.subscribe(SystemErds.erd.some_bool, turn_off_some_bool_and_increment_application_version);
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

fn bump_some_u16(system_data: *SystemData) void {
    system_data.write(SystemErds.erd.unaligned_u16, system_data.read(SystemErds.erd.unaligned_u16) + 1);
}

test "double sub test" {
    var system_data = SystemData.init();
    system_data.subscribe(SystemErds.erd.some_bool, turn_off_some_bool_and_increment_application_version);
    system_data.subscribe(SystemErds.erd.some_bool, bump_some_u16);

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

fn whatever(system_data: *SystemData) void {
    _ = system_data;
}

test "exact subscription enforcement" {
    var system_data = SystemData.init();

    system_data.subscribe(SystemErds.erd.some_bool, whatever);
    system_data.subscribe(SystemErds.erd.some_bool, bump_some_u16);
    system_data.subscribe(SystemErds.erd.some_bool, turn_off_some_bool_and_increment_application_version);
    system_data.subscribe(SystemErds.erd.unaligned_u16, whatever);

    // TODO: Move this test into the Application test file
    // and replace all of the above with `application.init`
    try system_data.verify_all_subs_are_saturated();
}

fn scratch_allocating(system_data: *SystemData) void {
    const allocated = system_data.scratch_alloc(u32, system_data.read(SystemErds.erd.unaligned_u16));
    for (allocated, 1..) |*item, i| {
        item.* = @intCast(i);
    }

    system_data.write(SystemErds.erd.application_version, allocated[allocated.len - 1]);
}

test "scratch allocations" {
    var system_data: SystemData = .init();

    system_data.subscribe(SystemErds.erd.unaligned_u16, scratch_allocating);
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
