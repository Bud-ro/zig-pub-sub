read_converted_both:
        push	rbp
        push	rbx
        push	rax
        mov	rbx, rdi
        mov	rsi, qword ptr [rdi + 168]
        lea	rdi, [rsp + 4]
        call	qword ptr [rbx + 88]
        mov	ebp, dword ptr [rsp + 4]
        mov	rsi, qword ptr [rbx + 168]
        lea	rdi, [rsp + 3]
        call	qword ptr [rbx + 96]
        movzx	eax, byte ptr [rsp + 3]
        add	eax, ebp
        add	rsp, 8
        pop	rbx
        pop	rbp
        ret

