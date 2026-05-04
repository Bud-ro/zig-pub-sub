read_big_struct:
        mov	rax, rdi
        mov	ecx, 256
        rep movsb es:[rdi], [rsi]
        ret

