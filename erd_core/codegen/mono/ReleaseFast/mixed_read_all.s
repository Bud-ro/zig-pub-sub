mixed_read_all:
        mov	eax, dword ptr [rdi]
        movzx	ecx, word ptr [rdi + 4]
        add	rcx, rax
        movzx	eax, byte ptr [rdi + 6]
        and	eax, 1
        mov	rdx, qword ptr [rdi + 208]
        mov	esi, dword ptr [rdx]
        movzx	r8d, word ptr [rdx + 4]
        add	r8d, esi
        add	rcx, qword ptr [rdi + 7]
        add	rax, rsi
        add	rax, rcx
        cmp	rsi, 101
        sbb	rax, -1
        add	rax, qword ptr [rdx + 7]
        add	rax, r8
        add	rax, 48921
        ret

