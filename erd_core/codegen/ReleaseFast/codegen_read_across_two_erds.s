codegen_read_across_two_erds:
        push	rbp
        mov	rbp, rsp
        mov	eax, dword ptr [rdi]
        movzx	ecx, word ptr [rdi + 5]
        lea	eax, [rcx + 2*rax]
        pop	rbp
        ret

