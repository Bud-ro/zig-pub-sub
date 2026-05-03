const std = @import("std");
const contract = @import("data_gen").contract;

const BoundedPair = struct {
    low: u16,
    high: u16,

    /// Validate constraints for this type.
    pub fn contractValidate(comptime self: BoundedPair) ?[]const u8 {
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

    /// Validate constraints for this type.
    pub fn contractValidate(comptime self: Nested) ?[]const u8 {
        if (self.name_id == 0) return "name_id must not be zero";
        return null;
    }
};

const DeeplyNested = struct {
    inner: Nested,
    tag: u8,
};

const WithArray = struct {
    items: [3]BoundedPair,
    label: u8,
};

const ThreeLevels = struct {
    group: WithArray,
    id: u8,
};

test "assertValid passes valid BoundedPair" {
    comptime {
        contract.assertValid(BoundedPair{ .low = 10, .high = 100 });
    }
}

test "assertValid passes plain struct (no contractValidate)" {
    comptime {
        contract.assertValid(PlainStruct{ .x = 42, .y = 99 });
    }
}

test "validated returns value unchanged" {
    comptime {
        const pair = contract.validated(BoundedPair{ .low = 5, .high = 500 });
        try std.testing.expectEqual(5, pair.low);
        try std.testing.expectEqual(500, pair.high);
    }
}

test "recursive validation through nested structs" {
    comptime {
        contract.assertValid(Nested{
            .pair = .{ .low = 10, .high = 100 },
            .name_id = 1,
        });
    }
}

test "recursive validation through arrays of structs" {
    comptime {
        contract.assertValid(WithArray{
            .items = .{
                .{ .low = 1, .high = 10 },
                .{ .low = 20, .high = 30 },
                .{ .low = 100, .high = 200 },
            },
            .label = 1,
        });
    }
}

test "check returns null for valid value" {
    comptime {
        try std.testing.expectEqual(
            @as(?[]const u8, null),
            contract.check(BoundedPair{ .low = 1, .high = 2 }, ""),
        );
    }
}

test "check error message for top-level failure" {
    comptime {
        try std.testing.expectEqualStrings(
            "low must be less than high",
            contract.check(BoundedPair{ .low = 50, .high = 10 }, "").?,
        );
    }
}

test "check error message for nested struct failure" {
    comptime {
        try std.testing.expectEqualStrings(
            ".pair: low must be less than high",
            contract.check(Nested{
                .pair = .{ .low = 50, .high = 10 },
                .name_id = 1,
            }, "").?,
        );
    }
}

test "check error message for deeply nested failure" {
    comptime {
        try std.testing.expectEqualStrings(
            ".inner.pair: low must be less than high",
            contract.check(DeeplyNested{
                .inner = .{
                    .pair = .{ .low = 999, .high = 1 },
                    .name_id = 1,
                },
                .tag = 5,
            }, "").?,
        );
    }
}

test "check error message for array element failure" {
    comptime {
        try std.testing.expectEqualStrings(
            ".items[1]: low must be less than high",
            contract.check(WithArray{
                .items = .{
                    .{ .low = 1, .high = 10 },
                    .{ .low = 50, .high = 5 },
                    .{ .low = 100, .high = 200 },
                },
                .label = 1,
            }, "").?,
        );
    }
}

test "check error message for nested array element failure" {
    comptime {
        try std.testing.expectEqualStrings(
            ".group.items[2]: high exceeds 1000",
            contract.check(ThreeLevels{
                .group = .{
                    .items = .{
                        .{ .low = 1, .high = 10 },
                        .{ .low = 20, .high = 30 },
                        .{ .low = 100, .high = 2000 },
                    },
                    .label = 1,
                },
                .id = 1,
            }, "").?,
        );
    }
}

test "own contractValidate runs before recursive field checks" {
    comptime {
        try std.testing.expectEqualStrings(
            "name_id must not be zero",
            contract.check(Nested{
                .pair = .{ .low = 50, .high = 10 },
                .name_id = 0,
            }, "").?,
        );
    }
}

test "check validates bare array of structs" {
    comptime {
        try std.testing.expectEqual(
            @as(?[]const u8, null),
            contract.check([3]BoundedPair{
                .{ .low = 1, .high = 10 },
                .{ .low = 20, .high = 30 },
                .{ .low = 100, .high = 200 },
            }, ""),
        );
    }
}

test "check error message for bare array element failure" {
    comptime {
        try std.testing.expectEqualStrings(
            "[1]: low must be less than high",
            contract.check([3]BoundedPair{
                .{ .low = 1, .high = 10 },
                .{ .low = 50, .high = 5 },
                .{ .low = 100, .high = 200 },
            }, "").?,
        );
    }
}

test "check validates nested array of arrays" {
    const Inner = struct {
        val: u8,

        /// Validate constraints for this type.
        pub fn contractValidate(comptime self: @This()) ?[]const u8 {
            if (self.val == 0) return "val must not be zero";
            return null;
        }
    };
    comptime {
        try std.testing.expectEqualStrings(
            ".rows[1][2]: val must not be zero",
            contract.check(struct {
                rows: [2][3]Inner,
            }{
                .rows = .{
                    .{ .{ .val = 1 }, .{ .val = 2 }, .{ .val = 3 } },
                    .{ .{ .val = 4 }, .{ .val = 5 }, .{ .val = 0 } },
                },
            }, "").?,
        );
    }
}
