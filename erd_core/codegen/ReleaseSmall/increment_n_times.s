increment_n_times:
.LBB305_1:
        cmp	esi, 1
        jb	.LBB305_3
        inc	dword ptr [rdi]
        dec	esi
        jmp	.LBB305_1
.LBB305_3:
        ret

