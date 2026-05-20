mixed_read_all:
        push	r15
        push	r14
        push	r13
        push	r12
        push	rbx
        sub	rsp, 16
        mov	rbx, rdi
        mov	eax, dword ptr [rdi]
        movzx	r12d, word ptr [rdi + 4]
        add	r12, rax
        movzx	r15d, byte ptr [rdi + 6]
        and	r15d, 1
        add	r12, qword ptr [rdi + 7]
        lea	r14, [rsp + 8]
        mov	rdi, r14
        call	qword ptr [rbx + 104]
        mov	r13d, dword ptr [r14]
        add	r13, r15
        mov	rdi, r14
        call	qword ptr [rbx + 112]
        movzx	r15d, word ptr [r14]
        add	r15, r13
        mov	rsi, qword ptr [rbx + 208]
        mov	rdi, r14
        call	qword ptr [rbx + 120]
        mov	r13d, dword ptr [r14]
        add	r13, r15
        mov	rsi, qword ptr [rbx + 208]
        mov	rdi, r14
        call	qword ptr [rbx + 128]
        movzx	r15d, byte ptr [r14]
        add	r15, r13
        add	r15, r12
        mov	rsi, qword ptr [rbx + 208]
        mov	rdi, r14
        call	qword ptr [rbx + 136]
        add	r15, qword ptr [r14]
        mov	rax, r15
        add	rsp, 16
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        ret

