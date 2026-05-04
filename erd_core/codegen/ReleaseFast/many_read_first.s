many_read_first:
        push	rbp
        mov	rbp, rsp
        movzx	eax, byte ptr [rdi]
        pop	rbp
        ret

