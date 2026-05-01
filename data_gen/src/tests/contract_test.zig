const std = @import("std");
const contracts = @import("data_gen").contracts;
const constraints = @import("data_gen").constraints;

const BoundedPair = struct {
    low: u16,
    high: u16,

    pub fn validate(comptime self: BoundedPair) void {
        constraints.inRange(u16, 0, 1000, self.low);
        constraints.inRange(u16, 0, 1000, self.high);
        constraints.lessThan(u16, self.low, self.high);
    }

    pub fn generate(comptime low: u16, comptime high: u16) BoundedPair {
        const self = BoundedPair{ .low = low, .high = high };
        self.validate();
        return self;
    }
};

const PlainStruct = struct {
    x: u32,
    y: u32,
};

test "hasValidate detects validate declaration" {
    comptime {
        try std.testing.expect(contracts.hasValidate(BoundedPair));
        try std.testing.expect(!contracts.hasValidate(PlainStruct));
    }
}

test "hasGenerate detects generate declaration" {
    comptime {
        try std.testing.expect(contracts.hasGenerate(BoundedPair));
        try std.testing.expect(!contracts.hasGenerate(PlainStruct));
    }
}

test "validated calls validate and returns value" {
    comptime {
        const pair = contracts.validated(BoundedPair, .{ .low = 10, .high = 100 });
        try std.testing.expectEqual(10, pair.low);
        try std.testing.expectEqual(100, pair.high);
    }
}

test "validated passes through plain structs unchanged" {
    comptime {
        const plain = contracts.validated(PlainStruct, .{ .x = 42, .y = 99 });
        try std.testing.expectEqual(42, plain.x);
        try std.testing.expectEqual(99, plain.y);
    }
}

test "assertValid does not compile-error on valid data" {
    comptime {
        contracts.assertValid(BoundedPair, .{ .low = 5, .high = 500 });
        contracts.assertValid(PlainStruct, .{ .x = 0, .y = 0 });
    }
}

test "generate produces validated instance" {
    comptime {
        const pair = BoundedPair.generate(10, 200);
        try std.testing.expectEqual(10, pair.low);
        try std.testing.expectEqual(200, pair.high);
    }
}
