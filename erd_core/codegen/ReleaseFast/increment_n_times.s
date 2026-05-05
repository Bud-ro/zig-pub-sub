increment_n_times:
        test	esi, esi
        je	.LBB18_2
        add	dword ptr [rdi], esi
.LBB18_2:
        ret

