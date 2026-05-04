dual_write:
        push	rbp
        mov	rbp, rsp
        mov	dword ptr [rdi], 42
        or	dword ptr [rsi + 4], -1
        pop	rbp
        ret

