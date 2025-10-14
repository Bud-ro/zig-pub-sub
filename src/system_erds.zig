const std = @import("std");
const Erd = @import("erd.zig");
const TimerStats = @import("common/timer_stats.zig");

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
};

pub const ErdDefinitions = struct {
    // zig fmt: off
    erd_application_version:  Erd = .{ .erd_number = 0x0000, .T = u32,                         .owner = .Ram,      .subs = 0 },
    erd_some_bool:            Erd = .{ .erd_number = 0x0001, .T = bool,                        .owner = .Ram,      .subs = 3 },
    erd_unaligned_u16:        Erd = .{ .erd_number = 0x0002, .T = u16,                         .owner = .Ram,      .subs = 1 },
    erd_well_packed:          Erd = .{ .erd_number = 0x0003, .T = WellPackedStruct,            .owner = .Ram,      .subs = 0 },
    erd_padded:               Erd = .{ .erd_number = 0x0004, .T = PaddedStruct,                .owner = .Ram,      .subs = 0 },
    erd_actually_packed_fr:   Erd = .{ .erd_number = 0x0005, .T = PackedFr,                    .owner = .Ram,      .subs = 0 },
    erd_always_42:            Erd = .{ .erd_number = 0x0006, .T = u16,                         .owner = .Indirect, .subs = 0 },
    erd_pointer_to_something: Erd = .{ .erd_number = null,   .T = ?*u16,                       .owner = .Ram,      .subs = 0 },
    erd_another_erd_plus_one: Erd = .{ .erd_number = 0x0008, .T = u16,                         .owner = .Indirect, .subs = 0 },
    erd_cool_u16:             Erd = .{ .erd_number = null,   .T = u16,                         .owner = .Ram,      .subs = 1 },
    erd_best_u16:             Erd = .{ .erd_number = null,   .T = u16,                         .owner = .Ram,      .subs = 0 },
    erd_timer_stats:          Erd = .{ .erd_number = null,   .T = TimerStats.StatMeasurement,  .owner = .Ram,      .subs = 0 },
    // zig fmt: on

    pub fn jsonStringify(self: ErdDefinitions, jws: anytype) !void {
        const erd_names = comptime std.meta.fieldNames(ErdDefinitions);
        try jws.beginObject();
        {
            try jws.objectField("erd-json-version");
            try jws.write("0.1.0");
            try jws.objectField("namespace");
            try jws.write("zig-embedded-starter-kit");
            try jws.objectField("erds");
            {
                try jws.beginArray();
                inline for (erd_names) |erd_name| {
                    if (@field(self, erd_name).erd_number != null) {
                        try jws.write(@field(self, erd_name));
                    }
                }
                try jws.endArray();
            }
        }
        try jws.endObject();
    }
};

/// Erd Definitions with autofilled indexes
pub const erd = blk: {
    var _erds = ErdDefinitions{};

    var owning_counts = std.mem.zeroes([std.meta.fields(Erd.ErdOwner).len]u16);
    for (std.meta.fieldNames(ErdDefinitions)) |erd_field_name| {
        const idx = @intFromEnum(@field(_erds, erd_field_name).owner);
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

fn num_erds(owner: Erd.ErdOwner) comptime_int {
    var i = 0;
    for (std.meta.fieldNames(ErdDefinitions)) |erd_name| {
        if (@field(erd, erd_name).owner == owner) {
            i += 1;
        }
    }
    return i;
}

fn component_definitions(comptime owner: Erd.ErdOwner) [num_erds(owner)]Erd {
    var _erds: [num_erds(owner)]Erd = undefined;
    var i = 0;

    for (std.meta.fieldNames(ErdDefinitions)) |erd_name| {
        if (@field(erd, erd_name).owner == owner) {
            _erds[i] = @field(erd, erd_name);
            i += 1;
        }
    }

    return _erds;
}

// Array versions of ERDs. For easier iteration.
pub const ram_definitions = component_definitions(.Ram);
pub const indirect_definitions = component_definitions(.Indirect);

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
