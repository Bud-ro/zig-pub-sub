read_modify_write_big:
        push	rbp
        mov	rbp, rsp
        add	byte ptr [rdi], 1
        pop	rbp
        ret

