increment_n_times:
.LBB20_1:
        cmp	esi, 1
        jb	.LBB20_3
        inc	dword ptr [rdi]
        dec	esi
        jmp	.LBB20_1
.LBB20_3:
        ret

