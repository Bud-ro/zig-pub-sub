; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 2 calls)
;
setup_timer_callback:
        mov	rax, rdi
        mov	rdi, rsi
        mov	rsi, rdx
        mov	rdx, rax
        jmp	timer.TimerModule.startPeriodic

; --- called functions ---

timer.TimerModule.startPeriodic:
        push	r15
        push	r14
        push	rbx
        mov	rbx, rdx
        cmp	qword ptr [rsi + 8], 0
        jne	.L0
        lea	rax, [rsi + 16]
        cmp	qword ptr [rdi], rax
        jne	.L1
.L0:
        mov	r14, rdi
        mov	r15, rsi
        call	timer.TimerModule.removeTimer
        mov	rdi, r14
        mov	rsi, r15
.L1:
        mov	qword ptr [rsi + 8], offset codegen_harness.timer_callback_read_write
        mov	dword ptr [rsi + 28], 100
        or	rbx, 1
        mov	qword ptr [rsi], rbx
        pop	rbx
        pop	r14
        pop	r15
        jmp	timer.TimerModule.insertTimer

