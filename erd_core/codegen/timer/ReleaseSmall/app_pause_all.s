; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
;
app_pause_all:
        push	r14
        push	rbx
        push	rax
        mov	rbx, rsi
        mov	r14, rdi
        call	.Ltimer.TimerModule.pause
        lea	rsi, [rbx + 32]
        mov	rdi, r14
        call	.Ltimer.TimerModule.pause
        lea	rsi, [rbx + 64]
        mov	rdi, r14
        call	.Ltimer.TimerModule.pause
        lea	rsi, [rbx + 96]
        mov	rdi, r14
        call	.Ltimer.TimerModule.pause
        lea	rsi, [rbx + 128]
        mov	rdi, r14
        call	.Ltimer.TimerModule.pause
        lea	rsi, [rbx + 160]
        mov	rdi, r14
        call	.Ltimer.TimerModule.pause
        lea	rsi, [rbx + 192]
        mov	rdi, r14
        call	.Ltimer.TimerModule.pause
        add	rbx, 224
        mov	rdi, r14
        mov	rsi, rbx
        add	rsp, 8
        pop	rbx
        pop	r14
        jmp	.Ltimer.TimerModule.pause

; --- called functions ---

.Ltimer.TimerModule.pause:
        push	r15
        push	r14
        push	rbx
        cmp	qword ptr [rsi + 8], 0
        je	.L0
        mov	rbx, rsi
        mov	r14, rdi
        lea	r15, [rsi + 16]
        mov	rsi, r15
        call	.Ltimer.TimerModule.tryRemove
        test	al, 1
        je	.L1
        mov	eax, dword ptr [r14 + 16]
        mov	ecx, dword ptr [rbx + 24]
        sub	ecx, eax
        xor	eax, eax
        cmp	ecx, -65535
        cmovb	eax, ecx
        mov	dword ptr [rbx + 24], eax
        mov	rax, qword ptr [r14 + 8]
        mov	qword ptr [rbx + 16], rax
        mov	qword ptr [r14 + 8], r15
        pop	rbx
        pop	r14
        pop	r15
        ret
.L1:
        lea	rax, [r14 + 8]
.L2:
        mov	rax, qword ptr [rax]
        test	rax, rax
        je	.L3
        cmp	rax, r15
        jne	.L2
.L3:
        test	rax, rax
        je	.L4
.L0:
        pop	rbx
        pop	r14
        pop	r15
        ret
.L4:
        mov	rdi, r14
        mov	rsi, rbx
        pop	rbx
        pop	r14
        pop	r15
        jmp	.Ltimer.TimerModule.isRunning

