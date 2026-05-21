//! Annotations for assembly snapshot files.
//!
//! The strip_asm tool reads this at build time and injects matching comments
//! into per-function assembly snapshots. Two mechanisms:
//!
//! 1. Ratings table (`ratings`): One entry per (function, mode) pair
//!    rating speed and code size. Every exported function in every mode
//!    MUST have an entry -- strip_asm enforces this at snapshot-update time.
//!
//! 2. Free-form comments (`comments`): Longer explanations for specific
//!    codegen quirks, attached to individual functions and optionally
//!    filtered by optimization mode.

/// Optimization level this annotation applies to.
pub const Mode = enum { release_fast, release_small };

/// Speed quality rating for a function's generated assembly.
pub const Speed = enum {
    optimal,
    near_optimal,
    suboptimal,

    /// Human-readable label for snapshot comments.
    pub fn label(self: Speed) []const u8 {
        return switch (self) {
            .optimal => "Optimal",
            .near_optimal => "Near-optimal",
            .suboptimal => "Suboptimal",
        };
    }
};

/// Code size quality rating. When `optimal_until_n_calls`, the inlined form
/// is smaller than a function call up to N call sites; beyond that, outlining
/// into a shared function would save ROM. The threshold N is stored in
/// `Rating.size_n`.
pub const Size = enum {
    optimal,
    optimal_until_n_calls,
    suboptimal,
};

/// Per-(function, mode) quality assessment.
pub const Rating = struct {
    func: []const u8,
    mode: Mode,
    speed: Speed = .optimal,
    size: Size = .optimal,
    size_n: ?u16 = null,
};

/// Free-form comment attached to a function's snapshot file.
pub const Comment = struct {
    func: []const u8,
    modes: ?[]const Mode = null,
    text: []const u8,
};

/// Generate two Rating entries (one per mode) with the same values.
fn b(comptime func: []const u8, comptime speed: Speed, comptime size: Size, comptime size_n: ?u16) [2]Rating {
    return .{
        .{ .func = func, .mode = .release_fast, .speed = speed, .size = size, .size_n = size_n },
        .{ .func = func, .mode = .release_small, .speed = speed, .size = size, .size_n = size_n },
    };
}

// zig fmt: off

/// Quality ratings for every exported function in every optimization mode.
pub const ratings =
       b("conditional_write_chain", .optimal, .optimal_until_n_calls, 2)
    ++ b("cross_erd_compute", .optimal, .optimal_until_n_calls, 2)
    ++ b("cross_system_read_add", .optimal, .optimal_until_n_calls, 2)
    ++ b("cross_system_read_write", .optimal, .optimal, null)
    ++ b("cross_system_swap", .optimal, .optimal_until_n_calls, 2)
    ++ b("double_modify_struct", .optimal, .optimal_until_n_calls, 2)
    ++ [_]Rating{.{ .func = "double_write_diff_values", .mode = .release_fast, .speed = .near_optimal, .size = .optimal_until_n_calls, .size_n = 2 }}
    ++ [_]Rating{.{ .func = "double_write_diff_values", .mode = .release_small, .size = .optimal_until_n_calls, .size_n = 2 }}
    ++ [_]Rating{.{ .func = "double_write_same_value", .mode = .release_fast, .speed = .near_optimal, .size = .optimal_until_n_calls, .size_n = 2 }}
    ++ [_]Rating{.{ .func = "double_write_same_value", .mode = .release_small, .size = .optimal_until_n_calls, .size_n = 2 }}
    ++ b("dual_read", .optimal, .optimal_until_n_calls, 3)
    ++ b("dual_write", .optimal, .optimal_until_n_calls, 2)
    ++ [_]Rating{.{ .func = "increment_n_times", .mode = .release_fast, .size = .optimal_until_n_calls, .size_n = 4 }}
    ++ [_]Rating{.{ .func = "increment_n_times", .mode = .release_small, .speed = .suboptimal, .size = .suboptimal }}
    ++ b("many_read_first", .optimal, .optimal, null)
    ++ b("many_read_last", .optimal, .optimal, null)
    ++ b("many_read_middle", .optimal, .optimal, null)
    ++ b("many_write_last_with_subs", .optimal, .optimal_until_n_calls, 2)
    ++ b("many_write_middle_no_subs", .optimal, .optimal, null)
    ++ b("mixed_modify", .optimal, .optimal, null)
    ++ b("mixed_read_all", .optimal, .optimal_until_n_calls, 2)
    ++ b("mixed_runtime_read", .optimal, .optimal, null)
    ++ b("mixed_runtime_write", .optimal, .optimal, null)
    ++ b("mixed_subscribe_conv", .optimal, .optimal_until_n_calls, 3)
    ++ b("mixed_subscribe_ram", .optimal, .optimal_until_n_calls, 3)
    ++ b("mixed_unsubscribe_conv", .optimal, .optimal_until_n_calls, 3)
    ++ b("mixed_unsubscribe_ram", .optimal, .optimal_until_n_calls, 6)
    ++ b("mixed_write_ram", .optimal, .optimal_until_n_calls, 2)
    ++ b("modify_medium_no_subs", .optimal, .optimal, null)
    ++ b("modify_medium_single_field", .near_optimal, .optimal_until_n_calls, 2)
    ++ b("modify_medium_two_fields", .near_optimal, .optimal_until_n_calls, 2)
    ++ b("multi_runtime_read", .optimal, .optimal, null)
    ++ b("multi_runtime_write", .optimal, .optimal, null)
    ++ b("read_across_two_erds", .optimal, .optimal_until_n_calls, 2)
    ++ b("read_all_component_types", .optimal, .optimal_until_n_calls, 2)
    ++ b("read_big_struct", .optimal, .optimal_until_n_calls, 2)
    ++ b("read_bool", .optimal, .optimal, null)
    ++ b("read_converted_both", .optimal, .optimal_until_n_calls, 2)
    ++ b("read_converted_flag_inv", .optimal, .optimal_until_n_calls, 2)
    ++ b("read_converted_sum", .optimal, .optimal_until_n_calls, 2)
    ++ b("read_indirect_both", .optimal, .optimal_until_n_calls, 6)
    ++ b("read_indirect_computed", .optimal, .optimal, null)
    ++ b("read_indirect_constant", .optimal, .optimal_until_n_calls, 6)
    ++ b("read_medium_struct", .optimal, .optimal_until_n_calls, 2)
    ++ b("read_modify_write_big", .optimal, .optimal, null)
    ++ b("read_ram_then_converted", .optimal, .optimal_until_n_calls, 2)
    ++ b("read_ram_then_indirect", .optimal, .optimal_until_n_calls, 3)
    ++ b("read_then_branch", .optimal, .optimal_until_n_calls, 2)
    ++ b("read_u16_unaligned", .optimal, .optimal, null)
    ++ b("read_u32", .optimal, .optimal, null)
    ++ b("read_u32_after_big", .optimal, .optimal_until_n_calls, 4)
    ++ b("read_write_other_read", .optimal, .optimal_until_n_calls, 2)
    ++ [_]Rating{.{ .func = "read_write_read", .mode = .release_fast, .size = .optimal_until_n_calls, .size_n = 3 }}
    ++ [_]Rating{.{ .func = "read_write_read", .mode = .release_small, .size = .optimal_until_n_calls, .size_n = 4 }}
    ++ b("runtime_read", .optimal, .optimal, null)
    ++ b("runtime_read_two", .optimal, .optimal_until_n_calls, 2)
    ++ b("runtime_write", .optimal, .optimal, null)
    ++ b("runtime_write_three", .optimal, .optimal_until_n_calls, 2)
    ++ b("runtime_write_two", .optimal, .optimal_until_n_calls, 2)
    ++ b("setup_timer_callback", .optimal, .optimal_until_n_calls, 2)
    ++ b("subscribe_callback", .optimal, .optimal_until_n_calls, 6)
    ++ b("subscribe_converted", .optimal, .optimal_until_n_calls, 2)
    ++ [_]Rating{.{ .func = "subscribe_converted_flag", .mode = .release_fast, .size = .optimal_until_n_calls, .size_n = 2 }}
    ++ [_]Rating{.{ .func = "subscribe_converted_flag", .mode = .release_small, .size = .optimal_until_n_calls, .size_n = 3 }}
    ++ b("tiny_modify", .optimal, .optimal, null)
    ++ b("tiny_read_all", .optimal, .optimal_until_n_calls, 2)
    ++ b("tiny_runtime_read", .optimal, .optimal, null)
    ++ b("tiny_runtime_write", .optimal, .optimal, null)
    ++ b("tiny_subscribe", .optimal, .optimal_until_n_calls, 6)
    ++ b("tiny_unsubscribe", .optimal, .optimal_until_n_calls, 6)
    ++ b("tiny_write_all", .optimal, .optimal_until_n_calls, 2)
    ++ [_]Rating{.{ .func = "triple_read_same_erd", .mode = .release_fast, .size = .optimal_until_n_calls, .size_n = 6 }}
    ++ [_]Rating{.{ .func = "triple_read_same_erd", .mode = .release_small }}
    ++ b("triple_write_increment", .optimal, .optimal_until_n_calls, 2)
    ++ b("unsubscribe_converted", .optimal, .optimal_until_n_calls, 3)
    ++ [_]Rating{.{ .func = "unsubscribe_converted_flag", .mode = .release_fast, .size = .optimal_until_n_calls, .size_n = 2 }}
    ++ [_]Rating{.{ .func = "unsubscribe_converted_flag", .mode = .release_small, .size = .optimal_until_n_calls, .size_n = 3 }}
    ++ b("wide_modify", .optimal, .optimal, null)
    ++ b("wide_read_all", .optimal, .optimal_until_n_calls, 2)
    ++ b("wide_runtime_read", .optimal, .optimal, null)
    ++ b("wide_runtime_write", .optimal, .optimal, null)
    ++ b("wide_subscribe", .optimal, .optimal_until_n_calls, 6)
    ++ b("wide_unsubscribe", .optimal, .optimal_until_n_calls, 6)
    ++ b("wide_write_all", .optimal, .optimal_until_n_calls, 2)
    ++ b("write_big_struct", .optimal, .optimal_until_n_calls, 2)
    ++ [_]Rating{.{ .func = "write_bool_with_subs", .mode = .release_fast, .size = .optimal_until_n_calls, .size_n = 2 }}
    ++ [_]Rating{.{ .func = "write_bool_with_subs", .mode = .release_small }}
    ++ b("write_junk_read_write", .optimal, .optimal_until_n_calls, 2)
    ++ b("write_ram_flag_with_converted_dep", .optimal, .optimal_until_n_calls, 2)
    ++ b("write_ram_no_converted_dep", .optimal, .optimal, null)
    ++ [_]Rating{.{ .func = "write_ram_with_converted_deps", .mode = .release_fast, .size = .optimal_until_n_calls, .size_n = 2 }}
    ++ [_]Rating{.{ .func = "write_ram_with_converted_deps", .mode = .release_small }}
    ++ b("write_then_read_converted", .optimal, .optimal_until_n_calls, 2)
    ++ [_]Rating{.{ .func = "write_triggering_callback", .mode = .release_fast, .size = .optimal_until_n_calls, .size_n = 2 }}
    ++ [_]Rating{.{ .func = "write_triggering_callback", .mode = .release_small, .size = .optimal_until_n_calls, .size_n = 3 }}
    ++ b("write_u16_no_subs", .optimal, .optimal, null)
    ++ [_]Rating{.{ .func = "write_u16_with_subs", .mode = .release_fast, .size = .optimal_until_n_calls, .size_n = 2 }}
    ++ [_]Rating{.{ .func = "write_u16_with_subs", .mode = .release_small }}
    ++ b("write_u32_no_subs", .optimal, .optimal_until_n_calls, 4)
;
// zig fmt: on

/// Free-form comments for functions with non-obvious codegen behavior.
pub const comments = [_]Comment{
    .{
        .func = "increment_n_times",
        .modes = &.{.release_small},
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
        .modes = &.{.release_fast},
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
        .modes = &.{.release_fast},
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
