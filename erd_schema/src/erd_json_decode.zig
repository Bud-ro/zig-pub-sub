//! Runtime decoder for type descriptors.
//!
//! Given a parsed JSON type descriptor and a raw byte buffer, interprets and
//! pretty-prints field names and values. Useful for debug tools, protocol
//! analyzers, and host-side ERD viewers that receive raw bytes over the wire.
//!
//! Lifetime: The root TypeDescriptor returned by `init()` (or
//! `initFromValue()`) owns the JSON parse tree. All string fields (names,
//! variant names, layout) point into that tree. Child TypeDescriptors
//! allocated for nested types share this lifetime. Do not use any
//! TypeDescriptor or its string fields after calling `deinit()` on the root.
const builtin = @import("builtin");
const std = @import("std");
const native = builtin.cpu.arch.endian();

/// Errors from parsing a JSON type descriptor into a TypeDescriptor.
pub const ParseError = error{
    UnsupportedKind,
    OutOfMemory,
    BufferUnderrun,
    ValueTooLong,
} || std.json.ParseFromValueError || std.json.Error;

/// Errors from formatting bytes through a TypeDescriptor.
pub const FormatError = error{ OutOfMemory, WriteFailed };

/// A runtime representation of a Zig type, parsed from a JSON type descriptor.
/// Supports interpreting raw byte buffers, pretty-printing values, and
/// converting between big-endian wire format and native byte order.
///
/// String fields (names, variants) point into the JSON parse tree that was
/// used to create this descriptor. The caller must keep that parse tree
/// alive for the lifetime of this descriptor.
pub const TypeDescriptor = struct {
    /// The kind and type-specific metadata.
    kind: Kind,

    const Kind = union(enum) {
        primitive: Primitive,
        float: Float,
        structure: Struct,
        array: Array,
        string: String,
        enumeration: Enum,
        @"union": Union,
    };

    const Primitive = struct {
        name: []const u8,
        size: usize,
        bits: usize,
        signed: bool,
    };

    const Float = struct {
        name: []const u8,
        size: usize,
        bits: usize,
    };

    const String = struct {
        max_len: usize,
        size: usize,
    };

    const Field = struct {
        name: []const u8,
        offset: ?usize,
        bit_offset: ?usize,
        bits: ?usize,
        type_desc: *TypeDescriptor,
    };

    const Struct = struct {
        name: []const u8,
        layout: []const u8,
        size: usize,
        backing_bits: ?usize,
        fields: []Field,
    };

    const Array = struct {
        len: usize,
        size: usize,
        element: *TypeDescriptor,
    };

    const Enum = struct {
        name: []const u8,
        size: usize,
        variants: []const []const u8,
    };

    const UnionField = struct {
        name: []const u8,
        type_desc: *TypeDescriptor,
    };

    const Union = struct {
        name: []const u8,
        layout: []const u8,
        size: usize,
        fields: []UnionField,
    };

    /// Build a TypeDescriptor from a parsed JSON value.
    /// The caller must keep `parsed` alive for the lifetime of this descriptor
    /// (string fields point into its memory).
    pub fn init(allocator: std.mem.Allocator, parsed: std.json.Parsed(std.json.Value)) ParseError!TypeDescriptor {
        return try fromValue(allocator, parsed.value);
    }

    /// Build a TypeDescriptor from a JSON value (e.g., a nested object
    /// within a larger parsed document). The caller manages the lifetime
    /// of whatever owns the value's string memory.
    pub fn initFromValue(allocator: std.mem.Allocator, value: std.json.Value) ParseError!TypeDescriptor {
        return try fromValue(allocator, value);
    }

    /// Free all child TypeDescriptors and field slices allocated during init.
    pub fn deinit(self: *TypeDescriptor, allocator: std.mem.Allocator) void {
        switch (self.kind) {
            .structure => |s| {
                for (s.fields) |*field| {
                    field.type_desc.deinit(allocator);
                    allocator.destroy(field.type_desc);
                }
                allocator.free(s.fields);
            },
            .array => |a| {
                a.element.deinit(allocator);
                allocator.destroy(a.element);
            },
            .enumeration => |e| {
                allocator.free(e.variants);
            },
            .@"union" => |u| {
                for (u.fields) |*field| {
                    field.type_desc.deinit(allocator);
                    allocator.destroy(field.type_desc);
                }
                allocator.free(u.fields);
            },
            .primitive, .float, .string => {},
        }
    }

    fn fromValue(allocator: std.mem.Allocator, value: std.json.Value) ParseError!TypeDescriptor {
        const obj = value.object;
        const kind_str = obj.get("kind").?.string;

        if (std.mem.eql(u8, kind_str, "primitive")) {
            return .{
                .kind = .{ .primitive = .{
                    .name = obj.get("name").?.string,
                    .size = @intCast(obj.get("size").?.integer),
                    .bits = @intCast(obj.get("bits").?.integer),
                    .signed = std.mem.eql(u8, obj.get("signedness").?.string, "signed"),
                } },
            };
        } else if (std.mem.eql(u8, kind_str, "float")) {
            return .{
                .kind = .{ .float = .{
                    .name = obj.get("name").?.string,
                    .size = @intCast(obj.get("size").?.integer),
                    .bits = @intCast(obj.get("bits").?.integer),
                } },
            };
        } else if (std.mem.eql(u8, kind_str, "struct")) {
            return parseStructValue(allocator, obj);
        } else if (std.mem.eql(u8, kind_str, "string")) {
            return .{
                .kind = .{ .string = .{
                    .max_len = @intCast(obj.get("max_len").?.integer),
                    .size = @intCast(obj.get("size").?.integer),
                } },
            };
        } else if (std.mem.eql(u8, kind_str, "array")) {
            const elem_td = try allocator.create(TypeDescriptor);
            errdefer allocator.destroy(elem_td);
            elem_td.* = try fromValue(allocator, obj.get("element").?);
            return .{
                .kind = .{ .array = .{
                    .len = @intCast(obj.get("len").?.integer),
                    .size = @intCast(obj.get("size").?.integer),
                    .element = elem_td,
                } },
            };
        } else if (std.mem.eql(u8, kind_str, "enum")) {
            return parseEnumValue(allocator, obj);
        } else if (std.mem.eql(u8, kind_str, "union")) {
            return parseUnionValue(allocator, obj);
        } else {
            return error.UnsupportedKind;
        }
    }

    fn parseStructValue(allocator: std.mem.Allocator, obj: std.json.ObjectMap) ParseError!TypeDescriptor {
        const fields_arr = obj.get("fields").?.array.items;
        const fields = try allocator.alloc(Field, fields_arr.len);
        errdefer allocator.free(fields);

        // Free any child TypeDescriptors already constructed if a later iteration fails.
        var built: usize = 0;
        errdefer for (fields[0..built]) |*f| {
            f.type_desc.deinit(allocator);
            allocator.destroy(f.type_desc);
        };

        for (fields_arr, 0..) |field_val, i| {
            const fo = field_val.object;
            const child_td = try allocator.create(TypeDescriptor);
            errdefer allocator.destroy(child_td);
            child_td.* = try fromValue(allocator, fo.get("type_descriptor").?);
            fields[i] = .{
                .name = fo.get("name").?.string,
                .offset = if (fo.get("offset")) |off| switch (off) {
                    .integer => |v| @as(?usize, @intCast(v)),
                    else => null,
                } else null,
                .bit_offset = if (fo.get("bit_offset")) |bo| @as(?usize, @intCast(bo.integer)) else null,
                .bits = if (fo.get("bits")) |b| @as(?usize, @intCast(b.integer)) else null,
                .type_desc = child_td,
            };
            built = i + 1;
        }
        return .{
            .kind = .{ .structure = .{
                .name = obj.get("name").?.string,
                .layout = obj.get("layout").?.string,
                .size = @intCast(obj.get("size").?.integer),
                .backing_bits = if (obj.get("backing_integer_bits")) |b| @as(?usize, @intCast(b.integer)) else null,
                .fields = fields,
            } },
        };
    }

    fn parseEnumValue(allocator: std.mem.Allocator, obj: std.json.ObjectMap) ParseError!TypeDescriptor {
        const variants_arr = obj.get("variants").?.array.items;
        const variants = try allocator.alloc([]const u8, variants_arr.len);
        for (variants_arr, 0..) |v, i| {
            variants[i] = v.string;
        }
        return .{
            .kind = .{ .enumeration = .{
                .name = obj.get("name").?.string,
                .size = @intCast(obj.get("size").?.integer),
                .variants = variants,
            } },
        };
    }

    fn parseUnionValue(allocator: std.mem.Allocator, obj: std.json.ObjectMap) ParseError!TypeDescriptor {
        const fields_arr = obj.get("fields").?.array.items;
        const fields = try allocator.alloc(UnionField, fields_arr.len);
        errdefer allocator.free(fields);

        var built: usize = 0;
        errdefer for (fields[0..built]) |*f| {
            f.type_desc.deinit(allocator);
            allocator.destroy(f.type_desc);
        };

        for (fields_arr, 0..) |field_val, i| {
            const fo = field_val.object;
            const child_td = try allocator.create(TypeDescriptor);
            errdefer allocator.destroy(child_td);
            child_td.* = try fromValue(allocator, fo.get("type_descriptor").?);
            fields[i] = .{
                .name = fo.get("name").?.string,
                .type_desc = child_td,
            };
            built = i + 1;
        }
        return .{
            .kind = .{ .@"union" = .{
                .name = obj.get("name").?.string,
                .layout = obj.get("layout").?.string,
                .size = @intCast(obj.get("size").?.integer),
                .fields = fields,
            } },
        };
    }

    /// Interpret raw bytes and write a human-readable representation.
    pub fn formatBytes(self: *const TypeDescriptor, bytes: []const u8, writer: anytype) FormatError!void {
        try self.formatBytesInner(bytes, writer, 0);
    }

    fn formatBytesInner(self: *const TypeDescriptor, bytes: []const u8, writer: anytype, indent: usize) FormatError!void {
        switch (self.kind) {
            .primitive => |p| {
                if (std.mem.eql(u8, p.name, "bool")) {
                    try writer.print("{s}", .{if (bytes[0] != 0) "true" else "false"});
                } else if (p.signed) {
                    try writer.print("{d}", .{readSignedInt(bytes, p.bits)});
                } else {
                    try writer.print("{d}", .{readUnsignedInt(bytes, p.bits)});
                }
            },
            .float => |f| {
                switch (f.bits) {
                    16 => {
                        const val: f16 = @bitCast(std.mem.readInt(u16, bytes[0..2], native));
                        try writer.print("{d}", .{@as(f32, val)});
                    },
                    32 => {
                        const val: f32 = @bitCast(std.mem.readInt(u32, bytes[0..4], native));
                        try writer.print("{d}", .{val});
                    },
                    64 => {
                        const val: f64 = @bitCast(std.mem.readInt(u64, bytes[0..8], native));
                        try writer.print("{d}", .{val});
                    },
                    else => {
                        try writer.print("<float{d}>", .{f.bits});
                    },
                }
            },
            .structure => |s| {
                if (std.mem.eql(u8, s.layout, "packed")) {
                    try formatPackedStruct(s, bytes, writer, indent);
                } else {
                    try formatExternStruct(s, bytes, writer, indent);
                }
            },
            .string => |s| {
                const end = std.mem.findScalar(u8, bytes[0..@min(s.max_len, bytes.len)], 0) orelse @min(s.max_len, bytes.len);
                try writer.print("\"{s}\"", .{bytes[0..end]});
            },
            .array => |a| {
                try writer.print("[", .{});
                if (a.len > 0) {
                    const elem_size = a.size / a.len;
                    for (0..a.len) |i| {
                        if (i > 0) try writer.print(", ", .{});
                        const start = i * elem_size;
                        const end_pos = start + elem_size;
                        if (end_pos <= bytes.len) {
                            try a.element.formatBytesInner(bytes[start..end_pos], writer, indent);
                        }
                    }
                }
                try writer.print("]", .{});
            },
            .enumeration => |e| {
                const raw = readUnsignedInt(bytes[0..e.size], e.size * 8);
                if (raw < e.variants.len) {
                    try writer.print("{s}", .{e.variants[raw]});
                } else {
                    try writer.print("<unknown:{d}>", .{raw});
                }
            },
            .@"union" => |u| {
                try writer.print("union{{ ", .{});
                for (u.fields, 0..) |field, i| {
                    if (i > 0) try writer.print(", ", .{});
                    try writer.print("{s}: ", .{field.name});
                    const field_size = field.type_desc.getSize();
                    if (field_size <= bytes.len) {
                        try field.type_desc.formatBytesInner(bytes[0..field_size], writer, indent + 1);
                    }
                }
                try writer.print(" }}", .{});
            },
        }
    }

    fn formatExternStruct(s: Struct, bytes: []const u8, writer: anytype, indent: usize) FormatError!void {
        // Tagged union convention: exactly 2 fields, first named "tag"
        // (enum or int), second is a union. Print only the active variant.
        if (s.fields.len == 2 and std.mem.eql(u8, s.fields[0].name, "tag")) {
            const union_field = s.fields[1];
            if (union_field.type_desc.kind == .@"union") {
                try formatTaggedUnion(s.fields[0], union_field, bytes, writer, indent);
                return;
            }
        }

        try writer.print("{{ ", .{});
        for (s.fields, 0..) |field, i| {
            if (i > 0) try writer.print(", ", .{});
            try writer.print("{s}: ", .{field.name});
            const offset = field.offset orelse 0;
            const field_size = field.type_desc.getSize();
            if (offset + field_size <= bytes.len) {
                try field.type_desc.formatBytesInner(bytes[offset .. offset + field_size], writer, indent + 1);
            } else {
                try writer.print("<out-of-bounds>", .{});
            }
        }
        try writer.print(" }}", .{});
    }

    fn formatTaggedUnion(tag_field: Field, union_field: Field, bytes: []const u8, writer: anytype, indent: usize) FormatError!void {
        const tag_offset = tag_field.offset orelse 0;
        const tag_size = tag_field.type_desc.getSize();
        const union_offset = union_field.offset orelse 0;
        const u = union_field.type_desc.kind.@"union";

        // Read the tag value
        const tag_val = readUnsignedInt(bytes[tag_offset .. tag_offset + tag_size], tag_size * 8);

        // Resolve tag name (if tag is an enum with variants)
        var tag_name: ?[]const u8 = null;
        if (tag_field.type_desc.kind == .enumeration) {
            const e = tag_field.type_desc.kind.enumeration;
            if (tag_val < e.variants.len) {
                tag_name = e.variants[tag_val];
            }
        }

        // Find the matching union variant
        var active_field: ?*const UnionField = null;
        if (tag_name) |name| {
            for (u.fields) |*uf| {
                if (std.mem.eql(u8, uf.name, name)) {
                    active_field = uf;
                    break;
                }
            }
        }

        if (active_field) |af| {
            // Print as: { tag: variant_name, union_field.variant: value }
            try writer.print("{{ tag: {s}, {s}.{s}: ", .{ tag_name.?, union_field.name, af.name });
            const field_size = af.type_desc.getSize();
            if (union_offset + field_size <= bytes.len) {
                try af.type_desc.formatBytesInner(bytes[union_offset .. union_offset + field_size], writer, indent + 1);
            }
            try writer.print(" }}", .{});
        } else {
            // Unknown tag value - print tag as number and all union interpretations
            try writer.print("{{ tag: {d}, ", .{tag_val});
            try union_field.type_desc.formatBytesInner(bytes[union_offset .. union_offset + u.size], writer, indent + 1);
            try writer.print(" }}", .{});
        }
    }

    fn formatPackedStruct(s: Struct, bytes: []const u8, writer: anytype, indent: usize) FormatError!void {
        _ = indent;
        try writer.print("{{ ", .{});
        for (s.fields, 0..) |field, i| {
            if (i > 0) try writer.print(", ", .{});
            try writer.print("{s}: ", .{field.name});
            const bit_offset = field.bit_offset orelse 0;
            const bits = field.bits orelse 1;
            try writer.print("{d}", .{readBits(bytes, bit_offset, bits)});
        }
        try writer.print(" }}", .{});
    }

    /// Returns the size in bytes of the type this descriptor represents.
    pub fn getSize(self: *const TypeDescriptor) usize {
        return switch (self.kind) {
            .primitive => |p| p.size,
            .float => |f| f.size,
            .structure => |s| s.size,
            .array => |a| a.size,
            .string => |s| s.size,
            .enumeration => |e| e.size,
            .@"union" => |u| u.size,
        };
    }

    /// Swap big-endian bytes to native in-place, using the type descriptor
    /// to know which byte ranges are multi-byte integers/floats.
    pub fn swapBigToNative(self: *const TypeDescriptor, buf: []u8) void {
        switch (self.kind) {
            .primitive => |p| {
                if (p.size > 1) std.mem.reverse(u8, buf[0..p.size]);
            },
            .float => |f| {
                if (f.size > 1) std.mem.reverse(u8, buf[0..f.size]);
            },
            .enumeration => |e| {
                if (e.size > 1) std.mem.reverse(u8, buf[0..e.size]);
            },
            .structure => |s| {
                if (std.mem.eql(u8, s.layout, "packed")) {
                    if (s.size > 1) std.mem.reverse(u8, buf[0..s.size]);
                } else {
                    for (s.fields) |field| {
                        const offset = field.offset orelse continue;
                        const field_size = field.type_desc.getSize();
                        if (offset + field_size <= buf.len) {
                            field.type_desc.swapBigToNative(buf[offset .. offset + field_size]);
                        }
                    }
                }
            },
            .array => |a| {
                if (a.len > 0) {
                    const elem_size = a.size / a.len;
                    for (0..a.len) |i| {
                        const start = i * elem_size;
                        const end = start + elem_size;
                        if (end <= buf.len) {
                            a.element.swapBigToNative(buf[start..end]);
                        }
                    }
                }
            },
            .string => {},
            .@"union" => {},
        }
    }

    /// Format big-endian (wire) bytes directly. Copies the data, swaps to native,
    /// then formats. The original bytes are not modified.
    /// For tagged unions (struct with "tag" + union), swaps the active variant
    /// based on the tag value.
    pub fn formatBytesBig(self: *const TypeDescriptor, be_bytes: []const u8, writer: anytype) FormatError!void {
        var buf: [256]u8 = undefined;
        const size = self.getSize();
        if (size > buf.len or size > be_bytes.len) return error.OutOfMemory;
        @memcpy(buf[0..size], be_bytes[0..size]);
        self.swapBigToNative(buf[0..size]);

        // For tagged unions, also swap the active union variant
        if (self.kind == .structure) {
            const s = self.kind.structure;
            if (s.fields.len == 2 and std.mem.eql(u8, s.fields[0].name, "tag") and s.fields[1].type_desc.kind == .@"union") {
                const tag_offset = s.fields[0].offset orelse 0;
                const tag_size = s.fields[0].type_desc.getSize();
                const union_offset = s.fields[1].offset orelse 0;
                const u = s.fields[1].type_desc.kind.@"union";
                const tag_val = readUnsignedInt(buf[tag_offset .. tag_offset + tag_size], tag_size * 8);

                // Find active variant name from enum
                var variant_name: ?[]const u8 = null;
                if (s.fields[0].type_desc.kind == .enumeration) {
                    const e = s.fields[0].type_desc.kind.enumeration;
                    if (tag_val < e.variants.len) variant_name = e.variants[tag_val];
                }

                // Swap the active variant's bytes
                if (variant_name) |name| {
                    for (u.fields) |uf| {
                        if (std.mem.eql(u8, uf.name, name)) {
                            const fs = uf.type_desc.getSize();
                            if (union_offset + fs <= size) {
                                uf.type_desc.swapBigToNative(buf[union_offset .. union_offset + fs]);
                            }
                            break;
                        }
                    }
                }
            }
        }

        try self.formatBytesInner(buf[0..size], writer, 0);
    }

    /// Extract a numeric value from big-endian bytes using this descriptor.
    /// T must be large enough to hold the value (e.g., i64 for any signed int).
    pub fn parseIntBig(self: *const TypeDescriptor, T: type, be_bytes: []const u8) error{TypeMismatch}!T {
        const size = self.getSize();
        if (size > be_bytes.len) return error.TypeMismatch;
        switch (self.kind) {
            .primitive => |p| {
                if (p.size > @sizeOf(T)) return error.TypeMismatch;
                if (p.signed) {
                    return @intCast(readSignedIntBig(be_bytes, p.bits));
                } else {
                    return @intCast(readUnsignedIntBig(be_bytes, p.bits));
                }
            },
            .enumeration => |e| {
                if (e.size > @sizeOf(T)) return error.TypeMismatch;
                return @intCast(readUnsignedIntBig(be_bytes, e.size * 8));
            },
            else => return error.TypeMismatch,
        }
    }
};

/// Read an unsigned integer from native-endian bytes.
/// Bytes must already be in host byte order (use SwapRules to convert from wire BE first).
fn readUnsignedInt(bytes: []const u8, bits: usize) u64 {
    // Fast paths for common sizes
    return switch (bits) {
        8 => bytes[0],
        16 => std.mem.readInt(u16, bytes[0..2], native),
        32 => std.mem.readInt(u32, bytes[0..4], native),
        64 => std.mem.readInt(u64, bytes[0..8], native),
        else => readUnsignedIntGeneric(bytes, bits),
    };
}

fn readUnsignedIntGeneric(bytes: []const u8, bits: usize) u64 {
    var result: u64 = 0;
    const byte_count = (bits + 7) / 8;
    for (0..@min(byte_count, bytes.len)) |i| {
        result |= @as(u64, bytes[i]) << @as(u6, @intCast(i * 8));
    }
    if (bits < 64) {
        const mask = (@as(u64, 1) << @as(u6, @intCast(bits))) - 1;
        result &= mask;
    }
    return result;
}

/// Read a signed integer from native-endian bytes with sign extension.
fn readSignedInt(bytes: []const u8, bits: usize) i64 {
    return signExtend(readUnsignedInt(bytes, bits), bits);
}

/// Sign-extend an N-bit unsigned value to a 64-bit signed value.
fn signExtend(unsigned: u64, bits: usize) i64 {
    if (bits == 0) return 0;
    if (bits >= 64) return @bitCast(unsigned);
    const sign_bit = @as(u64, 1) << @intCast(bits - 1);
    if (unsigned & sign_bit != 0) {
        const mask = ~((@as(u64, 1) << @intCast(bits)) - 1);
        return @bitCast(unsigned | mask);
    }
    return @intCast(unsigned);
}

/// Read an unsigned integer from big-endian bytes.
fn readUnsignedIntBig(bytes: []const u8, bits: usize) u64 {
    return switch (bits) {
        8 => bytes[0],
        16 => std.mem.readInt(u16, bytes[0..2], .big),
        32 => std.mem.readInt(u32, bytes[0..4], .big),
        64 => std.mem.readInt(u64, bytes[0..8], .big),
        else => blk: {
            // Generic BE: MSB first
            var result: u64 = 0;
            const byte_count = (bits + 7) / 8;
            for (0..@min(byte_count, bytes.len)) |i| {
                result = (result << 8) | bytes[i];
            }
            if (bits < 64) {
                const mask = (@as(u64, 1) << @as(u6, @intCast(bits))) - 1;
                result &= mask;
            }
            break :blk result;
        },
    };
}

fn readSignedIntBig(bytes: []const u8, bits: usize) i64 {
    return signExtend(readUnsignedIntBig(bytes, bits), bits);
}

fn readBits(bytes: []const u8, bit_offset: usize, bit_count: usize) u64 {
    var result: u64 = 0;
    for (0..bit_count) |i| {
        const bit_pos = bit_offset + i;
        const byte_idx = bit_pos / 8;
        const bit_idx: u3 = @intCast(bit_pos % 8);
        if (byte_idx < bytes.len) {
            const bit: u64 = (bytes[byte_idx] >> bit_idx) & 1;
            result |= bit << @intCast(i);
        }
    }
    return result;
}

// =======================================================================
// SchemaRegistry: look up ERDs by number and format wire data
// =======================================================================

/// Metadata for a single ERD in the schema: its name, number, type
/// descriptor, and byte size.
pub const ErdInfo = struct {
    /// Human-readable name from the ERD definitions (e.g., "firmware_version").
    name: []const u8,
    /// Public ERD handle used in wire messages.
    erd_number: u16,
    /// Type descriptor for interpreting the ERD's data bytes.
    td: TypeDescriptor,
    /// Size in bytes of this ERD's data.
    size: usize,
};

/// Registry of ERD type descriptors, built from a parsed JSON schema.
/// Provides lookup by erd_number and pretty-printing of wire data.
/// Takes ownership of the parsed JSON and frees it on deinit.
pub const SchemaRegistry = struct {
    entries: []ErdInfo,
    allocator: std.mem.Allocator,
    _parsed: std.json.Parsed(std.json.Value),

    /// Errors from `formatErdBig`.
    pub const FormatErdError = error{ ErdNotFound, SizeMismatch, OutOfMemory, WriteFailed };

    /// Build a registry from a parsed ERD schema JSON. Takes ownership
    /// of `parsed` and frees it on `deinit`.
    pub fn init(allocator: std.mem.Allocator, parsed: std.json.Parsed(std.json.Value)) ParseError!SchemaRegistry {
        const erd_array = parsed.value.object.get("erds").?.array.items;
        const entries = try allocator.alloc(ErdInfo, erd_array.len);
        errdefer allocator.free(entries);

        // If a later iteration fails, free any TypeDescriptors we've already built.
        var created: usize = 0;
        errdefer for (entries[0..created]) |*e| e.td.deinit(allocator);

        for (erd_array, 0..) |erd_val, i| {
            const obj = erd_val.object;
            const td = try TypeDescriptor.initFromValue(allocator, obj.get("type").?);
            const id_str = obj.get("id").?.string;
            entries[i] = .{
                .name = obj.get("name").?.string,
                .erd_number = std.fmt.parseInt(u16, id_str[2..], 16) catch 0,
                .td = td,
                .size = td.getSize(),
            };
            created = i + 1;
        }

        return .{ .entries = entries, .allocator = allocator, ._parsed = parsed };
    }

    /// Free all entries, type descriptors, and the owned JSON parse tree.
    pub fn deinit(self: *SchemaRegistry) void {
        for (self.entries) |*e| e.td.deinit(self.allocator);
        self.allocator.free(self.entries);
        self._parsed.deinit();
    }

    /// Look up an ERD by its public handle. Returns null if not found.
    pub fn findByNumber(self: *const SchemaRegistry, erd_number: u16) ?*const ErdInfo {
        for (self.entries) |*entry| {
            if (entry.erd_number == erd_number) return entry;
        }
        return null;
    }

    /// Pretty-print an ERD from big-endian wire data.
    /// Writes "erd_name: <value>" to the writer.
    pub fn formatErdBig(self: *const SchemaRegistry, erd_number: u16, be_data: []const u8, writer: anytype) FormatErdError!void {
        const info = self.findByNumber(erd_number) orelse return error.ErdNotFound;
        if (be_data.len < info.size) return error.SizeMismatch;
        try writer.print("{s}: ", .{info.name});
        try info.td.formatBytesBig(be_data[0..info.size], writer);
    }
};
