codegen_read_bool:
        push	rbp
        mov	rbp, rsp
        mov	al, byte ptr [rdi + 4]
        and	al, 1
        pop	rbp
        ret

