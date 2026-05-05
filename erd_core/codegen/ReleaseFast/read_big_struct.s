read_big_struct:
        push	rbx
        mov	rbx, rdi
        mov	edx, 256
        call	memcpy@PLT
        mov	rax, rbx
        pop	rbx
        ret

