increment_n_times:
.L0:
        cmp	esi, 1
        jb	.L1
        inc	dword ptr [rdi]
        dec	esi
        jmp	.L0
.L1:
        ret

