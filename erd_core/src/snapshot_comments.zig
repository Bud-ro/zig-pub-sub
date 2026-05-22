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
    .{ .func = "cross_erd_compute",                                                 .speed = .near_optimal, .size = .{ .until = 2 }           },
    .{ .func = "cross_system_read_add",                                                                     .size = .{ .until = 2 }           },
    .{ .func = "cross_system_read_write",                                                                                                     },
    .{ .func = "cross_system_swap",                                                 .speed = .near_optimal, .size = .{ .until = 2 }           },
    .{ .func = "double_modify_struct",                                              .speed = .near_optimal, .size = .{ .until = 2 }           },
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
    .{ .func = "many_write_last_with_subs",                                         .speed = .near_optimal, .size = .{ .until = 2 }           },
    .{ .func = "many_write_middle_no_subs",                                                                                                   },
    .{ .func = "mixed_modify",                                                      .speed = .near_optimal,                                   },
    .{ .func = "mixed_read_all",                                                                            .size = .{ .until = 2 }           },
    .{ .func = "mixed_runtime_read",                                                                                                          },
    .{ .func = "mixed_runtime_write",                                               .speed = .near_optimal,                                   },
    .{ .func = "mixed_subscribe_conv",                                                                      .size = .{ .until = 3 }           },
    .{ .func = "mixed_subscribe_ram",                                                                       .size = .{ .until = 3 }           },
    .{ .func = "mixed_unsubscribe_conv",                                                                    .size = .{ .until = 3 }           },
    .{ .func = "mixed_unsubscribe_ram",                                                                     .size = .{ .until = 6 }           },
    .{ .func = "mixed_write_ram",                                                   .speed = .near_optimal, .size = .{ .until = 2 }           },
    .{ .func = "modify_medium_no_subs",                                                                                                       },
    .{ .func = "modify_medium_single_field",                                        .speed = .near_optimal, .size = .{ .until = 2 }           },
    .{ .func = "modify_medium_two_fields",                                          .speed = .near_optimal, .size = .{ .until = 2 }           },
    .{ .func = "multi_runtime_read",                                                                                                          },
    .{ .func = "multi_runtime_write",                                               .speed = .near_optimal,                                   },
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
    .{ .func = "read_write_other_read",                                             .speed = .near_optimal, .size = .{ .until = 2 }           },
    .{ .func = "read_write_read",                           .mode = .release_fast,                          .size = .{ .until = 3 }           },
    .{ .func = "read_write_read",                           .mode = .release_small,                         .size = .{ .until = 4 }           },
    .{ .func = "runtime_read",                                                                                                                },
    .{ .func = "runtime_read_two",                                                                          .size = .{ .until = 2 }           },
    .{ .func = "runtime_write",                                                     .speed = .near_optimal,                                   },
    .{ .func = "runtime_write_three",                                               .speed = .near_optimal, .size = .{ .until = 2 }           },
    .{ .func = "runtime_write_two",                                                 .speed = .near_optimal, .size = .{ .until = 2 }           },
    .{ .func = "setup_timer_callback",                                                                      .size = .{ .until = 2 }           },
    .{ .func = "subscribe_callback",                                                                        .size = .{ .until = 6 }           },
    .{ .func = "subscribe_converted",                                                                       .size = .{ .until = 2 }           },
    .{ .func = "subscribe_converted_flag",                  .mode = .release_fast,                          .size = .{ .until = 2 }           },
    .{ .func = "subscribe_converted_flag",                  .mode = .release_small,                         .size = .{ .until = 3 }           },
    .{ .func = "tiny_modify",                                                       .speed = .near_optimal,                                   },
    .{ .func = "tiny_read_all",                                                                             .size = .{ .until = 2 }           },
    .{ .func = "tiny_runtime_read",                                                                                                           },
    .{ .func = "tiny_runtime_write",                                                .speed = .near_optimal,                                   },
    .{ .func = "tiny_subscribe",                                                                            .size = .{ .until = 6 }           },
    .{ .func = "tiny_unsubscribe",                                                                          .size = .{ .until = 6 }           },
    .{ .func = "tiny_write_all",                                                    .speed = .near_optimal, .size = .{ .until = 2 }           },
    .{ .func = "triple_read_same_erd",                      .mode = .release_fast,                          .size = .{ .until = 6 }           },
    .{ .func = "triple_read_same_erd",                      .mode = .release_small,                                                           },
    .{ .func = "triple_write_increment",                                            .speed = .near_optimal, .size = .{ .until = 2 }           },
    .{ .func = "unsubscribe_converted",                                                                     .size = .{ .until = 3 }           },
    .{ .func = "unsubscribe_converted_flag",                .mode = .release_fast,                          .size = .{ .until = 2 }           },
    .{ .func = "unsubscribe_converted_flag",                .mode = .release_small,                         .size = .{ .until = 3 }           },
    .{ .func = "wide_modify",                                                       .speed = .near_optimal,                                   },
    .{ .func = "wide_read_all",                                                                             .size = .{ .until = 2 }           },
    .{ .func = "wide_runtime_read",                                                                                                           },
    .{ .func = "wide_runtime_write",                                                .speed = .near_optimal,                                   },
    .{ .func = "wide_subscribe",                                                                            .size = .{ .until = 6 }           },
    .{ .func = "wide_unsubscribe",                                                                          .size = .{ .until = 6 }           },
    .{ .func = "wide_write_all",                                                    .speed = .near_optimal, .size = .{ .until = 2 }           },
    .{ .func = "write_big_struct",                                                                          .size = .{ .until = 2 }           },
    .{ .func = "write_bool_with_subs",                      .mode = .release_fast,  .speed = .near_optimal, .size = .{ .until = 2 }           },
    .{ .func = "write_bool_with_subs",                      .mode = .release_small, .speed = .near_optimal,},
    .{ .func = "write_junk_read_write",                                             .speed = .near_optimal, .size = .{ .until = 2 }           },
    .{ .func = "write_ram_flag_with_converted_dep",                                 .speed = .near_optimal, .size = .{ .until = 2 }           },
    .{ .func = "write_ram_no_converted_dep",                                                                                                  },
    .{ .func = "write_ram_with_converted_deps",             .mode = .release_fast,  .speed = .near_optimal, .size = .{ .until = 2 }           },
    .{ .func = "write_ram_with_converted_deps",             .mode = .release_small, .speed = .near_optimal,},
    .{ .func = "write_then_read_converted",                                         .speed = .near_optimal, .size = .{ .until = 2 }           },
    .{ .func = "write_triggering_callback",                 .mode = .release_fast,  .speed = .near_optimal, .size = .{ .until = 2 }           },
    .{ .func = "write_triggering_callback",                 .mode = .release_small, .speed = .near_optimal, .size = .{ .until = 3 }           },
    .{ .func = "write_u16_no_subs",                                                                                                           },
    .{ .func = "write_u16_with_subs",                       .mode = .release_fast,  .speed = .near_optimal, .size = .{ .until = 2 }           },
    .{ .func = "write_u16_with_subs",                       .mode = .release_small, .speed = .near_optimal,},
    .{ .func = "write_u32_no_subs",                                                                         .size = .{ .until = 4 }           },
};
// zig fmt: on

/// Free-form comments for functions with non-obvious codegen behavior.
///
/// Pattern key used in comments:
///   PER-ERD:    monomorphized per ERD (offset/index hardcoded at comptime).
///               A type-specialized noinline function shared across all ERDs
///               of the same Zig type would be smaller at 2+ ERDs.
///   NOINLINE-PUB: calls through the noinline Subscription.publish chain.
///               See the "Subscription.publish noinline analysis" comment
///               below for the full cost breakdown.
// zig fmt: off
pub const comments = [_]Comment{
    // ==================================================================
    // Subscription.publish noinline analysis
    //
    // Every write/modify that triggers subscribers goes through this chain:
    //   call RamDataComponent.publish  (noinline, per-DataComponent)
    //     jmp Subscription.publish     (noinline, single shared copy)
    //       call rax                   (indirect call to subscriber)
    //
    // On a simple in-order micro (no branch predictor), this costs:
    //   ~10 instructions  RamDataComponent.publish trampoline (table lookups)
    //   ~5 cycles         jmp to Subscription.publish (pipeline flush)
    //   ~13 instructions  Subscription.publish prologue/epilogue (6 push + 7 pop)
    //   ~3 instructions   loop setup
    //   Per subscriber slot: ~13 instructions + ~10 cycles branch/call flushes
    //
    // Total for 1 subscriber: ~55 cycles. Inlining Subscription.publish
    // into each RamDataComponent.publish would save ~18 cycles (~33%) by
    // eliminating the jmp + prologue/epilogue, at a cost of ~80 bytes per
    // DataComponent instantiation (~320 bytes at 5 components).
    //
    // Decision: keep noinline for code size. The ~18 cycle penalty is
    // acceptable for embedded pub-sub where publish is not the hot loop.
    //
    // Note: publish vs publish.2 in the snapshots are two distinct
    // RamDataComponent monomorphizations whose pretty-printed Zig names
    // collide (the type printer collapses ERD arrays to `.{ ... }`), so
    // LLVM's MC layer appends `.2` to disambiguate. They are different
    // functions operating on different DataComponent layouts.
    //
    // Functions tagged NOINLINE-PUB below go through this chain.
    // ==================================================================

    // ---- LLVM-specific speed issues ----
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
        \\NOINLINE-PUB + LLVM reload: after the first publish call,
        \\LLVM conservatively reloads the stored value because it
        \\cannot prove publish did not mutate it through the opaque
        \\publisher pointer.
        ,
    },
    .{
        .func = "double_write_diff_values",
        .modes = &.{.release_fast},
        .text =
        \\NOINLINE-PUB + LLVM reload: same root cause as
        \\double_write_same_value.
        ,
    },
    // ---- NOINLINE-PUB: single-write functions ----
    .{ .func = "write_bool_with_subs",              .modes = &.{.release_fast}, .text = "NOINLINE-PUB. PER-ERD: 40 bytes inlined."           },
    .{ .func = "write_u16_with_subs",               .modes = &.{.release_fast}, .text = "NOINLINE-PUB. PER-ERD: 36 bytes inlined."           },
    .{ .func = "write_triggering_callback",         .modes = &.{.release_fast}, .text = "NOINLINE-PUB. PER-ERD: 36 bytes inlined."           },
    .{ .func = "write_ram_with_converted_deps",     .modes = &.{.release_fast}, .text = "NOINLINE-PUB. PER-ERD: 28 bytes inlined."           },
    .{ .func = "write_ram_flag_with_converted_dep", .modes = &.{.release_fast}, .text = "NOINLINE-PUB. PER-ERD: 40 bytes inlined."           },
    .{ .func = "many_write_last_with_subs",                                     .text = "NOINLINE-PUB. PER-ERD: 28 bytes."                   },
    .{ .func = "cross_erd_compute",                                             .text = "NOINLINE-PUB. PER-ERD write portion."               },
    .{ .func = "cross_system_swap",                                             .text = "NOINLINE-PUB. PER-ERD: 35 bytes for the subscribable write." },
    .{ .func = "read_write_other_read",             .modes = &.{.release_fast}, .text = "NOINLINE-PUB. PER-ERD: 58 bytes, write portion inlined." },
    .{ .func = "write_then_read_converted",                                     .text = "NOINLINE-PUB. PER-ERD write + converted read inlined." },
    .{ .func = "write_junk_read_write",                                         .text = "NOINLINE-PUB. PER-ERD: two writes, junk read eliminated." },
    .{ .func = "triple_write_increment",                                        .text = "NOINLINE-PUB. PER-ERD: three writes."               },
    .{ .func = "modify_medium_single_field",                                    .text = "NOINLINE-PUB. In-place modify + unconditional publish." },
    .{ .func = "modify_medium_two_fields",                                      .text = "NOINLINE-PUB. In-place modify + unconditional publish." },
    .{ .func = "double_modify_struct",                                          .text = "NOINLINE-PUB. Two in-place modifies, each publishes." },
    .{ .func = "runtime_write",                                                 .text = "NOINLINE-PUB. Shared runtime dispatch path."        },
    .{ .func = "runtime_write_two",                                             .text = "NOINLINE-PUB. Two runtime writes."                  },
    .{ .func = "runtime_write_three",                                           .text = "NOINLINE-PUB. Three runtime writes."                },
    .{ .func = "multi_runtime_write",                                           .text = "NOINLINE-PUB. Multi-component runtime write."       },
    // ---- NOINLINE-PUB: mono stress test ----
    .{ .func = "tiny_write_all",                                                .text = "NOINLINE-PUB. PER-ERD: 3 writes inlined."           },
    .{ .func = "tiny_modify",                                                   .text = "NOINLINE-PUB. In-place modify."                     },
    .{ .func = "tiny_runtime_write",                                            .text = "NOINLINE-PUB. Shared runtime dispatch path."        },
    .{ .func = "wide_write_all",                                                .text = "NOINLINE-PUB. PER-ERD: 9 subscribable writes, 358 bytes RF." },
    .{ .func = "wide_modify",                                                   .text = "NOINLINE-PUB. In-place modify."                     },
    .{ .func = "wide_runtime_write",                                            .text = "NOINLINE-PUB. Shared runtime dispatch path."        },
    .{ .func = "mixed_write_ram",                                               .text = "NOINLINE-PUB. PER-ERD: 4 writes, 3 with subs."      },
    .{ .func = "mixed_modify",                                                  .text = "NOINLINE-PUB. In-place modify."                     },
    .{ .func = "mixed_runtime_write",                                           .text = "NOINLINE-PUB. Shared runtime dispatch path."        },
    // ---- Per-ERD reads >5 bytes ----
    .{ .func = "read_big_struct",                                               .text = "PER-ERD: 256-byte copy. runtimeRead would share the logic." },
    .{ .func = "read_medium_struct",                                            .text = "PER-ERD: 24-byte copy. runtimeRead would share the logic." },
    .{ .func = "read_converted_sum",                                            .text = "PER-ERD: compute inlined. Cannot per-type share (unique fn)." },
    .{ .func = "read_converted_flag_inv",                                       .text = "PER-ERD: compute inlined. Same tradeoff as read_converted_sum." },
    .{ .func = "read_converted_both",                                           .text = "PER-ERD: two converted reads, each unique compute function." },
    .{ .func = "read_all_component_types",                                      .text = "PER-ERD: RAM + indirect (const-folded) + converted inlined." },
    .{ .func = "read_ram_then_converted",                                       .text = "PER-ERD: RAM load + converted compute inlined."     },
};
// zig fmt: on
