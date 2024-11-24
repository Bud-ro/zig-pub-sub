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
subscriptions: [std.meta.fields(SystemErds.ErdDefinitions).len]?*Subscription = undefined,

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

    @memset(&this.subscriptions, null);

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

    if (publish_required) {
        this.publish(erd);
    }
}

pub fn subscribe(this: *SystemData, erd: Erd, sub: *Subscription) void {
    comptime {
        // TODO: Consider how to not enumerate these to save `@sizeOf(?*Subscription) * num_unsubabble_erds` memory
        // It could be done by storing subscriptions local to data components, but this is not strictly required.
        std.debug.assert(erd.owner != .Indirect);
    }
    const sub_idx = erd.system_data_idx;

    if (this.subscriptions[sub_idx] == null) {
        this.subscriptions[sub_idx] = sub;
        return;
    }

    var next: ?*Subscription = this.subscriptions[sub_idx];
    while (next) |item| {
        if (item.next_sub == null) {
            item.next_sub = sub;
            return;
        }
        next = item.next_sub;
    }
}

pub fn unsubscribe(this: *SystemData, erd: Erd, sub: *Subscription) void {
    comptime {
        // Definitely a programmer error if you try to unsub (or sub!) to one of these.
        std.debug.assert(erd.owner != .Indirect);
    }

    const sub_idx = erd.system_data_idx;
    var prev_ptr: *?*Subscription = &this.subscriptions[sub_idx];
    var next: ?*Subscription = this.subscriptions[sub_idx];
    while (next) |item| {
        if (item == sub) {
            if (item.next_sub) |next_sub| {
                prev_ptr.* = next_sub;
            } else {
                prev_ptr.* = null;
            }
        }
        prev_ptr = &item.next_sub;
        next = item.next_sub;
    }
}

fn publish(this: *SystemData, erd: Erd) void {
    const sub_idx = erd.system_data_idx;

    var next: ?*Subscription = this.subscriptions[sub_idx];
    while (next) |item| {
        item.callback(this);
        next = item.next_sub;
    }
}
