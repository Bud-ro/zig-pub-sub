//! Top level system data
//! This is a zero-cost wrapper around multiple data components
//! It binds ERDs of multiple data components into one name space, and initializes them
//! It is meant to be the top level component that you pass around your application.
//! It is intended to pass by value NOT by reference since most of it will fall away at
//! comptime and you want to ensure direct accesses to underlying function calls

const std = @import("std");
const Erd = @import("erd.zig");
const RamDataComponent = @import("ram_data_component.zig");
const IndirectDataComponent = @import("indirect_data_component.zig");
const SystemErds = @import("system_erds.zig");
const Subscription = @import("subscription.zig");

const SystemData = @This();

// TODO: Add args to subscriptions once comptime/runtime ERDs sorted out
// pub const SystemDataOnChangeArgs = struct {
//     system_data_idx: u16,
//     data: *const anyopaque,
// };

ram: RamDataComponent = undefined,
indirect: IndirectDataComponent = undefined,
subscriptions: [total_subscriptions()]Subscription = undefined,
/// This is a bump allocator meant to be reset at the end of a run to complete
scratch: std.heap.FixedBufferAllocator = undefined,
scratch_buf: [2048]u8 align(@alignOf(usize)) = undefined, // TODO: Does this actually need to be aligned?

fn total_subscriptions() usize {
    comptime {
        var size: usize = 0;
        for (std.meta.fieldNames(SystemErds.ErdDefinitions)) |erd_field_name| {
            size += @field(SystemErds.erd, erd_field_name).subs;
        }
        return size;
    }
}

const SystemErdsLength: usize = std.meta.fields(SystemErds.ErdDefinitions).len;

const subscription_offsets = blk: {
    var _offsets: [SystemErdsLength]usize = undefined;
    var cur_offset = 0;

    for (std.meta.fieldNames(SystemErds.ErdDefinitions), 0..) |erd_field_name, i| {
        if (@field(SystemErds.erd, erd_field_name).subs != 0) {
            _offsets[i] = cur_offset;
        }
        cur_offset += @field(SystemErds.erd, erd_field_name).subs;
    }
    break :blk _offsets;
};

/// Returns a column from system_erds as an array
fn system_erds_collect(T: type, name: []const u8) [SystemErdsLength]T {
    var field_values: [SystemErdsLength]T = undefined;
    for (std.meta.fieldNames(SystemErds.ErdDefinitions), 0..) |erd_field_name, i| {
        field_values[i] = @field(@field(SystemErds.erd, erd_field_name), name);
    }

    return field_values;
}

const subscription_count = system_erds_collect(u8, "subs");
const owner_from_idx = system_erds_collect(Erd.ErdOwner, "owner");
const data_component_idx_from_idx = system_erds_collect(u16, "data_component_idx");

fn always_42(data: *u16) void {
    data.* = 42;
}

fn plus_one(data: *u16) void {
    var should_be_42: u16 = undefined;
    always_42(&should_be_42);

    data.* = should_be_42 + 1;
}

const indirectErdMapping = [_]IndirectDataComponent.IndirectErdMapping{
    .map(.erd_always_42, always_42),
    .map(.erd_another_erd_plus_one, plus_one),
};

pub fn init() SystemData {
    var this = SystemData{};
    this.ram = .init();
    this.indirect = .init(indirectErdMapping);
    this.scratch = .init(&this.scratch_buf);

    @memset(&this.subscriptions, Subscription{ .context = null, .callback = null });
    return this;
}

/// Read an ERD by-value using comptime information (the `Erd` type)
/// Due to the performance and code size benefits, this should be preferred over `runtime_read`.
pub fn read(this: SystemData, comptime erd_enum: SystemErds.ErdEnum) SystemErds.erd_from_enum(erd_enum).T {
    const erd: Erd = SystemErds.erd_from_enum(erd_enum);
    switch (erd.owner) {
        .Ram => return this.ram.read(erd),
        .Indirect => return this.indirect.read(erd),
    }
}

/// Read an ERD into the provided `data` pointer, using the ERD's corresponding system_data_idx
/// This will be significantly slower than a comptime read, and should only be used sparingly, for example:
/// - When mapping from an `ErdHandle` to system_data_idx, eg. in response to UART commands
/// - Reading an ERD using info from an on-change callback
pub fn runtime_read(this: SystemData, system_data_idx: u16, data: *anyopaque) void {
    const owner: Erd.ErdOwner = owner_from_idx[system_data_idx];
    const data_component_idx: u16 = data_component_idx_from_idx[system_data_idx];

    switch (owner) {
        .Ram => this.ram.runtime_read(data_component_idx, data),
        .Indirect => this.indirect.runtime_read(data_component_idx, data),
    }
}

/// Write to an ERD by-value using comptime information (the `Erd` type)
/// Due to the performance and code size benefits, this should be preferred over `runtime_write`.
pub fn write(this: *SystemData, comptime erd_enum: SystemErds.ErdEnum, data: SystemErds.erd_from_enum(erd_enum).T) void {
    const erd: Erd = SystemErds.erd_from_enum(erd_enum);
    const publish_required = switch (erd.owner) {
        .Ram => this.ram.write(erd, data),
        .Indirect => comptime unreachable,
    };

    if (publish_required and erd.subs != 0) {
        this.publish(erd.system_data_idx, &data);
    }
}

/// Write to an ERD from the provided `data` pointer, using the ERD's corresponding system_data_idx
/// This will be significantly slower than a comptime write, and should only be used sparingly, for example:
/// - When mapping from an `ErdHandle` to system_data_idx, eg. in response to UART commands
/// - Writing an ERD using info from an on-change callback (common for ERD multiplexers)
///
/// NOTE: `data` must be aligned!
pub fn runtime_write(this: *SystemData, system_data_idx: u16, data: *const anyopaque) void {
    const publish_required = switch (owner_from_idx[system_data_idx]) {
        .Ram => this.ram.runtime_write(data_component_idx_from_idx[system_data_idx], data),
        .Indirect => comptime unreachable,
    };

    if (publish_required and subscription_count[system_data_idx] != 0) {
        this.publish(system_data_idx, data);
    }
}

fn publish(this: *SystemData, system_data_idx: u16, data: *const anyopaque) void {
    // TODO: Add a "publish depth" counter, which can be used to implement a global subscription
    //       that is only published to when a normal publish finishes and it wasn't triggered by another publish
    // this.publish_depth += 1;

    const sub_offset = subscription_offsets[system_data_idx];

    for (this.subscriptions[sub_offset .. sub_offset + subscription_count[system_data_idx]]) |_sub| {
        if (_sub.callback) |_callback| {
            _callback(_sub.context, data, this);
        }
    }

    // this.publish_depth -= 1;
    // if (this.publish_depth == 0) {
    //     this.publish_patient_subscriptions();
    // }
}

pub fn subscribe(
    this: *SystemData,
    comptime erd_enum: SystemErds.ErdEnum,
    context: ?*anyopaque,
    fn_ptr: Subscription.SubscriptionCallback,
) void {
    const erd: Erd = SystemErds.erd_from_enum(erd_enum);
    comptime {
        std.debug.assert(erd.subs > 0);
        std.debug.assert(erd.owner != .Indirect);
    }
    const sub_offset = subscription_offsets[erd.system_data_idx];

    for (this.subscriptions[sub_offset .. sub_offset + erd.subs]) |*_sub| {
        // Subscriptions cannot be added to the same list twice
        std.debug.assert(_sub.callback != fn_ptr);

        if (_sub.callback == null) {
            _sub.context = context;
            _sub.callback = fn_ptr;
            return;
        }
    }

    // In tests this verifies we aren't subscribing beyond our array length
    // These names should be stripped out of the binary if a panic handler isn't set.
    // TODO: Validate this assumption and switch to using something lighter if needed
    const erd_names = comptime std.meta.fieldNames(SystemErds.ErdDefinitions);
    std.debug.panic("ERD {s} oversubscribed!", .{erd_names[erd.system_data_idx]});
}

pub fn unsubscribe(this: *SystemData, comptime erd_enum: SystemErds.ErdEnum, fn_ptr: Subscription.SubscriptionCallback) void {
    const erd: Erd = SystemErds.erd_from_enum(erd_enum);
    comptime {
        std.debug.assert(erd.subs > 0);
        // We know you can't sub/unsub to these:
        std.debug.assert(erd.owner != .Indirect);
    }

    const sub_offset = subscription_offsets[erd.system_data_idx];

    for (this.subscriptions[sub_offset .. sub_offset + erd.subs]) |*_sub| {
        if (_sub.callback == fn_ptr) {
            _sub.callback = null;
            return;
        }
    }
}

/// Returns a slice allocated to the scratch buffer.
pub fn scratch_alloc(this: *SystemData, comptime T: type, n: usize) []T {
    // TODO: Consider if this can somehow be used for RX/TX buffers???
    // Or do those need to last more than one RTC? If so, is there an alternate strategy that can be employed?
    return this.scratch.allocator().alloc(T, n) catch @panic("We ran out of scratch memory!!!");
}

/// Call this at the end of a run to complete in your main-loop
pub fn scratch_reset(this: *SystemData) void {
    this.scratch.reset();
}

/// A test only function used to verify that after initialization, all of your subscriptions arrays are fully saturated
pub fn verify_all_subs_are_saturated(this: *SystemData) !void {
    inline for (std.meta.fields(SystemErds.ErdDefinitions), 0..) |field_info, i| {
        const erd_field_name = field_info.name;
        const sub_offset = subscription_offsets[i];
        const num_subs = @field(SystemErds.erd, erd_field_name).subs;
        if (num_subs == 0) {
            continue;
        }

        for (this.subscriptions[sub_offset .. sub_offset + num_subs]) |_sub| {
            if (_sub.callback == null) {
                std.debug.panic("ERD: {s} has not fully filled its subscription buffer after init!", .{erd_field_name});
            }
        }
    }
}
