; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
timer_elapsed:
        cmp	qword ptr [rsi + 8], 0
        je	.L0
        push	rbx
        mov	ebx, dword ptr [rsi + 28]
        call	timer.TimerModule.remainingTicks
        mov	ecx, eax
        mov	eax, ebx
        sub	eax, ecx
        pop	rbx
        ret
.L0:
        xor	eax, eax
        ret

; --- called functions ---

timer.TimerModule.remainingTicks:
        cmp	qword ptr [rsi + 8], 0
        je	.L1
        lea	rax, [rdi + 8]
        lea	rcx, [rsi + 16]
.L2:
        mov	rax, qword ptr [rax]
        test	rax, rax
        je	.L3
        cmp	rax, rcx
        jne	.L2
.L3:
        test	rax, rax
        je	.L4
        mov	eax, dword ptr [rsi + 24]
        ret
.L1:
        xor	eax, eax
        ret
.L4:
        mov	eax, dword ptr [rdi + 16]
        mov	ecx, dword ptr [rsi + 24]
        sub	ecx, eax
        xor	eax, eax
        cmp	ecx, -65535
        cmovb	eax, ecx
        ret

