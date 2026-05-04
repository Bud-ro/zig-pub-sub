codegen_read_big_struct:
        push	rbp
        mov	rbp, rsp
        mov	rax, rdi
        mov	ecx, 256
        rep movsb es:[rdi], [rsi]
        pop	rbp
        ret

