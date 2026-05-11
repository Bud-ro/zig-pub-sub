read_indirect_computed:
        push	rbx
        sub	rsp, 16
        mov	rax, rdi
        lea	rbx, [rsp + 14]
        mov	rdi, rbx
        call	qword ptr [rax + 80]
        movzx	eax, word ptr [rbx]
        add	rsp, 16
        pop	rbx
        ret

