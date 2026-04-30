const std = @import("std");
const erd_core = @import("erd_core");
const Erd = erd_core.Erd;
const TimerStats = erd_core.common.timer_stats;

pub const ComponentId = enum(u8) {
    ram,
    indirect,
    converted,
};

const Ram = @intFromEnum(ComponentId.ram);
const Indirect = @intFromEnum(ComponentId.indirect);
const Converted = @intFromEnum(ComponentId.converted);

/// `ErdEnum` allows for use of decl literals which makes API use of ERDs *significantly* shorter
pub const ErdEnum = enum {
    // This must match one to one with ErdDefinitions
    //
    // `std.meta.FieldEnum(ErdDefinitions)` would get rid of the duplication,
    // but probably shouldn't be used until the LSP support would allow auto-complete
    //
    // for the meantime let's just throw a compile error if it fails to match
    comptime {
        const erd_fields = std.meta.fieldNames(ErdDefinitions);
        const erd_enum_names = std.meta.fieldNames(ErdEnum);
        for (erd_fields, erd_enum_names) |field_name, enum_name| {
            if (!std.mem.eql(u8, field_name, enum_name)) {
                @compileError(std.fmt.comptimePrint("Field {s} does not match enum {s}", .{ field_name, enum_name }));
            }
        }
    }

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

pub const ErdDefinitions = struct {
    // zig fmt: off
    erd_application_version:  Erd = .{ .erd_number = 0x0000, .T = u32,                         .component_idx = Ram,      .subs = 0 },
    erd_some_bool:            Erd = .{ .erd_number = 0x0001, .T = bool,                        .component_idx = Ram,      .subs = 3 },
    erd_unaligned_u16:        Erd = .{ .erd_number = 0x0002, .T = u16,                         .component_idx = Ram,      .subs = 1 },
    erd_well_packed:          Erd = .{ .erd_number = 0x0003, .T = WellPackedStruct,            .component_idx = Ram,      .subs = 0 },
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

/// Erd Definitions with autofilled indexes
pub const erd = blk: {
    var _erds = ErdDefinitions{};

    var max_component_idx: comptime_int = 0;
    for (std.meta.fieldNames(ErdDefinitions)) |erd_field_name| {
        const idx = @field(_erds, erd_field_name).component_idx;
        if (idx > max_component_idx) max_component_idx = idx;
    }

    var owning_counts = std.mem.zeroes([max_component_idx + 1]u16);
    for (std.meta.fieldNames(ErdDefinitions)) |erd_field_name| {
        const idx = @field(_erds, erd_field_name).component_idx;
        @field(_erds, erd_field_name).data_component_idx = owning_counts[idx];
        owning_counts[idx] += 1;
    }

    // Assert because prints below assume this ERD size
    std.debug.assert(0xffff == std.math.maxInt(Erd.ErdHandle));
    var set = std.bit_set.ArrayBitSet(usize, std.math.maxInt(Erd.ErdHandle)).initEmpty();

    for (std.meta.fieldNames(ErdDefinitions), 0..) |erd_field_name, i| {
        @field(_erds, erd_field_name).system_data_idx = i;

        if (@field(_erds, erd_field_name).erd_number) |num| {
            if (set.isSet(num)) {
                @compileError(std.fmt.comptimePrint("Multiple ERD definitions with number 0x{x:0>4}", .{num}));
            } else {
                set.set(num);
            }
        }
    }

    break :blk _erds;
};

pub fn num_erds(comptime id: ComponentId) comptime_int {
    const component_idx = @intFromEnum(id);
    var i = 0;
    for (std.meta.fieldNames(ErdDefinitions)) |erd_name| {
        if (@field(erd, erd_name).component_idx == component_idx) {
            i += 1;
        }
    }
    return i;
}

pub fn component_definitions(comptime id: ComponentId) [num_erds(id)]Erd {
    const component_idx = @intFromEnum(id);
    var _erds: [num_erds(id)]Erd = undefined;
    var i = 0;

    for (std.meta.fieldNames(ErdDefinitions)) |erd_name| {
        if (@field(erd, erd_name).component_idx == component_idx) {
            _erds[i] = @field(erd, erd_name);
            i += 1;
        }
    }

    return _erds;
}

// Array versions of ERDs. For easier iteration.
pub const ram_definitions = component_definitions(.ram);
pub const indirect_definitions = component_definitions(.indirect);
pub const converted_definitions = component_definitions(.converted);

/// Enum to Erd mapper
pub fn erd_from_enum(comptime erd_enum: ErdEnum) Erd {
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
