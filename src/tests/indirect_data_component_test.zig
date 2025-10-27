const std = @import("std");
const IndirectDataComponent = @import("../indirect_data_component.zig");
const IndirectErdMapping = IndirectDataComponent.IndirectErdMapping;
const SystemErds = @import("../system_erds.zig");

const ExampleIndirectDataComponent = IndirectDataComponent.IndirectDataComponent(SystemErds);

test "indirect data component read" {
    var indirect_data: ExampleIndirectDataComponent = .init(&SystemErds.example_indirect_erd_mapping);

    try std.testing.expectEqual(42, indirect_data.read(SystemErds.erd.erd_always_42));
    try std.testing.expectEqual(42 + 1, indirect_data.read(SystemErds.erd.erd_another_erd_plus_one));
}

test "indirect data component write" {
    return error.SkipZigTest; // Test for compile error

    // var indirect_data = IndirectDataComponent.init([_]IndirectErdMapping{
    //     .map(.erd_always_42, erd_always_42),
    //     .map(.erd_another_erd_plus_one, plus_one),
    // });

    // _ = indirect_data.write(SystemErds.erd.erd_always_42, 41);
}

test "indirect data component runtime read" {
    var indirect_data: ExampleIndirectDataComponent = .init(&SystemErds.example_indirect_erd_mapping);

    var should_be_42: u16 = undefined;
    var should_be_43: u16 = undefined;

    indirect_data.runtime_read(SystemErds.erd.erd_always_42.data_component_idx, &should_be_42);
    indirect_data.runtime_read(SystemErds.erd.erd_another_erd_plus_one.data_component_idx, &should_be_43);

    try std.testing.expectEqual(42, should_be_42);
    try std.testing.expectEqual(42 + 1, should_be_43);
}

test "indirect data component runtime write" {
    return error.SkipZigTest; // Test for compile error

    // var indirect_data = IndirectDataComponent.init([_]IndirectErdMapping{
    //     .map(.erd_always_42, erd_always_42),
    //     .map(.erd_another_erd_plus_one, plus_one),
    // });

    // _ = indirect_data.runtime_write(SystemErds.erd.erd_always_42.data_component_idx, &41);
}
