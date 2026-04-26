//! Application-specific wiring
//! This file binds ERD definitions to concrete data component implementations
//! and provides the fully instantiated SystemData type for this application.

const std = @import("std");
const SystemErds = @import("system_erds.zig");

pub const RamDataComponent = @import("ram_data_component.zig").RamDataComponent(&SystemErds.ram_definitions);
pub const IndirectDataComponent = @import("indirect_data_component.zig").IndirectDataComponent(&SystemErds.indirect_definitions);

pub const Components = struct {
    ram: RamDataComponent,
    indirect: IndirectDataComponent,

    comptime {
        const Id = SystemErds.ComponentId;
        if (std.meta.fields(Components)[@intFromEnum(Id.ram)].type != RamDataComponent)
            @compileError("ComponentId.ram does not match RamDataComponent position in Components");
        if (std.meta.fields(Components)[@intFromEnum(Id.indirect)].type != IndirectDataComponent)
            @compileError("ComponentId.indirect does not match IndirectDataComponent position in Components");
    }
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
    .map(SystemErds.erd.erd_always_42, always_42),
    .map(SystemErds.erd.erd_another_erd_plus_one, plus_one),
};

pub const Application = struct {
    system_data: SystemData,
};

pub fn init() Application {
    return .{ .system_data = SystemData.init(.{
        .ram = RamDataComponent.init(),
        .indirect = IndirectDataComponent.init(indirect_mappings),
    }) };
}
