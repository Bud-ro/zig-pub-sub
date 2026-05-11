read_converted_flag_inv:
        push	rbx
        sub	rsp, 16
        mov	rax, rdi
        mov	rsi, qword ptr [rdi + 168]
        lea	rbx, [rsp + 15]
        mov	rdi, rbx
        call	qword ptr [rax + 96]
        mov	al, byte ptr [rbx]
        add	rsp, 16
        pop	rbx
        ret

