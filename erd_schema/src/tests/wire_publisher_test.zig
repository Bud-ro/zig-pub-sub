//! Tests for `WirePublisher`: subscribes to a SystemData's watched ERDs and
//! republishes their changes as (erd_number, big-endian bytes) to its own
//! pool of downstream subscribers.

const erd_core = @import("erd_core");
const erd_schema = @import("erd_schema");
const std = @import("std");
const Erd = erd_core.Erd;
const WirePublisher = erd_schema.WirePublisher;
const SystemDataTestDouble = erd_core.testing.SystemDataTestDouble;

const TestSystem = SystemDataTestDouble.create(struct {
    temperature: Erd = SystemDataTestDouble.ramErd(u16, .{ .subs = 1, .erd_number = 0x1000 }),
    pressure: Erd = SystemDataTestDouble.ramErd(u32, .{ .subs = 1, .erd_number = 0x1001 }),
    flags: Erd = SystemDataTestDouble.ramErd(u8, .{ .subs = 1, .erd_number = 0x1002 }),
    private: Erd = SystemDataTestDouble.ramErd(u32, .{ .subs = 0 }),
});
const TestSD = TestSystem.SystemData;

fn watchedErds() [3]Erd {
    const e = TestSD.erds;
    return .{ e.temperature, e.pressure, e.flags };
}

const Wire = WirePublisher(TestSD, &watchedErds(), 2);

const max_events = 16;
var event_log: [max_events]Event = undefined;
var event_count: usize = 0;

const Event = struct {
    erd_number: u16,
    bytes: [8]u8,
    len: u16,
};

fn recordingCallback(_: ?*anyopaque, args: ?*const anyopaque, _: *anyopaque) void {
    const out: *const Wire.OnChangeArgs = @ptrCast(@alignCast(args.?));
    if (event_count < max_events) {
        var ev: Event = .{ .erd_number = out.erd_number, .bytes = .{ 0, 0, 0, 0, 0, 0, 0, 0 }, .len = @intCast(out.be_bytes.len) };
        const n = @min(out.be_bytes.len, ev.bytes.len);
        @memcpy(ev.bytes[0..n], out.be_bytes[0..n]);
        event_log[event_count] = ev;
        event_count += 1;
    }
}

fn secondCallback(_: ?*anyopaque, _: ?*const anyopaque, _: *anyopaque) void {
    // Different identity from recordingCallback; used to verify n_subs > 1.
    if (event_count < max_events) event_count += 1;
}

fn resetLog() void {
    event_count = 0;
}

test "publishes big-endian bytes for u16" {
    resetLog();
    var sd = TestSystem.init();
    var wire = Wire.init();
    wire.postSystemDataInit(&sd);
    wire.subscribe(null, recordingCallback);

    sd.write(.temperature, 0x1234);

    try std.testing.expectEqual(1, event_count);
    try std.testing.expectEqual(@as(u16, 0x1000), event_log[0].erd_number);
    try std.testing.expectEqual(@as(u16, 2), event_log[0].len);
    // Big-endian: high byte first.
    try std.testing.expectEqual(@as(u8, 0x12), event_log[0].bytes[0]);
    try std.testing.expectEqual(@as(u8, 0x34), event_log[0].bytes[1]);
}

test "publishes big-endian bytes for u32" {
    resetLog();
    var sd = TestSystem.init();
    var wire = Wire.init();
    wire.postSystemDataInit(&sd);
    wire.subscribe(null, recordingCallback);

    sd.write(.pressure, 0xDEADBEEF);

    try std.testing.expectEqual(1, event_count);
    try std.testing.expectEqual(@as(u16, 0x1001), event_log[0].erd_number);
    try std.testing.expectEqual(@as(u16, 4), event_log[0].len);
    try std.testing.expectEqual(@as(u8, 0xDE), event_log[0].bytes[0]);
    try std.testing.expectEqual(@as(u8, 0xAD), event_log[0].bytes[1]);
    try std.testing.expectEqual(@as(u8, 0xBE), event_log[0].bytes[2]);
    try std.testing.expectEqual(@as(u8, 0xEF), event_log[0].bytes[3]);
}

test "publishes u8 without swap" {
    resetLog();
    var sd = TestSystem.init();
    var wire = Wire.init();
    wire.postSystemDataInit(&sd);
    wire.subscribe(null, recordingCallback);

    sd.write(.flags, 0xA5);

    try std.testing.expectEqual(1, event_count);
    try std.testing.expectEqual(@as(u16, 0x1002), event_log[0].erd_number);
    try std.testing.expectEqual(@as(u16, 1), event_log[0].len);
    try std.testing.expectEqual(@as(u8, 0xA5), event_log[0].bytes[0]);
}

test "does not fire for unwatched ERDs" {
    resetLog();
    var sd = TestSystem.init();
    var wire = Wire.init();
    wire.postSystemDataInit(&sd);
    wire.subscribe(null, recordingCallback);

    // `private` is not in the watched list.
    sd.write(.private, 999);

    try std.testing.expectEqual(0, event_count);
}

test "does not fire when value is unchanged" {
    resetLog();
    var sd = TestSystem.init();
    var wire = Wire.init();
    wire.postSystemDataInit(&sd);
    wire.subscribe(null, recordingCallback);

    // Initial value is 0; write 0 again.
    sd.write(.temperature, 0);

    try std.testing.expectEqual(0, event_count);
}

test "delivers to every downstream subscriber" {
    resetLog();
    var sd = TestSystem.init();
    var wire = Wire.init();
    wire.postSystemDataInit(&sd);
    wire.subscribe(null, recordingCallback);
    wire.subscribe(null, secondCallback);

    sd.write(.temperature, 1);

    try std.testing.expectEqual(2, event_count);
}

test "unsubscribe stops delivery" {
    resetLog();
    var sd = TestSystem.init();
    var wire = Wire.init();
    wire.postSystemDataInit(&sd);
    wire.subscribe(null, recordingCallback);

    sd.write(.temperature, 1);
    try std.testing.expectEqual(1, event_count);

    wire.unsubscribe(recordingCallback);
    sd.write(.temperature, 2);
    try std.testing.expectEqual(1, event_count);
}

test "multiple writes accumulate in order" {
    resetLog();
    var sd = TestSystem.init();
    var wire = Wire.init();
    wire.postSystemDataInit(&sd);
    wire.subscribe(null, recordingCallback);

    sd.write(.temperature, 1);
    sd.write(.pressure, 2);
    sd.write(.flags, 3);

    try std.testing.expectEqual(3, event_count);
    try std.testing.expectEqual(@as(u16, 0x1000), event_log[0].erd_number);
    try std.testing.expectEqual(@as(u16, 0x1001), event_log[1].erd_number);
    try std.testing.expectEqual(@as(u16, 0x1002), event_log[2].erd_number);
}

test "swaps fields of an extern struct" {
    const Sample = extern struct { a: u32, b: u16, c: u8 };
    const StructSys = SystemDataTestDouble.create(struct {
        sample: Erd = SystemDataTestDouble.ramErd(Sample, .{ .subs = 1, .erd_number = 0x2000 }),
    });
    const StructSD = StructSys.SystemData;

    const StructWire = WirePublisher(StructSD, &.{StructSD.erds.sample}, 1);

    resetLog();
    var sd = StructSys.init();
    var wire = StructWire.init();
    wire.postSystemDataInit(&sd);

    // Capture into the same log via a closure over StructWire.OnChangeArgs.
    const local = struct {
        fn cb(_: ?*anyopaque, args: ?*const anyopaque, _: *anyopaque) void {
            const out: *const StructWire.OnChangeArgs = @ptrCast(@alignCast(args.?));
            if (event_count < max_events) {
                var ev: Event = .{ .erd_number = out.erd_number, .bytes = .{ 0, 0, 0, 0, 0, 0, 0, 0 }, .len = @intCast(out.be_bytes.len) };
                const n = @min(out.be_bytes.len, ev.bytes.len);
                @memcpy(ev.bytes[0..n], out.be_bytes[0..n]);
                event_log[event_count] = ev;
                event_count += 1;
            }
        }
    }.cb;
    wire.subscribe(null, local);

    sd.write(.sample, .{ .a = 0xAABBCCDD, .b = 0x1122, .c = 0x33 });

    try std.testing.expectEqual(1, event_count);
    try std.testing.expectEqual(@as(u16, 0x2000), event_log[0].erd_number);
    // a (u32) -> AA BB CC DD, b (u16) -> 11 22, c (u8) -> 33.
    try std.testing.expectEqual(@as(u8, 0xAA), event_log[0].bytes[0]);
    try std.testing.expectEqual(@as(u8, 0xBB), event_log[0].bytes[1]);
    try std.testing.expectEqual(@as(u8, 0xCC), event_log[0].bytes[2]);
    try std.testing.expectEqual(@as(u8, 0xDD), event_log[0].bytes[3]);
    try std.testing.expectEqual(@as(u8, 0x11), event_log[0].bytes[4]);
    try std.testing.expectEqual(@as(u8, 0x22), event_log[0].bytes[5]);
    try std.testing.expectEqual(@as(u8, 0x33), event_log[0].bytes[6]);
}

test "swaps the active variant of a tagged-union ERD" {
    // extern struct { tag, payload: extern union } is the tagged-union pattern
    // recognized by erd_swap. The payload bytes must be reversed according to
    // the *active* variant, which a static swap-rule table cannot express.
    const Kind = enum(u8) { u32v = 0, u16v = 1 };
    const Tagged = extern struct {
        tag: Kind,
        payload: extern union {
            u32v: u32,
            u16v: u16,
        },
    };
    const TaggedSys = SystemDataTestDouble.create(struct {
        reading: Erd = SystemDataTestDouble.ramErd(Tagged, .{ .subs = 1, .erd_number = 0x3000 }),
    });
    const TaggedSD = TaggedSys.SystemData;
    const TaggedWire = WirePublisher(TaggedSD, &.{TaggedSD.erds.reading}, 1);

    resetLog();
    var sd = TaggedSys.init();
    var wire = TaggedWire.init();
    wire.postSystemDataInit(&sd);

    const local = struct {
        fn cb(_: ?*anyopaque, args: ?*const anyopaque, _: *anyopaque) void {
            const out: *const TaggedWire.OnChangeArgs = @ptrCast(@alignCast(args.?));
            if (event_count < max_events) {
                var ev: Event = .{ .erd_number = out.erd_number, .bytes = .{ 0, 0, 0, 0, 0, 0, 0, 0 }, .len = @intCast(out.be_bytes.len) };
                const n = @min(out.be_bytes.len, ev.bytes.len);
                @memcpy(ev.bytes[0..n], out.be_bytes[0..n]);
                event_log[event_count] = ev;
                event_count += 1;
            }
        }
    }.cb;
    wire.subscribe(null, local);

    sd.write(.reading, .{ .tag = .u32v, .payload = .{ .u32v = 0xAABBCCDD } });

    try std.testing.expectEqual(1, event_count);
    try std.testing.expectEqual(@as(u16, 0x3000), event_log[0].erd_number);
    // tag (u8) at offset 0 is unswapped; payload (u32) lives at offset 4
    // (extern union is 4-aligned) and must be reversed to big-endian.
    try std.testing.expectEqual(@as(u8, 0x00), event_log[0].bytes[0]);
    try std.testing.expectEqual(@as(u8, 0xAA), event_log[0].bytes[4]);
    try std.testing.expectEqual(@as(u8, 0xBB), event_log[0].bytes[5]);
    try std.testing.expectEqual(@as(u8, 0xCC), event_log[0].bytes[6]);
    try std.testing.expectEqual(@as(u8, 0xDD), event_log[0].bytes[7]);
}
