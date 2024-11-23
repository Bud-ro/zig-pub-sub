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

var some_bool_sub = Subscription{ .callback = turn_off_some_bool_and_increment_application_version };

test "subscription_test" {
    var system_data = SystemData.init();

    system_data.subscribe(SystemErds.erd.some_bool, &some_bool_sub);

    system_data.write(SystemErds.erd.some_bool, true);
    try std.testing.expectEqual(false, system_data.read(SystemErds.erd.some_bool));
    try std.testing.expectEqual(2, system_data.read(SystemErds.erd.application_version));
}
