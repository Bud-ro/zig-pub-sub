//! Fuzz tests for ERD type descriptor runtime decoder.
//!
//! Verifies that formatBytes never crashes on arbitrary byte buffers
//! for any supported type descriptor kind.
const std = @import("std");
const decode = @import("erd_schema").decode;
const TypeDescriptor = decode.TypeDescriptor;

test "fuzz: formatBytes on u32 descriptor with random bytes" {
    try std.testing.fuzz({}, struct {
        fn f(_: void, smith: *std.testing.Smith) !void {
            var buf: [4]u8 = undefined;
            smith.bytesWithHash(&buf, 0);

            var td = try TypeDescriptor.parse(std.testing.allocator,
                \\{"kind":"primitive","name":"u32","size":4,"signedness":"unsigned","bits":32}
            );
            defer td.deinit();

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
            smith.bytesWithHash(&buf, 0);

            var td = try TypeDescriptor.parse(std.testing.allocator,
                \\{"kind":"struct","name":"S","layout":"extern","size":4,"fields":[{"name":"a","offset":0,"type_descriptor":{"kind":"primitive","name":"u8","size":1,"signedness":"unsigned","bits":8}},{"name":"b","offset":2,"type_descriptor":{"kind":"primitive","name":"u16","size":2,"signedness":"unsigned","bits":16}}]}
            );
            defer td.deinit();

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
            smith.bytesWithHash(&buf, 0);

            var td = try TypeDescriptor.parse(std.testing.allocator,
                \\{"kind":"string","max_len":16,"size":16}
            );
            defer td.deinit();

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
            smith.bytesWithHash(&buf, 0);

            var td = try TypeDescriptor.parse(std.testing.allocator,
                \\{"kind":"enum","name":"E","tag_type":"u8","size":1,"variants":["a","b","c"]}
            );
            defer td.deinit();

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
            smith.bytesWithHash(&buf, 0);

            var td = try TypeDescriptor.parse(std.testing.allocator,
                \\{"kind":"struct","name":"P","layout":"packed","size":1,"backing_integer_bits":8,"fields":[{"name":"a","bit_offset":0,"bits":5,"type_descriptor":{"kind":"primitive","name":"u5","size":1,"signedness":"unsigned","bits":5}},{"name":"b","bit_offset":5,"bits":3,"type_descriptor":{"kind":"primitive","name":"u3","size":1,"signedness":"unsigned","bits":3}}]}
            );
            defer td.deinit();

            var out: std.Io.Writer.Allocating = .init(std.testing.allocator);
            defer out.deinit();
            try td.formatBytes(&buf, &out.writer);
            try std.testing.expect(out.writer.buffered().len > 0);
        }
    }.f, .{});
}

test "fuzz: swap rules are idempotent on random bytes" {
    const erd_swap = @import("erd_schema").swap;
    const Rules = erd_swap.SwapRules(extern struct { a: u8, b: u16, c: u32 });

    try std.testing.fuzz({}, struct {
        fn f(_: void, smith: *std.testing.Smith) !void {
            var buf: [8]u8 = undefined;
            smith.bytesWithHash(&buf, 0);
            const original = buf;

            // apply twice should restore original (idempotent)
            Rules.apply(&buf);
            Rules.apply(&buf);
            try std.testing.expectEqualSlices(u8, &original, &buf);
        }
    }.f, .{});
}
