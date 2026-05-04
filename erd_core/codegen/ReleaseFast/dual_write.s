dual_write:
        mov	dword ptr [rdi], 42
        mov	dword ptr [rsi + 4], -1
        ret

