const erd_core = @import("erd_core");
const Erd = erd_core.Erd;
const TimerStats = erd_core.common.timer_stats;

/// Identifies which data component owns an ERD.
pub const ComponentId = enum(u8) {
    ram,
    indirect,
    converted,
};

const Ram = @intFromEnum(ComponentId.ram);
const Indirect = @intFromEnum(ComponentId.indirect);
const Converted = @intFromEnum(ComponentId.converted);

/// `ErdEnum` allows for use of decl literals which makes API use of ERDs *significantly* shorter.
/// Variants are listed out manually (rather than via `std.meta.FieldEnum(ErdDefinitions)`)
/// so LSP autocomplete works; ordering is checked against `ErdDefinitions` inside `SystemData`.
pub const ErdEnum = enum {
    erd_application_version,
    erd_some_bool,
    erd_unaligned_u16,
    erd_well_packed,
    erd_padded,
    erd_actually_packed_fr,
    erd_always_42,
    erd_pointer_to_something,
    erd_another_erd_plus_one,
    erd_cool_u16,
    erd_best_u16,
    erd_timer_stats,
    erd_cool_plus_best,
};

/// Struct of all ERD field definitions for this application.
pub const ErdDefinitions = struct {
    // zig fmt: off
    erd_application_version:  Erd = .{ .erd_number = 0x0000, .T = u32,                         .component_idx = Ram,      .subs = 0 },
    erd_some_bool:            Erd = .{ .erd_number = 0x0001, .T = bool,                        .component_idx = Ram,      .subs = 3 },
    erd_unaligned_u16:        Erd = .{ .erd_number = 0x0002, .T = u16,                         .component_idx = Ram,      .subs = 1 },
    erd_well_packed:          Erd = .{ .erd_number = null,   .T = WellPackedStruct,            .component_idx = Ram,      .subs = 0 },
    erd_padded:               Erd = .{ .erd_number = 0x0004, .T = PaddedStruct,                .component_idx = Ram,      .subs = 0 },
    erd_actually_packed_fr:   Erd = .{ .erd_number = 0x0005, .T = PackedFr,                    .component_idx = Ram,      .subs = 0 },
    erd_always_42:            Erd = .{ .erd_number = 0x0006, .T = u16,                         .component_idx = Indirect, .subs = 0 },
    erd_pointer_to_something: Erd = .{ .erd_number = null,   .T = ?*u16,                       .component_idx = Ram,      .subs = 0 },
    erd_another_erd_plus_one: Erd = .{ .erd_number = 0x0008, .T = u16,                         .component_idx = Indirect, .subs = 0 },
    erd_cool_u16:             Erd = .{ .erd_number = null,   .T = u16,                         .component_idx = Ram,      .subs = 2 },
    erd_best_u16:             Erd = .{ .erd_number = null,   .T = u16,                         .component_idx = Ram,      .subs = 1 },
    erd_timer_stats:          Erd = .{ .erd_number = null,   .T = TimerStats.StatMeasurement,  .component_idx = Ram,      .subs = 0 },
    erd_cool_plus_best:       Erd = .{ .erd_number = null,   .T = u16,                         .component_idx = Converted,.subs = 0 },
    // zig fmt: on
};

/// ERD definitions with `data_component_idx` and `system_data_idx` auto-assigned.
pub const erd = erd_core.erd_table.autofill(ErdDefinitions);

/// Count ERDs belonging to the given component.
pub fn numErds(comptime id: ComponentId) comptime_int {
    return erd_core.erd_table.numErdsByComponent(erd, @intFromEnum(id));
}

/// Extract ERD definitions for a specific component as an array.
pub fn componentDefinitions(comptime id: ComponentId) [numErds(id)]Erd {
    return erd_core.erd_table.collectByComponent(erd, @intFromEnum(id));
}

// Array versions of ERDs. For easier iteration.
/// All RAM component ERD definitions as an array.
pub const ram_definitions = componentDefinitions(.ram);
/// All indirect component ERD definitions as an array.
pub const indirect_definitions = componentDefinitions(.indirect);
/// All converted component ERD definitions as an array.
pub const converted_definitions = componentDefinitions(.converted);

/// Enum to Erd mapper
pub fn erdFromEnum(comptime erd_enum: ErdEnum) Erd {
    return @field(erd, @tagName(erd_enum));
}

const WellPackedStruct = struct {
    a: u8,
    b: u8,
    c: u16,
};

const PaddedStruct = extern struct {
    a: u8,
    b: u16,
    d: u32,
    c: bool,
};

const PackedFr = packed struct {
    a: u5,
    b: u5,
    c: u5,
    d: u5,
    e: u1,
    f: u1,
    g: u1,
};
