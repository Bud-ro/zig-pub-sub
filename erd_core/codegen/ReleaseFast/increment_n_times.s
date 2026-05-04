increment_n_times:
        test	esi, esi
        je	.LBB15_2
        add	dword ptr [rdi], esi
.LBB15_2:
        ret

