codegen_read_bool:
        push	rbp
        mov	rbp, rsp
        movzx	eax, byte ptr [rdi + 4]
        and	al, 1
        pop	rbp
        ret

