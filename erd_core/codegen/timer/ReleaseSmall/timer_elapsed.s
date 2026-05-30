; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
timer_elapsed:
        push	rbx
        cmp	qword ptr [rsi + 8], 0
        je	.L0
        mov	ebx, dword ptr [rsi + 28]
        call	.Ltimer.TimerModule.remainingTicks
        sub	ebx, eax
        jmp	.L1
.L0:
        xor	ebx, ebx
.L1:
        mov	eax, ebx
        pop	rbx
        ret

; --- called functions ---

.Ltimer.TimerModule.remainingTicks:
        cmp	qword ptr [rsi + 8], 0
        je	.L2
        lea	rax, [rdi + 8]
        lea	rcx, [rsi + 16]
.L3:
        mov	rax, qword ptr [rax]
        test	rax, rax
        je	.L4
        cmp	rax, rcx
        jne	.L3
.L4:
        test	rax, rax
        je	.L5
        mov	eax, dword ptr [rsi + 24]
        ret
.L2:
        xor	eax, eax
        ret
.L5:
        mov	eax, dword ptr [rdi + 16]
        mov	ecx, dword ptr [rsi + 24]
        sub	ecx, eax
        xor	eax, eax
        cmp	ecx, -65535
        cmovb	eax, ecx
        ret

