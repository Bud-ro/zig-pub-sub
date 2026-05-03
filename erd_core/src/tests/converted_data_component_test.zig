const erd_core = @import("erd_core");
const std = @import("std");
const Erd = erd_core.Erd;
const RamDataComponent = erd_core.data_component.Ram;
const ConvertedDataComponentFn = erd_core.data_component.Converted;
const ConvertedMapping = erd_core.data_component.ConvertedMapping;
const SystemDataFn = erd_core.SystemData;

const ComponentId = enum(u8) { ram, converted };
const Ram = @intFromEnum(ComponentId.ram);
const Converted = @intFromEnum(ComponentId.converted);

const ErdDefs = struct {
    // zig fmt: off
    dep_a:   Erd = .{ .erd_number = null, .T = u16,  .component_idx = Ram,       .subs = 2 },
    dep_b:   Erd = .{ .erd_number = null, .T = u16,  .component_idx = Ram,       .subs = 1 },
    dep_c:   Erd = .{ .erd_number = null, .T = u16,  .component_idx = Ram,       .subs = 0 },
    sum_ab:  Erd = .{ .erd_number = null, .T = u16,  .component_idx = Converted, .subs = 1 },
    no_subs: Erd = .{ .erd_number = null, .T = u16,  .component_idx = Converted, .subs = 0 },
    // zig fmt: on
};

const erd_instance = blk: {
    var erds = ErdDefs{};
    const max_component = 1;
    var counts = [_]u16{0} ** (max_component + 1);
    for (std.meta.fieldNames(ErdDefs), 0..) |name, i| {
        const idx = @field(erds, name).component_idx;
        @field(erds, name).data_component_idx = counts[idx];
        counts[idx] += 1;
        @field(erds, name).system_data_idx = i;
    }
    break :blk erds;
};

const ErdEnum = std.meta.FieldEnum(ErdDefs);

fn collectComponentErds(component_idx: comptime_int) [countComponentErds(component_idx)]Erd {
    var result: [countComponentErds(component_idx)]Erd = undefined;
    var i: usize = 0;
    for (std.meta.fieldNames(ErdDefs)) |name| {
        if (@field(erd_instance, name).component_idx == component_idx) {
            result[i] = @field(erd_instance, name);
            i += 1;
        }
    }
    return result;
}

fn countComponentErds(component_idx: comptime_int) comptime_int {
    var count: comptime_int = 0;
    for (std.meta.fieldNames(ErdDefs)) |name| {
        if (@field(erd_instance, name).component_idx == component_idx) {
            count += 1;
        }
    }
    return count;
}

const ram_erds = collectComponentErds(Ram);
const converted_erds = collectComponentErds(Converted);

const RamComponent = RamDataComponent(&ram_erds);

fn computeSum(result: *u16, ctx: *anyopaque) void {
    const sd: *SystemData = @ptrCast(@alignCast(ctx));
    result.* = sd.read(.dep_a) + sd.read(.dep_b);
}

fn computeNoSubs(result: *u16, ctx: *anyopaque) void {
    const sd: *SystemData = @ptrCast(@alignCast(ctx));
    result.* = sd.read(.dep_a) * 2;
}

const converted_mappings = [_]ConvertedMapping{
    .map(erd_instance.sum_ab, computeSum, &.{
        erd_instance.dep_a,
        erd_instance.dep_b,
    }),
    .map(erd_instance.no_subs, computeNoSubs, &.{
        erd_instance.dep_a,
    }),
};

const ConvertedComponent = ConvertedDataComponentFn(&converted_erds, converted_mappings);

const Components = struct {
    ram: RamComponent,
    converted: ConvertedComponent,
};

const SystemData = SystemDataFn(ErdDefs, ErdEnum, erd_instance, Components);

fn setupSystem(sd: *SystemData) void {
    sd.* = SystemData.init(.{
        .ram = RamComponent.init(),
        .converted = .{},
    });
    sd.components.converted.postSystemDataInit(sd);
}

test "read always recomputes" {
    var sd: SystemData = undefined;
    setupSystem(&sd);

    try std.testing.expectEqual(0, sd.read(.sum_ab));

    sd.write(.dep_a, 10);
    sd.write(.dep_b, 20);
    try std.testing.expectEqual(30, sd.read(.sum_ab));

    sd.write(.dep_a, 5);
    try std.testing.expectEqual(25, sd.read(.sum_ab));
}

var subscriber_received_value: u16 = 0;
var subscriber_call_count: u32 = 0;

fn testSubscriber(_: ?*anyopaque, _args: ?*const anyopaque, _: *anyopaque) void {
    const args: *const SystemData.OnChangeArgs = @ptrCast(@alignCast(_args.?));
    const val: *const u16 = @ptrCast(@alignCast(args.data));
    subscriber_received_value = val.*;
    subscriber_call_count += 1;
}

test "dependency change publishes to converted ERD subscribers" {
    subscriber_received_value = 0;
    subscriber_call_count = 0;
    var sd: SystemData = undefined;
    setupSystem(&sd);

    sd.subscribe(.sum_ab, null, testSubscriber);

    sd.write(.dep_a, 10);
    try std.testing.expectEqual(10, subscriber_received_value);
    try std.testing.expectEqual(1, subscriber_call_count);

    sd.write(.dep_b, 5);
    try std.testing.expectEqual(15, subscriber_received_value);
    try std.testing.expectEqual(2, subscriber_call_count);
}

test "same value write does not trigger converted publish" {
    subscriber_call_count = 0;
    var sd: SystemData = undefined;
    setupSystem(&sd);

    sd.subscribe(.sum_ab, null, testSubscriber);

    sd.write(.dep_a, 0);
    try std.testing.expectEqual(0, subscriber_call_count);
}

test "unsubscribe from converted ERD" {
    subscriber_call_count = 0;
    var sd: SystemData = undefined;
    setupSystem(&sd);

    sd.subscribe(.sum_ab, null, testSubscriber);
    sd.write(.dep_a, 1);
    try std.testing.expectEqual(1, subscriber_call_count);

    sd.unsubscribe(.sum_ab, testSubscriber);
    sd.write(.dep_a, 2);
    try std.testing.expectEqual(1, subscriber_call_count);
}

test "converted ERD with no subscribers still computes on read" {
    var sd: SystemData = undefined;
    setupSystem(&sd);

    sd.write(.dep_a, 7);
    try std.testing.expectEqual(14, sd.read(.no_subs));
}

var cascaded_value: u16 = 0;

fn cascadeSubscriber(_: ?*anyopaque, _args: ?*const anyopaque, publisher: *anyopaque) void {
    const args: *const SystemData.OnChangeArgs = @ptrCast(@alignCast(_args.?));
    const val: *const u16 = @ptrCast(@alignCast(args.data));
    var sd: *SystemData = @ptrCast(@alignCast(publisher));

    cascaded_value = val.*;
    sd.write(.dep_c, val.*);
}

test "converted subscriber can write other ERDs" {
    cascaded_value = 0;
    var sd: SystemData = undefined;
    setupSystem(&sd);

    sd.subscribe(.sum_ab, null, cascadeSubscriber);

    sd.write(.dep_a, 3);
    sd.write(.dep_b, 4);
    try std.testing.expectEqual(7, cascaded_value);
    try std.testing.expectEqual(7, sd.read(.dep_c));
}
