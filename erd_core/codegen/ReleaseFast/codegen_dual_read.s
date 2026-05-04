codegen_dual_read:
        push	rbp
        mov	rbp, rsp
        mov	ecx, dword ptr [rdi]
        movsxd	rax, dword ptr [rsi]
        add	rax, rcx
        pop	rbp
        ret

