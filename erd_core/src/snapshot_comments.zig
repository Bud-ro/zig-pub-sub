//! Annotations for assembly snapshot files.
//!
//! Each entry maps an exported function name to a comment that will be
//! prepended to the corresponding per-function assembly snapshot. Use this
//! to document known codegen quirks, intentional tradeoffs, or LLVM missed
//! optimizations so that future readers of the snapshots have context.
//!
//! The strip_asm tool reads this at build time and injects matching comments.

pub const Comment = struct {
    func: []const u8,
    text: []const u8,
};

pub const comments = [_]Comment{
    .{
        .func = "increment_n_times",
        .text =
        \\ReleaseFast collapses the loop to a single `add [rdi], esi`,
        \\but ReleaseSmall emits a literal inc-per-iteration loop.
        \\This is an LLVM missed optimization under -Oz -- the collapsed
        \\form is both smaller and faster. Not fixable from Zig without
        \\changing subscription semantics (one publish vs N publishes).
        ,
    },
};
