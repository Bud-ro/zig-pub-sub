read_ram_then_converted:
        push	rbx
        sub	rsp, 16
        mov	rax, rdi
        mov	ebx, dword ptr [rdi]
        mov	rsi, qword ptr [rdi + 168]
        lea	rdi, [rsp + 12]
        call	qword ptr [rax + 88]
        add	ebx, dword ptr [rsp + 12]
        mov	eax, ebx
        add	rsp, 16
        pop	rbx
        ret

