; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
timer_unpause:
        jmp	.Ltimer.TimerModule.unpause

; --- called functions ---

.Ltimer.TimerModule.unpause:
        push	r15
        push	r14
        push	rbx
        cmp	qword ptr [rsi + 8], 0
        je	.L0
        mov	rbx, rsi
        mov	r14, rdi
        add	rdi, 8
        lea	r15, [rsi + 16]
        mov	rsi, r15
        call	.Ltimer.TimerModule.tryRemove
        test	al, 1
        je	.L1
        mov	edx, dword ptr [rbx + 24]
        mov	rdi, r14
        mov	rsi, rbx
        pop	rbx
        pop	r14
        pop	r15
        jmp	.Ltimer.TimerModule.insertTimer
.L1:
        mov	rax, r14
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

