const erd_core = @import("erd_core");
const std = @import("std");
const Erd = erd_core.Erd;
const IndirectMapping = erd_core.data_component.IndirectMapping;

const erds = [_]Erd{
    .{ .erd_number = null, .T = u16, .component_idx = 0, .subs = 0, .data_component_idx = 0, .system_data_idx = 0 },
    .{ .erd_number = null, .T = u16, .component_idx = 0, .subs = 0, .data_component_idx = 1, .system_data_idx = 1 },
};

const erd_always_42 = erds[0];
const erd_plus_one = erds[1];

fn always42(data: *u16) void {
    data.* = 42;
}

fn plusOne(data: *u16) void {
    var should_be_42: u16 = undefined;
    always42(&should_be_42);

    data.* = should_be_42 + 1;
}

const mappings = [_]IndirectMapping{
    .map(erd_always_42, always42),
    .map(erd_plus_one, plusOne),
};

const IndirectDataComponent = erd_core.data_component.Indirect(&erds, mappings);

test "indirect data component read" {
    var indirect_data = IndirectDataComponent{};

    try std.testing.expectEqual(42, indirect_data.read(erd_always_42));
    try std.testing.expectEqual(42 + 1, indirect_data.read(erd_plus_one));
}

test "indirect data component write" {
    return error.SkipZigTest; // Test for compile error

    // zlinter-disable no_comment_out_code
    // var indirect_data = IndirectDataComponent{};
    // _ = indirect_data.write(erd_always_42, 41);
    // zlinter-enable no_comment_out_code
}

test "indirect data component runtime read" {
    var indirect_data = IndirectDataComponent{};

    var should_be_42: u16 = undefined;
    var should_be_43: u16 = undefined;

    indirect_data.runtimeRead(erd_always_42.data_component_idx, &should_be_42);
    indirect_data.runtimeRead(erd_plus_one.data_component_idx, &should_be_43);

    try std.testing.expectEqual(42, should_be_42);
    try std.testing.expectEqual(42 + 1, should_be_43);
}

test "indirect data component runtime write" {
    return error.SkipZigTest; // Test for compile error

    // zlinter-disable no_comment_out_code
    // var indirect_data = IndirectDataComponent{};
    // _ = indirect_data.runtimeWrite(erd_always_42.data_component_idx, &41);
    // zlinter-enable no_comment_out_code
}
