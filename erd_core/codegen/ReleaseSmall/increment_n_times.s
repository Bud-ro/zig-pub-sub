increment_n_times:
.LBB311_1:
        cmp	esi, 1
        jb	.LBB311_3
        inc	dword ptr [rdi]
        dec	esi
        jmp	.LBB311_1
.LBB311_3:
        ret

