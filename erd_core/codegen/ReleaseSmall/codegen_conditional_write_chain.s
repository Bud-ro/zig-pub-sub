codegen_conditional_write_chain:
        push	rbp
        mov	rbp, rsp
        test	byte ptr [rdi + 4], 1
        je	.LBB60_1
        add	dword ptr [rdi], 10
.LBB60_1:
        cmp	word ptr [rdi + 5], 100
        jbe	.LBB60_3
        add	dword ptr [rdi], 20
.LBB60_3:
        pop	rbp
        ret

