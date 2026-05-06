//! Runtime decoder for type descriptors.
//!
//! Given a parsed JSON type descriptor and a raw byte buffer, interprets and
//! pretty-prints field names and values. Useful for debug tools, protocol
//! analyzers, and host-side ERD viewers that receive raw bytes over the wire.
//!
//! Usage:
//!   var td = try TypeDescriptor.parse(allocator, json_string);
//!   defer td.deinit();
//!   try td.formatBytes(raw_bytes, writer);
//!   // Output: "{ mode: ok, threshold: 1234 }"
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
        @"union": Union,
    };

    const Primitive = struct {
        name: []const u8,
        size: usize,
        bits: usize,
        signed: bool,
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
        tag_type: *TypeDescriptor,
        fields: []UnionField,
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
            .@"union" => |u| {
                u.tag_type.deinit();
                self.allocator.destroy(u.tag_type);
                for (u.fields) |*field| {
                    field.type_desc.deinit();
                    self.allocator.destroy(field.type_desc);
                }
                self.allocator.free(u.fields);
            },
            .primitive, .string => {},
        }
        if (self._parsed) |p| {
            p.deinit();
            self._parsed = null;
        }
    }

    fn fromValue(allocator: std.mem.Allocator, value: std.json.Value) anyerror!TypeDescriptor {
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
            return parseStruct(allocator, obj);
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
            return parseEnum(allocator, obj);
        } else if (std.mem.eql(u8, kind_str, "union")) {
            return parseUnion(allocator, obj);
        } else {
            return error.UnsupportedKind;
        }
    }

    fn parseStruct(allocator: std.mem.Allocator, obj: std.json.ObjectMap) !TypeDescriptor {
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
    }

    fn parseEnum(allocator: std.mem.Allocator, obj: std.json.ObjectMap) !TypeDescriptor {
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
    }

    fn parseUnion(allocator: std.mem.Allocator, obj: std.json.ObjectMap) !TypeDescriptor {
        const tag_td = try allocator.create(TypeDescriptor);
        tag_td.* = try fromValue(allocator, obj.get("tag_type").?);

        const fields_arr = obj.get("fields").?.array.items;
        const fields = try allocator.alloc(UnionField, fields_arr.len);
        for (fields_arr, 0..) |field_val, i| {
            const fo = field_val.object;
            const child_td = try allocator.create(TypeDescriptor);
            child_td.* = try fromValue(allocator, fo.get("type_descriptor").?);
            fields[i] = .{
                .name = fo.get("name").?.string,
                .type_desc = child_td,
            };
        }
        return .{
            .allocator = allocator,
            .kind = .{ .@"union" = .{
                .name = obj.get("name").?.string,
                .layout = obj.get("layout").?.string,
                .size = @intCast(obj.get("size").?.integer),
                .tag_type = tag_td,
                .fields = fields,
            } },
        };
    }

    /// Interpret raw bytes and write a human-readable representation.
    pub fn formatBytes(self: *const TypeDescriptor, bytes: []const u8, writer: anytype) anyerror!void {
        try self.formatBytesInner(bytes, writer, 0);
    }

    fn formatBytesInner(self: *const TypeDescriptor, bytes: []const u8, writer: anytype, indent: usize) anyerror!void {
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
            .@"union" => |u| {
                // For extern unions we don't know which field is active without
                // external tag info, so print all interpretations
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
            try writer.print("{d}", .{readBits(bytes, bit_offset, bits)});
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
            .@"union" => |u| u.size,
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
