conditional_write_chain:
        test	byte ptr [rdi + 4], 1
        je	.LBB310_1
        add	dword ptr [rdi], 10
.LBB310_1:
        cmp	word ptr [rdi + 5], 100
        jbe	.LBB310_3
        add	dword ptr [rdi], 20
.LBB310_3:
        ret

