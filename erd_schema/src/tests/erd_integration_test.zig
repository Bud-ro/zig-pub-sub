//! Integration test: full pipeline from wire bytes to pretty-printed ERD values.
//!
//! Exercises the complete flow:
//!   1. Define ERDs with types and erd_numbers
//!   2. Serialize the type descriptors to JSON (erd_json)
//!   3. Simulate receiving big-endian bytes over the wire
//!   4. Use SwapRules to convert BE -> native endianness
//!   5. Use TypeDescriptor to pretty-print the native bytes
//!
//! This test validates that the serializer, swap rules, and runtime decoder
//! compose correctly end-to-end.
const std = @import("std");
const erd_schema = @import("erd_schema");
const erd_json = erd_schema.json;
const decode = erd_schema.decode;
const TypeDescriptor = decode.TypeDescriptor;
const Erd = @import("erd_core").Erd;

fn format(td: *const TypeDescriptor, bytes: []const u8) !struct { str: []const u8, out: std.Io.Writer.Allocating } {
    var out: std.Io.Writer.Allocating = .init(std.testing.allocator);
    errdefer out.deinit();
    try td.formatBytes(bytes, &out.writer);
    return .{ .str = out.writer.buffered(), .out = out };
}

// =======================================================================
// ERD table used throughout these tests
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

const test_erds = TestErds{};

// =======================================================================
// Step 1: Generate the full JSON schema
// =======================================================================

test "generate ERD JSON schema" {
    var out: std.Io.Writer.Allocating = .init(std.testing.allocator);
    defer out.deinit();

    try erd_json.generate(test_erds, &out.writer, .{ .namespace = "integration-test" });
    const json_str = out.writer.buffered();

    // Parse and verify structure
    const parsed = try std.json.parseFromSlice(std.json.Value, std.testing.allocator, json_str, .{});
    defer parsed.deinit();

    const erds = parsed.value.object.get("erds").?.array.items;
    try std.testing.expectEqual(4, erds.len);

    // firmware_version is a u32 primitive
    try std.testing.expectEqualStrings("firmware_version", erds[0].object.get("name").?.string);
    try std.testing.expectEqualStrings("0x0001", erds[0].object.get("id").?.string);
    const fw_type = erds[0].object.get("type").?.object;
    try std.testing.expectEqualStrings("primitive", fw_type.get("kind").?.string);

    // sensor is an extern struct
    const sensor_type = erds[1].object.get("type").?.object;
    try std.testing.expectEqualStrings("struct", sensor_type.get("kind").?.string);
    try std.testing.expectEqualStrings("extern", sensor_type.get("layout").?.string);

    // model_number is a string
    const model_type = erds[2].object.get("type").?.object;
    try std.testing.expectEqualStrings("string", model_type.get("kind").?.string);

    // calibration is a float
    const cal_type = erds[3].object.get("type").?.object;
    try std.testing.expectEqualStrings("float", cal_type.get("kind").?.string);
}

// =======================================================================
// Step 2: Receive BE bytes, swap to native, pretty-print
// =======================================================================

test "pipeline: u32 firmware version from BE wire bytes" {
    // Firmware version 0x01020304
    // BE wire bytes: 01 02 03 04
    var wire_bytes = [_]u8{ 0x01, 0x02, 0x03, 0x04 };

    // Swap BE -> native LE
    const Rules = erd_schema.SwapRules(u32);
    Rules.apply(&wire_bytes);

    // Verify the native value: 0x01020304 = 16909060
    const native_val = std.mem.readInt(u32, &wire_bytes, .little);
    try std.testing.expectEqual(@as(u32, 0x01020304), native_val);

    // Parse the type descriptor and format
    var td = try TypeDescriptor.parse(std.testing.allocator,
        \\{"kind":"primitive","name":"u32","size":4,"signedness":"unsigned","bits":32}
    );
    defer td.deinit();

    var r = try format(&td, &wire_bytes);
    defer r.out.deinit();

    try std.testing.expectEqualStrings("16909060", r.str);
}

test "pipeline: extern struct from BE wire bytes" {
    // SensorReading: temperature=0x0064 (100), humidity=0x37 (55), status=0x01 (warning)
    // BE wire bytes: 00 64 37 01
    var wire_bytes = [_]u8{ 0x00, 0x64, 0x37, 0x01 };

    // Swap rules for SensorReading: only temperature (u16 at offset 0) needs swapping
    const Rules = erd_schema.SwapRules(SensorReading);
    Rules.apply(&wire_bytes);

    // After swap: temperature bytes reversed (64 00), rest unchanged
    try std.testing.expectEqual(@as(u8, 0x64), wire_bytes[0]);
    try std.testing.expectEqual(@as(u8, 0x00), wire_bytes[1]);

    // Generate type descriptor JSON for SensorReading
    var json_out: std.Io.Writer.Allocating = .init(std.testing.allocator);
    defer json_out.deinit();
    try erd_json.generateTypeDescriptor(SensorReading, &json_out.writer);

    // Parse and format
    var td = try TypeDescriptor.parse(std.testing.allocator, json_out.writer.buffered());
    defer td.deinit();

    var r = try format(&td, &wire_bytes);
    defer r.out.deinit();

    try std.testing.expectEqualStrings("{ temperature: 100, humidity: 55, status: warning }", r.str);
}

test "pipeline: string model number from wire bytes" {
    // Model number "ACME-1234" padded with nulls
    var wire_bytes: [16]u8 = .{0} ** 16;
    @memcpy(wire_bytes[0..9], "ACME-1234");

    // Strings are [N]u8 - no byte swapping needed (SwapRules produces no rules)
    const Rules = erd_schema.SwapRules([16]u8);
    try std.testing.expectEqual(0, Rules.ruleCount());

    var td = try TypeDescriptor.parse(std.testing.allocator,
        \\{"kind":"string","max_len":16,"size":16}
    );
    defer td.deinit();

    var r = try format(&td, &wire_bytes);
    defer r.out.deinit();

    try std.testing.expectEqualStrings("\"ACME-1234\"", r.str);
}

test "pipeline: f32 calibration from BE wire bytes" {
    // 3.14 as f32 = 0x4048F5C3
    // BE wire bytes: 40 48 F5 C3
    var wire_bytes = [_]u8{ 0x40, 0x48, 0xF5, 0xC3 };

    // Swap to native LE
    const Rules = erd_schema.SwapRules(f32);
    Rules.apply(&wire_bytes);

    // After swap: C3 F5 48 40 (LE representation of 3.14)
    try std.testing.expectEqual(@as(u8, 0xC3), wire_bytes[0]);

    var td = try TypeDescriptor.parse(std.testing.allocator,
        \\{"kind":"float","name":"f32","size":4,"bits":32}
    );
    defer td.deinit();

    var r = try format(&td, &wire_bytes);
    defer r.out.deinit();

    // Should parse as approximately 3.14
    // std {d} format for 3.14f32 -> check what it produces
    const val: f32 = @bitCast(std.mem.readInt(u32, &wire_bytes, .little));
    var expected_out: std.Io.Writer.Allocating = .init(std.testing.allocator);
    defer expected_out.deinit();
    try expected_out.writer.print("{d}", .{val});
    try std.testing.expectEqualStrings(expected_out.writer.buffered(), r.str);
}

// =======================================================================
// Step 3: ERD lookup by erd_number in the JSON schema
// =======================================================================

test "pipeline: look up ERD by number in schema, then decode" {
    // Generate the full schema
    var schema_out: std.Io.Writer.Allocating = .init(std.testing.allocator);
    defer schema_out.deinit();
    try erd_json.generate(test_erds, &schema_out.writer, .{});

    // Parse the schema
    const parsed = try std.json.parseFromSlice(std.json.Value, std.testing.allocator, schema_out.writer.buffered(), .{});
    defer parsed.deinit();

    // Simulate: we received erd_number 0x0002 with BE data
    const target_id = "0x0002";
    var wire_bytes = [_]u8{ 0x00, 0x64, 0x37, 0x01 }; // sensor reading in BE

    // Find the ERD in the schema by id
    const erds = parsed.value.object.get("erds").?.array.items;
    var found_type: ?std.json.Value = null;
    for (erds) |erd_entry| {
        const id = erd_entry.object.get("id").?.string;
        if (std.mem.eql(u8, id, target_id)) {
            found_type = erd_entry.object.get("type").?;
            break;
        }
    }
    try std.testing.expect(found_type != null);

    // Build TypeDescriptor directly from the parsed JSON value (no re-serializing)
    var td = try TypeDescriptor.fromParsedValue(std.testing.allocator, found_type.?, null);
    defer td.deinit();

    // Swap BE -> native
    const Rules = erd_schema.SwapRules(SensorReading);
    Rules.apply(&wire_bytes);

    // Format
    var r = try format(&td, &wire_bytes);
    defer r.out.deinit();

    try std.testing.expectEqualStrings("{ temperature: 100, humidity: 55, status: warning }", r.str);
}

// =======================================================================
// Step 4: Tagged union pattern end-to-end
// =======================================================================

test "pipeline: tagged union from BE wire bytes" {
    const Tag = enum(u8) { temperature, error_code };
    const Payload = extern union {
        temperature: u16,
        error_code: u8,
    };
    const Msg = extern struct {
        tag: Tag,
        payload: Payload,
    };

    // Wire bytes (BE): tag=0x00 (temperature), pad, temp=0x04D2 (1234 in BE)
    const wire_bytes = [_]u8{ 0x00, 0x00, 0x04, 0xD2 };
    const msg: *const Msg = @ptrCast(@alignCast(&wire_bytes));

    // Tag is u8 - no swap needed, read directly
    try std.testing.expectEqual(Tag.temperature, msg.tag);

    // Payload field is BE u16 - use bigToNative
    const temp = std.mem.bigToNative(u16, msg.payload.temperature);
    try std.testing.expectEqual(@as(u16, 1234), temp);
}

test "pipeline: bigToNative on extern struct fields" {
    // When you have the Zig type, bigToNative per-field is the cleanest pattern
    const wire_bytes = [_]u8{ 0x00, 0x64, 0x37, 0x01 };
    const wire: *const SensorReading = @ptrCast(@alignCast(&wire_bytes));

    const native: SensorReading = .{
        .temperature = std.mem.bigToNative(u16, wire.temperature),
        .humidity = wire.humidity,
        .status = wire.status,
    };

    try std.testing.expectEqual(@as(u16, 100), native.temperature);
    try std.testing.expectEqual(@as(u8, 55), native.humidity);
    try std.testing.expectEqual(@as(u8, 1), @intFromEnum(native.status));
}
