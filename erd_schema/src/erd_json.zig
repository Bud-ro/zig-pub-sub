/// Generic ERD JSON serialization
///
/// Generates a JSON representation of any ERD definitions struct.
/// Each field of the struct must be an Erd type with `erd_number` and `T` fields.
const std = @import("std");

pub const Options = struct {
    namespace: []const u8 = "zig-pub-sub",
    version: []const u8 = "0.1.0",
};

pub fn generate(comptime ErdDefs: type, erd_defs: ErdDefs, writer: *std.io.Writer, comptime options: Options) !void {
    var jws: std.json.Stringify = .{
        .writer = writer,
        .options = .{ .whitespace = .indent_4 },
    };
    try serialize(ErdDefs, erd_defs, &jws, options);
}

pub fn serialize(comptime ErdDefs: type, erd_defs: ErdDefs, jws: anytype, comptime options: Options) !void {
    const erd_names = comptime std.meta.fieldNames(ErdDefs);
    try jws.beginObject();
    {
        try jws.objectField("erd-json-version");
        try jws.write(options.version);
        try jws.objectField("namespace");
        try jws.write(options.namespace);
        try jws.objectField("erds");
        {
            try jws.beginArray();
            inline for (erd_names) |erd_name| {
                const e = @field(erd_defs, erd_name);
                if (e.erd_number != null) {
                    try jws.beginObject();
                    try jws.objectField("name");
                    try jws.write(erd_name);
                    try jws.objectField("id");
                    try jws.print("\"0x{x:0>4}\"", .{e.erd_number.?});
                    try jws.objectField("type");
                    try jws.print("\"{}\"", .{e.T});
                    try jws.endObject();
                }
            }
            try jws.endArray();
        }
    }
    try jws.endObject();
}
