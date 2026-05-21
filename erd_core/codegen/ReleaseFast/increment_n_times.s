; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
increment_n_times:
        test	esi, esi
        je	.L0
        add	dword ptr [rdi], esi
.L0:
        ret

