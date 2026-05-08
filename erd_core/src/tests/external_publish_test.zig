//! Tests for the external publish mechanism in SystemData.
const erd_core = @import("erd_core");
const std = @import("std");
const Erd = erd_core.Erd;
const SystemDataTestDouble = erd_core.testing.SystemDataTestDouble;

const TestSystem = SystemDataTestDouble.create(struct {
    // zig fmt: off
    temperature:     Erd = SystemDataTestDouble.ramErd(u16, .{ .subs = 1, .erd_number = 0x0001, .published = true }),
    humidity:        Erd = SystemDataTestDouble.ramErd(u8,  .{ .subs = 0, .erd_number = 0x0002, .published = true }),
    internal_count:  Erd = SystemDataTestDouble.ramErd(u32, .{ .subs = 1 }),
    firmware_ver:    Erd = SystemDataTestDouble.ramErd(u32, .{ .erd_number = 0x0004 }),
    // zig fmt: on
});
const max_log = 16;
var publish_log: [max_log]struct { erd_number: u16, data: [8]u8, len: usize } = undefined;
var publish_count: usize = 0;

fn testExternalPublish(erd_number: u16, data: []const u8) void {
    if (publish_count < max_log) {
        var entry: @TypeOf(publish_log[0]) = .{ .erd_number = erd_number, .data = .{0} ** 8, .len = data.len };
        @memcpy(entry.data[0..data.len], data);
        publish_log[publish_count] = entry;
        publish_count += 1;
    }
}

fn resetLog() void {
    publish_count = 0;
}

test "published ERD fires external publish on write" {
    resetLog();
    var sd = TestSystem.init();
    sd.setExternalPublish(testExternalPublish);

    sd.write(.temperature, 100);

    try std.testing.expectEqual(1, publish_count);
    try std.testing.expectEqual(@as(u16, 0x0001), publish_log[0].erd_number);
    try std.testing.expectEqual(2, publish_log[0].len);
    const val = std.mem.readInt(u16, publish_log[0].data[0..2], .little);
    try std.testing.expectEqual(@as(u16, 100), val);
}

test "published ERD with subs == 0 fires external publish" {
    resetLog();
    var sd = TestSystem.init();
    sd.setExternalPublish(testExternalPublish);

    sd.write(.humidity, 55);

    try std.testing.expectEqual(1, publish_count);
    try std.testing.expectEqual(@as(u16, 0x0002), publish_log[0].erd_number);
    try std.testing.expectEqual(@as(u8, 55), publish_log[0].data[0]);
}

test "unpublished ERD does not fire external publish" {
    resetLog();
    var sd = TestSystem.init();
    sd.setExternalPublish(testExternalPublish);

    sd.write(.internal_count, 999);
    try std.testing.expectEqual(0, publish_count);
}

test "ERD with erd_number but not published does not fire" {
    resetLog();
    var sd = TestSystem.init();
    sd.setExternalPublish(testExternalPublish);

    sd.write(.firmware_ver, 0x01020304);
    try std.testing.expectEqual(0, publish_count);
}

test "same value write does not fire external publish" {
    resetLog();
    var sd = TestSystem.init();
    sd.setExternalPublish(testExternalPublish);

    sd.write(.temperature, 0);
    try std.testing.expectEqual(0, publish_count);
}

test "no external_publish_fn set: no crash" {
    var sd = TestSystem.init();
    // No setExternalPublish call
    sd.write(.temperature, 100);
    // Should not crash
}

test "multiple writes accumulate" {
    resetLog();
    var sd = TestSystem.init();
    sd.setExternalPublish(testExternalPublish);

    sd.write(.temperature, 100);
    sd.write(.humidity, 55);
    sd.write(.temperature, 200);

    try std.testing.expectEqual(3, publish_count);
    try std.testing.expectEqual(@as(u16, 0x0001), publish_log[0].erd_number);
    try std.testing.expectEqual(@as(u16, 0x0002), publish_log[1].erd_number);
    try std.testing.expectEqual(@as(u16, 0x0001), publish_log[2].erd_number);
}

test "internal subscribers still fire alongside external publish" {
    resetLog();
    var sd = TestSystem.init();
    sd.setExternalPublish(testExternalPublish);

    var sub_count: u32 = 0;
    sd.subscribe(.temperature, &sub_count, struct {
        fn cb(ctx: ?*anyopaque, _: ?*const anyopaque, _: *anyopaque) void {
            const count: *u32 = @ptrCast(@alignCast(ctx.?));
            count.* += 1;
        }
    }.cb);

    sd.write(.temperature, 42);

    // Both internal subscriber and external publish should fire
    try std.testing.expectEqual(@as(u32, 1), sub_count);
    try std.testing.expectEqual(1, publish_count);
}
