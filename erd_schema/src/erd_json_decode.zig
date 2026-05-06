/// Runtime decoder for type descriptors.
///
/// Given a parsed JSON type descriptor and a raw byte buffer, interprets and
/// pretty-prints field names and values. Useful for debug tools, protocol
/// analyzers, and host-side ERD viewers that receive raw bytes over the wire.
///
/// Usage:
///   const td = try TypeDescriptor.parse(allocator, json_string);
///   defer td.deinit();
///   try td.formatBytes(raw_bytes, writer);
///   // Output: "{ mode: 0 (ok), threshold: 1234 }"
const std = @import("std");

pub const TypeDescriptor = struct {
    kind: Kind,
    allocator: std.mem.Allocator,
    _parsed: ?std.json.Parsed(std.json.Value) = null,

    const Kind = union(enum) {
        primitive: Primitive,
        structure: Struct,
        array: Array,
        string: String,
        enumeration: Enum,
        optional: Optional,
        pointer: Pointer,
    };

    const String = struct {
        max_len: usize,
        size: usize,
    };

    const Primitive = struct {
        name: []const u8,
        size: usize,
        bits: usize,
        signed: bool,
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

    const Optional = struct {
        size: usize,
        child: *TypeDescriptor,
    };

    const Pointer = struct {
        size: usize,
        child: *TypeDescriptor,
    };

    pub fn parse(allocator: std.mem.Allocator, json_str: []const u8) !TypeDescriptor {
        const parsed = try std.json.parseFromSlice(std.json.Value, allocator, json_str, .{});
        var td = try fromValue(allocator, parsed.value);
        td._parsed = parsed;
        return td;
    }

    pub fn deinit(self: *TypeDescriptor) void {
        switch (self.kind) {
            .structure => |s| {
                for (s.fields) |*field| {
                    field.type_desc.deinit();
                    self.allocator.destroy(field.type_desc);
                }
                self.allocator.free(s.fields);
            },
            .array => |a| {
                a.element.deinit();
                self.allocator.destroy(a.element);
            },
            .enumeration => |e| {
                self.allocator.free(e.variants);
            },
            .optional => |o| {
                o.child.deinit();
                self.allocator.destroy(o.child);
            },
            .pointer => |p| {
                p.child.deinit();
                self.allocator.destroy(p.child);
            },
            .primitive, .string => {},
        }
        if (self._parsed) |p| {
            p.deinit();
            self._parsed = null;
        }
    }

    fn fromValue(allocator: std.mem.Allocator, value: std.json.Value) !TypeDescriptor {
        const obj = value.object;
        const kind_str = obj.get("kind").?.string;

        if (std.mem.eql(u8, kind_str, "primitive")) {
            return .{
                .allocator = allocator,
                .kind = .{ .primitive = .{
                    .name = obj.get("name").?.string,
                    .size = @intCast(obj.get("size").?.integer),
                    .bits = @intCast(obj.get("bits").?.integer),
                    .signed = std.mem.eql(u8, obj.get("signedness").?.string, "signed"),
                } },
            };
        } else if (std.mem.eql(u8, kind_str, "struct")) {
            const fields_arr = obj.get("fields").?.array.items;
            const fields = try allocator.alloc(Field, fields_arr.len);
            for (fields_arr, 0..) |field_val, i| {
                const fo = field_val.object;
                const child_td = try allocator.create(TypeDescriptor);
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
            }
            return .{
                .allocator = allocator,
                .kind = .{ .structure = .{
                    .name = obj.get("name").?.string,
                    .layout = obj.get("layout").?.string,
                    .size = @intCast(obj.get("size").?.integer),
                    .backing_bits = if (obj.get("backing_integer_bits")) |b| @as(?usize, @intCast(b.integer)) else null,
                    .fields = fields,
                } },
            };
        } else if (std.mem.eql(u8, kind_str, "string")) {
            return .{
                .allocator = allocator,
                .kind = .{ .string = .{
                    .max_len = @intCast(obj.get("max_len").?.integer),
                    .size = @intCast(obj.get("size").?.integer),
                } },
            };
        } else if (std.mem.eql(u8, kind_str, "array")) {
            const elem_td = try allocator.create(TypeDescriptor);
            elem_td.* = try fromValue(allocator, obj.get("element").?);
            return .{
                .allocator = allocator,
                .kind = .{ .array = .{
                    .len = @intCast(obj.get("len").?.integer),
                    .size = @intCast(obj.get("size").?.integer),
                    .element = elem_td,
                } },
            };
        } else if (std.mem.eql(u8, kind_str, "enum")) {
            const variants_arr = obj.get("variants").?.array.items;
            const variants = try allocator.alloc([]const u8, variants_arr.len);
            for (variants_arr, 0..) |v, i| {
                variants[i] = v.string;
            }
            return .{
                .allocator = allocator,
                .kind = .{ .enumeration = .{
                    .name = obj.get("name").?.string,
                    .size = @intCast(obj.get("size").?.integer),
                    .variants = variants,
                } },
            };
        } else if (std.mem.eql(u8, kind_str, "optional")) {
            const child_td = try allocator.create(TypeDescriptor);
            child_td.* = try fromValue(allocator, obj.get("child").?);
            return .{
                .allocator = allocator,
                .kind = .{ .optional = .{
                    .size = @intCast(obj.get("size").?.integer),
                    .child = child_td,
                } },
            };
        } else if (std.mem.eql(u8, kind_str, "pointer")) {
            const child_td = try allocator.create(TypeDescriptor);
            child_td.* = try fromValue(allocator, obj.get("child").?);
            return .{
                .allocator = allocator,
                .kind = .{ .pointer = .{
                    .size = @intCast(obj.get("size").?.integer),
                    .child = child_td,
                } },
            };
        } else {
            return error.UnsupportedKind;
        }
    }

    /// Interpret raw bytes according to this type descriptor and write a
    /// human-readable representation to `writer`.
    pub fn formatBytes(self: *const TypeDescriptor, bytes: []const u8, writer: anytype) anyerror!void {
        try self.formatBytesInner(bytes, writer, 0);
    }

    fn formatBytesInner(self: *const TypeDescriptor, bytes: []const u8, writer: anytype, indent: usize) anyerror!void {
        switch (self.kind) {
            .primitive => |p| {
                if (std.mem.eql(u8, p.name, "bool")) {
                    try writer.print("{s}", .{if (bytes[0] != 0) "true" else "false"});
                } else if (p.signed) {
                    const val = readSignedInt(bytes, p.bits);
                    try writer.print("{d}", .{val});
                } else {
                    const val = readUnsignedInt(bytes, p.bits);
                    try writer.print("{d}", .{val});
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
                const end = std.mem.indexOfScalar(u8, bytes[0..@min(s.max_len, bytes.len)], 0) orelse @min(s.max_len, bytes.len);
                try writer.print("\"{s}\"", .{bytes[0..end]});
            },
            .array => |a| {
                const elem_size = a.size / a.len;
                try writer.print("[", .{});
                for (0..a.len) |i| {
                    if (i > 0) try writer.print(", ", .{});
                    const start = i * elem_size;
                    const end = start + elem_size;
                    if (end <= bytes.len) {
                        try a.element.formatBytesInner(bytes[start..end], writer, indent);
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
            .optional => |o| {
                // Optionals: last byte is the tag (0 = null, 1 = some) for most types
                // This is a simplification - real optional layout varies
                if (bytes.len > 0 and bytes[o.size - 1] != 0) {
                    try writer.print("?", .{});
                    try o.child.formatBytesInner(bytes[0..o.child.getSize()], writer, indent);
                } else {
                    try writer.print("null", .{});
                }
            },
            .pointer => {
                const addr = readUnsignedInt(bytes, @min(bytes.len, 8) * 8);
                try writer.print("0x{x}", .{addr});
            },
        }
    }

    fn formatExternStruct(s: Struct, bytes: []const u8, writer: anytype, indent: usize) anyerror!void {
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

    fn formatPackedStruct(s: Struct, bytes: []const u8, writer: anytype, indent: usize) anyerror!void {
        _ = indent;
        try writer.print("{{ ", .{});
        for (s.fields, 0..) |field, i| {
            if (i > 0) try writer.print(", ", .{});
            try writer.print("{s}: ", .{field.name});
            const bit_offset = field.bit_offset orelse 0;
            const bits = field.bits orelse 1;
            const val = readBits(bytes, bit_offset, bits);
            try writer.print("{d}", .{val});
        }
        try writer.print(" }}", .{});
    }

    pub fn getSize(self: *const TypeDescriptor) usize {
        return switch (self.kind) {
            .primitive => |p| p.size,
            .structure => |s| s.size,
            .array => |a| a.size,
            .string => |s| s.size,
            .enumeration => |e| e.size,
            .optional => |o| o.size,
            .pointer => |p| p.size,
        };
    }
};

fn readUnsignedInt(bytes: []const u8, bits: usize) u64 {
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

fn readSignedInt(bytes: []const u8, bits: usize) i64 {
    const unsigned = readUnsignedInt(bytes, bits);
    if (bits >= 64) return @bitCast(unsigned);
    const sign_bit = @as(u64, 1) << @intCast(bits - 1);
    if (unsigned & sign_bit != 0) {
        // Sign extend
        const mask = ~((@as(u64, 1) << @intCast(bits)) - 1);
        return @bitCast(unsigned | mask);
    }
    return @intCast(unsigned);
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
