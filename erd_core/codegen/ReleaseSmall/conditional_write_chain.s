conditional_write_chain:
        test	byte ptr [rdi + 4], 1
        je	.LBB19_1
        add	dword ptr [rdi], 10
.LBB19_1:
        cmp	word ptr [rdi + 5], 100
        jbe	.LBB19_3
        add	dword ptr [rdi], 20
.LBB19_3:
        ret

