codegen_read_write_read:
        push	rbp
        mov	rbp, rsp
        mov	eax, dword ptr [rdi]
        add	eax, 1
        mov	dword ptr [rdi], eax
        pop	rbp
        ret

