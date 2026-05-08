//! ERD serialization: transforms Zig ERD types into consumable JSON output,
//! provides the inverse (interpreting raw bytes from type descriptors),
//! and generates endian swap rules for wire serialization.

// zlinter-disable require_doc_comment
const std = @import("std");

pub const decode = @import("erd_json_decode.zig");
pub const json = @import("erd_json.zig");
pub const swap = @import("erd_swap.zig");
pub const type_gen = @import("erd_type_gen.zig");
pub const TypeFromDescriptor = type_gen.TypeFromDescriptor;
pub const SwapRules = swap.SwapRules;

test {
    std.testing.refAllDecls(@This());
    _ = @import("tests/erd_fuzz_test.zig");
    _ = @import("tests/erd_integration_test.zig");
    _ = @import("tests/erd_json_decode_test.zig");
    _ = @import("tests/erd_json_test.zig");
    _ = @import("tests/erd_swap_test.zig");
    _ = @import("tests/erd_type_gen_test.zig");
}
