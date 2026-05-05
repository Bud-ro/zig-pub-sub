cross_system_read_write:
        mov	eax, dword ptr [rsi]
        mov	dword ptr [rdi], eax
        ret

