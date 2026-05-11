read_all_component_types:
        push	rbp
        push	rbx
        push	rax
        mov	rbx, rdi
        mov	ebp, dword ptr [rdi]
        mov	rdi, rsp
        call	qword ptr [rbx + 72]
        add	ebp, dword ptr [rsp]
        mov	rsi, qword ptr [rbx + 168]
        lea	rdi, [rsp + 4]
        call	qword ptr [rbx + 88]
        add	ebp, dword ptr [rsp + 4]
        mov	eax, ebp
        add	rsp, 8
        pop	rbx
        pop	rbp
        ret

