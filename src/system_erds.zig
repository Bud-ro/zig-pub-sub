const std = @import("std");
const Erd = @import("erd.zig");
const ErdOwner = Erd.ErdOwner;

pub const ErdDefinitions = struct {
    // zig fmt: off
    application_version:  Erd = .{ .erd_number = null,   .T = u32,              .owner = .Ram      },
    some_bool:            Erd = .{ .erd_number = null,   .T = bool,             .owner = .Ram      },
    unaligned_u16:        Erd = .{ .erd_number = null,   .T = u16,              .owner = .Ram      },
    well_packed:          Erd = .{ .erd_number = null,   .T = WellPackedStruct, .owner = .Ram      },
    padded:               Erd = .{ .erd_number = null,   .T = PaddedStruct,     .owner = .Ram      },
    actually_packed_fr:   Erd = .{ .erd_number = null,   .T = PackedFr,         .owner = .Ram      },
    always_42:            Erd = .{ .erd_number = null,   .T = u16,              .owner = .Indirect },
    another_erd_plus_one: Erd = .{ .erd_number = null,   .T = u16,              .owner = .Indirect },
    // zig fmt: on
};

/// Erd Definitions with autofilled indexes
pub const erd = blk: {
    var owning_counts = std.mem.zeroes([std.meta.fields(ErdOwner).len]u16);
    var _erds = ErdDefinitions{};
    for (std.meta.fieldNames(ErdDefinitions)) |erd_field_name| {
        const idx = @intFromEnum(@field(_erds, erd_field_name).owner);
        @field(_erds, erd_field_name).idx = owning_counts[idx];
        owning_counts[idx] += 1;
    }

    break :blk _erds;
};

fn num_ram_erds() comptime_int {
    var i = 0;
    for (std.meta.fieldNames(ErdDefinitions)) |erd_name| {
        if (@field(erd, erd_name).owner == .Ram) {
            i += 1;
        }
    }
    return i;
}

pub const ram_definitions: [num_ram_erds()]Erd = blk: {
    var _erds: [num_ram_erds()]Erd = undefined;
    var i = 0;

    for (std.meta.fieldNames(ErdDefinitions)) |erd_name| {
        if (@field(erd, erd_name).owner == .Ram) {
            _erds[i] = @field(erd, erd_name);
            i += 1;
        }
    }

    break :blk _erds;
};

fn num_indirect_erds() comptime_int {
    var i = 0;
    for (std.meta.fieldNames(ErdDefinitions)) |erd_name| {
        if (@field(erd, erd_name).owner == .Indirect) {
            i += 1;
        }
    }
    return i;
}

pub const indirect_definitions: [num_indirect_erds()]Erd = blk: {
    var _erds: [num_indirect_erds()]Erd = undefined;
    var i = 0;

    for (std.meta.fieldNames(ErdDefinitions)) |erd_name| {
        if (@field(erd, erd_name).owner == .Indirect) {
            _erds[i] = @field(erd, erd_name);
            i += 1;
        }
    }

    break :blk _erds;
};

const WellPackedStruct = struct {
    a: u8,
    b: u8,
    c: u16,
};

const PaddedStruct = struct {
    a: u8,
    b: u16,
    c: bool,
    d: u32,
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
