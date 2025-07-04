const std = @import("std");
const ErdJson = @import("../erd_json.zig");

test "Correct ERD JSON Generation" {
    const generated_json = try ErdJson.generate_erd_json(std.testing.allocator);
    defer std.testing.allocator.free(generated_json);

    // TODO: Add the ability to pass an arbitrary table so that this test can remain static
    // and not require an update anytime system_erds.zig changes
    const expected_json =
        \\{
        \\    "erd-json-version": "0.1.0",
        \\    "namespace": "zig-embedded-starter-kit",
        \\    "erds": [
        \\        {
        \\            "name": "erd_application_version",
        \\            "id": "0x0000",
        \\            "type": "u32"
        \\        },
        \\        {
        \\            "name": "erd_some_bool",
        \\            "id": "0x0001",
        \\            "type": "bool"
        \\        },
        \\        {
        \\            "name": "erd_unaligned_u16",
        \\            "id": "0x0002",
        \\            "type": "u16"
        \\        },
        \\        {
        \\            "name": "erd_well_packed",
        \\            "id": "0x0003",
        \\            "type": "system_erds.WellPackedStruct"
        \\        },
        \\        {
        \\            "name": "erd_padded",
        \\            "id": "0x0004",
        \\            "type": "system_erds.PaddedStruct"
        \\        },
        \\        {
        \\            "name": "erd_actually_packed_fr",
        \\            "id": "0x0005",
        \\            "type": "system_erds.PackedFr"
        \\        },
        \\        {
        \\            "name": "erd_always_42",
        \\            "id": "0x0006",
        \\            "type": "u16"
        \\        },
        \\        {
        \\            "name": "erd_another_erd_plus_one",
        \\            "id": "0x0008",
        \\            "type": "u16"
        \\        }
        \\    ]
        \\}
    ;

    try std.testing.expectEqualStrings(expected_json, generated_json);
}
