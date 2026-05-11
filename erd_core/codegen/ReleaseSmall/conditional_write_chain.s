conditional_write_chain:
        test	byte ptr [rdi + 4], 1
        je	.LBB304_1
        add	dword ptr [rdi], 10
.LBB304_1:
        cmp	word ptr [rdi + 5], 100
        jbe	.LBB304_3
        add	dword ptr [rdi], 20
.LBB304_3:
        ret

