//! Annotations for assembly snapshot files.
//!
//! The strip_asm tool reads this at build time and injects matching comments
//! into per-function assembly snapshots. Two mechanisms:
//!
//! 1. **Ratings table** (`ratings`): One entry per (function, mode) pair
//!    rating speed and code size. Every exported function in every mode
//!    MUST have an entry -- strip_asm enforces this at snapshot-update time.
//!
//! 2. **Free-form comments** (`comments`): Longer explanations for specific
//!    codegen quirks, attached to individual functions and optionally
//!    filtered by optimization mode.

pub const Mode = enum { ReleaseFast, ReleaseSmall };

pub const Speed = enum {
    optimal,
    near_optimal,
    suboptimal,

    pub fn label(self: Speed) []const u8 {
        return switch (self) {
            .optimal => "Optimal",
            .near_optimal => "Near-optimal",
            .suboptimal => "Suboptimal",
        };
    }
};

pub const Size = enum {
    optimal,
    optimal_until_n_calls,
    suboptimal,

    pub fn label(self: Size) []const u8 {
        return switch (self) {
            .optimal => "Optimal",
            .optimal_until_n_calls => "Optimal (until N calls)",
            .suboptimal => "Suboptimal",
        };
    }
};

pub const Rating = struct {
    func: []const u8,
    mode: Mode,
    speed: Speed = .optimal,
    size: Size = .optimal,
};

pub const Comment = struct {
    func: []const u8,
    modes: ?[]const Mode = null,
    text: []const u8,
};

// zig fmt: off

/// Helper to generate two Rating entries (one per mode) with the same values.
fn both(comptime func: []const u8, comptime speed: Speed, comptime size: Size) [2]Rating {
    return .{
        .{ .func = func, .mode = .ReleaseFast, .speed = speed, .size = size },
        .{ .func = func, .mode = .ReleaseSmall, .speed = speed, .size = size },
    };
}

pub const ratings = both("read_u32", .optimal, .optimal)
    ++ both("read_bool", .optimal, .optimal)
    ++ both("read_u16_unaligned", .optimal, .optimal)
    ++ both("read_u32_after_big", .optimal, .optimal)
    ++ both("read_big_struct", .optimal, .optimal)
    ++ both("read_medium_struct", .optimal, .optimal)
    ++ both("read_then_branch", .optimal, .optimal)
    ++ both("dual_read", .optimal, .optimal)
    ++ both("triple_read_same_erd", .optimal, .optimal)
    ++ both("read_across_two_erds", .optimal, .optimal)
    ++ both("many_read_first", .optimal, .optimal)
    ++ both("many_read_last", .optimal, .optimal)
    ++ both("many_read_middle", .optimal, .optimal)
    ++ both("read_write_read", .optimal, .optimal)
    ++ both("read_modify_write_big", .optimal, .optimal)
    ++ both("read_indirect_constant", .optimal, .optimal)
    ++ both("read_indirect_computed", .optimal, .optimal)
    ++ both("read_indirect_both", .optimal, .optimal)
    ++ both("read_converted_sum", .optimal, .optimal)
    ++ both("read_converted_flag_inv", .optimal, .optimal)
    ++ both("read_converted_both", .optimal, .optimal)
    ++ both("read_all_component_types", .optimal, .optimal)
    ++ both("read_ram_then_converted", .optimal, .optimal)
    ++ both("read_ram_then_indirect", .optimal, .optimal)
    // --- Simple writes ---
    ++ both("write_u32_no_subs", .optimal, .optimal)
    ++ [_]Rating{.{ .func = "write_u16_no_subs", .mode = .ReleaseFast }}
    ++ both("write_big_struct", .optimal, .optimal)
    ++ both("many_write_middle_no_subs", .optimal, .optimal)
    ++ [_]Rating{.{ .func = "write_ram_no_converted_dep", .mode = .ReleaseSmall }}
    ++ both("dual_write", .optimal, .optimal)
    ++ both("cross_system_read_write", .optimal, .optimal)
    ++ both("cross_system_read_add", .optimal, .optimal)
    // --- Writes with subs ---
    ++ both("write_bool_with_subs", .optimal, .optimal)
    ++ both("write_u16_with_subs", .optimal, .optimal)
    ++ both("write_triggering_callback", .optimal, .optimal)
    ++ both("many_write_last_with_subs", .optimal, .optimal)
    ++ both("conditional_write_chain", .optimal, .optimal)
    ++ both("write_ram_with_converted_deps", .optimal, .optimal)
    ++ both("write_ram_flag_with_converted_dep", .optimal, .optimal)
    ++ both("write_then_read_converted", .optimal, .optimal)
    ++ both("write_junk_read_write", .optimal, .optimal)
    ++ both("triple_write_increment", .optimal, .optimal)
    ++ [_]Rating{.{ .func = "increment_n_times", .mode = .ReleaseFast }}
    ++ [_]Rating{.{ .func = "increment_n_times", .mode = .ReleaseSmall, .speed = .suboptimal, .size = .suboptimal }}
    ++ [_]Rating{.{ .func = "double_write_diff_values", .mode = .ReleaseFast, .speed = .near_optimal }}
    ++ [_]Rating{.{ .func = "double_write_diff_values", .mode = .ReleaseSmall }}
    ++ [_]Rating{.{ .func = "double_write_same_value", .mode = .ReleaseFast, .speed = .near_optimal }}
    ++ [_]Rating{.{ .func = "double_write_same_value", .mode = .ReleaseSmall }}
    // --- Cross-erd and modify ---
    ++ both("cross_erd_compute", .optimal, .optimal)
    ++ both("cross_system_swap", .optimal, .optimal)
    ++ both("read_write_other_read", .optimal, .optimal)
    ++ both("modify_medium_no_subs", .optimal, .optimal)
    ++ both("modify_medium_single_field", .near_optimal, .optimal)
    ++ both("modify_medium_two_fields", .near_optimal, .optimal)
    ++ both("double_modify_struct", .optimal, .optimal)
    // --- Subscribe / unsubscribe ---
    ++ both("subscribe_callback", .optimal, .optimal)
    ++ both("subscribe_converted", .optimal, .optimal)
    ++ both("subscribe_converted_flag", .optimal, .optimal)
    ++ both("unsubscribe_converted", .optimal, .optimal)
    ++ both("unsubscribe_converted_flag", .optimal, .optimal)
    // --- Runtime dispatch ---
    ++ both("runtime_read", .optimal, .optimal)
    ++ both("runtime_read_two", .optimal, .optimal)
    ++ both("runtime_write", .optimal, .optimal)
    ++ both("runtime_write_two", .optimal, .optimal)
    ++ both("runtime_write_three", .optimal, .optimal)
    ++ both("multi_runtime_read", .optimal, .optimal)
    ++ both("multi_runtime_write", .optimal, .optimal)
    ++ both("setup_timer_callback", .optimal, .optimal)
    // --- Mono: tiny ---
    ++ both("tiny_read_all", .optimal, .optimal)
    ++ both("tiny_write_all", .optimal, .optimal)
    ++ both("tiny_modify", .optimal, .optimal)
    ++ both("tiny_runtime_read", .optimal, .optimal)
    ++ both("tiny_runtime_write", .optimal, .optimal)
    ++ both("tiny_subscribe", .optimal, .optimal)
    ++ both("tiny_unsubscribe", .optimal, .optimal)
    // --- Mono: wide ---
    ++ both("wide_read_all", .optimal, .optimal)
    ++ both("wide_write_all", .optimal, .optimal)
    ++ both("wide_modify", .optimal, .optimal)
    ++ both("wide_runtime_read", .optimal, .optimal)
    ++ both("wide_runtime_write", .optimal, .optimal)
    ++ both("wide_subscribe", .optimal, .optimal)
    ++ both("wide_unsubscribe", .optimal, .optimal)
    // --- Mono: mixed ---
    ++ both("mixed_read_all", .optimal, .optimal)
    ++ both("mixed_write_ram", .optimal, .optimal)
    ++ both("mixed_modify", .optimal, .optimal)
    ++ both("mixed_runtime_read", .optimal, .optimal)
    ++ both("mixed_runtime_write", .optimal, .optimal)
    ++ both("mixed_subscribe_ram", .optimal, .optimal)
    ++ both("mixed_subscribe_conv", .optimal, .optimal)
    ++ both("mixed_unsubscribe_ram", .optimal, .optimal)
    ++ both("mixed_unsubscribe_conv", .optimal, .optimal)
;
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
