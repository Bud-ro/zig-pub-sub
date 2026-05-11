read_all_component_types:
        push	rbp
        push	r14
        push	rbx
        sub	rsp, 16
        mov	rbx, rdi
        mov	ebp, dword ptr [rdi]
        lea	r14, [rsp + 8]
        mov	rdi, r14
        call	qword ptr [rbx + 72]
        add	ebp, dword ptr [r14]
        mov	rsi, qword ptr [rbx + 168]
        lea	r14, [rsp + 12]
        mov	rdi, r14
        call	qword ptr [rbx + 88]
        add	ebp, dword ptr [r14]
        mov	eax, ebp
        add	rsp, 16
        pop	rbx
        pop	r14
        pop	rbp
        ret

