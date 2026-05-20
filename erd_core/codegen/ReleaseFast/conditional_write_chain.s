conditional_write_chain:
        test	byte ptr [rdi + 4], 1
        jne	.L0
        cmp	word ptr [rdi + 5], 100
        ja	.L1
.L2:
        ret
.L0:
        add	dword ptr [rdi], 10
        cmp	word ptr [rdi + 5], 100
        jbe	.L2
.L1:
        add	dword ptr [rdi], 20
        ret

