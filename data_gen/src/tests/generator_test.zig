const std = @import("std");
const generator = @import("data_gen").generator;

test "generateArray produces correct values" {
    const doubler = struct {
        fn f(comptime i: usize) u32 {
            return @intCast(i * 2);
        }
    }.f;

    comptime {
        const arr = generator.generateArray(u32, 5, doubler);
        try std.testing.expectEqual(5, arr.len);
        try std.testing.expectEqual(0, arr[0]);
        try std.testing.expectEqual(2, arr[1]);
        try std.testing.expectEqual(8, arr[4]);
    }
}

test "generateArray with struct type" {
    const Entry = struct { idx: u8, value: u16 };
    const gen = struct {
        fn f(comptime i: usize) Entry {
            return .{ .idx = @intCast(i), .value = @intCast(i * 100) };
        }
    }.f;

    comptime {
        const arr = generator.generateArray(Entry, 4, gen);
        try std.testing.expectEqual(4, arr.len);
        try std.testing.expectEqual(0, arr[0].idx);
        try std.testing.expectEqual(300, arr[3].value);
    }
}

test "generateArray with n=0 yields empty array" {
    const noop = struct {
        fn f(comptime _: usize) u32 {
            return 0;
        }
    }.f;

    comptime {
        const arr = generator.generateArray(u32, 0, noop);
        try std.testing.expectEqual(0, arr.len);
    }
}

test "generateArray with n=1 invokes func once" {
    const constant = struct {
        fn f(comptime _: usize) u32 {
            return 0xDEAD;
        }
    }.f;

    comptime {
        const arr = generator.generateArray(u32, 1, constant);
        try std.testing.expectEqual(1, arr.len);
        try std.testing.expectEqual(0xDEAD, arr[0]);
    }
}
