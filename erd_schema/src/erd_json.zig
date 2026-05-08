//! ERD JSON serialization.
//!
//! Generates a JSON representation of any ERD definitions struct.
//! Each field of the struct must be an Erd type with `erd_number` and `T` fields.
//! ERDs without an `erd_number` are omitted. Each emitted ERD includes a full
//! type descriptor that external tools can use to interpret raw bytes.
const std = @import("std");

/// Configuration options for ERD JSON output.
pub const Options = struct {
    /// Namespace identifier included in the JSON header.
    namespace: []const u8 = "zig-pub-sub",
    /// Schema version string included in the JSON header.
    version: []const u8 = "0.1.0",
};

/// Generate JSON representation of ERD definitions to the given writer.
// zlinter-disable-next-line no_inferred_error_unions
pub fn generate(erd_defs: anytype, writer: *std.Io.Writer, comptime options: Options) !void {
    var jws: std.json.Stringify = .{
        .writer = writer,
        .options = .{ .whitespace = .indent_4 },
    };
    try serialize(erd_defs, &jws, options);
}

/// Serialize ERD definitions into the provided JSON write stream.
// zlinter-disable-next-line no_inferred_error_unions
pub fn serialize(erd_defs: anytype, jws: anytype, comptime options: Options) !void {
    const ErdDefs = @TypeOf(erd_defs);
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
                    try typeDescriptor(e.T, jws);
                    try jws.endObject();
                }
            }
            try jws.endArray();
        }
    }
    try jws.endObject();
}

/// Generate just a type descriptor as a standalone JSON string.
// zlinter-disable-next-line no_inferred_error_unions
pub fn generateTypeDescriptor(T: type, writer: *std.Io.Writer) !void {
    var jws: std.json.Stringify = .{
        .writer = writer,
        .options = .{ .whitespace = .indent_4 },
    };
    try typeDescriptor(T, &jws);
}

/// Emit a full type descriptor for any Zig type so external tools can
/// interpret raw bytes unambiguously.
// zlinter-disable-next-line no_inferred_error_unions
pub fn typeDescriptor(T: type, jws: anytype) !void {
    const info = @typeInfo(T);
    switch (info) {
        .int => |int_info| {
            try jws.beginObject();
            try jws.objectField("kind");
            try jws.write("primitive");
            try jws.objectField("name");
            try jws.print("\"{}\"", .{T});
            try jws.objectField("size");
            try jws.write(@sizeOf(T));
            try jws.objectField("signedness");
            try jws.write(if (int_info.signedness == .signed) "signed" else "unsigned");
            try jws.objectField("bits");
            try jws.write(int_info.bits);
            try jws.endObject();
        },
        .bool => {
            try jws.beginObject();
            try jws.objectField("kind");
            try jws.write("primitive");
            try jws.objectField("name");
            try jws.write("bool");
            try jws.objectField("size");
            try jws.write(@sizeOf(bool));
            try jws.objectField("signedness");
            try jws.write("unsigned");
            try jws.objectField("bits");
            try jws.write(1);
            try jws.endObject();
        },
        .@"struct" => |struct_info| {
            if (struct_info.layout == .auto) {
                @compileError("Cannot serialize auto-layout struct '" ++
                    @typeName(T) ++ "': Zig may reorder fields, " ++
                    "so byte layout is not deterministic. Use extern or packed.");
            }
            try jws.beginObject();
            try jws.objectField("kind");
            try jws.write("struct");
            try jws.objectField("name");
            try jws.print("\"{}\"", .{T});
            try jws.objectField("layout");
            try jws.write(if (struct_info.layout == .@"packed") "packed" else "extern");
            try jws.objectField("size");
            try jws.write(@sizeOf(T));
            if (struct_info.layout == .@"packed") {
                try jws.objectField("backing_integer_bits");
                try jws.write(@bitSizeOf(T));
            }
            try jws.objectField("fields");
            try jws.beginArray();
            inline for (struct_info.fields) |field| {
                try jws.beginObject();
                try jws.objectField("name");
                try jws.write(field.name);
                if (struct_info.layout == .@"packed") {
                    try jws.objectField("bit_offset");
                    try jws.write(@bitOffsetOf(T, field.name));
                    try jws.objectField("bits");
                    try jws.write(@bitSizeOf(field.type));
                } else {
                    try jws.objectField("offset");
                    try jws.write(@offsetOf(T, field.name));
                }
                try jws.objectField("type_descriptor");
                try typeDescriptor(field.type, jws);
                try jws.endObject();
            }
            try jws.endArray();
            try jws.endObject();
        },
        .@"enum" => |enum_info| {
            try jws.beginObject();
            try jws.objectField("kind");
            try jws.write("enum");
            try jws.objectField("name");
            try jws.print("\"{}\"", .{T});
            try jws.objectField("tag_type");
            try jws.print("\"{}\"", .{enum_info.tag_type});
            try jws.objectField("size");
            try jws.write(@sizeOf(T));
            try jws.objectField("variants");
            try jws.beginArray();
            inline for (enum_info.fields) |field| {
                try jws.write(field.name);
            }
            try jws.endArray();
            try jws.endObject();
        },
        .array => |array_info| {
            if (array_info.child == u8) {
                // [N]u8 is a null-terminated string buffer
                try jws.beginObject();
                try jws.objectField("kind");
                try jws.write("string");
                try jws.objectField("max_len");
                try jws.write(array_info.len);
                try jws.objectField("size");
                try jws.write(@sizeOf(T));
                try jws.endObject();
            } else {
                try jws.beginObject();
                try jws.objectField("kind");
                try jws.write("array");
                try jws.objectField("len");
                try jws.write(array_info.len);
                try jws.objectField("size");
                try jws.write(@sizeOf(T));
                try jws.objectField("element");
                try typeDescriptor(array_info.child, jws);
                try jws.endObject();
            }
        },
        .float => |float_info| {
            try jws.beginObject();
            try jws.objectField("kind");
            try jws.write("float");
            try jws.objectField("name");
            try jws.print("\"{}\"", .{T});
            try jws.objectField("size");
            try jws.write(@sizeOf(T));
            try jws.objectField("bits");
            try jws.write(float_info.bits);
            try jws.endObject();
        },
        .@"union" => |union_info| {
            if (union_info.layout != .@"extern") {
                @compileError("Cannot serialize non-extern union '" ++ @typeName(T) ++
                    "': only extern unions have a guaranteed memory layout");
            }
            // extern unions cannot have tag types in Zig; the tag must be
            // a separate field in a wrapping extern struct
            try jws.beginObject();
            try jws.objectField("kind");
            try jws.write("union");
            try jws.objectField("name");
            try jws.print("\"{}\"", .{T});
            try jws.objectField("layout");
            try jws.write("extern");
            try jws.objectField("size");
            try jws.write(@sizeOf(T));
            try jws.objectField("fields");
            try jws.beginArray();
            inline for (union_info.fields) |field| {
                try jws.beginObject();
                try jws.objectField("name");
                try jws.write(field.name);
                try jws.objectField("type_descriptor");
                try typeDescriptor(field.type, jws);
                try jws.endObject();
            }
            try jws.endArray();
            try jws.endObject();
        },
        .vector => {
            @compileError("Cannot serialize vector type '" ++ @typeName(T) ++
                "': vectors have no guaranteed byte layout (@ptrCast to array is illegal)");
        },
        .optional => {
            @compileError("Cannot serialize optional type '" ++ @typeName(T) ++
                "': non-pointer optionals have no guaranteed in-memory representation");
        },
        .pointer => {
            @compileError("Cannot serialize pointer type '" ++ @typeName(T) ++
                "': pointers are memory addresses with no meaning outside the originating process");
        },
        else => {
            @compileError("Cannot serialize type '" ++ @typeName(T) ++
                "': unsupported type category for wire serialization");
        },
    }
}
