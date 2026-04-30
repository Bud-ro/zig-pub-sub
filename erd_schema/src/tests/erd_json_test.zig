const std = @import("std");
const erd_schema = @import("erd_schema");
const erd_json = erd_schema.json;
const Erd = @import("erd_core").Erd;

const TestErds = struct {
    // zig fmt: off
    version:  Erd = .{ .erd_number = 0x0000, .T = u32,  .component_idx = 0, .subs = 0 },
    flag:     Erd = .{ .erd_number = 0x0001, .T = bool, .component_idx = 0, .subs = 0 },
    hidden:   Erd = .{ .erd_number = null,   .T = u16,  .component_idx = 0, .subs = 0 },
    sensor:   Erd = .{ .erd_number = 0x0010, .T = i32,  .component_idx = 0, .subs = 0 },
    // zig fmt: on
};

const test_erds = TestErds{};

test "generates JSON for ERDs with erd_numbers, skipping null" {
    var out: std.io.Writer.Allocating = .init(std.testing.allocator);
    defer out.deinit();

    try erd_json.generate(TestErds, test_erds, &out.writer, .{ .namespace = "test" });

    const expected =
        \\{
        \\    "erd-json-version": "0.1.0",
        \\    "namespace": "test",
        \\    "erds": [
        \\        {
        \\            "name": "version",
        \\            "id": "0x0000",
        \\            "type": "u32"
        \\        },
        \\        {
        \\            "name": "flag",
        \\            "id": "0x0001",
        \\            "type": "bool"
        \\        },
        \\        {
        \\            "name": "sensor",
        \\            "id": "0x0010",
        \\            "type": "i32"
        \\        }
        \\    ]
        \\}
    ;

    try std.testing.expectEqualStrings(expected, out.writer.buffered());
}

test "empty ERD definitions produce empty erds array" {
    const EmptyErds = struct {};
    var out: std.io.Writer.Allocating = .init(std.testing.allocator);
    defer out.deinit();

    try erd_json.generate(EmptyErds, .{}, &out.writer, .{});

    const expected =
        \\{
        \\    "erd-json-version": "0.1.0",
        \\    "namespace": "zig-pub-sub",
        \\    "erds": []
        \\}
    ;

    try std.testing.expectEqualStrings(expected, out.writer.buffered());
}
