const std = @import("std");
const transform = @import("data_gen").transform;

test "fixedPoint Q8.8 exact values" {
    comptime {
        try std.testing.expectEqual(@as(u16, 256), transform.fixedPoint(u16, 8, 1.0));
        try std.testing.expectEqual(@as(u16, 384), transform.fixedPoint(u16, 8, 1.5));
        try std.testing.expectEqual(@as(u16, 320), transform.fixedPoint(u16, 8, 1.25));
        try std.testing.expectEqual(@as(u16, 64), transform.fixedPoint(u16, 8, 0.25));
        try std.testing.expectEqual(@as(u16, 0), transform.fixedPoint(u16, 8, 0.0));
    }
}

test "fixedPoint Q8.8 signed" {
    comptime {
        try std.testing.expectEqual(@as(i16, -256), transform.fixedPoint(i16, 8, -1.0));
        try std.testing.expectEqual(@as(i16, -128), transform.fixedPoint(i16, 8, -0.5));
        try std.testing.expectEqual(@as(i16, 256), transform.fixedPoint(i16, 8, 1.0));
    }
}

test "fixedPoint Q1.15 high precision" {
    comptime {
        try std.testing.expectEqual(@as(u16, 16384), transform.fixedPoint(u16, 15, 0.5));
        try std.testing.expectEqual(@as(u16, 8192), transform.fixedPoint(u16, 15, 0.25));
        try std.testing.expectEqual(@as(u16, 32768), transform.fixedPoint(u16, 15, 1.0));
    }
}

test "scaled exact conversion" {
    comptime {
        try std.testing.expectEqual(@as(u16, 3300), transform.scaled(u16, 1000, 3.3));
        try std.testing.expectEqual(@as(u16, 5000), transform.scaled(u16, 1000, 5.0));
        try std.testing.expectEqual(@as(u16, 1250), transform.scaled(u16, 1000, 1.25));
    }
}

test "scaledNearest rounds correctly" {
    comptime {
        try std.testing.expectEqual(@as(u16, 333), transform.scaledNearest(u16, 1000, 0.3333));
        try std.testing.expectEqual(@as(u16, 667), transform.scaledNearest(u16, 1000, 0.6667));
        try std.testing.expectEqual(@as(u8, 128), transform.scaledNearest(u8, 255, 0.5));
    }
}

test "percentOf with rounding" {
    comptime {
        try std.testing.expectEqual(@as(u8, 128), transform.percentOf(u8, 255, 50.0));
        try std.testing.expectEqual(@as(u8, 255), transform.percentOf(u8, 255, 100.0));
        try std.testing.expectEqual(@as(u8, 0), transform.percentOf(u8, 255, 0.0));
    }
}
