const std = @import("std");

// --- Namespaces ---
/// ERD JSON serialization utilities.
pub const json = @import("erd_json.zig");

test {
    std.testing.refAllDecls(@This());
    _ = @import("tests/erd_json_test.zig");
}
