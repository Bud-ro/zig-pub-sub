conditional_write_chain:
        test	byte ptr [rdi + 4], 1
        jne	.LBB317_4
        cmp	word ptr [rdi + 5], 100
        ja	.LBB317_2
.LBB317_3:
        ret
.LBB317_4:
        add	dword ptr [rdi], 10
        cmp	word ptr [rdi + 5], 100
        jbe	.LBB317_3
.LBB317_2:
        add	dword ptr [rdi], 20
        ret

