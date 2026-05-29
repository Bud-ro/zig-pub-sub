; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
;
app_query_remaining:
        push	r15
        push	r14
        push	rbx
        mov	rbx, rdx
        mov	r14, rsi
        mov	r15, rdi
        call	.Ltimer.TimerModule.remainingTicks
        mov	dword ptr [rbx], eax
        lea	rsi, [r14 + 32]
        mov	rdi, r15
        call	.Ltimer.TimerModule.remainingTicks
        mov	dword ptr [rbx + 4], eax
        lea	rsi, [r14 + 64]
        mov	rdi, r15
        call	.Ltimer.TimerModule.remainingTicks
        mov	dword ptr [rbx + 8], eax
        lea	rsi, [r14 + 96]
        mov	rdi, r15
        call	.Ltimer.TimerModule.remainingTicks
        mov	dword ptr [rbx + 12], eax
        lea	rsi, [r14 + 128]
        mov	rdi, r15
        call	.Ltimer.TimerModule.remainingTicks
        mov	dword ptr [rbx + 16], eax
        lea	rsi, [r14 + 160]
        mov	rdi, r15
        call	.Ltimer.TimerModule.remainingTicks
        mov	dword ptr [rbx + 20], eax
        lea	rsi, [r14 + 192]
        mov	rdi, r15
        call	.Ltimer.TimerModule.remainingTicks
        mov	dword ptr [rbx + 24], eax
        add	r14, 224
        mov	rdi, r15
        mov	rsi, r14
        call	.Ltimer.TimerModule.remainingTicks
        mov	dword ptr [rbx + 28], eax
        pop	rbx
        pop	r14
        pop	r15
        ret

; --- called functions ---

.Ltimer.TimerModule.remainingTicks:
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

