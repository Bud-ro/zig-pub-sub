conditional_write_chain:
        test	byte ptr [rdi + 4], 1
        jne	.LBB17_4
        cmp	word ptr [rdi + 5], 100
        ja	.LBB17_2
.LBB17_3:
        ret
.LBB17_4:
        add	dword ptr [rdi], 10
        cmp	word ptr [rdi + 5], 100
        jbe	.LBB17_3
.LBB17_2:
        add	dword ptr [rdi], 20
        ret

