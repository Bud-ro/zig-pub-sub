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
        push	61
        pop	rsi
        mov	edi, offset .L__anon_0
        call	.Ldebug.defaultPanic

