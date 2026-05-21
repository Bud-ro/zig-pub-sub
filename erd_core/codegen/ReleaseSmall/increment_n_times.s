; snapshot_comments.zig
; Speed: Suboptimal | Local Size: Suboptimal | Global Size: Optimal
; ReleaseFast collapses the loop to a single `add [rdi], esi`,
; but ReleaseSmall emits a literal inc-per-iteration loop.
; This is an LLVM missed optimization under -Oz -- the collapsed
; form is both smaller and faster. Not fixable from Zig without
; changing subscription semantics (one publish vs N publishes).
;
increment_n_times:
.L0:
        cmp	esi, 1
        jb	.L1
        inc	dword ptr [rdi]
        dec	esi
        jmp	.L0
.L1:
        ret

