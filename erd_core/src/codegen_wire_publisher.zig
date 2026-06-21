//! WirePublisher codegen inspection harness
//!
//! Exercises `erd_schema.WirePublisher` across a varied `SystemData` (RAM +
//! Indirect + Converted data components, scalar / struct / tagged-union ERD
//! types) and several publisher instantiations. Build as an object and inspect
//! the generated assembly to verify the republish path stays cheap:
//!   - The shared `handler` does one index dispatch + memcpy + swap + publish
//!   - No-swap byte ERDs (u8, all-byte structs) skip the swap entirely
//!   - Each instantiation shares a single handler/publishWire/binarySearch
//!     rather than monomorphizing per watched ERD
//!
//! This file lives under `erd_core/src` alongside the other codegen harnesses,
//! but it `@import("erd_schema")` because WirePublisher lives there. It is only
//! ever compiled by `build_codegen.zig` (never by erd_core's own build/test),
//! which supplies the `erd_schema` module from the sibling package.
//!
//! Snapshotted via `zig build codegen-update`; verified via `codegen-check`.

const std = @import("std");
const erd_core = @import("erd_core");
const erd_schema = @import("erd_schema");
const Erd = erd_core.Erd;
const WirePublisher = erd_schema.WirePublisher;
const SwapRules = erd_schema.SwapRules;
const Subscription = erd_core.Subscription;
const IndirectMapping = erd_core.data_component.IndirectMapping;
const ConvertedMapping = erd_core.data_component.ConvertedMapping;

// ---------------------------------------------------------------------------
// Varied ERD value types
// ---------------------------------------------------------------------------

/// Multi-field extern struct: exercises per-field swap rule generation.
const Sample = extern struct { a: u32, b: u16, c: u8 };

/// All-byte extern struct: applyToBig is a no-op (swap can be skipped).
const Bytes4 = extern struct { a: u8, b: u8, c: u8, d: u8 };

/// Tagged-union pattern recognized by erd_swap: the active payload variant
/// must be byte-swapped based on the runtime tag, which a flat rule table
/// cannot express.
const Kind = enum(u8) { u32v = 0, u16v = 1 };
const Reading = extern struct {
    tag: Kind,
    payload: extern union {
        u32v: u32,
        u16v: u16,
    },
};

// ---------------------------------------------------------------------------
// System W: a varied multi-component telemetry SystemData
//   - RAM ERDs of every interesting shape (scalars, struct, tagged union)
//   - one Indirect (read-only, unwatchable) ERD
//   - one Converted ERD derived from RAM, watched by the publisher
// ---------------------------------------------------------------------------
const Ram = 0;
const Indirect = 1;
const Converted = 2;

const WireDefs = struct {
    // zig fmt: off
    // RAM, watched (erd_number set, subs > 0)
    temperature: Erd = .{ .erd_number = 0x1000, .T = u16,     .component_idx = Ram,       .subs = 1 },
    pressure:    Erd = .{ .erd_number = 0x1001, .T = u32,     .component_idx = Ram,       .subs = 1 },
    uptime:      Erd = .{ .erd_number = 0x1002, .T = u64,     .component_idx = Ram,       .subs = 1 },
    flags:       Erd = .{ .erd_number = 0x1003, .T = u8,      .component_idx = Ram,       .subs = 1 },
    sample:      Erd = .{ .erd_number = 0x1004, .T = Sample,  .component_idx = Ram,       .subs = 1 },
    reading:     Erd = .{ .erd_number = 0x1005, .T = Reading, .component_idx = Ram,       .subs = 1 },
    raw_bytes:   Erd = .{ .erd_number = 0x1006, .T = Bytes4,  .component_idx = Ram,       .subs = 1 },
    // RAM, not watched (private working state)
    raw_a:       Erd = .{ .erd_number = null,   .T = u32,     .component_idx = Ram,       .subs = 1 },
    raw_b:       Erd = .{ .erd_number = null,   .T = u16,     .component_idx = Ram,       .subs = 0 },
    // Indirect: read-only computed, no subs (cannot be watched)
    ind_build:   Erd = .{ .erd_number = 0x2000, .T = u32,     .component_idx = Indirect,  .subs = 0 },
    // Converted: derived from RAM, watched
    conv_sum:    Erd = .{ .erd_number = 0x3000, .T = u32,     .component_idx = Converted, .subs = 1 },
    // zig fmt: on
};

const wire_erd = erd_core.erd_table.autofill(WireDefs);
const WireEnum = std.meta.FieldEnum(WireDefs);

const wire_ram_erds = erd_core.erd_table.collectByComponent(wire_erd, Ram);
const wire_ind_erds = erd_core.erd_table.collectByComponent(wire_erd, Indirect);
const wire_conv_erds = erd_core.erd_table.collectByComponent(wire_erd, Converted);

fn indBuildFn(data: *u32) void {
    data.* = 0xC0DE;
}

const wire_ind_mappings = [_]IndirectMapping{
    .map(wire_erd.ind_build, indBuildFn),
};

fn convSumFn(result: *u32, ctx: *anyopaque) void {
    const sd: *WireSD = @ptrCast(@alignCast(ctx));
    result.* = sd.read(.raw_a) +% @as(u32, sd.read(.temperature));
}

const wire_conv_mappings = [_]ConvertedMapping{
    .map(wire_erd.conv_sum, convSumFn, &.{ wire_erd.raw_a, wire_erd.temperature }),
};

const WireRam = erd_core.data_component.Ram(&wire_ram_erds);
const WireInd = erd_core.data_component.Indirect(&wire_ind_erds, wire_ind_mappings);
const WireConv = erd_core.data_component.Converted(&wire_conv_erds, wire_conv_mappings);

const WireComponents = struct {
    ram: WireRam,
    indirect: WireInd,
    converted: WireConv,
};

const WireSD = erd_core.SystemData(WireDefs, WireEnum, wire_erd, WireComponents);

comptime {
    std.debug.assert(Ram == std.meta.fieldIndex(WireComponents, "ram").?);
    std.debug.assert(Indirect == std.meta.fieldIndex(WireComponents, "indirect").?);
    std.debug.assert(Converted == std.meta.fieldIndex(WireComponents, "converted").?);
}

// ---------------------------------------------------------------------------
// Publisher instantiations
// ---------------------------------------------------------------------------

/// Watch one ERD of each interesting shape across two data components. This is
/// the "wide dispatch" case: 8 descriptors, swap rules for scalars, a struct,
/// and a tagged union, plus a converted ERD.
fn wideWatched() [8]Erd {
    const e = WireSD.erds;
    return .{ e.temperature, e.pressure, e.uptime, e.flags, e.sample, e.reading, e.raw_bytes, e.conv_sum };
}
const WireWide = WirePublisher(WireSD, &wideWatched(), 3);

/// Watch a single ERD: the degenerate dispatch (binary search over one entry).
const WireSingle = WirePublisher(WireSD, &.{WireSD.erds.temperature}, 1);

/// Watch two ERDs where one needs no byte swap (u8 flags) and one does (u32
/// pressure): exercises the mixed swap/no-swap dispatch.
fn pairWatched() [2]Erd {
    const e = WireSD.erds;
    return .{ e.flags, e.pressure };
}
const WirePair = WirePublisher(WireSD, &pairWatched(), 2);

// ===========================================================================
// Setup: init / postSystemDataInit / subscribe / unsubscribe
// ===========================================================================

export fn wire_wide_init(out: *WireWide) void {
    out.* = WireWide.init();
}

export fn wire_wide_post_init(wire: *WireWide, sd: *WireSD) void {
    wire.postSystemDataInit(sd);
}

fn downstreamCb(_: ?*anyopaque, _: ?*const anyopaque, _: *anyopaque) void {}

export fn wire_wide_subscribe(wire: *WireWide) void {
    wire.subscribe(null, downstreamCb);
}

export fn wire_wide_unsubscribe(wire: *WireWide) void {
    wire.unsubscribe(downstreamCb);
}

export fn wire_single_post_init(wire: *WireSingle, sd: *WireSD) void {
    wire.postSystemDataInit(sd);
}

export fn wire_pair_post_init(wire: *WirePair, sd: *WireSD) void {
    wire.postSystemDataInit(sd);
}

// ===========================================================================
// The republish core: the shared handler (index dispatch + memcpy + swap +
// publish). The live SystemData->handler call is indirect, so we invoke the
// handler directly here to make its body visible to the snapshot tool.
// ===========================================================================

export fn wire_wide_handler(ctx: ?*anyopaque, args: ?*const anyopaque, publisher: *anyopaque) void {
    WireWide.handler(ctx, args, publisher);
}

export fn wire_single_handler(ctx: ?*anyopaque, args: ?*const anyopaque, publisher: *anyopaque) void {
    WireSingle.handler(ctx, args, publisher);
}

export fn wire_pair_handler(ctx: ?*anyopaque, args: ?*const anyopaque, publisher: *anyopaque) void {
    WirePair.handler(ctx, args, publisher);
}

// ===========================================================================
// Per-type byte-swap conversions: the actual native->big-endian work the
// handler dispatches to via a function pointer. Snapshotting them directly
// shows the cost of each shape in isolation.
// ===========================================================================

export fn wire_swap_u16(buf: *[2]u8) void {
    SwapRules(u16).applyToBig(buf);
}

export fn wire_swap_u32(buf: *[4]u8) void {
    SwapRules(u32).applyToBig(buf);
}

export fn wire_swap_u64(buf: *[8]u8) void {
    SwapRules(u64).applyToBig(buf);
}

export fn wire_swap_sample(buf: *[@sizeOf(Sample)]u8) void {
    SwapRules(Sample).applyToBig(buf);
}

export fn wire_swap_bytes4(buf: *[4]u8) void {
    SwapRules(Bytes4).applyToBig(buf);
}

export fn wire_swap_reading(buf: *[@sizeOf(Reading)]u8) void {
    SwapRules(Reading).applyToBig(buf);
}

// ===========================================================================
// Full integration: a SystemData write that propagates through the on-change
// chain and reaches the (indirect) wire handler. Shows the publish-path size
// for a watched RAM ERD and a watched Converted ERD.
// ===========================================================================

export fn wire_write_ram(sd: *WireSD, val: u16) void {
    sd.write(.temperature, val);
}

export fn wire_write_converted_dep(sd: *WireSD, val: u32) void {
    // raw_a feeds conv_sum (watched); writing it republishes the converted ERD.
    sd.write(.raw_a, val);
}
