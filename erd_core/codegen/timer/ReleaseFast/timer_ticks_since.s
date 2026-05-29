; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
timer_ticks_since:
        push	rax
        lea	rax, [rdi + 8]
        lea	rcx, [rsi + 16]
.L0:
        mov	rax, qword ptr [rax]
        test	rax, rax
        je	.L1
        cmp	rax, rcx
        jne	.L0
.L1:
        test	rax, rax
        jne	.L2
        mov	ecx, dword ptr [rsi + 28]
        sub	ecx, dword ptr [rsi + 24]
        mov	eax, dword ptr [rdi + 16]
        add	eax, ecx
        pop	rcx
        ret
.L2:
        mov	edi, offset __anon_0
        mov	esi, 61
        call	debug.defaultPanic

