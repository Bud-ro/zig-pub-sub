//! Codegen inspection harness
//!
//! Exported functions that exercise SystemData read/write/subscribe across
//! multiple configurations. Build as an object (`zig build emit-asm`) and
//! inspect the generated assembly to verify zero-cost abstractions:
//!   - Comptime reads should compile to a single load from a fixed offset
//!   - Writes without subscriptions should be a single store
//!   - Writes with subscriptions should inline the on-change check
//!   - Multiple reads of the same ERD should be CSE'd by LLVM
//!
//! Use `zig build codegen-update` to snapshot stripped assembly and sizes,
//! and `zig build codegen-check` to verify snapshots haven't regressed.

const std = @import("std");
const SystemDataTestDouble = @import("testing.zig");
const Erd = @import("erd.zig");
const timer = @import("timer.zig");

// ---------------------------------------------------------------------------
// System A: small system (4 ERDs, one with subs)
// ---------------------------------------------------------------------------
const SmallSystem = SystemDataTestDouble.create(struct {
    version: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u32, .{}),
    flag: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(bool, .{ .subs = 1 }),
    unaligned_u16: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u16, .{}),
    subscribable_u16: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u16, .{ .subs = 2 }),
});
const SmallSD = SmallSystem.SystemData;

// ---------------------------------------------------------------------------
// System B: second independent SystemData (verifies no cross-contamination)
// ---------------------------------------------------------------------------
const OtherSystem = SystemDataTestDouble.create(struct {
    sensor_a: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(i32, .{ .subs = 1 }),
    sensor_b: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(i32, .{}),
    output: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u64, .{}),
});
const OtherSD = OtherSystem.SystemData;

// ---------------------------------------------------------------------------
// System C: many ERDs (32) to stress comptime dispatch and offset computation
// ---------------------------------------------------------------------------
const ManyErdsSystem = SystemDataTestDouble.create(struct {
    e00: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u8, .{}),
    e01: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u16, .{}),
    e02: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u32, .{}),
    e03: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u64, .{}),
    e04: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u8, .{}),
    e05: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u16, .{}),
    e06: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u32, .{}),
    e07: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u64, .{}),
    e08: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u8, .{ .subs = 1 }),
    e09: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u16, .{}),
    e10: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u32, .{}),
    e11: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u64, .{}),
    e12: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u8, .{}),
    e13: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u16, .{}),
    e14: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u32, .{}),
    e15: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u64, .{}),
    e16: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u8, .{}),
    e17: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u16, .{}),
    e18: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u32, .{}),
    e19: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u64, .{}),
    e20: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u8, .{}),
    e21: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u16, .{}),
    e22: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u32, .{}),
    e23: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u64, .{}),
    e24: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u8, .{}),
    e25: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u16, .{}),
    e26: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u32, .{}),
    e27: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u64, .{}),
    e28: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u8, .{}),
    e29: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u16, .{}),
    e30: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u32, .{}),
    e31: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u64, .{ .subs = 3 }),
});
const ManySD = ManyErdsSystem.SystemData;

// ---------------------------------------------------------------------------
// System D: huge ERD types (large structs)
// ---------------------------------------------------------------------------
const BigStruct = extern struct {
    data: [256]u8,
};

const MediumStruct = extern struct {
    a: u64,
    b: u64,
    c: u32,
    d: u16,
    e: u8,
    f: bool,
};

const HugeSystem = SystemDataTestDouble.create(struct {
    big: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(BigStruct, .{}),
    medium: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(MediumStruct, .{ .subs = 1 }),
    small_after_big: SystemDataTestDouble.Erd = SystemDataTestDouble.ramErd(u32, .{}),
});
const HugeSD = HugeSystem.SystemData;

// ===========================================================================
// Comptime reads — small system
// ===========================================================================

export fn codegen_read_u32(sd: *SmallSD) u32 {
    return sd.read(.version);
}

export fn codegen_read_bool(sd: *SmallSD) bool {
    return sd.read(.flag);
}

export fn codegen_read_u16_unaligned(sd: *SmallSD) u16 {
    return sd.read(.unaligned_u16);
}

// ===========================================================================
// Comptime writes — small system
// ===========================================================================

export fn codegen_write_u32_no_subs(sd: *SmallSD) void {
    sd.write(.version, 0xDEADBEEF);
}

export fn codegen_write_u16_no_subs(sd: *SmallSD, val: u16) void {
    sd.write(.unaligned_u16, val);
}

export fn codegen_write_bool_with_subs(sd: *SmallSD, val: bool) void {
    sd.write(.flag, val);
}

export fn codegen_write_u16_with_subs(sd: *SmallSD, val: u16) void {
    sd.write(.subscribable_u16, val);
}

// ===========================================================================
// Runtime read/write — small system
// ===========================================================================

export fn codegen_runtime_read_u32(sd: *SmallSD) u32 {
    var val: u32 = undefined;
    sd.runtime_read(0, &val);
    return val;
}

export fn codegen_runtime_write_u32(sd: *SmallSD) void {
    const val: u32 = 0xDEADBEEF;
    sd.runtime_write(0, &val);
}

// ===========================================================================
// Multiple SystemData instances (verify no cross-contamination)
// ===========================================================================

export fn codegen_dual_read(sd_a: *SmallSD, sd_b: *OtherSD) u64 {
    const a: u64 = sd_a.read(.version);
    const b: u64 = @bitCast(@as(i64, sd_b.read(.sensor_a)));
    return a +% b;
}

export fn codegen_dual_write(sd_a: *SmallSD, sd_b: *OtherSD) void {
    sd_a.write(.version, 42);
    sd_b.write(.sensor_b, -1);
}

// ===========================================================================
// Many ERDs — first, middle, last access patterns
// ===========================================================================

export fn codegen_many_read_first(sd: *ManySD) u8 {
    return sd.read(.e00);
}

export fn codegen_many_read_middle(sd: *ManySD) u32 {
    return sd.read(.e14);
}

export fn codegen_many_read_last(sd: *ManySD) u64 {
    return sd.read(.e31);
}

export fn codegen_many_write_last_with_subs(sd: *ManySD, val: u64) void {
    sd.write(.e31, val);
}

export fn codegen_many_write_middle_no_subs(sd: *ManySD, val: u32) void {
    sd.write(.e14, val);
}

// ===========================================================================
// Huge ERD types — read, write, read-modify-write
// ===========================================================================

export fn codegen_read_big_struct(sd: *HugeSD) BigStruct {
    return sd.read(.big);
}

export fn codegen_read_medium_struct(sd: *HugeSD) MediumStruct {
    return sd.read(.medium);
}

export fn codegen_read_u32_after_big(sd: *HugeSD) u32 {
    return sd.read(.small_after_big);
}

export fn codegen_write_big_struct(sd: *HugeSD, val: *const BigStruct) void {
    sd.write(.big, val.*);
}

export fn codegen_write_medium_with_subs(sd: *HugeSD, val: *const MediumStruct) void {
    sd.write(.medium, val.*);
}

export fn codegen_read_modify_write_medium(sd: *HugeSD) void {
    var val = sd.read(.medium);
    val.c +%= 1;
    sd.write(.medium, val);
}

export fn codegen_read_modify_write_big(sd: *HugeSD) void {
    var val = sd.read(.big);
    val.data[0] +%= 1;
    sd.write(.big, val);
}

// ===========================================================================
// Timer callback context — read/write inside a timer callback
// ===========================================================================

fn timer_callback_read_write(ctx: ?*anyopaque, _: *timer.TimerModule, _: *timer.Timer) void {
    const sd: *SmallSD = @ptrCast(@alignCast(ctx.?));
    const current = sd.read(.version);
    sd.write(.version, current +% 1);
}

export fn codegen_setup_timer_callback(sd: *SmallSD, tm: *timer.TimerModule, t: *timer.Timer) void {
    tm.start_periodic(t, 100, sd, timer_callback_read_write);
}

// Force the timer callback to be emitted even if the linker would discard it
comptime {
    _ = &timer_callback_read_write;
}

// ===========================================================================
// Redundant read elimination — does LLVM CSE through the abstraction?
// ===========================================================================

export fn codegen_triple_read_same_erd(sd: *SmallSD) u32 {
    const a = sd.read(.version);
    const b = sd.read(.version);
    const c = sd.read(.version);
    return a +% b +% c;
}

export fn codegen_read_then_branch(sd: *SmallSD, flag: bool) u32 {
    const a = sd.read(.version);
    if (flag) {
        const b = sd.read(.version);
        return a +% b;
    }
    const c = sd.read(.version);
    return a *% c;
}

export fn codegen_read_write_read(sd: *SmallSD) u32 {
    const before = sd.read(.version);
    sd.write(.version, before +% 1);
    const after = sd.read(.version);
    return after;
}

export fn codegen_read_write_other_read(sd: *SmallSD, val: bool) u32 {
    const before = sd.read(.version);
    sd.write(.flag, val);
    const after = sd.read(.version);
    return before +% after;
}

export fn codegen_read_across_two_erds(sd: *SmallSD) u32 {
    const a = sd.read(.version);
    const b: u32 = sd.read(.unaligned_u16);
    const c = sd.read(.version);
    return a +% b +% c;
}

// ===========================================================================
// Subscription callback that reads the written ERD via args
// ===========================================================================

fn accumulate_callback(_: ?*anyopaque, _args: ?*const anyopaque, publisher: *anyopaque) void {
    const args: *const SmallSD.OnChangeArgs = @ptrCast(@alignCast(_args.?));
    var sd: *SmallSD = @ptrCast(@alignCast(publisher));
    const written_val: *const bool = @ptrCast(args.data);
    if (written_val.*) {
        sd.write(.version, sd.read(.version) +% 1);
    }
}

export fn codegen_subscribe_callback(sd: *SmallSD) void {
    sd.subscribe(.flag, null, accumulate_callback);
}

export fn codegen_write_triggering_callback(sd: *SmallSD) void {
    sd.write(.flag, true);
}

comptime {
    _ = &accumulate_callback;
}

// ===========================================================================
// Loop-like patterns — repeated writes, conditional accumulation
// ===========================================================================

export fn codegen_increment_n_times(sd: *SmallSD, n: u32) void {
    var i: u32 = 0;
    while (i < n) : (i += 1) {
        sd.write(.version, sd.read(.version) +% 1);
    }
}

export fn codegen_conditional_write_chain(sd: *SmallSD) void {
    if (sd.read(.flag)) {
        sd.write(.version, sd.read(.version) +% 10);
    }
    if (sd.read(.unaligned_u16) > 100) {
        sd.write(.version, sd.read(.version) +% 20);
    }
}

// ===========================================================================
// Cross-ERD dependency — read one, compute, write another
// ===========================================================================

export fn codegen_cross_erd_compute(sd: *SmallSD) void {
    const a: u32 = sd.read(.unaligned_u16);
    const b = sd.read(.version);
    sd.write(.subscribable_u16, @truncate(a +% b));
}

// ===========================================================================
// Cross-system reads — two different SystemData types in one function
// ===========================================================================

export fn codegen_cross_system_read_add(sd_a: *SmallSD, sd_b: *OtherSD) i64 {
    const a: i64 = @intCast(sd_a.read(.version));
    const b: i64 = sd_b.read(.sensor_a);
    const c: i64 = @intCast(sd_a.read(.unaligned_u16));
    const d: i64 = sd_b.read(.sensor_b);
    return a +% b +% c +% d;
}

export fn codegen_cross_system_read_write(sd_a: *SmallSD, sd_b: *OtherSD) void {
    const val = sd_b.read(.sensor_a);
    sd_a.write(.version, @bitCast(val));
}

export fn codegen_cross_system_swap(sd_a: *SmallSD, sd_b: *OtherSD) void {
    const a = sd_a.read(.version);
    const b: u32 = @bitCast(sd_b.read(.sensor_a));
    sd_a.write(.version, b);
    sd_b.write(.sensor_a, @bitCast(a));
}

// ===========================================================================
// Multi-write patterns — verify LLVM eliminates redundant checks
// ===========================================================================

// Writing the same value twice: second write should be eliminated or at
// minimum the second publish should be skipped since the value hasn't changed.
export fn codegen_double_write_same_value(sd: *SmallSD) void {
    sd.write(.flag, true);
    sd.write(.flag, true);
}

// Writing different values: both writes must happen, but only the value that
// actually differs from storage should trigger a publish.
export fn codegen_double_write_diff_values(sd: *SmallSD) void {
    sd.write(.flag, true);
    sd.write(.flag, false);
}

// Write, read something unrelated, write again. The junk read shouldn't
// prevent LLVM from reasoning about the two writes.
export fn codegen_write_junk_read_write(sd: *SmallSD) void {
    sd.write(.subscribable_u16, 1);
    _ = sd.read(.version);
    sd.write(.subscribable_u16, 2);
}

// Triple write to the same ERD with incrementing values.
export fn codegen_triple_write_increment(sd: *SmallSD) void {
    sd.write(.subscribable_u16, 1);
    sd.write(.subscribable_u16, 2);
    sd.write(.subscribable_u16, 3);
}

// Read-modify-write twice on a struct: change different fields each time.
export fn codegen_double_rmw_struct(sd: *HugeSD) void {
    var val = sd.read(.medium);
    val.c +%= 1;
    sd.write(.medium, val);

    var val2 = sd.read(.medium);
    val2.a +%= 1;
    sd.write(.medium, val2);
}
