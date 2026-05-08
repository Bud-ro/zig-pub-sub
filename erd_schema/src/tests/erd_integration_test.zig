//! Integration test: end-to-end ERD message decoding.
//!
//! Demonstrates the workflow for a host-side tool or debug console:
//!   1. Load the ERD schema JSON (generated at build time from Zig types)
//!   2. Build a lookup table: erd_number -> { name, type_descriptor, size }
//!   3. Receive wire messages containing [erd_number_be:2][data_be:N]
//!   4. Look up the ERD, pretty-print the BE data directly
//!   5. Optionally extract a typed value when you know the numeric type
const std = @import("std");
const erd_schema = @import("erd_schema");
const erd_json = erd_schema.json;
const decode = erd_schema.decode;
const TypeDescriptor = decode.TypeDescriptor;
const Erd = @import("erd_core").Erd;

// =======================================================================
// ERD definitions (firmware side)
// =======================================================================

const SensorReading = extern struct {
    temperature: u16,
    humidity: u8,
    status: enum(u8) { ok, warning, critical },
};

const TestErds = struct {
    // zig fmt: off
    firmware_version: Erd = .{ .erd_number = 0x0001, .T = u32,           .component_idx = 0, .subs = 0 },
    sensor:           Erd = .{ .erd_number = 0x0002, .T = SensorReading, .component_idx = 0, .subs = 0 },
    model_number:     Erd = .{ .erd_number = 0x0003, .T = [16]u8,        .component_idx = 0, .subs = 0 },
    calibration:      Erd = .{ .erd_number = 0x0004, .T = f32,           .component_idx = 0, .subs = 0 },
    // zig fmt: on
};

// =======================================================================
// Schema registry (host side - built once from the JSON)
// =======================================================================

const ErdInfo = struct {
    name: []const u8,
    erd_number: u16,
    td: TypeDescriptor,
    size: usize,
};

const SchemaRegistry = struct {
    entries: []ErdInfo,
    allocator: std.mem.Allocator,
    _parsed: std.json.Parsed(std.json.Value),

    fn init(allocator: std.mem.Allocator, schema_json: []const u8) !SchemaRegistry {
        const parsed = try std.json.parseFromSlice(std.json.Value, allocator, schema_json, .{});
        errdefer parsed.deinit();

        const erd_array = parsed.value.object.get("erds").?.array.items;
        const entries = try allocator.alloc(ErdInfo, erd_array.len);
        errdefer allocator.free(entries);

        for (erd_array, 0..) |erd_val, i| {
            const obj = erd_val.object;
            const td = try TypeDescriptor.fromParsedValue(allocator, obj.get("type").?, null);
            const id_str = obj.get("id").?.string;
            entries[i] = .{
                .name = obj.get("name").?.string,
                .erd_number = std.fmt.parseInt(u16, id_str[2..], 16) catch 0,
                .td = td,
                .size = td.getSize(),
            };
        }

        return .{ .entries = entries, .allocator = allocator, ._parsed = parsed };
    }

    fn deinit(self: *SchemaRegistry) void {
        for (self.entries) |*e| e.td.deinit();
        self.allocator.free(self.entries);
        self._parsed.deinit();
    }

    fn findByNumber(self: *const SchemaRegistry, erd_number: u16) ?*const ErdInfo {
        for (self.entries) |*entry| {
            if (entry.erd_number == erd_number) return entry;
        }
        return null;
    }

    /// Pretty-print an ERD from big-endian wire data.
    /// Writes "erd_name: <value>" to the writer.
    fn formatErdBig(self: *const SchemaRegistry, erd_number: u16, be_data: []const u8, writer: anytype) error{ ErdNotFound, SizeMismatch, OutOfMemory, WriteFailed }!void {
        const info = self.findByNumber(erd_number) orelse return error.ErdNotFound;
        if (be_data.len < info.size) return error.SizeMismatch;
        try writer.print("{s}: ", .{info.name});
        try info.td.formatBytesBig(be_data[0..info.size], writer);
    }
};

// Shared schema setup
fn makeRegistry() !struct { registry: SchemaRegistry, schema_out: std.Io.Writer.Allocating } {
    var schema_out: std.Io.Writer.Allocating = .init(std.testing.allocator);
    errdefer schema_out.deinit();
    try erd_json.generate(TestErds{}, &schema_out.writer, .{});
    const registry = try SchemaRegistry.init(std.testing.allocator, schema_out.writer.buffered());
    return .{ .registry = registry, .schema_out = schema_out };
}

// =======================================================================
// Wire message format: [erd_number_be:2] [data_be:N]
// =======================================================================

test "u16 ERD: construct wire bytes, format, extract value" {
    var r = try makeRegistry();
    defer r.registry.deinit();
    defer r.schema_out.deinit();

    // Construct a wire message: ERD 0x0001 (firmware_version), value 0x01020304
    const wire = [_]u8{
        0x00, 0x01, // erd_number = 0x0001 in BE
        0x01, 0x02, 0x03, 0x04, // u32 value in BE
    };

    // Parse erd_number
    const erd_number = std.mem.readInt(u16, wire[0..2], .big);
    try std.testing.expectEqual(@as(u16, 0x0001), erd_number);
    const data_be = wire[2..];

    // Runtime path: look up and pretty-print directly from BE bytes
    var out: std.Io.Writer.Allocating = .init(std.testing.allocator);
    defer out.deinit();
    try r.registry.formatErdBig(erd_number, data_be, &out.writer);
    try std.testing.expectEqualStrings("firmware_version: 16909060", out.writer.buffered());

    // Typed path: when you know it's a u32, extract the value directly
    const info = r.registry.findByNumber(erd_number).?;
    const val = try info.td.parseIntBig(u32, data_be);
    try std.testing.expectEqual(@as(u32, 0x01020304), val);
}

test "extern struct ERD: format nested fields from BE" {
    var r = try makeRegistry();
    defer r.registry.deinit();
    defer r.schema_out.deinit();

    // Wire message: ERD 0x0002 (sensor), temp=100 hum=55 status=warning
    const wire = [_]u8{
        0x00, 0x02, // erd_number
        0x00, 0x64, // temperature = 100 in BE
        0x37, // humidity = 55
        0x01, // status = warning
    };

    const erd_number = std.mem.readInt(u16, wire[0..2], .big);
    const data_be = wire[2..];

    var out: std.Io.Writer.Allocating = .init(std.testing.allocator);
    defer out.deinit();
    try r.registry.formatErdBig(erd_number, data_be, &out.writer);
    try std.testing.expectEqualStrings("sensor: { temperature: 100, humidity: 55, status: warning }", out.writer.buffered());
}

test "string ERD: no swapping needed" {
    var r = try makeRegistry();
    defer r.registry.deinit();
    defer r.schema_out.deinit();

    // Wire message: ERD 0x0003 (model_number), "ACME-1234" + nulls
    var wire: [2 + 16]u8 = .{0} ** 18;
    wire[0] = 0x00;
    wire[1] = 0x03;
    @memcpy(wire[2..11], "ACME-1234");

    const erd_number = std.mem.readInt(u16, wire[0..2], .big);
    const data_be = wire[2..];

    var out: std.Io.Writer.Allocating = .init(std.testing.allocator);
    defer out.deinit();
    try r.registry.formatErdBig(erd_number, data_be, &out.writer);
    try std.testing.expectEqualStrings("model_number: \"ACME-1234\"", out.writer.buffered());
}

test "f32 ERD: format float from BE" {
    var r = try makeRegistry();
    defer r.registry.deinit();
    defer r.schema_out.deinit();

    // Wire message: ERD 0x0004 (calibration), 3.14f32 = 0x4048F5C3 in BE
    const wire = [_]u8{
        0x00, 0x04, // erd_number
        0x40, 0x48, 0xF5, 0xC3, // f32 3.14 in BE
    };

    const erd_number = std.mem.readInt(u16, wire[0..2], .big);
    const data_be = wire[2..];

    var out: std.Io.Writer.Allocating = .init(std.testing.allocator);
    defer out.deinit();
    try r.registry.formatErdBig(erd_number, data_be, &out.writer);

    const result = out.writer.buffered();
    try std.testing.expect(std.mem.startsWith(u8, result, "calibration: 3.14"));
}

test "unknown ERD returns error" {
    var r = try makeRegistry();
    defer r.registry.deinit();
    defer r.schema_out.deinit();

    var out: std.Io.Writer.Allocating = .init(std.testing.allocator);
    defer out.deinit();

    const err = r.registry.formatErdBig(0xFFFF, &.{0}, &out.writer);
    try std.testing.expectError(error.ErdNotFound, err);
}

test "truncated data returns error" {
    var r = try makeRegistry();
    defer r.registry.deinit();
    defer r.schema_out.deinit();

    var out: std.Io.Writer.Allocating = .init(std.testing.allocator);
    defer out.deinit();

    // ERD 0x0001 expects 4 bytes but we only provide 2
    const err = r.registry.formatErdBig(0x0001, &.{ 0x00, 0x01 }, &out.writer);
    try std.testing.expectError(error.SizeMismatch, err);
}

test "parseIntBig extracts value without formatting" {
    var r = try makeRegistry();
    defer r.registry.deinit();
    defer r.schema_out.deinit();

    const info = r.registry.findByNumber(0x0001).?;

    // 0x01020304 in BE
    const data_be = [_]u8{ 0x01, 0x02, 0x03, 0x04 };
    const val = try info.td.parseIntBig(u32, &data_be);
    try std.testing.expectEqual(@as(u32, 0x01020304), val);

    // Also works with a larger target type
    const val64 = try info.td.parseIntBig(u64, &data_be);
    try std.testing.expectEqual(@as(u64, 0x01020304), val64);
}

test "parseIntBig rejects struct descriptor" {
    var r = try makeRegistry();
    defer r.registry.deinit();
    defer r.schema_out.deinit();

    const info = r.registry.findByNumber(0x0002).?; // sensor (struct)
    const err = info.td.parseIntBig(u32, &.{ 0, 0, 0, 0 });
    try std.testing.expectError(error.TypeMismatch, err);
}

test "stream of wire messages" {
    var r = try makeRegistry();
    defer r.registry.deinit();
    defer r.schema_out.deinit();

    const Message = struct { wire: []const u8, expected: []const u8 };
    const messages = [_]Message{
        .{
            .wire = &[_]u8{ 0x00, 0x01, 0x00, 0x00, 0x00, 0x2A }, // firmware_version = 42
            .expected = "firmware_version: 42",
        },
        .{
            .wire = &[_]u8{ 0x00, 0x02, 0x00, 0x16, 0x50, 0x00 }, // sensor: temp=22, hum=80, status=ok
            .expected = "sensor: { temperature: 22, humidity: 80, status: ok }",
        },
    };

    for (messages) |msg| {
        const erd_number = std.mem.readInt(u16, msg.wire[0..2], .big);
        const data_be = msg.wire[2..];

        var out: std.Io.Writer.Allocating = .init(std.testing.allocator);
        defer out.deinit();
        try r.registry.formatErdBig(erd_number, data_be, &out.writer);
        try std.testing.expectEqualStrings(msg.expected, out.writer.buffered());
    }
}

// =======================================================================
// Comptime typed path (for comparison - when you have the Zig type)
// =======================================================================

test "comptime: SwapRules.fromBig one-shot conversion" {
    const wire_bytes = [_]u8{ 0x00, 0x64, 0x37, 0x01 };
    const reading = erd_schema.SwapRules(SensorReading).fromBig(&wire_bytes);

    try std.testing.expectEqual(@as(u16, 100), reading.temperature);
    try std.testing.expectEqual(@as(u8, 55), reading.humidity);
    try std.testing.expectEqual(@as(u8, 1), @intFromEnum(reading.status));
}

test "comptime: round-trip toBig -> fromBig" {
    const original = SensorReading{ .temperature = 1234, .humidity = 99, .status = .critical };
    const wire = erd_schema.SwapRules(SensorReading).toBig(original);
    const restored = erd_schema.SwapRules(SensorReading).fromBig(&wire);

    try std.testing.expectEqual(original.temperature, restored.temperature);
    try std.testing.expectEqual(original.humidity, restored.humidity);
    try std.testing.expectEqual(original.status, restored.status);
}
