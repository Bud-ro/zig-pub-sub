conditional_write_chain:
        test	byte ptr [rdi + 4], 1
        jne	.LBB311_4
        cmp	word ptr [rdi + 5], 100
        ja	.LBB311_2
.LBB311_3:
        ret
.LBB311_4:
        add	dword ptr [rdi], 10
        cmp	word ptr [rdi + 5], 100
        jbe	.LBB311_3
.LBB311_2:
        add	dword ptr [rdi], 20
        ret

