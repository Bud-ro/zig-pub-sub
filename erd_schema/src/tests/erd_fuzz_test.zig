//! Fuzz tests for ERD type descriptor runtime decoder.
//!
//! - Generates random valid type descriptor JSON and parses it
//! - Feeds random bytes to formatBytes for each descriptor kind
//! - Verifies swap rule idempotency on random bytes
const std = @import("std");
const decode = @import("erd_schema").decode;
const TypeDescriptor = decode.TypeDescriptor;

// =======================================================================
// Helpers for generating valid type descriptor JSON
// =======================================================================

fn appendStr(buf: []u8, pos: *usize, s: []const u8) void {
    if (pos.* + s.len > buf.len) return;
    @memcpy(buf[pos.*..][0..s.len], s);
    pos.* += s.len;
}

const prim_names = [_][]const u8{ "u8", "u16", "u32", "u64", "i8", "i16", "i32", "i64", "bool" };
const prim_sizes = [_][]const u8{ "1", "2", "4", "8", "1", "2", "4", "8", "1" };
const prim_bits = [_][]const u8{ "8", "16", "32", "64", "8", "16", "32", "64", "1" };
const prim_signs = [_][]const u8{ "unsigned", "unsigned", "unsigned", "unsigned", "signed", "signed", "signed", "signed", "unsigned" };

fn generatePrimitive(buf: []u8, pos: *usize, smith: *std.testing.Smith) void {
    const idx = smith.index(prim_names.len);
    appendStr(buf, pos, "{\"kind\":\"primitive\",\"name\":\"");
    appendStr(buf, pos, prim_names[idx]);
    appendStr(buf, pos, "\",\"size\":");
    appendStr(buf, pos, prim_sizes[idx]);
    appendStr(buf, pos, ",\"signedness\":\"");
    appendStr(buf, pos, prim_signs[idx]);
    appendStr(buf, pos, "\",\"bits\":");
    appendStr(buf, pos, prim_bits[idx]);
    appendStr(buf, pos, "}");
}

fn generateFloat(buf: []u8, pos: *usize, smith: *std.testing.Smith) void {
    const float_names = [_][]const u8{ "f16", "f32", "f64" };
    const float_sizes = [_][]const u8{ "2", "4", "8" };
    const float_bits = [_][]const u8{ "16", "32", "64" };
    const idx = smith.index(float_names.len);
    appendStr(buf, pos, "{\"kind\":\"float\",\"name\":\"");
    appendStr(buf, pos, float_names[idx]);
    appendStr(buf, pos, "\",\"size\":");
    appendStr(buf, pos, float_sizes[idx]);
    appendStr(buf, pos, ",\"bits\":");
    appendStr(buf, pos, float_bits[idx]);
    appendStr(buf, pos, "}");
}

fn generateString(buf: []u8, pos: *usize, smith: *std.testing.Smith) void {
    const lens = [_][]const u8{ "4", "8", "16", "32" };
    const idx = smith.index(lens.len);
    appendStr(buf, pos, "{\"kind\":\"string\",\"max_len\":");
    appendStr(buf, pos, lens[idx]);
    appendStr(buf, pos, ",\"size\":");
    appendStr(buf, pos, lens[idx]);
    appendStr(buf, pos, "}");
}

fn generateEnum(buf: []u8, pos: *usize, smith: *std.testing.Smith) void {
    const num_variants = smith.index(3) + 2; // 2..4
    appendStr(buf, pos, "{\"kind\":\"enum\",\"name\":\"E\",\"tag_type\":\"u8\",\"size\":1,\"variants\":[");
    for (0..num_variants) |i| {
        if (i > 0) appendStr(buf, pos, ",");
        appendStr(buf, pos, "\"v");
        const digit: [1]u8 = .{'0' + @as(u8, @intCast(i))};
        appendStr(buf, pos, &digit);
        appendStr(buf, pos, "\"");
    }
    appendStr(buf, pos, "]}");
}

fn generateTypeDescriptor(buf: []u8, pos: *usize, smith: *std.testing.Smith, depth: u8) void {
    if (depth > 2) {
        generatePrimitive(buf, pos, smith);
        return;
    }

    const choice = smith.index(7);
    switch (choice) {
        0, 1 => generatePrimitive(buf, pos, smith),
        2 => generateFloat(buf, pos, smith),
        3 => generateString(buf, pos, smith),
        4 => generateEnum(buf, pos, smith),
        5 => {
            // extern struct with 1-3 primitive fields
            const num_fields = smith.index(3) + 1;
            appendStr(buf, pos, "{\"kind\":\"struct\",\"name\":\"S\",\"layout\":\"extern\",\"size\":16,\"fields\":[");
            for (0..num_fields) |i| {
                if (i > 0) appendStr(buf, pos, ",");
                appendStr(buf, pos, "{\"name\":\"f");
                const digit: [1]u8 = .{'0' + @as(u8, @intCast(i))};
                appendStr(buf, pos, &digit);
                appendStr(buf, pos, "\",\"offset\":");
                const offsets = [_][]const u8{ "0", "2", "4" };
                appendStr(buf, pos, offsets[i]);
                appendStr(buf, pos, ",\"type_descriptor\":");
                generateTypeDescriptor(buf, pos, smith, depth + 1);
                appendStr(buf, pos, "}");
            }
            appendStr(buf, pos, "]}");
        },
        6 => {
            // array of primitives
            appendStr(buf, pos, "{\"kind\":\"array\",\"len\":2,\"size\":8,\"element\":");
            generateTypeDescriptor(buf, pos, smith, depth + 1);
            appendStr(buf, pos, "}");
        },
        else => generatePrimitive(buf, pos, smith),
    }
}

// =======================================================================
// Fuzz: generate random valid JSON, parse it, feed random bytes
// =======================================================================

test "fuzz: random valid type descriptor parsed and formatted" {
    try std.testing.fuzz({}, struct {
        fn f(_: void, smith: *std.testing.Smith) !void {
            // Generate a random valid type descriptor JSON
            var json_buf: [2048]u8 = undefined;
            var pos: usize = 0;
            generateTypeDescriptor(&json_buf, &pos, smith, 0);

            if (pos == 0 or pos >= json_buf.len) return;
            const json_str = json_buf[0..pos];

            // Parse it - should not crash
            const parsed = std.json.parseFromSlice(std.json.Value, std.testing.allocator, json_str, .{}) catch return;
            defer parsed.deinit();
            var td = TypeDescriptor.init(std.testing.allocator, parsed) catch return;
            defer td.deinit(std.testing.allocator);

            // Generate random bytes matching the descriptor's size
            const size = td.getSize();
            if (size == 0 or size > 64) return;

            var data_buf: [64]u8 = undefined;
            smith.bytes(data_buf[0..size]);

            // Format with random bytes - should not crash
            var out: std.Io.Writer.Allocating = .init(std.testing.allocator);
            defer out.deinit();
            td.formatBytes(data_buf[0..size], &out.writer) catch return;

            // Should produce some output
            try std.testing.expect(out.writer.buffered().len > 0);
        }
    }.f, .{});
}

// =======================================================================
// Fuzz: known descriptors with random bytes
// =======================================================================

test "fuzz: formatBytes on u32 descriptor with random bytes" {
    try std.testing.fuzz({}, struct {
        fn f(_: void, smith: *std.testing.Smith) !void {
            var buf: [4]u8 = undefined;
            smith.bytes(&buf);

            const parsed = try std.json.parseFromSlice(std.json.Value, std.testing.allocator,
                \\{"kind":"primitive","name":"u32","size":4,"signedness":"unsigned","bits":32}
            , .{});
            defer parsed.deinit();
            var td = try TypeDescriptor.init(std.testing.allocator, parsed);
            defer td.deinit(std.testing.allocator);

            var out: std.Io.Writer.Allocating = .init(std.testing.allocator);
            defer out.deinit();
            try td.formatBytes(&buf, &out.writer);
            try std.testing.expect(out.writer.buffered().len > 0);
        }
    }.f, .{});
}

test "fuzz: formatBytes on extern struct descriptor with random bytes" {
    try std.testing.fuzz({}, struct {
        fn f(_: void, smith: *std.testing.Smith) !void {
            var buf: [4]u8 = undefined;
            smith.bytes(&buf);

            const parsed = try std.json.parseFromSlice(std.json.Value, std.testing.allocator,
                \\{"kind":"struct","name":"S","layout":"extern","size":4,"fields":[{"name":"a","offset":0,"type_descriptor":{"kind":"primitive","name":"u8","size":1,"signedness":"unsigned","bits":8}},{"name":"b","offset":2,"type_descriptor":{"kind":"primitive","name":"u16","size":2,"signedness":"unsigned","bits":16}}]}
            , .{});
            defer parsed.deinit();
            var td = try TypeDescriptor.init(std.testing.allocator, parsed);
            defer td.deinit(std.testing.allocator);

            var out: std.Io.Writer.Allocating = .init(std.testing.allocator);
            defer out.deinit();
            try td.formatBytes(&buf, &out.writer);
            try std.testing.expect(out.writer.buffered().len > 0);
        }
    }.f, .{});
}

test "fuzz: formatBytes on string descriptor with random bytes" {
    try std.testing.fuzz({}, struct {
        fn f(_: void, smith: *std.testing.Smith) !void {
            var buf: [16]u8 = undefined;
            smith.bytes(&buf);

            const parsed = try std.json.parseFromSlice(std.json.Value, std.testing.allocator,
                \\{"kind":"string","max_len":16,"size":16}
            , .{});
            defer parsed.deinit();
            var td = try TypeDescriptor.init(std.testing.allocator, parsed);
            defer td.deinit(std.testing.allocator);

            var out: std.Io.Writer.Allocating = .init(std.testing.allocator);
            defer out.deinit();
            try td.formatBytes(&buf, &out.writer);
            try std.testing.expect(out.writer.buffered().len > 0);
        }
    }.f, .{});
}

test "fuzz: formatBytes on enum descriptor with random bytes" {
    try std.testing.fuzz({}, struct {
        fn f(_: void, smith: *std.testing.Smith) !void {
            var buf: [1]u8 = undefined;
            smith.bytes(&buf);

            const parsed = try std.json.parseFromSlice(std.json.Value, std.testing.allocator,
                \\{"kind":"enum","name":"E","tag_type":"u8","size":1,"variants":["a","b","c"]}
            , .{});
            defer parsed.deinit();
            var td = try TypeDescriptor.init(std.testing.allocator, parsed);
            defer td.deinit(std.testing.allocator);

            var out: std.Io.Writer.Allocating = .init(std.testing.allocator);
            defer out.deinit();
            try td.formatBytes(&buf, &out.writer);
            try std.testing.expect(out.writer.buffered().len > 0);
        }
    }.f, .{});
}

test "fuzz: formatBytes on packed struct descriptor with random bytes" {
    try std.testing.fuzz({}, struct {
        fn f(_: void, smith: *std.testing.Smith) !void {
            var buf: [1]u8 = undefined;
            smith.bytes(&buf);

            const parsed = try std.json.parseFromSlice(std.json.Value, std.testing.allocator,
                \\{"kind":"struct","name":"P","layout":"packed","size":1,"backing_integer_bits":8,"fields":[{"name":"a","bit_offset":0,"bits":5,"type_descriptor":{"kind":"primitive","name":"u5","size":1,"signedness":"unsigned","bits":5}},{"name":"b","bit_offset":5,"bits":3,"type_descriptor":{"kind":"primitive","name":"u3","size":1,"signedness":"unsigned","bits":3}}]}
            , .{});
            defer parsed.deinit();
            var td = try TypeDescriptor.init(std.testing.allocator, parsed);
            defer td.deinit(std.testing.allocator);

            var out: std.Io.Writer.Allocating = .init(std.testing.allocator);
            defer out.deinit();
            try td.formatBytes(&buf, &out.writer);
            try std.testing.expect(out.writer.buffered().len > 0);
        }
    }.f, .{});
}

test "fuzz: formatBytes on float descriptor with random bytes" {
    try std.testing.fuzz({}, struct {
        fn f(_: void, smith: *std.testing.Smith) !void {
            var buf: [4]u8 = undefined;
            smith.bytes(&buf);

            const parsed = try std.json.parseFromSlice(std.json.Value, std.testing.allocator,
                \\{"kind":"float","name":"f32","size":4,"bits":32}
            , .{});
            defer parsed.deinit();
            var td = try TypeDescriptor.init(std.testing.allocator, parsed);
            defer td.deinit(std.testing.allocator);

            var out: std.Io.Writer.Allocating = .init(std.testing.allocator);
            defer out.deinit();
            try td.formatBytes(&buf, &out.writer);
            try std.testing.expect(out.writer.buffered().len > 0);
        }
    }.f, .{});
}

// =======================================================================
// Fuzz: swap rule idempotency
// =======================================================================

test "fuzz: swap rules are idempotent on random bytes" {
    const erd_swap = @import("erd_schema").swap;
    const Rules = erd_swap.SwapRules(extern struct { a: u8, b: u16, c: u32 });

    try std.testing.fuzz({}, struct {
        fn f(_: void, smith: *std.testing.Smith) !void {
            var buf: [8]u8 = undefined;
            smith.bytes(&buf);
            const original = buf;

            Rules.apply(&buf);
            Rules.apply(&buf);
            try std.testing.expectEqualSlices(u8, &original, &buf);
        }
    }.f, .{});
}
