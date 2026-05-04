conditional_write_chain:
        push	rbp
        mov	rbp, rsp
        test	byte ptr [rdi + 4], 1
        jne	.LBB135_4
        cmp	word ptr [rdi + 5], 100
        ja	.LBB135_2
.LBB135_3:
        pop	rbp
        ret
.LBB135_4:
        add	dword ptr [rdi], 10
        cmp	word ptr [rdi + 5], 100
        jbe	.LBB135_3
.LBB135_2:
        add	dword ptr [rdi], 20
        pop	rbp
        ret

