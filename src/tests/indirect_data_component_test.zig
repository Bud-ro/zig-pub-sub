const std = @import("std");
const IndirectDataComponent = @import("../indirect_data_component.zig");
const IndirectErdMapping = IndirectDataComponent.IndirectErdMapping;
const SystemErds = @import("../system_erds.zig");

fn erd_always_42(data: *u16) void {
    data.* = 42;
}

fn plus_one(data: *u16) void {
    var should_be_42: u16 = undefined;
    erd_always_42(&should_be_42);

    data.* = should_be_42 + 1;
}

test "indirect data component read" {
    var indirect_data = IndirectDataComponent.init([_]IndirectErdMapping{
        IndirectErdMapping.map(SystemErds.erd.erd_always_42, erd_always_42),
        IndirectErdMapping.map(SystemErds.erd.erd_another_erd_plus_one, plus_one),
    });

    try std.testing.expectEqual(42, indirect_data.read(SystemErds.erd.erd_always_42));
    try std.testing.expectEqual(42 + 1, indirect_data.read(SystemErds.erd.erd_another_erd_plus_one));
}

test "indirect data component write" {
    return error.SkipZigTest;
    // TODO: Re-enable this test once you can test for compile error

    // var indirect_data = IndirectDataComponent.init([_]IndirectErdMapping{
    //     .{ .erd = SystemErds.erd.erd_always_42, .fn_ptr = &erd_always_42 },
    //     .{ .erd = SystemErds.erd.erd_another_erd_plus_one, .fn_ptr = &plus_one },
    // });

    // _ = indirect_data.write(SystemErds.erd.erd_always_42, 41);
}

test "indirect data component runtime read" {
    var indirect_data = IndirectDataComponent.init([_]IndirectErdMapping{
        IndirectErdMapping.map(SystemErds.erd.erd_always_42, erd_always_42),
        IndirectErdMapping.map(SystemErds.erd.erd_another_erd_plus_one, plus_one),
    });

    var should_be_42: u16 = undefined;
    var should_be_43: u16 = undefined;

    indirect_data.runtime_read(SystemErds.erd.erd_always_42.data_component_idx, &should_be_42);
    indirect_data.runtime_read(SystemErds.erd.erd_another_erd_plus_one.data_component_idx, &should_be_43);

    try std.testing.expectEqual(42, should_be_42);
    try std.testing.expectEqual(42 + 1, should_be_43);
}

test "indirect data component runtime write" {
    // return error.SkipZigTest;
    // TODO: Re-enable this test once you can test for compile error

    // var indirect_data = IndirectDataComponent.init([_]IndirectErdMapping{
    //     .{ .erd = SystemErds.erd.erd_always_42, .fn_ptr = &erd_always_42 },
    //     .{ .erd = SystemErds.erd.erd_another_erd_plus_one, .fn_ptr = &plus_one },
    // });

    // _ = indirect_data.runtime_write(SystemErds.erd.erd_always_42.data_component_idx, &41);
}
