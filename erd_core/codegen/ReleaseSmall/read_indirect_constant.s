read_indirect_constant:
        push	rbx
        sub	rsp, 16
        mov	rax, rdi
        lea	rbx, [rsp + 12]
        mov	rdi, rbx
        call	qword ptr [rax + 72]
        mov	eax, dword ptr [rbx]
        add	rsp, 16
        pop	rbx
        ret

