triple_read_same_erd:
        push	rbp
        mov	rbp, rsp
        mov	eax, dword ptr [rdi]
        lea	eax, [rax + 2*rax]
        pop	rbp
        ret

