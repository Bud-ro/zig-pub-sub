//! Integration test: end-to-end ERD message decoding.
//!
//! Demonstrates the intended workflow for a host-side tool or debug console:
//!   1. Load the ERD schema JSON (generated at build time from Zig types)
//!   2. Build a lookup table: erd_number -> { name, type_descriptor, size }
//!   3. Receive wire messages containing [erd_number_be:2][data_be:N]
//!   4. Look up the ERD, swap the data to native, pretty-print it
//!
//! The runtime decoder (TypeDescriptor) handles all types generically
//! without monomorphizing per ERD type.
const std = @import("std");
const erd_schema = @import("erd_schema");
const erd_json = erd_schema.json;
const decode = erd_schema.decode;
const TypeDescriptor = decode.TypeDescriptor;
const Erd = @import("erd_core").Erd;

// =======================================================================
// ERD definitions (firmware side - generates the schema at build time)
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
    id: []const u8,
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
            var td = try TypeDescriptor.fromParsedValue(allocator, obj.get("type").?, null);
            entries[i] = .{
                .name = obj.get("name").?.string,
                .id = obj.get("id").?.string,
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

    fn findById(self: *const SchemaRegistry, id_hex: []const u8) ?*const ErdInfo {
        for (self.entries) |*entry| {
            if (std.mem.eql(u8, entry.id, id_hex)) return entry;
        }
        return null;
    }

    fn findByNumber(self: *const SchemaRegistry, erd_number: u16) ?*const ErdInfo {
        var buf: [6]u8 = undefined;
        const id_str = std.fmt.bufPrint(&buf, "0x{x:0>4}", .{erd_number}) catch return null;
        return self.findById(id_str);
    }

    /// The main API: take an ERD number and native-endian data bytes,
    /// produce "erd_name: <formatted value>"
    fn formatErd(self: *const SchemaRegistry, erd_number: u16, data: []const u8, writer: anytype) !bool {
        const info = self.findByNumber(erd_number) orelse return false;
        try writer.print("{s}: ", .{info.name});
        try info.td.formatBytes(data, writer);
        return true;
    }
};

// =======================================================================
// Test: Build schema, decode individual ERDs
// =======================================================================

test "decode u32 firmware version" {
    var schema_out: std.Io.Writer.Allocating = .init(std.testing.allocator);
    defer schema_out.deinit();
    try erd_json.generate(TestErds{}, &schema_out.writer, .{});

    var registry = try SchemaRegistry.init(std.testing.allocator, schema_out.writer.buffered());
    defer registry.deinit();

    // Simulate wire message: erd=0x0001, data=0x01020304 in native bytes
    const data = std.mem.toBytes(@as(u32, 0x01020304));

    var out: std.Io.Writer.Allocating = .init(std.testing.allocator);
    defer out.deinit();
    const found = try registry.formatErd(0x0001, &data, &out.writer);

    try std.testing.expect(found);
    try std.testing.expectEqualStrings("firmware_version: 16909060", out.writer.buffered());
}

test "decode extern struct sensor reading" {
    var schema_out: std.Io.Writer.Allocating = .init(std.testing.allocator);
    defer schema_out.deinit();
    try erd_json.generate(TestErds{}, &schema_out.writer, .{});

    var registry = try SchemaRegistry.init(std.testing.allocator, schema_out.writer.buffered());
    defer registry.deinit();

    // Native-endian sensor reading: temp=100, humidity=55, status=warning(1)
    const reading = SensorReading{
        .temperature = 100,
        .humidity = 55,
        .status = .warning,
    };
    const data = std.mem.asBytes(&reading);

    var out: std.Io.Writer.Allocating = .init(std.testing.allocator);
    defer out.deinit();
    const found = try registry.formatErd(0x0002, data, &out.writer);

    try std.testing.expect(found);
    try std.testing.expectEqualStrings("sensor: { temperature: 100, humidity: 55, status: warning }", out.writer.buffered());
}

test "decode string model number" {
    var schema_out: std.Io.Writer.Allocating = .init(std.testing.allocator);
    defer schema_out.deinit();
    try erd_json.generate(TestErds{}, &schema_out.writer, .{});

    var registry = try SchemaRegistry.init(std.testing.allocator, schema_out.writer.buffered());
    defer registry.deinit();

    var data: [16]u8 = .{0} ** 16;
    @memcpy(data[0..9], "ACME-1234");

    var out: std.Io.Writer.Allocating = .init(std.testing.allocator);
    defer out.deinit();
    _ = try registry.formatErd(0x0003, &data, &out.writer);

    try std.testing.expectEqualStrings("model_number: \"ACME-1234\"", out.writer.buffered());
}

test "decode f32 calibration" {
    var schema_out: std.Io.Writer.Allocating = .init(std.testing.allocator);
    defer schema_out.deinit();
    try erd_json.generate(TestErds{}, &schema_out.writer, .{});

    var registry = try SchemaRegistry.init(std.testing.allocator, schema_out.writer.buffered());
    defer registry.deinit();

    const data = std.mem.toBytes(@as(f32, 3.14));

    var out: std.Io.Writer.Allocating = .init(std.testing.allocator);
    defer out.deinit();
    _ = try registry.formatErd(0x0004, &data, &out.writer);

    // Verify it starts with "calibration: 3.14" (exact format may vary)
    const result = out.writer.buffered();
    try std.testing.expect(std.mem.startsWith(u8, result, "calibration: 3.14"));
}

test "unknown ERD number returns false" {
    var schema_out: std.Io.Writer.Allocating = .init(std.testing.allocator);
    defer schema_out.deinit();
    try erd_json.generate(TestErds{}, &schema_out.writer, .{});

    var registry = try SchemaRegistry.init(std.testing.allocator, schema_out.writer.buffered());
    defer registry.deinit();

    var out: std.Io.Writer.Allocating = .init(std.testing.allocator);
    defer out.deinit();
    const found = try registry.formatErd(0xFFFF, &.{0}, &out.writer);

    try std.testing.expect(!found);
    try std.testing.expectEqual(0, out.writer.buffered().len);
}

// =======================================================================
// Test: Simulated wire message with BE erd_number + BE data
// =======================================================================

test "full wire message: BE erd_number + BE data -> pretty print" {
    var schema_out: std.Io.Writer.Allocating = .init(std.testing.allocator);
    defer schema_out.deinit();
    try erd_json.generate(TestErds{}, &schema_out.writer, .{});

    var registry = try SchemaRegistry.init(std.testing.allocator, schema_out.writer.buffered());
    defer registry.deinit();

    // Simulated wire message: [erd_number_be:2] [data_be:4]
    // ERD 0x0001 (firmware_version), value 0x01020304
    const wire_msg = [_]u8{
        0x00, 0x01, // erd_number = 0x0001 in BE
        0x01, 0x02, 0x03, 0x04, // u32 value in BE
    };

    // Parse erd_number from first 2 bytes (BE)
    const erd_number = std.mem.bigToNative(u16, @as(*const u16, @ptrCast(@alignCast(wire_msg[0..2]))).*);
    try std.testing.expectEqual(@as(u16, 0x0001), erd_number);

    // Look up the ERD to get its size
    const info = registry.findByNumber(erd_number).?;
    try std.testing.expectEqualStrings("firmware_version", info.name);
    try std.testing.expectEqual(4, info.size);

    // Extract data bytes and swap to native using readInt
    // For a generic path without the Zig type, copy and reverse multi-byte fields.
    // Here we know it's a u32, so just read as BE and write as native:
    var native_data: [4]u8 = undefined;
    const val = std.mem.readInt(u32, wire_msg[2..6], .big);
    std.mem.writeInt(u32, &native_data, val, .little);

    var out: std.Io.Writer.Allocating = .init(std.testing.allocator);
    defer out.deinit();
    _ = try registry.formatErd(erd_number, &native_data, &out.writer);

    try std.testing.expectEqualStrings("firmware_version: 16909060", out.writer.buffered());
}

test "multiple ERDs decoded from a stream of messages" {
    var schema_out: std.Io.Writer.Allocating = .init(std.testing.allocator);
    defer schema_out.deinit();
    try erd_json.generate(TestErds{}, &schema_out.writer, .{});

    var registry = try SchemaRegistry.init(std.testing.allocator, schema_out.writer.buffered());
    defer registry.deinit();

    // Three messages in native byte order (post-swap)
    const messages = [_]struct { erd: u16, data: []const u8 }{
        .{ .erd = 0x0001, .data = &std.mem.toBytes(@as(u32, 42)) },
        .{ .erd = 0x0003, .data = "Hello\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" },
        .{ .erd = 0x0002, .data = &std.mem.toBytes(SensorReading{ .temperature = 22, .humidity = 80, .status = .ok }) },
    };

    const expected = [_][]const u8{
        "firmware_version: 42",
        "model_number: \"Hello\"",
        "sensor: { temperature: 22, humidity: 80, status: ok }",
    };

    for (messages, expected) |msg, exp| {
        var out: std.Io.Writer.Allocating = .init(std.testing.allocator);
        defer out.deinit();
        _ = try registry.formatErd(msg.erd, msg.data, &out.writer);
        try std.testing.expectEqualStrings(exp, out.writer.buffered());
    }
}

// =======================================================================
// Test: Direct value access when you know the type (comptime path)
// =======================================================================

test "comptime typed path: SwapRules.fromBig in one shot" {
    // When you have the Zig type, one call does the whole conversion.
    const wire_bytes = [_]u8{ 0x00, 0x64, 0x37, 0x01 };

    const reading = erd_schema.SwapRules(SensorReading).fromBig(&wire_bytes);

    try std.testing.expectEqual(@as(u16, 100), reading.temperature);
    try std.testing.expectEqual(@as(u8, 55), reading.humidity);
    try std.testing.expectEqual(@as(u8, 1), @intFromEnum(reading.status));
}

test "comptime typed path: SwapRules.toBig for serialization" {
    const reading = SensorReading{
        .temperature = 100,
        .humidity = 55,
        .status = .warning,
    };

    const wire = erd_schema.SwapRules(SensorReading).toBig(reading);

    // temperature 100 = 0x0064, BE = 00 64
    try std.testing.expectEqual(@as(u8, 0x00), wire[0]);
    try std.testing.expectEqual(@as(u8, 0x64), wire[1]);
    // humidity and status are single bytes, unchanged
    try std.testing.expectEqual(@as(u8, 55), wire[2]);
    try std.testing.expectEqual(@as(u8, 1), wire[3]);
}

test "comptime typed path: round-trip toBig -> fromBig" {
    const original = SensorReading{
        .temperature = 1234,
        .humidity = 99,
        .status = .critical,
    };

    const wire = erd_schema.SwapRules(SensorReading).toBig(original);
    const restored = erd_schema.SwapRules(SensorReading).fromBig(&wire);

    try std.testing.expectEqual(original.temperature, restored.temperature);
    try std.testing.expectEqual(original.humidity, restored.humidity);
    try std.testing.expectEqual(original.status, restored.status);
}

test "comptime typed path: bigToNative per-field (manual alternative)" {
    // For comparison: the per-field approach when you want more control.
    const wire_bytes = [_]u8{ 0x00, 0x64, 0x37, 0x01 };
    const wire: *const SensorReading = @ptrCast(@alignCast(&wire_bytes));

    const native: SensorReading = .{
        .temperature = std.mem.bigToNative(u16, wire.temperature),
        .humidity = wire.humidity,
        .status = wire.status,
    };

    try std.testing.expectEqual(@as(u16, 100), native.temperature);
}
