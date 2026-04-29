pub const erd_json = @import("erd_json.zig");
pub const generate_erd_json = erd_json.generate;
pub const serialize_erd_json = erd_json.serialize;
pub const JsonOptions = erd_json.Options;

test {
    _ = @import("tests/erd_json_test.zig");
}
