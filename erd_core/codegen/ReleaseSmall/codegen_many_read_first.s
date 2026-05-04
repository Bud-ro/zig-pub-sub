codegen_many_read_first:
        push	rbp
        mov	rbp, rsp
        mov	al, byte ptr [rdi]
        pop	rbp
        ret

