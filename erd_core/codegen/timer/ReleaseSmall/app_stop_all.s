; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
;
app_stop_all:
        push	r14
        push	rbx
        push	rax
        mov	rbx, rsi
        mov	r14, rdi
        call	.Ltimer.TimerModule.stop
        lea	rsi, [rbx + 32]
        mov	rdi, r14
        call	.Ltimer.TimerModule.stop
        lea	rsi, [rbx + 64]
        mov	rdi, r14
        call	.Ltimer.TimerModule.stop
        lea	rsi, [rbx + 96]
        mov	rdi, r14
        call	.Ltimer.TimerModule.stop
        lea	rsi, [rbx + 128]
        mov	rdi, r14
        call	.Ltimer.TimerModule.stop
        lea	rsi, [rbx + 160]
        mov	rdi, r14
        call	.Ltimer.TimerModule.stop
        lea	rsi, [rbx + 192]
        mov	rdi, r14
        call	.Ltimer.TimerModule.stop
        add	rbx, 224
        mov	rdi, r14
        mov	rsi, rbx
        add	rsp, 8
        pop	rbx
        pop	r14
        jmp	.Ltimer.TimerModule.stop

; --- called functions ---

.Ltimer.TimerModule.stop:
        and	byte ptr [rsi], -2
        cmp	qword ptr [rsi + 8], 0
        jne	.Ltimer.TimerModule.removeTimer
        ret

