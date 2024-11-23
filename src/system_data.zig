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
subscriptions: [std.meta.fields(SystemErds.ErdDefinitions).len]Subscription = undefined,

fn dummy_sub_callback(system_data: *SystemData) void {
    _ = system_data;
    unreachable;
}

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

    @memset(&this.subscriptions, Subscription{ .callback = dummy_sub_callback, .next_sub = null });
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
    const sub_idx = erd.system_data_idx;

    var last_valid_item = &this.subscriptions[sub_idx];
    var next = this.subscriptions[sub_idx].next_sub;
    while (next) |item| {
        last_valid_item = item;
        next = item.next_sub;
    }
    last_valid_item.next_sub = sub;
}

fn publish(this: *SystemData, erd: Erd) void {
    const sub_idx = erd.system_data_idx;

    var next = this.subscriptions[sub_idx].next_sub;
    // Purposely skip the head of the list, since that will always be the dummy sub.
    // TODO: Make a proper linked list head so that we don't waste `num_erds * @sizeOf(callback)` on holding callbacks
    while (next) |item| {
        item.callback(this);
        next = item.next_sub;
    }
}
