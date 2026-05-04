read_modify_write_big:
        push	rbp
        mov	rbp, rsp
        inc	byte ptr [rdi]
        pop	rbp
        ret

