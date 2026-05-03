//! Application-specific wiring
//! This file binds ERD definitions to concrete data component implementations
//! and provides the fully instantiated SystemData type for this application.

const erd_core = @import("erd_core");
const std = @import("std");
const system_erds = @import("system_erds.zig");

fn always42(data: *u16) void {
    data.* = 42;
}

fn plusOne(data: *u16) void {
    var should_be_42: u16 = undefined;
    always42(&should_be_42);

    data.* = should_be_42 + 1;
}

const IndirectMapping = erd_core.data_component.IndirectMapping;
const indirect_mappings = [_]IndirectMapping{
    .map(system_erds.erd.erd_always_42, always42),
    .map(system_erds.erd.erd_another_erd_plus_one, plusOne),
};

fn computeCoolPlusBest(result: *u16, ctx: *anyopaque) void {
    const sd: *SystemData = @ptrCast(@alignCast(ctx));
    result.* = sd.read(.erd_cool_u16) + sd.read(.erd_best_u16);
}

const ConvertedMapping = erd_core.data_component.ConvertedMapping;
const converted_mappings = [_]ConvertedMapping{
    .map(system_erds.erd.erd_cool_plus_best, computeCoolPlusBest, &.{
        system_erds.erd.erd_cool_u16,
        system_erds.erd.erd_best_u16,
    }),
};

/// Concrete RAM data component type for this application.
pub const RamDataComponent = erd_core.data_component.Ram(&system_erds.ram_definitions);
/// Concrete indirect data component type for this application.
pub const IndirectDataComponent = erd_core.data_component.Indirect(&system_erds.indirect_definitions, indirect_mappings);
/// Concrete converted data component type for this application.
pub const ConvertedDataComponent = erd_core.data_component.Converted(&system_erds.converted_definitions, converted_mappings);

/// Aggregate of all data components wired to SystemData.
pub const Components = struct {
    ram: RamDataComponent,
    indirect: IndirectDataComponent,
    converted: ConvertedDataComponent,

    comptime {
        const Id = system_erds.ComponentId;
        if (std.meta.fields(Components)[@intFromEnum(Id.ram)].type != RamDataComponent)
            @compileError("ComponentId.ram does not match RamDataComponent position in Components");
        if (std.meta.fields(Components)[@intFromEnum(Id.indirect)].type != IndirectDataComponent)
            @compileError("ComponentId.indirect does not match IndirectDataComponent position in Components");
        if (std.meta.fields(Components)[@intFromEnum(Id.converted)].type != ConvertedDataComponent)
            @compileError("ComponentId.converted does not match ConvertedDataComponent position in Components");
    }
};

/// Fully instantiated SystemData type for this application.
pub const SystemData = erd_core.SystemData(system_erds.ErdDefinitions, system_erds.ErdEnum, system_erds.erd, Components);

/// Top-level application state holding the SystemData instance.
pub const Application = struct {
    system_data: SystemData,
};

/// Initialize the application with all components and dependency subscriptions.
pub fn init() Application {
    var app = Application{ .system_data = SystemData.init(.{
        .ram = RamDataComponent.init(),
        .indirect = .{},
        .converted = .{},
    }) };
    app.system_data.components.converted.postSystemDataInit(&app.system_data);
    return app;
}
