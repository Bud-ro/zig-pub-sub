read_bool:
        push	rbp
        mov	rbp, rsp
        movzx	eax, byte ptr [rdi + 4]
        pop	rbp
        ret

