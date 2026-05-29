; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
; Tail call into shared, noinline startPeriodic (was 196 bytes inlined in RF).
;
timer_start_periodic:
        mov	edx, 100
        jmp	timer.TimerModule.startPeriodic

; --- called functions ---

timer.TimerModule.startPeriodic:
        cmp	qword ptr [rsi + 8], 0
        jne	.L0
        lea	rax, [rsi + 16]
        cmp	qword ptr [rdi], rax
        je	.L0
        mov	qword ptr [rsi + 8], offset codegen_timer.cb0
        mov	dword ptr [rsi + 28], edx
        mov	qword ptr [rsi], 1
        jmp	timer.TimerModule.insertTimer
.L0:
        push	rbp
        push	r14
        push	rbx
        mov	rbx, rdi
        mov	r14, rsi
        mov	ebp, edx
        call	timer.TimerModule.removeTimer
        mov	rdi, rbx
        mov	rsi, r14
        mov	edx, ebp
        pop	rbx
        pop	r14
        pop	rbp
        mov	qword ptr [rsi + 8], offset codegen_timer.cb0
        mov	dword ptr [rsi + 28], edx
        mov	qword ptr [rsi], 1
        jmp	timer.TimerModule.insertTimer

