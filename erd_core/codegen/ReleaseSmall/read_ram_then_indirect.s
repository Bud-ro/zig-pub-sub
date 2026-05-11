read_ram_then_indirect:
        push	r14
        push	rbx
        push	rax
        mov	rax, rdi
        mov	ebx, dword ptr [rdi]
        lea	r14, [rsp + 4]
        mov	rdi, r14
        call	qword ptr [rax + 72]
        add	ebx, dword ptr [r14]
        mov	eax, ebx
        add	rsp, 8
        pop	rbx
        pop	r14
        ret

