increment_n_times:
        test	esi, esi
        je	.LBB312_2
        add	dword ptr [rdi], esi
.LBB312_2:
        ret

