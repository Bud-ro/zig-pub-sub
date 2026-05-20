increment_n_times:
        test	esi, esi
        je	.LBB318_2
        add	dword ptr [rdi], esi
.LBB318_2:
        ret

