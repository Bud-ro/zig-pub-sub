//! ERD serialization — transforms Zig ERD types into consumable JSON output.

// zlinter-disable require_doc_comment
const std = @import("std");

pub const json = @import("erd_json.zig");

test {
    std.testing.refAllDecls(@This());
    _ = @import("tests/erd_json_test.zig");
}
