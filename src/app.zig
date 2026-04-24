//! Application-specific wiring
//! This file binds ERD definitions to concrete data component implementations
//! and provides the fully instantiated SystemData type for this application.

const SystemErds = @import("system_erds.zig");

pub const RamDataComponent = @import("ram_data_component.zig").RamDataComponent(&SystemErds.ram_definitions);
pub const IndirectDataComponent = @import("indirect_data_component.zig").IndirectDataComponent(&SystemErds.indirect_definitions);

pub const Components = struct {
    ram: RamDataComponent,
    indirect: IndirectDataComponent,
};

pub const SystemData = @import("system_data.zig").SystemData(SystemErds.ErdDefinitions, SystemErds.ErdEnum, SystemErds.erd, Components);

fn always_42(data: *u16) void {
    data.* = 42;
}

fn plus_one(data: *u16) void {
    var should_be_42: u16 = undefined;
    always_42(&should_be_42);

    data.* = should_be_42 + 1;
}

const indirect_mappings = [_]IndirectDataComponent.IndirectErdMapping{
    IndirectDataComponent.IndirectErdMapping.map(SystemErds.erd.erd_always_42, always_42),
    IndirectDataComponent.IndirectErdMapping.map(SystemErds.erd.erd_another_erd_plus_one, plus_one),
};

pub fn init() SystemData {
    var this = SystemData{};
    this.components.ram = RamDataComponent.init();
    this.components.indirect = IndirectDataComponent.init(indirect_mappings);
    this.scratch = .init(&this.scratch_buf);

    @memset(&this.subscriptions, .{ .context = null, .callback = null });
    return this;
}
