conditional_write_chain:
        test	byte ptr [rdi + 4], 1
        jne	.LBB310_4
        cmp	word ptr [rdi + 5], 100
        ja	.LBB310_2
.LBB310_3:
        ret
.LBB310_4:
        add	dword ptr [rdi], 10
        cmp	word ptr [rdi + 5], 100
        jbe	.LBB310_3
.LBB310_2:
        add	dword ptr [rdi], 20
        ret

