; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 2 calls)
;
wide_read_all:
        movzx	eax, byte ptr [rdi]
        movzx	edx, word ptr [rdi + 2]
        add	rdx, rax
        mov	eax, dword ptr [rdi + 4]
        mov	ecx, dword ptr [rdi + 36]
        add	rax, rdx
        add	rax, qword ptr [rdi + 8]
        movsx	rdx, byte ptr [rdi + 16]
        movsx	rsi, word ptr [rdi + 18]
        add	rsi, rdx
        movsxd	rdx, dword ptr [rdi + 20]
        add	rdx, rsi
        add	rdx, rax
        add	rdx, qword ptr [rdi + 24]
        movzx	eax, byte ptr [rdi + 32]
        and	eax, 1
        movzx	esi, byte ptr [rdi + 33]
        add	rsi, rax
        movzx	eax, word ptr [rdi + 34]
        add	rax, rsi
        add	rcx, rax
        add	rcx, rdx
        add	rcx, qword ptr [rdi + 40]
        movsxd	rax, dword ptr [rdi + 48]
        movzx	edx, byte ptr [rdi + 52]
        and	edx, 1
        add	rdx, rax
        mov	eax, dword ptr [rdi + 56]
        add	rax, rdx
        add	rax, rcx
        ret

