increment_n_times:
        push	rbp
        mov	rbp, rsp
        test	esi, esi
        je	.LBB15_2
        add	dword ptr [rdi], esi
.LBB15_2:
        pop	rbp
        ret

