read_indirect_both:
        push	rbp
        push	rbx
        push	rax
        mov	rbx, rdi
        lea	rdi, [rsp + 4]
        call	qword ptr [rbx + 72]
        mov	ebp, dword ptr [rsp + 4]
        lea	rdi, [rsp + 2]
        call	qword ptr [rbx + 80]
        movzx	eax, word ptr [rsp + 2]
        add	eax, ebp
        add	rsp, 8
        pop	rbx
        pop	rbp
        ret

