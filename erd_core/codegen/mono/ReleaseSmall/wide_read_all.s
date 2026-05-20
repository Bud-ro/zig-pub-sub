wide_read_all:
        movzx	eax, byte ptr [rdi]
        movzx	edx, word ptr [rdi + 1]
        add	rdx, rax
        mov	eax, dword ptr [rdi + 3]
        mov	ecx, dword ptr [rdi + 34]
        add	rax, rdx
        add	rax, qword ptr [rdi + 7]
        movsx	rdx, byte ptr [rdi + 15]
        movsx	rsi, word ptr [rdi + 16]
        add	rsi, rdx
        movsxd	rdx, dword ptr [rdi + 18]
        add	rdx, rsi
        add	rdx, rax
        add	rdx, qword ptr [rdi + 22]
        movzx	eax, byte ptr [rdi + 30]
        and	eax, 1
        movzx	esi, byte ptr [rdi + 31]
        add	rsi, rax
        movzx	eax, word ptr [rdi + 32]
        add	rax, rsi
        add	rcx, rax
        add	rcx, rdx
        add	rcx, qword ptr [rdi + 38]
        movsxd	rax, dword ptr [rdi + 46]
        movzx	edx, byte ptr [rdi + 50]
        and	edx, 1
        add	rdx, rax
        mov	eax, dword ptr [rdi + 51]
        add	rax, rdx
        add	rax, rcx
        ret

