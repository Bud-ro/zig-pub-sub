//! Monomorphization stress test
//!
//! Exercises every SystemData API across multiple system configurations to
//! measure how much code the compiler duplicates vs shares. Snapshotted via
//! `zig build codegen-update`; verified via `zig build codegen-check`.
//! For quick local iteration: `zig build emit-mono-asm`.

const std = @import("std");
const erd_core = @import("erd_core");
const SystemDataTestDouble = erd_core.testing.SystemDataTestDouble;
const Erd = erd_core.Erd;
const IndirectMapping = erd_core.data_component.IndirectMapping;
const ConvertedMapping = erd_core.data_component.ConvertedMapping;

const Pair = extern struct { x: u32, y: u32 };

// ===========================================================================
// System 1: "Tiny" -- 3 ERDs, RAM only, minimal subs
// ===========================================================================
const TinySystem = SystemDataTestDouble.create(struct {
    counter: Erd = SystemDataTestDouble.ramErd(u32, .{ .subs = 1 }),
    flag: Erd = SystemDataTestDouble.ramErd(bool, .{ .subs = 1 }),
    pair: Erd = SystemDataTestDouble.ramErd(Pair, .{ .subs = 1 }),
});
const TinySD = TinySystem.SystemData;

// ===========================================================================
// System 2: "Wide" -- 16 ERDs, all RAM, diverse types, some subs
// ===========================================================================
const WideSystem = SystemDataTestDouble.create(struct {
    w00: Erd = SystemDataTestDouble.ramErd(u8, .{ .subs = 1 }),
    w01: Erd = SystemDataTestDouble.ramErd(u16, .{}),
    w02: Erd = SystemDataTestDouble.ramErd(u32, .{ .subs = 2 }),
    w03: Erd = SystemDataTestDouble.ramErd(u64, .{}),
    w04: Erd = SystemDataTestDouble.ramErd(i8, .{}),
    w05: Erd = SystemDataTestDouble.ramErd(i16, .{ .subs = 1 }),
    w06: Erd = SystemDataTestDouble.ramErd(i32, .{}),
    w07: Erd = SystemDataTestDouble.ramErd(i64, .{ .subs = 2 }),
    w08: Erd = SystemDataTestDouble.ramErd(bool, .{}),
    w09: Erd = SystemDataTestDouble.ramErd(u8, .{ .subs = 1 }),
    w10: Erd = SystemDataTestDouble.ramErd(u16, .{}),
    w11: Erd = SystemDataTestDouble.ramErd(u32, .{ .subs = 1 }),
    w12: Erd = SystemDataTestDouble.ramErd(u64, .{}),
    w13: Erd = SystemDataTestDouble.ramErd(i32, .{ .subs = 2 }),
    w14: Erd = SystemDataTestDouble.ramErd(bool, .{}),
    w15: Erd = SystemDataTestDouble.ramErd(u32, .{ .subs = 1 }),
    w_pair: Erd = SystemDataTestDouble.ramErd(Pair, .{ .subs = 1 }),
});
const WideSD = WideSystem.SystemData;

// ===========================================================================
// System 3: "Mixed" -- RAM + Indirect + Converted, 9 ERDs total
// ===========================================================================
const Ram = 0;
const Indirect = 1;
const Converted = 2;

const MixedDefs = struct {
    // zig fmt: off
    ram_a:     Erd = .{ .erd_number = null, .T = u32,  .component_idx = Ram,       .subs = 2 },
    ram_b:     Erd = .{ .erd_number = null, .T = u16,  .component_idx = Ram,       .subs = 1 },
    ram_c:     Erd = .{ .erd_number = null, .T = bool, .component_idx = Ram,       .subs = 0 },
    ram_d:     Erd = .{ .erd_number = null, .T = u64,  .component_idx = Ram,       .subs = 1 },
    ind_x:     Erd = .{ .erd_number = null, .T = u32,  .component_idx = Indirect,  .subs = 0 },
    ind_y:     Erd = .{ .erd_number = null, .T = u16,  .component_idx = Indirect,  .subs = 0 },
    conv_sum:  Erd = .{ .erd_number = null, .T = u32,  .component_idx = Converted, .subs = 2 },
    conv_flag: Erd = .{ .erd_number = null, .T = bool, .component_idx = Converted, .subs = 1 },
    conv_wide: Erd = .{ .erd_number = null, .T = u64,  .component_idx = Converted, .subs = 1 },
    ram_pair:  Erd = .{ .erd_number = null, .T = Pair, .component_idx = Ram,       .subs = 1 },
    // zig fmt: on
};

const mixed_erd = blk: {
    var erds = MixedDefs{};
    var component_counts = [_]u16{ 0, 0, 0 };
    for (std.meta.fieldNames(MixedDefs), 0..) |name, i| {
        const idx = @field(erds, name).component_idx;
        @field(erds, name).data_component_idx = component_counts[idx];
        @field(erds, name).system_data_idx = i;
        component_counts[idx] += 1;
    }
    break :blk erds;
};

const MixedEnum = std.meta.FieldEnum(MixedDefs);

fn mixedRamErds() [5]Erd {
    return .{ mixed_erd.ram_a, mixed_erd.ram_b, mixed_erd.ram_c, mixed_erd.ram_d, mixed_erd.ram_pair };
}

fn mixedIndErds() [2]Erd {
    return .{ mixed_erd.ind_x, mixed_erd.ind_y };
}

fn mixedConvErds() [3]Erd {
    return .{ mixed_erd.conv_sum, mixed_erd.conv_flag, mixed_erd.conv_wide };
}

fn indXFn(data: *u32) void {
    data.* = 0xBEEF;
}

fn indYFn(data: *u16) void {
    data.* = 42;
}

const mixed_ind_mappings = [_]IndirectMapping{
    .map(mixed_erd.ind_x, indXFn),
    .map(mixed_erd.ind_y, indYFn),
};

fn convSumFn(result: *u32, ctx: *anyopaque) void {
    const sd: *MixedSD = @ptrCast(@alignCast(ctx));
    result.* = sd.read(.ram_a) +% @as(u32, sd.read(.ram_b));
}

fn convFlagFn(result: *bool, ctx: *anyopaque) void {
    const sd: *MixedSD = @ptrCast(@alignCast(ctx));
    result.* = sd.read(.ram_a) > 100;
}

fn convWideFn(result: *u64, ctx: *anyopaque) void {
    const sd: *MixedSD = @ptrCast(@alignCast(ctx));
    result.* = @as(u64, sd.read(.ram_a)) +% sd.read(.ram_d);
}

const mixed_conv_mappings = [_]ConvertedMapping{
    .map(mixed_erd.conv_sum, convSumFn, &.{ mixed_erd.ram_a, mixed_erd.ram_b }),
    .map(mixed_erd.conv_flag, convFlagFn, &.{mixed_erd.ram_a}),
    .map(mixed_erd.conv_wide, convWideFn, &.{ mixed_erd.ram_a, mixed_erd.ram_d }),
};

const mixed_ram_defs = mixedRamErds();
const mixed_ind_defs = mixedIndErds();
const mixed_conv_defs = mixedConvErds();

const MixedRam = erd_core.data_component.Ram(&mixed_ram_defs);
const MixedInd = erd_core.data_component.Indirect(&mixed_ind_defs, mixed_ind_mappings);
const MixedConv = erd_core.data_component.Converted(&mixed_conv_defs, mixed_conv_mappings);

const MixedComponents = struct {
    ram: MixedRam,
    indirect: MixedInd,
    converted: MixedConv,
};

const MixedSD = erd_core.SystemData(MixedDefs, MixedEnum, mixed_erd, MixedComponents);

comptime {
    std.debug.assert(Ram == std.meta.fieldIndex(MixedComponents, "ram").?);
    std.debug.assert(Indirect == std.meta.fieldIndex(MixedComponents, "indirect").?);
    std.debug.assert(Converted == std.meta.fieldIndex(MixedComponents, "converted").?);
}

// ===========================================================================
// Callbacks (shared across systems for subscribe tests)
// ===========================================================================

fn tiny_callback(_: ?*anyopaque, _: ?*const anyopaque, _: *anyopaque) void {}
fn wide_callback(_: ?*anyopaque, _: ?*const anyopaque, _: *anyopaque) void {}
fn mixed_callback(_: ?*anyopaque, _: ?*const anyopaque, _: *anyopaque) void {}

// ===========================================================================
// Tiny system: full API exercise
// ===========================================================================

export fn tiny_read_all(sd: *TinySD) u32 {
    return sd.read(.counter) +% @as(u32, @intFromBool(sd.read(.flag)));
}

export fn tiny_write_all(sd: *TinySD, val: u32, flag: bool) void {
    sd.write(.counter, val);
    sd.write(.flag, flag);
}

export fn tiny_runtime_read(sd: *TinySD, idx: u16, out: *anyopaque) void {
    sd.runtimeRead(idx, out);
}

export fn tiny_runtime_write(sd: *TinySD, idx: u16, data: *const anyopaque) void {
    sd.runtimeWrite(idx, data);
}

export fn tiny_subscribe(sd: *TinySD) void {
    sd.subscribe(.counter, null, tiny_callback);
}

export fn tiny_unsubscribe(sd: *TinySD) void {
    sd.unsubscribe(.counter, tiny_callback);
}

export fn tiny_modify(sd: *TinySD) void {
    sd.modify(.pair, struct {
        fn m(val: *Pair) void {
            val.x +%= 1;
        }
    }.m);
}

// ===========================================================================
// Wide system: full API exercise
// ===========================================================================

export fn wide_read_all(sd: *WideSD) u64 {
    var acc: u64 = 0;
    acc +%= sd.read(.w00);
    acc +%= sd.read(.w01);
    acc +%= sd.read(.w02);
    acc +%= sd.read(.w03);
    acc +%= @as(u64, @bitCast(@as(i64, sd.read(.w04))));
    acc +%= @as(u64, @bitCast(@as(i64, sd.read(.w05))));
    acc +%= @as(u64, @bitCast(@as(i64, sd.read(.w06))));
    acc +%= @as(u64, @bitCast(@as(i64, sd.read(.w07))));
    acc +%= @intFromBool(sd.read(.w08));
    acc +%= sd.read(.w09);
    acc +%= sd.read(.w10);
    acc +%= sd.read(.w11);
    acc +%= sd.read(.w12);
    acc +%= @as(u64, @bitCast(@as(i64, sd.read(.w13))));
    acc +%= @intFromBool(sd.read(.w14));
    acc +%= sd.read(.w15);
    return acc;
}

export fn wide_write_all(sd: *WideSD) void {
    sd.write(.w00, 1);
    sd.write(.w01, 2);
    sd.write(.w02, 3);
    sd.write(.w03, 4);
    sd.write(.w04, 5);
    sd.write(.w05, 6);
    sd.write(.w06, 7);
    sd.write(.w07, 8);
    sd.write(.w08, true);
    sd.write(.w09, 9);
    sd.write(.w10, 10);
    sd.write(.w11, 11);
    sd.write(.w12, 12);
    sd.write(.w13, 13);
    sd.write(.w14, false);
    sd.write(.w15, 14);
}

export fn wide_runtime_read(sd: *WideSD, idx: u16, out: *anyopaque) void {
    sd.runtimeRead(idx, out);
}

export fn wide_runtime_write(sd: *WideSD, idx: u16, data: *const anyopaque) void {
    sd.runtimeWrite(idx, data);
}

export fn wide_subscribe(sd: *WideSD) void {
    sd.subscribe(.w02, null, wide_callback);
}

export fn wide_unsubscribe(sd: *WideSD) void {
    sd.unsubscribe(.w02, wide_callback);
}

export fn wide_modify(sd: *WideSD) void {
    sd.modify(.w_pair, struct {
        fn m(val: *Pair) void {
            val.x +%= 1;
        }
    }.m);
}

// ===========================================================================
// Mixed system: full API exercise (RAM + Indirect + Converted)
// ===========================================================================

export fn mixed_read_all(sd: *MixedSD) u64 {
    var acc: u64 = 0;
    acc +%= sd.read(.ram_a);
    acc +%= sd.read(.ram_b);
    acc +%= @intFromBool(sd.read(.ram_c));
    acc +%= sd.read(.ram_d);
    acc +%= sd.read(.ind_x);
    acc +%= sd.read(.ind_y);
    acc +%= sd.read(.conv_sum);
    acc +%= @intFromBool(sd.read(.conv_flag));
    acc +%= sd.read(.conv_wide);
    return acc;
}

export fn mixed_write_ram(sd: *MixedSD, a: u32, b: u16, c: bool, d: u64) void {
    sd.write(.ram_a, a);
    sd.write(.ram_b, b);
    sd.write(.ram_c, c);
    sd.write(.ram_d, d);
}

export fn mixed_runtime_read(sd: *MixedSD, idx: u16, out: *anyopaque) void {
    sd.runtimeRead(idx, out);
}

export fn mixed_runtime_write(sd: *MixedSD, idx: u16, data: *const anyopaque) void {
    sd.runtimeWrite(idx, data);
}

export fn mixed_subscribe_ram(sd: *MixedSD) void {
    sd.subscribe(.ram_a, null, mixed_callback);
}

export fn mixed_subscribe_conv(sd: *MixedSD) void {
    sd.subscribe(.conv_sum, null, mixed_callback);
}

export fn mixed_unsubscribe_ram(sd: *MixedSD) void {
    sd.unsubscribe(.ram_a, mixed_callback);
}

export fn mixed_unsubscribe_conv(sd: *MixedSD) void {
    sd.unsubscribe(.conv_sum, mixed_callback);
}

export fn mixed_modify(sd: *MixedSD) void {
    sd.modify(.ram_pair, struct {
        fn m(val: *Pair) void {
            val.x +%= 1;
        }
    }.m);
}
