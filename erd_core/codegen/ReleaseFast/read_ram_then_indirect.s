read_ram_then_indirect:
        push	rbx
        sub	rsp, 16
        mov	rax, rdi
        mov	ebx, dword ptr [rdi]
        lea	rdi, [rsp + 12]
        call	qword ptr [rax + 72]
        add	ebx, dword ptr [rsp + 12]
        mov	eax, ebx
        add	rsp, 16
        pop	rbx
        ret

