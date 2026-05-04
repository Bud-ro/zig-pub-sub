codegen_cross_system_read_add:
        push	rbp
        mov	rbp, rsp
        mov	eax, dword ptr [rdi]
        movsxd	rcx, dword ptr [rsi]
        add	rcx, rax
        movzx	edx, word ptr [rdi + 5]
        movsxd	rax, dword ptr [rsi + 4]
        add	rax, rdx
        add	rax, rcx
        pop	rbp
        ret

