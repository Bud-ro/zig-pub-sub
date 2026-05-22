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
pub const Mode = enum { release_fast, release_small, all };

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

/// Code size quality rating. The `until` variant means the inlined form is
/// smaller than a function call up to N call sites; beyond that threshold,
/// outlining into a shared function would save ROM.
pub const Size = union(enum) {
    optimal,
    until: u16,
    suboptimal,
};

/// Per-(function, mode) quality assessment.
pub const Rating = struct {
    func: []const u8,
    mode: Mode = .all,
    speed: Speed = .optimal,
    size: Size = .optimal,
};

/// Free-form comment attached to a function's snapshot file.
pub const Comment = struct {
    func: []const u8,
    modes: ?[]const Mode = null,
    text: []const u8,
};

// zig fmt: off

/// Quality ratings for every exported function in every optimization mode.
pub const ratings = [_]Rating{
    //                                                      mode                    speed                   size
    .{ .func = "conditional_write_chain",                                                                   .size = .{ .until = 2 }           },
    .{ .func = "cross_erd_compute",                                                                         .size = .{ .until = 2 }           },
    .{ .func = "cross_system_read_add",                                                                     .size = .{ .until = 2 }           },
    .{ .func = "cross_system_read_write",                                                                                                     },
    .{ .func = "cross_system_swap",                                                                         .size = .{ .until = 2 }           },
    .{ .func = "double_modify_struct",                                          .speed = .near_optimal, .size = .{ .until = 2 }           },
    .{ .func = "double_write_diff_values",                  .mode = .release_fast,  .speed = .near_optimal, .size = .{ .until = 2 }           },
    .{ .func = "double_write_diff_values",                  .mode = .release_small,                         .size = .{ .until = 2 }           },
    .{ .func = "double_write_same_value",                   .mode = .release_fast,  .speed = .near_optimal, .size = .{ .until = 2 }           },
    .{ .func = "double_write_same_value",                   .mode = .release_small,                         .size = .{ .until = 2 }           },
    .{ .func = "dual_read",                                                                                 .size = .{ .until = 3 }           },
    .{ .func = "dual_write",                                                                                .size = .{ .until = 2 }           },
    .{ .func = "increment_n_times",                         .mode = .release_fast,                          .size = .{ .until = 4 }           },
    .{ .func = "increment_n_times",                         .mode = .release_small, .speed = .suboptimal,   .size = .suboptimal               },
    .{ .func = "many_read_first",                                                                                                             },
    .{ .func = "many_read_last",                                                                                                              },
    .{ .func = "many_read_middle",                                                                                                            },
    .{ .func = "many_write_last_with_subs",                                                                 .size = .{ .until = 2 }           },
    .{ .func = "many_write_middle_no_subs",                                                                                                   },
    .{ .func = "mixed_modify",                                                  .speed = .near_optimal,                                       },
    .{ .func = "mixed_read_all",                                                                            .size = .{ .until = 2 }           },
    .{ .func = "mixed_runtime_read",                                                                                                          },
    .{ .func = "mixed_runtime_write",                                                                                                         },
    .{ .func = "mixed_subscribe_conv",                                                                      .size = .{ .until = 3 }           },
    .{ .func = "mixed_subscribe_ram",                                                                       .size = .{ .until = 3 }           },
    .{ .func = "mixed_unsubscribe_conv",                                                                    .size = .{ .until = 3 }           },
    .{ .func = "mixed_unsubscribe_ram",                                                                     .size = .{ .until = 6 }           },
    .{ .func = "mixed_write_ram",                                                                           .size = .{ .until = 2 }           },
    .{ .func = "modify_medium_no_subs",                                                                                                       },
    .{ .func = "modify_medium_single_field",                                        .speed = .near_optimal, .size = .{ .until = 2 }           },
    .{ .func = "modify_medium_two_fields",                                          .speed = .near_optimal, .size = .{ .until = 2 }           },
    .{ .func = "multi_runtime_read",                                                                                                          },
    .{ .func = "multi_runtime_write",                                                                                                         },
    .{ .func = "read_across_two_erds",                                                                      .size = .{ .until = 2 }           },
    .{ .func = "read_all_component_types",                                                                  .size = .{ .until = 2 }           },
    .{ .func = "read_big_struct",                                                                           .size = .{ .until = 2 }           },
    .{ .func = "read_bool",                                                                                                                   },
    .{ .func = "read_converted_both",                                                                       .size = .{ .until = 2 }           },
    .{ .func = "read_converted_flag_inv",                                                                   .size = .{ .until = 2 }           },
    .{ .func = "read_converted_sum",                                                                        .size = .{ .until = 2 }           },
    .{ .func = "read_indirect_both",                                                                        .size = .{ .until = 6 }           },
    .{ .func = "read_indirect_computed",                                                                                                      },
    .{ .func = "read_indirect_constant",                                                                    .size = .{ .until = 6 }           },
    .{ .func = "read_medium_struct",                                                                        .size = .{ .until = 2 }           },
    .{ .func = "read_modify_write_big",                                                                                                       },
    .{ .func = "read_ram_then_converted",                                                                   .size = .{ .until = 2 }           },
    .{ .func = "read_ram_then_indirect",                                                                    .size = .{ .until = 3 }           },
    .{ .func = "read_then_branch",                                                                          .size = .{ .until = 2 }           },
    .{ .func = "read_u16_unaligned",                                                                                                          },
    .{ .func = "read_u32",                                                                                                                    },
    .{ .func = "read_u32_after_big",                                                                        .size = .{ .until = 4 }           },
    .{ .func = "read_write_other_read",                                                                     .size = .{ .until = 2 }           },
    .{ .func = "read_write_read",                           .mode = .release_fast,                          .size = .{ .until = 3 }           },
    .{ .func = "read_write_read",                           .mode = .release_small,                         .size = .{ .until = 4 }           },
    .{ .func = "runtime_read",                                                                                                                },
    .{ .func = "runtime_read_two",                                                                          .size = .{ .until = 2 }           },
    .{ .func = "runtime_write",                                                                                                               },
    .{ .func = "runtime_write_three",                                                                       .size = .{ .until = 2 }           },
    .{ .func = "runtime_write_two",                                                                         .size = .{ .until = 2 }           },
    .{ .func = "setup_timer_callback",                                                                      .size = .{ .until = 2 }           },
    .{ .func = "subscribe_callback",                                                                        .size = .{ .until = 6 }           },
    .{ .func = "subscribe_converted",                                                                       .size = .{ .until = 2 }           },
    .{ .func = "subscribe_converted_flag",                  .mode = .release_fast,                          .size = .{ .until = 2 }           },
    .{ .func = "subscribe_converted_flag",                  .mode = .release_small,                         .size = .{ .until = 3 }           },
    .{ .func = "tiny_modify",                                                   .speed = .near_optimal,                                       },
    .{ .func = "tiny_read_all",                                                                             .size = .{ .until = 2 }           },
    .{ .func = "tiny_runtime_read",                                                                                                           },
    .{ .func = "tiny_runtime_write",                                                                                                          },
    .{ .func = "tiny_subscribe",                                                                            .size = .{ .until = 6 }           },
    .{ .func = "tiny_unsubscribe",                                                                          .size = .{ .until = 6 }           },
    .{ .func = "tiny_write_all",                                                                            .size = .{ .until = 2 }           },
    .{ .func = "triple_read_same_erd",                      .mode = .release_fast,                          .size = .{ .until = 6 }           },
    .{ .func = "triple_read_same_erd",                      .mode = .release_small,                                                           },
    .{ .func = "triple_write_increment",                                                                    .size = .{ .until = 2 }           },
    .{ .func = "unsubscribe_converted",                                                                     .size = .{ .until = 3 }           },
    .{ .func = "unsubscribe_converted_flag",                .mode = .release_fast,                          .size = .{ .until = 2 }           },
    .{ .func = "unsubscribe_converted_flag",                .mode = .release_small,                         .size = .{ .until = 3 }           },
    .{ .func = "wide_modify",                                                   .speed = .near_optimal,                                       },
    .{ .func = "wide_read_all",                                                                             .size = .{ .until = 2 }           },
    .{ .func = "wide_runtime_read",                                                                                                           },
    .{ .func = "wide_runtime_write",                                                                                                          },
    .{ .func = "wide_subscribe",                                                                            .size = .{ .until = 6 }           },
    .{ .func = "wide_unsubscribe",                                                                          .size = .{ .until = 6 }           },
    .{ .func = "wide_write_all",                                                                            .size = .{ .until = 2 }           },
    .{ .func = "write_big_struct",                                                                          .size = .{ .until = 2 }           },
    .{ .func = "write_bool_with_subs",                      .mode = .release_fast,                          .size = .{ .until = 2 }           },
    .{ .func = "write_bool_with_subs",                      .mode = .release_small,                                                           },
    .{ .func = "write_junk_read_write",                                                                     .size = .{ .until = 2 }           },
    .{ .func = "write_ram_flag_with_converted_dep",                                                         .size = .{ .until = 2 }           },
    .{ .func = "write_ram_no_converted_dep",                                                                                                  },
    .{ .func = "write_ram_with_converted_deps",             .mode = .release_fast,                          .size = .{ .until = 2 }           },
    .{ .func = "write_ram_with_converted_deps",             .mode = .release_small,                                                           },
    .{ .func = "write_then_read_converted",                                                                 .size = .{ .until = 2 }           },
    .{ .func = "write_triggering_callback",                 .mode = .release_fast,                          .size = .{ .until = 2 }           },
    .{ .func = "write_triggering_callback",                 .mode = .release_small,                         .size = .{ .until = 3 }           },
    .{ .func = "write_u16_no_subs",                                                                                                           },
    .{ .func = "write_u16_with_subs",                       .mode = .release_fast,                          .size = .{ .until = 2 }           },
    .{ .func = "write_u16_with_subs",                       .mode = .release_small,                                                           },
    .{ .func = "write_u32_no_subs",                                                                         .size = .{ .until = 4 }           },
};
// zig fmt: on

/// Free-form comments for functions with non-obvious codegen behavior.
///
/// Pattern key used in comments:
///   PER-ERD: monomorphized per ERD (offset/index hardcoded at comptime).
///            A type-specialized noinline function shared across all ERDs
///            of the same Zig type would be smaller at 2+ ERDs.
///   PER-TYPE: monomorphized per Zig type but shared across ERDs of that type.
///   SHARED: already uses a noinline function shared across ERD types.
pub const comments = [_]Comment{
    // ---- Speed issues ----
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
    .{
        .func = "mixed_modify",
        .text =
        \\modifyInner copies entire Pair (8 bytes) to stack, calls
        \\modifier via indirect call, copies back, unconditionally
        \\publishes. Ideal codegen would be `inc [rdi+15]` + publish.
        \\The indirect call blocks this. Also monomorphized per
        \\RamDataComponent (PER-ERD pattern at the component level).
        ,
    },
    .{
        .func = "tiny_modify",
        .text =
        \\Same modifyInner tradeoff as mixed_modify. Copies Pair
        \\to stack for a single field increment. Per-component
        \\monomorphized -- tiny/wide/mixed each get their own
        \\modifyInner despite identical logic.
        ,
    },
    .{
        .func = "wide_modify",
        .text =
        \\Same modifyInner tradeoff as mixed_modify.
        ,
    },
    .{
        .func = "double_modify_struct",
        .text =
        \\Two calls to shared modifyInner with different modifier
        \\lambdas. The indirect call prevents inlining either
        \\modifier. Copies 24-byte MediumStruct to stack each time.
        ,
    },
    // ---- Per-ERD monomorphization (write with subs) ----
    // Each subscribable write inlines compare+store+conditional-publish per
    // ERD. With 2+ ERDs of the same Zig type, a type-specialized noinline
    // write(sd, data_component_idx, val) would share the ~35 byte body and
    // cost ~8 bytes per call site instead of ~28-40 bytes inlined.
    // ReleaseSmall already outlines these via shared write helpers.
    .{
        .func = "write_bool_with_subs",
        .modes = &.{.release_fast},
        .text =
        \\PER-ERD: 40 bytes inlined. A per-type noinline write_bool
        \\would share the body across all bool ERDs with subs.
        ,
    },
    .{
        .func = "write_u16_with_subs",
        .modes = &.{.release_fast},
        .text =
        \\PER-ERD: 36 bytes inlined. Same per-type opportunity as
        \\write_bool_with_subs but for u16 ERDs.
        ,
    },
    .{
        .func = "write_triggering_callback",
        .modes = &.{.release_fast},
        .text =
        \\PER-ERD: 36 bytes inlined (writes constant true to a bool
        \\ERD). Would share body with write_bool_with_subs if per-type.
        ,
    },
    .{
        .func = "write_ram_with_converted_deps",
        .modes = &.{.release_fast},
        .text =
        \\PER-ERD: 28 bytes inlined. Write to a u32 RAM ERD whose
        \\converted dependents recompute on change. Per-type u32
        \\write would share the compare+store+publish body.
        ,
    },
    .{
        .func = "write_ram_flag_with_converted_dep",
        .modes = &.{.release_fast},
        .text =
        \\PER-ERD: 40 bytes inlined. Bool write with converted
        \\dependency subscription. Same per-type opportunity as
        \\write_bool_with_subs.
        ,
    },
    .{
        .func = "many_write_last_with_subs",
        .text =
        \\PER-ERD: 28 bytes. Writes a u64 at a fixed offset in a
        \\32-ERD system. Per-type u64 write would share the body.
        ,
    },
    // ---- Per-ERD monomorphization (compound writes) ----
    // These functions do multiple writes, each inlined per-ERD. The total
    // cost is N * per-write-cost. Per-type writes would reduce each write
    // to ~8 bytes (call + idx arg) instead of 28-40 bytes inlined.
    .{
        .func = "cross_erd_compute",
        .text =
        \\PER-ERD: reads two ERDs, computes sum, writes result.
        \\The write portion (compare+store+publish) is per-ERD
        \\inlined. Per-type write would shrink the write half.
        ,
    },
    .{
        .func = "cross_system_swap",
        .text =
        \\PER-ERD: swaps values between two SystemData instances.
        \\The subscribable write is per-ERD inlined at 35 bytes.
        ,
    },
    .{
        .func = "read_write_other_read",
        .modes = &.{.release_fast},
        .text =
        \\PER-ERD: 58 bytes. Read + write + read with inlined
        \\compare+store+publish for the write portion.
        ,
    },
    .{
        .func = "write_then_read_converted",
        .text =
        \\PER-ERD: write inlined + converted read inlined. Both
        \\halves are per-ERD monomorphized.
        ,
    },
    .{
        .func = "conditional_write_chain",
        .text =
        \\PER-ERD: two conditional writes to different ERDs, both
        \\inlined with hardcoded offsets.
        ,
    },
    // ---- Per-ERD monomorphization (reads >5 bytes) ----
    // These reads are per-ERD (offset hardcoded) and >5 bytes. For struct
    // reads, a per-type read with offset lookup would be smaller at 2+ ERDs.
    // For converted reads, the compute function is unique per ERD so
    // per-type sharing is not possible -- but runtimeRead provides a fully
    // shared alternative at the cost of an indirect call.
    .{
        .func = "read_big_struct",
        .text =
        \\PER-ERD: copies 256 bytes from a hardcoded offset via
        \\memcpy/rep movsb. runtimeRead would share the copy logic.
        ,
    },
    .{
        .func = "read_medium_struct",
        .text =
        \\PER-ERD: copies 24 bytes via movups+mov from hardcoded
        \\offset. Per-type or runtimeRead would share the body.
        ,
    },
    .{
        .func = "read_converted_sum",
        .text =
        \\PER-ERD: compute function inlined (two loads + add).
        \\Cannot be per-type shared since each converted ERD has
        \\a unique compute function. runtimeRead is the shared
        \\alternative (indirect call through function pointer table).
        ,
    },
    .{
        .func = "read_converted_flag_inv",
        .text =
        \\PER-ERD: compute function inlined (load + compare).
        \\Same tradeoff as read_converted_sum.
        ,
    },
    .{
        .func = "read_converted_both",
        .text =
        \\PER-ERD: two converted reads inlined. Each has a unique
        \\compute function so per-type sharing is not possible.
        ,
    },
    .{
        .func = "read_all_component_types",
        .text =
        \\PER-ERD: reads from RAM + indirect + converted, all
        \\inlined. The indirect read is constant-folded.
        ,
    },
    .{
        .func = "read_ram_then_converted",
        .text =
        \\PER-ERD: RAM read (1 instruction) + converted read
        \\(inlined compute function). The converted portion
        \\cannot be per-type shared.
        ,
    },
    // ---- Mono: per-ERD patterns in the stress test ----
    .{
        .func = "tiny_write_all",
        .text =
        \\PER-ERD: 3 writes (u32+bool+Pair), each inlined with
        \\compare+store+conditional-publish. Per-type writes would
        \\reduce from ~86 bytes to ~3*8 + shared bodies.
        ,
    },
    .{
        .func = "wide_write_all",
        .text =
        \\PER-ERD: 9 subscribable writes inlined at 358 bytes
        \\(ReleaseFast). This is the worst-case for per-ERD
        \\monomorphization. Per-type writes would save ~250 bytes.
        ,
    },
    .{
        .func = "mixed_write_ram",
        .text =
        \\PER-ERD: 4 RAM writes (u32+u16+bool+u64), each inlined.
        \\3 have subs and get compare+store+publish. Per-type writes
        \\would share bodies across the 3 subscribable types.
        ,
    },
};
