//! Annotations for assembly snapshot files.
//!
//! The strip_asm tool reads this at build time and injects matching comments
//! into per-function assembly snapshots. Two mechanisms:
//!
//! 1. **Ratings table** (`ratings`): One line per function rating speed and
//!    code size. Rendered as a one-line header in each snapshot file.
//!    Defaults to optimal for all axes -- only specify what deviates.
//!
//! 2. **Free-form comments** (`comments`): Longer explanations for specific
//!    codegen quirks, attached to individual functions and optionally
//!    filtered by optimization mode.

pub const Mode = enum { ReleaseFast, ReleaseSmall };

pub const Quality = enum {
    optimal,
    near_optimal,
    suboptimal,

    pub fn label(self: Quality) []const u8 {
        return switch (self) {
            .optimal => "Optimal",
            .near_optimal => "Near-optimal",
            .suboptimal => "Suboptimal",
        };
    }
};

pub const Rating = struct {
    func: []const u8,
    modes: ?[]const Mode = null,
    speed: Quality = .optimal,
    local_size: Quality = .optimal,
    global_size: Quality = .optimal,
};

pub const Comment = struct {
    func: []const u8,
    modes: ?[]const Mode = null,
    text: []const u8,
};

// zig fmt: off
pub const ratings = [_]Rating{
    // --- Reads (all optimal) ---
    .{ .func = "read_u32" },
    .{ .func = "read_bool" },
    .{ .func = "read_u16_unaligned" },
    .{ .func = "read_u32_after_big" },
    .{ .func = "read_big_struct" },
    .{ .func = "read_medium_struct" },
    .{ .func = "read_then_branch" },
    .{ .func = "dual_read" },
    .{ .func = "triple_read_same_erd" },
    .{ .func = "read_across_two_erds" },
    .{ .func = "many_read_first" },
    .{ .func = "many_read_last" },
    .{ .func = "many_read_middle" },
    .{ .func = "read_write_read" },
    .{ .func = "read_modify_write_big" },
    .{ .func = "read_indirect_constant" },
    .{ .func = "read_indirect_computed" },
    .{ .func = "read_indirect_both" },
    .{ .func = "read_converted_sum" },
    .{ .func = "read_converted_flag_inv" },
    .{ .func = "read_converted_both" },
    .{ .func = "read_all_component_types" },
    .{ .func = "read_ram_then_converted" },
    .{ .func = "read_ram_then_indirect" },
    // --- Simple writes (all optimal) ---
    .{ .func = "write_u32_no_subs" },
    .{ .func = "write_u16_no_subs" },
    .{ .func = "write_big_struct" },
    .{ .func = "many_write_middle_no_subs" },
    .{ .func = "write_ram_no_converted_dep" },
    .{ .func = "dual_write" },
    .{ .func = "cross_system_read_write" },
    .{ .func = "cross_system_read_add" },
    // --- Writes with subs ---
    .{ .func = "write_bool_with_subs" },
    .{ .func = "write_u16_with_subs" },
    .{ .func = "write_triggering_callback" },
    .{ .func = "many_write_last_with_subs" },
    .{ .func = "conditional_write_chain" },
    .{ .func = "write_ram_with_converted_deps" },
    .{ .func = "write_ram_flag_with_converted_dep" },
    .{ .func = "write_then_read_converted" },
    .{ .func = "write_junk_read_write" },
    .{ .func = "triple_write_increment" },
    .{ .func = "increment_n_times", .modes = &.{.ReleaseSmall}, .speed = .suboptimal, .local_size = .suboptimal },
    .{ .func = "double_write_diff_values", .modes = &.{.ReleaseFast}, .speed = .near_optimal },
    .{ .func = "double_write_same_value", .modes = &.{.ReleaseFast}, .speed = .near_optimal },
    // --- Cross-erd and modify ---
    .{ .func = "cross_erd_compute" },
    .{ .func = "cross_system_swap" },
    .{ .func = "read_write_other_read" },
    .{ .func = "modify_medium_no_subs" },
    .{ .func = "modify_medium_single_field", .speed = .near_optimal },
    .{ .func = "modify_medium_two_fields", .speed = .near_optimal },
    .{ .func = "double_modify_struct" },
    // --- Subscribe / unsubscribe (all optimal) ---
    .{ .func = "subscribe_callback" },
    .{ .func = "subscribe_converted" },
    .{ .func = "subscribe_converted_flag" },
    .{ .func = "unsubscribe_converted" },
    .{ .func = "unsubscribe_converted_flag" },
    // --- Runtime dispatch ---
    .{ .func = "runtime_read" },
    .{ .func = "runtime_read_two" },
    .{ .func = "runtime_write" },
    .{ .func = "runtime_write_two" },
    .{ .func = "runtime_write_three" },
    .{ .func = "multi_runtime_read" },
    .{ .func = "multi_runtime_write" },
    .{ .func = "setup_timer_callback" },
    // --- Mono: tiny ---
    .{ .func = "tiny_read_all" },
    .{ .func = "tiny_write_all" },
    .{ .func = "tiny_modify" },
    .{ .func = "tiny_runtime_read" },
    .{ .func = "tiny_runtime_write" },
    .{ .func = "tiny_subscribe" },
    .{ .func = "tiny_unsubscribe" },
    // --- Mono: wide ---
    .{ .func = "wide_read_all" },
    .{ .func = "wide_write_all" },
    .{ .func = "wide_modify" },
    .{ .func = "wide_runtime_read" },
    .{ .func = "wide_runtime_write" },
    .{ .func = "wide_subscribe" },
    .{ .func = "wide_unsubscribe" },
    // --- Mono: mixed ---
    .{ .func = "mixed_read_all" },
    .{ .func = "mixed_write_ram" },
    .{ .func = "mixed_modify" },
    .{ .func = "mixed_runtime_read" },
    .{ .func = "mixed_runtime_write" },
    .{ .func = "mixed_subscribe_ram" },
    .{ .func = "mixed_subscribe_conv" },
    .{ .func = "mixed_unsubscribe_ram" },
    .{ .func = "mixed_unsubscribe_conv" },
};
// zig fmt: on

pub const comments = [_]Comment{
    .{
        .func = "increment_n_times",
        .modes = &.{.ReleaseSmall},
        .text =
        \\ReleaseFast collapses the loop to a single `add [rdi], esi`,
        \\but ReleaseSmall emits a literal inc-per-iteration loop.
        \\This is an LLVM missed optimization under -Oz -- the collapsed
        \\form is both smaller and faster. Not fixable from Zig without
        \\changing subscription semantics (one publish vs N publishes).
        ,
    },
    .{
        .func = "double_write_same_value",
        .modes = &.{.ReleaseFast},
        .text =
        \\LLVM cannot eliminate the second write's compare-and-publish
        \\sequence. After the first publish call, it conservatively
        \\reloads the stored value because publish takes the SystemData
        \\pointer and callbacks could mutate the flag. Not fixable from
        \\Zig without lying to LLVM about callback side effects.
        ,
    },
    .{
        .func = "double_write_diff_values",
        .modes = &.{.ReleaseFast},
        .text =
        \\After the first write's publish call, LLVM reloads the stored
        \\flag value before comparing for the second write. It cannot
        \\prove publish did not mutate the flag through the opaque
        \\publisher pointer. Same root cause as double_write_same_value.
        ,
    },
    .{
        .func = "modify_medium_single_field",
        .text =
        \\The noinline modifyInner uses an indirect call for the modifier,
        \\preventing LLVM from inlining it and optimizing away unchanged
        \\field copies. This is intentional -- the noinline shares the
        \\read/modify/writeback/publish body across all modifier lambdas.
        \\Users who need single-field speed can use write() instead.
        ,
    },
    .{
        .func = "modify_medium_two_fields",
        .text =
        \\Same noinline modifyInner tradeoff as modify_medium_single_field.
        \\The full struct copy is the cost of sharing the modify body.
        ,
    },
};
