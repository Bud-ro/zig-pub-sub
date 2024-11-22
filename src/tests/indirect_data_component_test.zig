const std = @import("std");
const IndirectDataComponent = @import("../indirect_data_component.zig");
const IndirectErdMapping = IndirectDataComponent.IndirectErdMapping;
const SystemErds = @import("../system_erds.zig");

fn always_42() u16 {
    return 42;
}

fn plus_one() u16 {
    return always_42() + 1;
}

test "indirect data component read" {
    var indirect_data = IndirectDataComponent.init([_]IndirectErdMapping{
        IndirectErdMapping.map(SystemErds.erd.always_42, always_42),
        IndirectErdMapping.map(SystemErds.erd.another_erd_plus_one, plus_one),
    });

    try std.testing.expectEqual(42, indirect_data.read(SystemErds.erd.always_42));
    try std.testing.expectEqual(42 + 1, indirect_data.read(SystemErds.erd.another_erd_plus_one));
}

test "indirect data component write" {
    return error.SkipZigTest;
    // TODO: Re-enable this test once you can test for compile error

    // var indirect_data = IndirectDataComponent.init([_]IndirectErdMapping{
    //     .{ .erd = SystemErds.erd.always_42, .fn_ptr = &always_42 },
    //     .{ .erd = SystemErds.erd.another_erd_plus_one, .fn_ptr = &plus_one },
    // });

    // indirect_data.write(SystemErds.erd.always_42, 41);
}
