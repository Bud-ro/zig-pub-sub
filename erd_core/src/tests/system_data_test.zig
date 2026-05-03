const std = @import("std");
const erd_core = @import("erd_core");
const Erd = erd_core.Erd;
const SystemDataTestDouble = erd_core.testing.SystemDataTestDouble;
const Subscription = erd_core.Subscription;

const TestSystem = SystemDataTestDouble.create(struct {
    application_version: Erd = SystemDataTestDouble.ramErd(u32, .{}),
    some_bool: Erd = SystemDataTestDouble.ramErd(bool, .{ .subs = 3 }),
    unaligned_u16: Erd = SystemDataTestDouble.ramErd(u16, .{ .subs = 1 }),
    cool_u16: Erd = SystemDataTestDouble.ramErd(u16, .{ .subs = 1 }),
    best_u16: Erd = SystemDataTestDouble.ramErd(u16, .{}),
});
const SystemData = TestSystem.SystemData;

test "ram data component read and write" {
    var system_data = TestSystem.init();
    try std.testing.expectEqual(0, system_data.read(.application_version));

    const new_ver: u32 = 0x12345678;
    system_data.write(.application_version, new_ver);
    try std.testing.expectEqual(new_ver, system_data.read(.application_version));
}

test "runtime read/write matches data components" {
    var system_data = TestSystem.init();
    var ver: u32 = undefined;
    system_data.runtime_read(0, &ver);
    try std.testing.expectEqual(0, ver);

    system_data.write(.application_version, 1234);
    system_data.runtime_read(0, &ver);
    try std.testing.expectEqual(1234, ver);
}

fn example_do(system_data: *SystemData) !void {
    const new_ver: u32 = 0x87654321;
    system_data.write(.application_version, new_ver);
}

test "mutable system_data passing without error" {
    var system_data = TestSystem.init();

    try example_do(&system_data);
    try std.testing.expectEqual(0x87654321, system_data.read(.application_version));
}

var persisted_system_data: *SystemData = undefined;
fn example_callback_effect() !void {
    const new_ver: u32 = 0xCAFEBABE;
    persisted_system_data.write(.application_version, new_ver);
}

fn example_init(system_data: *SystemData) void {
    if (!@inComptime()) {
        persisted_system_data = system_data;
    } else {
        @compileError("This NEEDS to be able to be runtime");
    }
}

test "retain reference to system_data" {
    var system_data = TestSystem.init();

    example_init(&system_data);

    try example_callback_effect();
    try std.testing.expectEqual(0xCAFEBABE, system_data.read(.application_version));
}

fn turn_off_bool_and_bump_version(_: ?*anyopaque, _: ?*const anyopaque, publisher: *anyopaque) void {
    var system_data: *SystemData = @ptrCast(@alignCast(publisher));

    system_data.write(.some_bool, false);
    system_data.write(.application_version, system_data.read(.application_version) + 1);
}

test "subscription_test" {
    var system_data = TestSystem.init();

    system_data.subscribe(.some_bool, null, turn_off_bool_and_bump_version);
    defer system_data.unsubscribe(.some_bool, turn_off_bool_and_bump_version);

    system_data.write(.some_bool, true);
    try std.testing.expectEqual(false, system_data.read(.some_bool));
    try std.testing.expectEqual(2, system_data.read(.application_version));

    system_data.unsubscribe(.some_bool, turn_off_bool_and_bump_version);
    system_data.write(.some_bool, true);
    try std.testing.expectEqual(true, system_data.read(.some_bool));
    try std.testing.expectEqual(2, system_data.read(.application_version));
}

test "re-subscribe" {
    var system_data = TestSystem.init();
    system_data.subscribe(.some_bool, null, turn_off_bool_and_bump_version);
    system_data.subscribe(.some_bool, null, turn_off_bool_and_bump_version);
    system_data.subscribe(.some_bool, null, turn_off_bool_and_bump_version);
    system_data.subscribe(.some_bool, null, turn_off_bool_and_bump_version);
    system_data.subscribe(.some_bool, null, turn_off_bool_and_bump_version);

    system_data.write(.some_bool, true);
    try std.testing.expectEqual(false, system_data.read(.some_bool));
    try std.testing.expectEqual(2, system_data.read(.application_version));
}

fn forward_context(context: ?*anyopaque, _: ?*const anyopaque, publisher: *anyopaque) void {
    var system_data: *SystemData = @ptrCast(@alignCast(publisher));
    const a: *u8 = @ptrCast(context.?);

    system_data.write(.unaligned_u16, a.*);
}

test "subscription with context" {
    var system_data = TestSystem.init();

    var a: u8 = 17;
    system_data.subscribe(.some_bool, &a, forward_context);
    system_data.write(.some_bool, true);

    try std.testing.expectEqual(17, system_data.read(.unaligned_u16));
}

fn context_must_match_args(context: ?*anyopaque, _args: ?*const anyopaque, publisher: *anyopaque) void {
    const args: *const SystemData.OnChangeArgs = @ptrCast(@alignCast(_args.?));
    var system_data: *SystemData = @ptrCast(@alignCast(publisher));

    const a: *u16 = @ptrCast(@alignCast(context.?));
    const b: *const u16 = @ptrCast(@alignCast(args.data));

    system_data.write(.some_bool, a.* == b.*);
}

test "subscription with args" {
    var system_data = TestSystem.init();

    var a: u16 = 1;
    system_data.subscribe(.unaligned_u16, &a, context_must_match_args);
    system_data.write(.unaligned_u16, 1);
    try std.testing.expect(true == system_data.read(.some_bool));

    system_data.write(.unaligned_u16, 2);
    try std.testing.expect(false == system_data.read(.some_bool));

    a = 2;
    system_data.write(.unaligned_u16, 2);
    // NOTE: Stays false because no publish
    try std.testing.expect(false == system_data.read(.some_bool));
}

fn switch_on_system_data_idx(_: ?*anyopaque, _args: ?*const anyopaque, publisher: *anyopaque) void {
    const args: *const SystemData.OnChangeArgs = @ptrCast(@alignCast(_args.?));
    var system_data: *SystemData = @ptrCast(@alignCast(publisher));

    if (args.system_data_idx != SystemData.erd_from_enum(.some_bool).system_data_idx) {
        system_data.write(.best_u16, system_data.read(.best_u16) + 1);
    }

    switch (args.system_data_idx) {
        // Ideally I'd like to type this instead:
        // .cool_u16 => system_data.write(.some_bool, true)
        // TODO: That probably requires unifying `system_data_idx` and `ErdEnum` to be the same thing
        SystemData.erd_from_enum(.cool_u16).system_data_idx => system_data.write(.some_bool, true),
        SystemData.erd_from_enum(.unaligned_u16).system_data_idx => system_data.write(.some_bool, false),
        else => {},
    }
}

test "subscription args using system_data_idx" {
    var system_data = TestSystem.init();

    system_data.subscribe(.cool_u16, null, switch_on_system_data_idx);
    system_data.subscribe(.some_bool, null, switch_on_system_data_idx);
    system_data.subscribe(.unaligned_u16, null, switch_on_system_data_idx);

    try std.testing.expectEqual(0, system_data.read(.best_u16));

    system_data.write(.cool_u16, 1);
    try std.testing.expectEqual(1, system_data.read(.best_u16));
    try std.testing.expectEqual(true, system_data.read(.some_bool));

    system_data.write(.cool_u16, 2);
    try std.testing.expectEqual(2, system_data.read(.best_u16));
    try std.testing.expectEqual(true, system_data.read(.some_bool));

    system_data.write(.unaligned_u16, 1);
    try std.testing.expectEqual(3, system_data.read(.best_u16));
    try std.testing.expectEqual(false, system_data.read(.some_bool));

    system_data.write(.some_bool, true);
    try std.testing.expectEqual(3, system_data.read(.best_u16));
    try std.testing.expectEqual(true, system_data.read(.some_bool));
}

fn bump_some_u16(_: ?*anyopaque, _: ?*const anyopaque, publisher: *anyopaque) void {
    var system_data: *SystemData = @ptrCast(@alignCast(publisher));

    system_data.write(.unaligned_u16, system_data.read(.unaligned_u16) + 1);
}

test "double sub test" {
    var system_data = TestSystem.init();
    system_data.subscribe(.some_bool, null, turn_off_bool_and_bump_version);
    system_data.subscribe(.some_bool, null, bump_some_u16);

    system_data.write(.some_bool, true);
    try std.testing.expectEqual(false, system_data.read(.some_bool));
    try std.testing.expectEqual(2, system_data.read(.application_version));
    try std.testing.expectEqual(2, system_data.read(.unaligned_u16));

    system_data.unsubscribe(.some_bool, turn_off_bool_and_bump_version);
    system_data.write(.some_bool, true);
    try std.testing.expectEqual(true, system_data.read(.some_bool));
    try std.testing.expectEqual(2, system_data.read(.application_version));
    try std.testing.expectEqual(3, system_data.read(.unaligned_u16));
}

fn whatever(_: ?*anyopaque, _: ?*const anyopaque, _: *anyopaque) void {
    // intentionally empty
}

test "exact subscription enforcement" {
    var system_data = TestSystem.init();

    system_data.subscribe(.some_bool, null, whatever);
    system_data.subscribe(.some_bool, null, bump_some_u16);
    system_data.subscribe(.unaligned_u16, null, whatever);
    system_data.subscribe(.cool_u16, null, whatever);

    // TODO: Move this test into the Application test file
    // and replace all of the above with `application.init`
    const exceptions = [_]SystemData.SubException{
        .{ .erd_enum = .some_bool, .missing = 1 },
    };
    try system_data.verify_all_subs_are_saturated(&exceptions);
}

fn scratch_allocating(_: ?*anyopaque, _args: ?*const anyopaque, publisher: *anyopaque) void {
    const args: *const SystemData.OnChangeArgs = @ptrCast(@alignCast(_args.?));
    var system_data: *SystemData = @ptrCast(@alignCast(publisher));

    const val: *const u16 = @ptrCast(@alignCast(args.data));
    const allocated = system_data.scratch_alloc(u32, val.*);
    for (allocated, 1..) |*item, i| {
        item.* = @intCast(i);
    }

    system_data.write(.application_version, allocated[allocated.len - 1]);
}

test "scratch allocations" {
    var system_data: SystemData = TestSystem.init();

    system_data.subscribe(.unaligned_u16, null, scratch_allocating);
    system_data.write(.unaligned_u16, 7);
    try std.testing.expectEqual(7, system_data.read(.application_version));

    system_data.scratch_reset();

    system_data.write(.unaligned_u16, 5);
    try std.testing.expectEqual(5, system_data.read(.application_version));

    const more_allocation = system_data.scratch_alloc(u8, system_data.read(.application_version));
    try std.testing.expect(system_data.scratch.ownsSlice(more_allocation));

    system_data.scratch_reset();
    // NOTE: The below doesn't fail, but depending on optimization level may yield different results!
    // One must be very careful since this data is now considered freed, but there's no runtime check on it.
    // system_data.write(.application_version, more_allocation[0]);
    // try std.testing.expectEqual(0b10101010, system_data.read(.application_version));
}
