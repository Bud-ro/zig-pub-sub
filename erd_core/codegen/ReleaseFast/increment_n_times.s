increment_n_times:
        test	esi, esi
        je	.LBB311_2
        add	dword ptr [rdi], esi
.LBB311_2:
        ret

