codegen_cross_system_read_write:
        push	rbp
        mov	rbp, rsp
        mov	eax, dword ptr [rsi]
        mov	dword ptr [rdi], eax
        pop	rbp
        ret

