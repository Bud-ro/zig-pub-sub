read_indirect_constant:
        push	rax
        mov	rax, rdi
        lea	rdi, [rsp + 4]
        call	qword ptr [rax + 72]
        mov	eax, dword ptr [rsp + 4]
        pop	rcx
        ret

