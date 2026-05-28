const erd_core = @import("erd_core");
const std = @import("std");
const Erd = erd_core.Erd;
const SystemDataTestDouble = erd_core.testing.SystemDataTestDouble;

const TestSystem = SystemDataTestDouble.create(struct {
    /// Published ERD with subscriptions - monitored.
    temperature: Erd = SystemDataTestDouble.ramErd(u16, .{ .subs = 2, .erd_number = 0x1000, .published = true }),
    /// Published ERD with subscriptions - monitored.
    humidity: Erd = SystemDataTestDouble.ramErd(u8, .{ .subs = 2, .erd_number = 0x1001, .published = true }),
    /// Private ERD (not published) - never monitored externally.
    internal_counter: Erd = SystemDataTestDouble.ramErd(u32, .{ .subs = 1 }),
    /// Has erd_number but NOT published - should not be monitored.
    debug_flags: Erd = SystemDataTestDouble.ramErd(u8, .{ .subs = 1, .erd_number = 0x1003 }),
});

const max_sends = 16;
var send_log: [max_sends]SendEntry = undefined;
var send_count: usize = 0;

const SendEntry = struct {
    erd_number: u16,
    len: u16,
    first_bytes: [4]u8,
};

fn testSendFn(erd_number: u16, data: []const u8) void {
    if (send_count < max_sends) {
        var entry = SendEntry{ .erd_number = erd_number, .len = @intCast(data.len), .first_bytes = .{ 0, 0, 0, 0 } };
        const copy_len: usize = @min(data.len, 4);
        @memcpy(entry.first_bytes[0..copy_len], data[0..copy_len]);
        send_log[send_count] = entry;
        send_count += 1;
    }
}

fn resetLog() void {
    send_count = 0;
}

const ExternalDataComponent = erd_core.data_component.External;
const ExternalComponent = ExternalDataComponent(&getAllErds());

fn getAllErds() [4]Erd {
    const erds_instance = TestSystem.SystemData.erds;
    return .{
        @field(erds_instance, "temperature"),
        @field(erds_instance, "humidity"),
        @field(erds_instance, "internal_counter"),
        @field(erds_instance, "debug_flags"),
    };
}

test "subscribes to published ERDs and sends on change" {
    resetLog();
    var system_data = TestSystem.init();
    var ext = ExternalComponent.init(testSendFn);
    ext.postSystemDataInit(&system_data);

    system_data.write(.temperature, 2500);
    try std.testing.expectEqual(1, send_count);
    try std.testing.expectEqual(@as(u16, 0x1000), send_log[0].erd_number);
    try std.testing.expectEqual(@as(u16, 2), send_log[0].len);
    try std.testing.expectEqual(@as(u8, 0xC4), send_log[0].first_bytes[0]);
    try std.testing.expectEqual(@as(u8, 0x09), send_log[0].first_bytes[1]);
}

test "does not fire for private ERDs" {
    resetLog();
    var system_data = TestSystem.init();
    var ext = ExternalComponent.init(testSendFn);
    ext.postSystemDataInit(&system_data);

    system_data.write(.internal_counter, 999);
    try std.testing.expectEqual(0, send_count);
}

test "does not fire for ERDs with erd_number but not published" {
    resetLog();
    var system_data = TestSystem.init();
    var ext = ExternalComponent.init(testSendFn);
    ext.postSystemDataInit(&system_data);

    system_data.write(.debug_flags, 0xFF);
    try std.testing.expectEqual(0, send_count);
}

test "does not fire when value unchanged" {
    resetLog();
    var system_data = TestSystem.init();
    var ext = ExternalComponent.init(testSendFn);
    ext.postSystemDataInit(&system_data);

    system_data.write(.temperature, 0);
    try std.testing.expectEqual(0, send_count);
}

test "monitored_count only counts published ERDs with subs" {
    // temperature + humidity are published with subs > 0
    // debug_flags has subs but is not published
    // internal_counter is neither
    try std.testing.expectEqual(2, ExternalComponent.monitored_count);
}
