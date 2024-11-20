const std = @import("std");
const IndirectDataComponent = @import("../indirect_data_component.zig");
const erd = IndirectDataComponent.erds; // TODO: Should a data component know about its ERDs, or should it be told about them via .init?
const IndirectErdMapping = IndirectDataComponent.IndirectErdMapping;

fn always_42() u16 {
    return 42;
}

fn plus_one() u16 {
    return always_42() + 1;
}

test "indirect data component read" {
    var indirect_data = IndirectDataComponent.init(&[_]IndirectErdMapping{
        IndirectErdMapping.map(erd.always_42, always_42),
        IndirectErdMapping.map(erd.another_erd_plus_one, plus_one),
    });

    try std.testing.expectEqual(@as(u32, 42), indirect_data.read(erd.always_42));
    try std.testing.expectEqual(@as(u32, 42 + 1), indirect_data.read(erd.another_erd_plus_one));
}

test "indirect data component write" {
    return error.SkipZigTest;
    // TODO: Re-enable this test once you can test for compile error

    // var indirect_data = IndirectDataComponent.init(&[_]IndirectErdMapping{
    //     .{ .erd = erd.always_42, .fn_ptr = &always_42 },
    //     .{ .erd = erd.another_erd_plus_one, .fn_ptr = &plus_one },
    // });

    // try std.testing.expectEqual(@as(u32, 42), indirect_data.write(erd.always_42, 41));
}
