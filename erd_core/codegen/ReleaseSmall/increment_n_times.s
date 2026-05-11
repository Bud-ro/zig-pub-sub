increment_n_times:
.LBB304_1:
        cmp	esi, 1
        jb	.LBB304_3
        inc	dword ptr [rdi]
        dec	esi
        jmp	.LBB304_1
.LBB304_3:
        ret

