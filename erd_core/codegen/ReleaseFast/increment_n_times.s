increment_n_times:
        push	rbp
        mov	rbp, rsp
        test	esi, esi
        je	.LBB134_2
        add	dword ptr [rdi], esi
.LBB134_2:
        pop	rbp
        ret

