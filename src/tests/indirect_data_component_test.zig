const std = @import("std");
const Erd = @import("../erd.zig");

const erds = [_]Erd{
    .{ .erd_number = null, .T = u16, .component_idx = 0, .subs = 0, .data_component_idx = 0, .system_data_idx = 0 },
    .{ .erd_number = null, .T = u16, .component_idx = 0, .subs = 0, .data_component_idx = 1, .system_data_idx = 1 },
};

const IndirectDataComponent = @import("../indirect_data_component.zig").IndirectDataComponent(&erds);
const IndirectErdMapping = IndirectDataComponent.IndirectErdMapping;

const erd_always_42 = erds[0];
const erd_plus_one = erds[1];

fn always_42(data: *u16) void {
    data.* = 42;
}

fn plus_one(data: *u16) void {
    var should_be_42: u16 = undefined;
    always_42(&should_be_42);

    data.* = should_be_42 + 1;
}

const mappings = [_]IndirectErdMapping{
    IndirectErdMapping.map(erd_always_42, always_42),
    IndirectErdMapping.map(erd_plus_one, plus_one),
};

test "indirect data component read" {
    var indirect_data = IndirectDataComponent.init(mappings);

    try std.testing.expectEqual(42, indirect_data.read(erd_always_42));
    try std.testing.expectEqual(42 + 1, indirect_data.read(erd_plus_one));
}

test "indirect data component write" {
    return error.SkipZigTest; // Test for compile error

    // var indirect_data = IndirectDataComponent.init(mappings);
    // _ = indirect_data.write(erd_always_42, 41);
}

test "indirect data component runtime read" {
    var indirect_data = IndirectDataComponent.init(mappings);

    var should_be_42: u16 = undefined;
    var should_be_43: u16 = undefined;

    indirect_data.runtime_read(erd_always_42.data_component_idx, &should_be_42);
    indirect_data.runtime_read(erd_plus_one.data_component_idx, &should_be_43);

    try std.testing.expectEqual(42, should_be_42);
    try std.testing.expectEqual(42 + 1, should_be_43);
}

test "indirect data component runtime write" {
    return error.SkipZigTest; // Test for compile error

    // var indirect_data = IndirectDataComponent.init(mappings);
    // _ = indirect_data.runtime_write(erd_always_42.data_component_idx, &41);
}
