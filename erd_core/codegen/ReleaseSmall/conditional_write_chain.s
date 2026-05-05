conditional_write_chain:
        test	byte ptr [rdi + 4], 1
        je	.LBB17_1
        add	dword ptr [rdi], 10
.LBB17_1:
        cmp	word ptr [rdi + 5], 100
        jbe	.LBB17_3
        add	dword ptr [rdi], 20
.LBB17_3:
        ret

