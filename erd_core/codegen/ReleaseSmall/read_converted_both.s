read_converted_both:
        push	rbp
        push	r14
        push	rbx
        sub	rsp, 16
        mov	rbx, rdi
        mov	rsi, qword ptr [rdi + 168]
        lea	r14, [rsp + 12]
        mov	rdi, r14
        call	qword ptr [rbx + 88]
        mov	ebp, dword ptr [r14]
        mov	rsi, qword ptr [rbx + 168]
        lea	r14, [rsp + 11]
        mov	rdi, r14
        call	qword ptr [rbx + 96]
        movzx	eax, byte ptr [r14]
        add	eax, ebp
        add	rsp, 16
        pop	rbx
        pop	r14
        pop	rbp
        ret

