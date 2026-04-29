//! Application-specific wiring
//! This file binds ERD definitions to concrete data component implementations
//! and provides the fully instantiated SystemData type for this application.

const std = @import("std");
const SystemErds = @import("system_erds.zig");
const ConvertedErdMapping = @import("converted_data_component.zig").ConvertedErdMapping;

pub const RamDataComponent = @import("ram_data_component.zig").RamDataComponent(&SystemErds.ram_definitions);
pub const IndirectDataComponent = @import("indirect_data_component.zig").IndirectDataComponent(&SystemErds.indirect_definitions);
pub const ConvertedDataComponent = @import("converted_data_component.zig").ConvertedDataComponent(&SystemErds.converted_definitions, converted_mappings);

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

fn compute_cool_plus_best(result: *u16, ctx: *anyopaque) void {
    const sd: *SystemData = @ptrCast(@alignCast(ctx));
    result.* = sd.read(.erd_cool_u16) + sd.read(.erd_best_u16);
}

const converted_mappings = [_]ConvertedErdMapping{
    .map(SystemErds.erd.erd_cool_plus_best, compute_cool_plus_best, &.{
        SystemErds.erd.erd_cool_u16,
        SystemErds.erd.erd_best_u16,
    }),
};

pub const Components = struct {
    ram: RamDataComponent,
    indirect: IndirectDataComponent,
    converted: ConvertedDataComponent,

    comptime {
        const Id = SystemErds.ComponentId;
        if (std.meta.fields(Components)[@intFromEnum(Id.ram)].type != RamDataComponent)
            @compileError("ComponentId.ram does not match RamDataComponent position in Components");
        if (std.meta.fields(Components)[@intFromEnum(Id.indirect)].type != IndirectDataComponent)
            @compileError("ComponentId.indirect does not match IndirectDataComponent position in Components");
        if (std.meta.fields(Components)[@intFromEnum(Id.converted)].type != ConvertedDataComponent)
            @compileError("ComponentId.converted does not match ConvertedDataComponent position in Components");
    }
};

pub const SystemData = @import("system_data.zig").SystemData(SystemErds.ErdDefinitions, SystemErds.ErdEnum, SystemErds.erd, Components);

pub const Application = struct {
    system_data: SystemData,
};

pub fn init() Application {
    var app = Application{ .system_data = SystemData.init(.{
        .ram = RamDataComponent.init(),
        .indirect = IndirectDataComponent.init(indirect_mappings),
        .converted = ConvertedDataComponent.init(),
    }) };
    app.system_data.components.converted.post_system_data_init(&app.system_data);
    return app;
}
