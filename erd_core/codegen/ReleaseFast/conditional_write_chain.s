conditional_write_chain:
        push	rbp
        mov	rbp, rsp
        test	byte ptr [rdi + 4], 1
        jne	.LBB14_4
        cmp	word ptr [rdi + 5], 100
        ja	.LBB14_2
.LBB14_3:
        pop	rbp
        ret
.LBB14_4:
        add	dword ptr [rdi], 10
        cmp	word ptr [rdi + 5], 100
        jbe	.LBB14_3
.LBB14_2:
        add	dword ptr [rdi], 20
        pop	rbp
        ret

