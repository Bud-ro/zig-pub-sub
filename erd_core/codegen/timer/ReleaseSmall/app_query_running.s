; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
;
app_query_running:
        push	r15
        push	r14
        push	rbx
        mov	rbx, rdx
        mov	r14, rsi
        mov	r15, rdi
        call	.Ltimer.TimerModule.isRunning
        and	al, 1
        mov	byte ptr [rbx], al
        lea	rsi, [r14 + 32]
        mov	rdi, r15
        call	.Ltimer.TimerModule.isRunning
        and	al, 1
        mov	byte ptr [rbx + 1], al
        lea	rsi, [r14 + 64]
        mov	rdi, r15
        call	.Ltimer.TimerModule.isRunning
        and	al, 1
        mov	byte ptr [rbx + 2], al
        lea	rsi, [r14 + 96]
        mov	rdi, r15
        call	.Ltimer.TimerModule.isRunning
        and	al, 1
        mov	byte ptr [rbx + 3], al
        lea	rsi, [r14 + 128]
        mov	rdi, r15
        call	.Ltimer.TimerModule.isRunning
        and	al, 1
        mov	byte ptr [rbx + 4], al
        lea	rsi, [r14 + 160]
        mov	rdi, r15
        call	.Ltimer.TimerModule.isRunning
        and	al, 1
        mov	byte ptr [rbx + 5], al
        lea	rsi, [r14 + 192]
        mov	rdi, r15
        call	.Ltimer.TimerModule.isRunning
        and	al, 1
        mov	byte ptr [rbx + 6], al
        add	r14, 224
        mov	rdi, r15
        mov	rsi, r14
        call	.Ltimer.TimerModule.isRunning
        and	al, 1
        mov	byte ptr [rbx + 7], al
        pop	rbx
        pop	r14
        pop	r15
        ret

; --- called functions ---

.Ltimer.TimerModule.isRunning:
        add	rsi, 16
        mov	rcx, rdi
.L0:
        mov	rcx, qword ptr [rcx]
        test	rcx, rcx
        je	.L1
        cmp	rcx, rsi
        jne	.L0
.L1:
        mov	al, 1
        test	rcx, rcx
        jne	.L2
        add	rdi, 8
.L3:
        mov	rdi, qword ptr [rdi]
        test	rdi, rdi
        setne	al
        je	.L2
        cmp	rdi, rsi
        jne	.L3
.L2:
        ret

