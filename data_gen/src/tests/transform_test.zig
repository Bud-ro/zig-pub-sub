const std = @import("std");
const transforms = @import("data_gen").transforms;

test "fixedPoint Q8.8 exact values" {
    comptime {
        try std.testing.expectEqual(@as(u16, 256), transforms.fixedPoint(u16, 8, 1.0));
        try std.testing.expectEqual(@as(u16, 384), transforms.fixedPoint(u16, 8, 1.5));
        try std.testing.expectEqual(@as(u16, 320), transforms.fixedPoint(u16, 8, 1.25));
        try std.testing.expectEqual(@as(u16, 64), transforms.fixedPoint(u16, 8, 0.25));
        try std.testing.expectEqual(@as(u16, 0), transforms.fixedPoint(u16, 8, 0.0));
    }
}

test "fixedPoint Q8.8 signed" {
    comptime {
        try std.testing.expectEqual(@as(i16, -256), transforms.fixedPoint(i16, 8, -1.0));
        try std.testing.expectEqual(@as(i16, -128), transforms.fixedPoint(i16, 8, -0.5));
        try std.testing.expectEqual(@as(i16, 256), transforms.fixedPoint(i16, 8, 1.0));
    }
}

test "fixedPoint Q1.15 high precision" {
    comptime {
        try std.testing.expectEqual(@as(u16, 16384), transforms.fixedPoint(u16, 15, 0.5));
        try std.testing.expectEqual(@as(u16, 8192), transforms.fixedPoint(u16, 15, 0.25));
        try std.testing.expectEqual(@as(u16, 32768), transforms.fixedPoint(u16, 15, 1.0));
    }
}

test "scaled exact conversion" {
    comptime {
        try std.testing.expectEqual(@as(u16, 3300), transforms.scaled(u16, 1000, 3.3));
        try std.testing.expectEqual(@as(u16, 5000), transforms.scaled(u16, 1000, 5.0));
        try std.testing.expectEqual(@as(u16, 1250), transforms.scaled(u16, 1000, 1.25));
    }
}

test "scaledNearest rounds correctly" {
    comptime {
        try std.testing.expectEqual(@as(u16, 333), transforms.scaledNearest(u16, 1000, 0.3333));
        try std.testing.expectEqual(@as(u16, 667), transforms.scaledNearest(u16, 1000, 0.6667));
        try std.testing.expectEqual(@as(u8, 128), transforms.scaledNearest(u8, 255, 0.5));
    }
}

test "percentOf with rounding" {
    comptime {
        try std.testing.expectEqual(@as(u8, 128), transforms.percentOf(u8, 255, 50.0));
        try std.testing.expectEqual(@as(u8, 255), transforms.percentOf(u8, 255, 100.0));
        try std.testing.expectEqual(@as(u8, 0), transforms.percentOf(u8, 255, 0.0));
    }
}

test "freqToPeriod" {
    comptime {
        try std.testing.expectEqual(@as(u32, 1000), transforms.freqToPeriod(u32, 1000.0, .microseconds));
        try std.testing.expectEqual(@as(u32, 100), transforms.freqToPeriod(u32, 10000.0, .microseconds));
        try std.testing.expectEqual(@as(u16, 10), transforms.freqToPeriod(u16, 100.0, .milliseconds));
    }
}

test "freqToTicks" {
    comptime {
        try std.testing.expectEqual(@as(u16, 100), transforms.freqToTicks(u16, 100.0, 10000.0));
        try std.testing.expectEqual(@as(u16, 10), transforms.freqToTicks(u16, 1000.0, 10000.0));
        try std.testing.expectEqual(@as(u16, 1), transforms.freqToTicks(u16, 10000.0, 10000.0));
    }
}
