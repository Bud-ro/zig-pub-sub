read_bool:
        push	rbp
        mov	rbp, rsp
        mov	al, byte ptr [rdi + 4]
        pop	rbp
        ret

