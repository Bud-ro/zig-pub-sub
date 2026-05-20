; This comment can be modified at snapshot_comments.zig
; ReleaseFast collapses the loop to a single `add [rdi], esi`,
; but ReleaseSmall emits a literal inc-per-iteration loop.
; This is an LLVM missed optimization under -Oz -- the collapsed
; form is both smaller and faster. Not fixable from Zig without
; changing subscription semantics (one publish vs N publishes).
;
increment_n_times:
        test	esi, esi
        je	.L0
        add	dword ptr [rdi], esi
.L0:
        ret

