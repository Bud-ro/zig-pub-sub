const std = @import("std");
const contracts = @import("data_gen").contracts;

const BoundedPair = struct {
    low: u16,
    high: u16,

    pub fn validate(comptime self: BoundedPair) ?[]const u8 {
        if (self.low >= self.high) return "low must be less than high";
        if (self.low > 1000) return "low exceeds 1000";
        if (self.high > 1000) return "high exceeds 1000";
        return null;
    }
};

const PlainStruct = struct {
    x: u32,
    y: u32,
};

const Nested = struct {
    pair: BoundedPair,
    name_id: u8,

    pub fn validate(comptime self: Nested) ?[]const u8 {
        if (self.name_id == 0) return "name_id must not be zero";
        return null;
    }
};

test "assertValid passes valid BoundedPair" {
    comptime {
        contracts.assertValid(BoundedPair{ .low = 10, .high = 100 });
    }
}

test "assertValid passes plain struct (no validate)" {
    comptime {
        contracts.assertValid(PlainStruct{ .x = 42, .y = 99 });
    }
}

test "validated returns value unchanged" {
    comptime {
        const pair = contracts.validated(BoundedPair{ .low = 5, .high = 500 });
        try std.testing.expectEqual(5, pair.low);
        try std.testing.expectEqual(500, pair.high);
    }
}

test "recursive validation through nested structs" {
    comptime {
        contracts.assertValid(Nested{
            .pair = .{ .low = 10, .high = 100 },
            .name_id = 1,
        });
    }
}

test "recursive validation through arrays of structs" {
    const Config = struct {
        items: [3]BoundedPair,
    };

    comptime {
        contracts.assertValid(Config{
            .items = .{
                .{ .low = 1, .high = 10 },
                .{ .low = 20, .high = 30 },
                .{ .low = 100, .high = 200 },
            },
        });
    }
}

test "check returns null for valid value" {
    comptime {
        try std.testing.expectEqual(
            @as(?[]const u8, null),
            contracts.check(BoundedPair{ .low = 1, .high = 2 }, ""),
        );
    }
}

test "check returns error message for invalid value" {
    comptime {
        const err = contracts.check(BoundedPair{ .low = 50, .high = 10 }, "");
        try std.testing.expect(err != null);
    }
}
