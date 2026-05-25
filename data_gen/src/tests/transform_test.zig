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

test "percentOf rounds to nearest" {
    comptime {
        try std.testing.expectEqual(@as(u8, 100), transform.percentOf(u8, 1000, 10.0));
        try std.testing.expectEqual(@as(u16, 33), transform.percentOf(u16, 100, 33.33));
        try std.testing.expectEqual(@as(u16, 67), transform.percentOf(u16, 100, 66.67));
    }
}

test "scaledNearest handles signed values" {
    comptime {
        try std.testing.expectEqual(@as(i16, -333), transform.scaledNearest(i16, 1000, -0.3333));
        try std.testing.expectEqual(@as(i16, -1), transform.scaledNearest(i16, 100, -0.005));
    }
}

test "fixedPoint signed extremes" {
    comptime {
        try std.testing.expectEqual(@as(i16, -32768), transform.fixedPoint(i16, 15, -1.0));
        try std.testing.expectEqual(@as(i8, -128), transform.fixedPoint(i8, 0, -128.0));
        try std.testing.expectEqual(@as(i8, 127), transform.fixedPoint(i8, 0, 127.0));
    }
}

test "scaled zero is always representable" {
    comptime {
        try std.testing.expectEqual(@as(u16, 0), transform.scaled(u16, 1000, 0.0));
        try std.testing.expectEqual(@as(i16, 0), transform.scaled(i16, 1000, 0.0));
    }
}

test "scaled accepts values at the u16 boundary" {
    comptime {
        // 65.535 * 1000 = 65535, exactly fits in u16 max.
        try std.testing.expectEqual(@as(u16, 65535), transform.scaled(u16, 1000, 65.535));
    }
}

test "scaled accepts signed negative values" {
    comptime {
        try std.testing.expectEqual(@as(i16, -3300), transform.scaled(i16, 1000, -3.3));
        try std.testing.expectEqual(@as(i16, -32768), transform.scaled(i16, 1, -32768.0));
        try std.testing.expectEqual(@as(i8, -128), transform.scaled(i8, 1, -128.0));
    }
}

test "scaledNearest at i16 boundaries" {
    comptime {
        try std.testing.expectEqual(@as(i16, 32767), transform.scaledNearest(i16, 1, 32767.0));
        try std.testing.expectEqual(@as(i16, -32768), transform.scaledNearest(i16, 1, -32768.0));
    }
}

test "scaledNearest accepts fractional values that round to in-range max" {
    comptime {
        // Values just below max where @round stays in range must still pass:
        // catches a regression where checkFitsIn rejects pre-round values.
        try std.testing.expectEqual(@as(i16, 32767), transform.scaledNearest(i16, 1, 32767.4));
        try std.testing.expectEqual(@as(i16, -32768), transform.scaledNearest(i16, 1, -32768.4));
        try std.testing.expectEqual(@as(u8, 255), transform.scaledNearest(u8, 1, 255.4));
    }
    // Note: the symmetric overflow case (e.g. scaledNearest(i16, 1, 32767.5)
    // where @round = 32768) is rejected by checkFitsIn at @compileError time
    // and so can't be exercised by a runtime test. Verified manually.
}
