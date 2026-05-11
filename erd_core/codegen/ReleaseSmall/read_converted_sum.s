read_converted_sum:
        push	rbx
        sub	rsp, 16
        mov	rax, rdi
        mov	rsi, qword ptr [rdi + 168]
        lea	rbx, [rsp + 12]
        mov	rdi, rbx
        call	qword ptr [rax + 88]
        mov	eax, dword ptr [rbx]
        add	rsp, 16
        pop	rbx
        ret

