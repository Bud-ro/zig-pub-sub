read_ram_then_converted:
        push	r14
        push	rbx
        push	rax
        mov	rax, rdi
        mov	ebx, dword ptr [rdi]
        mov	rsi, qword ptr [rdi + 168]
        lea	r14, [rsp + 4]
        mov	rdi, r14
        call	qword ptr [rax + 88]
        add	ebx, dword ptr [r14]
        mov	eax, ebx
        add	rsp, 8
        pop	rbx
        pop	r14
        ret

