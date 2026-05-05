//! ERD serialization: transforms Zig ERD types into consumable JSON output,
//! and provides the inverse (interpreting raw bytes from type descriptors).

// zlinter-disable require_doc_comment
const std = @import("std");

pub const decode = @import("erd_json_decode.zig");
pub const json = @import("erd_json.zig");
pub const type_gen = @import("erd_type_gen.zig");
pub const TypeFromDescriptor = type_gen.TypeFromDescriptor;

test {
    std.testing.refAllDecls(@This());
    _ = @import("tests/erd_json_test.zig");
    _ = @import("tests/erd_json_decode_test.zig");
    _ = @import("tests/erd_type_gen_test.zig");
}
