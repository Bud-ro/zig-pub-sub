conditional_write_chain:
        test	byte ptr [rdi + 4], 1
        jne	.LBB14_4
        cmp	word ptr [rdi + 5], 100
        ja	.LBB14_2
.LBB14_3:
        ret
.LBB14_4:
        add	dword ptr [rdi], 10
        cmp	word ptr [rdi + 5], 100
        jbe	.LBB14_3
.LBB14_2:
        add	dword ptr [rdi], 20
        ret

