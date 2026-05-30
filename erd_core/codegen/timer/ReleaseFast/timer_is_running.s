; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
timer_is_running:
        jmp	timer.TimerModule.isRunning

; --- called functions ---

timer.TimerModule.isRunning:
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

