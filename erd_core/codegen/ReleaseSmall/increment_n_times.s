increment_n_times:
.LBB18_1:
        cmp	esi, 1
        jb	.LBB18_3
        inc	dword ptr [rdi]
        dec	esi
        jmp	.LBB18_1
.LBB18_3:
        ret

