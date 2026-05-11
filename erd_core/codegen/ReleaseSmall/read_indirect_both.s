read_indirect_both:
        push	rbp
        push	r14
        push	rbx
        sub	rsp, 16
        mov	rbx, rdi
        lea	r14, [rsp + 12]
        mov	rdi, r14
        call	qword ptr [rbx + 72]
        mov	ebp, dword ptr [r14]
        lea	r14, [rsp + 10]
        mov	rdi, r14
        call	qword ptr [rbx + 80]
        movzx	eax, word ptr [r14]
        add	eax, ebp
        add	rsp, 16
        pop	rbx
        pop	r14
        pop	rbp
        ret

