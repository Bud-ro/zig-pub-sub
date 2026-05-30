; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
timer_remaining:
        jmp	timer.TimerModule.remainingTicks

; --- called functions ---

timer.TimerModule.remainingTicks:
        cmp	qword ptr [rsi + 8], 0
        je	.L0
        lea	rax, [rdi + 8]
        lea	rcx, [rsi + 16]
.L1:
        mov	rax, qword ptr [rax]
        test	rax, rax
        je	.L2
        cmp	rax, rcx
        jne	.L1
.L2:
        test	rax, rax
        je	.L3
        mov	eax, dword ptr [rsi + 24]
        ret
.L0:
        xor	eax, eax
        ret
.L3:
        mov	eax, dword ptr [rdi + 16]
        mov	ecx, dword ptr [rsi + 24]
        sub	ecx, eax
        xor	eax, eax
        cmp	ecx, -65535
        cmovb	eax, ecx
        ret

