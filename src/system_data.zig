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

ram: RamDataComponent = undefined,
indirect: IndirectDataComponent = undefined,
subscriptions: [subscription_count()]Subscription = undefined,
/// This is a bump allocator meant to be reset at the end of a run to complete
scratch: std.heap.FixedBufferAllocator = undefined,
scratch_buf: [2048]u8 align(@alignOf(usize)) = undefined, // TODO: Does this actually need to be aligned?

fn subscription_count() usize {
    comptime {
        var size: usize = 0;
        for (std.meta.fieldNames(SystemErds.ErdDefinitions)) |erd_field_name| {
            size += @field(SystemErds.erd, erd_field_name).subs;
        }
        return size;
    }
}
const subscription_offsets = blk: {
    var _offsets: [std.meta.fields(SystemErds.ErdDefinitions).len]usize = undefined;
    var cur_offset = 0;

    for (std.meta.fieldNames(SystemErds.ErdDefinitions), 0..) |erd_field_name, i| {
        if (@field(SystemErds.erd, erd_field_name).subs == 0) {
            _offsets[i] = 0xffff;
        } else {
            _offsets[i] = cur_offset;
        }
        cur_offset += @field(SystemErds.erd, erd_field_name).subs;
    }
    break :blk _offsets;
};

fn always_42() u16 {
    return 42;
}

fn plus_one() u16 {
    return always_42() + 1;
}

const indirectErdMapping = [_]IndirectDataComponent.IndirectErdMapping{
    IndirectDataComponent.IndirectErdMapping.map(SystemErds.erd.always_42, always_42),
    IndirectDataComponent.IndirectErdMapping.map(SystemErds.erd.another_erd_plus_one, plus_one),
};

pub fn init() SystemData {
    var this = SystemData{};
    this.ram = RamDataComponent.init();
    this.indirect = IndirectDataComponent.init(indirectErdMapping);
    this.scratch = std.heap.FixedBufferAllocator.init(&this.scratch_buf);

    @memset(&this.subscriptions, Subscription{ .callback = null });
    return this;
}

pub fn read(this: SystemData, erd: Erd) erd.T {
    switch (erd.owner) {
        .Ram => return this.ram.read(erd),
        .Indirect => return this.indirect.read(erd),
    }
}

pub fn write(this: *SystemData, erd: Erd, data: erd.T) void {
    const publish_required = switch (erd.owner) {
        .Ram => this.ram.write(erd, data),
        .Indirect => comptime unreachable,
    };

    if (publish_required and erd.subs != 0) {
        this.publish(erd);
    }
}

pub fn subscribe(this: *SystemData, erd: Erd, fn_ptr: Subscription.SubscriptionCallback) void {
    comptime {
        std.debug.assert(erd.subs > 0);

        std.debug.assert(erd.owner != .Indirect);
    }
    const sub_offset = subscription_offsets[erd.system_data_idx];

    for (this.subscriptions[sub_offset .. sub_offset + erd.subs]) |_sub| {
        // Subscriptions cannot be added to the same list twice
        std.debug.assert(_sub.callback != fn_ptr);
    }

    for (this.subscriptions[sub_offset .. sub_offset + erd.subs]) |*_sub| {
        if (_sub.*.callback == null) {
            _sub.*.callback = fn_ptr;
            return;
        }
    }

    // In tests this verifies we aren't subscribing beyond our array length
    // These names should be stripped out of the binary
    const erd_names = comptime std.meta.fieldNames(SystemErds.ErdDefinitions);
    std.debug.panic("ERD {s} oversubscribed!", .{erd_names[erd.system_data_idx]});
}

pub fn unsubscribe(this: *SystemData, erd: Erd, fn_ptr: Subscription.SubscriptionCallback) void {
    comptime {
        std.debug.assert(erd.subs > 0);

        // Definitely a programmer error if you try to unsub (or sub!) to one of these.
        std.debug.assert(erd.owner != .Indirect);
    }

    const sub_offset = subscription_offsets[erd.system_data_idx];

    for (this.subscriptions[sub_offset .. sub_offset + erd.subs]) |*_sub| {
        if (_sub.*.callback == fn_ptr) {
            _sub.*.callback = null;
            return;
        }
    }
}

fn publish(this: *SystemData, erd: Erd) void {
    const sub_offset = subscription_offsets[erd.system_data_idx];

    for (this.subscriptions[sub_offset .. sub_offset + erd.subs]) |_sub| {
        if (_sub.callback) |_callback| {
            _callback(this);
        }
    }
}

/// Returns a slice allocated to the scratch buffer.
/// You must not assume that the data you receive back is zero initialized.
pub fn scratch_alloc(this: *SystemData, comptime T: type, n: usize) []T {
    // Use threadSafeAllocator until it is known how this interacts with
    // interrupts. In all likelyhood we will never want to free or resize anyways,
    // so it's fine to use this.
    //
    // catch unreachable because we'll assume that a single RTC + interrupts can never overflow this
    // TODO: Is there something better that can be done here?
    // TODO: Consider if this can somehow be used for RX/TX buffers???
    // Or do those need to last more than one RTC? If so, is there an alternate strategy that can be employed?
    return this.scratch.threadSafeAllocator().alloc(T, n) catch unreachable;
}

/// Call this at the end of a run to complete in your main-loop
pub fn scratch_reset(this: *SystemData) void {
    // TODO: Should this also zero out the buffer just to prevent any misuse?
    return this.scratch.reset();
}

/// A test only function used to verify that after initialization, all of your subscriptions arrays are fully saturated
pub fn verify_all_subs_are_saturated(this: *SystemData) !void {
    inline for (std.meta.fields(SystemErds.ErdDefinitions), 0..) |field_info, i| {
        const erd_field_name = field_info.name;
        const sub_offset = subscription_offsets[i];
        if (sub_offset == 0xffff) {
            continue;
        }

        for (this.subscriptions[sub_offset .. sub_offset + @field(SystemErds.erd, erd_field_name).subs]) |_sub| {
            if (_sub.callback == null) {
                std.debug.panic("ERD: {s} has not fully filled its subscription buffer after init!", .{erd_field_name});
            }
        }
    }
}
