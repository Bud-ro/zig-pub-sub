; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
; 8 starts -> 8 calls to shared startPeriodic/startOneShot (was 1812 bytes of inlined copies in RF).
;
app_init:
        push	r14
        push	rbx
        push	rax
        mov	rbx, rsi
        mov	r14, rdi
        push	10
        pop	rdx
        call	.Ltimer.TimerModule.startPeriodic
        lea	rsi, [rbx + 32]
        push	20
        pop	rdx
        mov	rdi, r14
        call	.Ltimer.TimerModule.startPeriodic
        lea	rsi, [rbx + 64]
        push	30
        pop	rdx
        mov	rdi, r14
        call	.Ltimer.TimerModule.startPeriodic
        lea	rsi, [rbx + 96]
        push	40
        pop	rdx
        mov	rdi, r14
        call	.Ltimer.TimerModule.startOneShot
        lea	rsi, [rbx + 128]
        push	50
        pop	rdx
        mov	rdi, r14
        call	.Ltimer.TimerModule.startOneShot
        lea	rsi, [rbx + 160]
        push	60
        pop	rdx
        mov	rdi, r14
        call	.Ltimer.TimerModule.startOneShot
        lea	rsi, [rbx + 192]
        push	70
        pop	rdx
        mov	rdi, r14
        call	.Ltimer.TimerModule.startPeriodic
        add	rbx, 224
        push	80
        pop	rdx
        mov	rdi, r14
        mov	rsi, rbx
        add	rsp, 8
        pop	rbx
        pop	r14
        jmp	.Ltimer.TimerModule.startOneShot

; --- called functions ---

.Ltimer.TimerModule.startPeriodic:
        cmp	qword ptr [rsi + 8], 0
        jne	.L0
        lea	rax, [rsi + 16]
        cmp	qword ptr [rdi], rax
        je	.L0
        mov	qword ptr [rsi + 8], offset .Lcodegen_timer.cb0
        mov	dword ptr [rsi + 28], edx
        mov	qword ptr [rsi], 1
        jmp	.Ltimer.TimerModule.insertTimer
.L0:
        push	rbp
        push	r14
        push	rbx
        mov	rbx, rdi
        mov	r14, rsi
        mov	ebp, edx
        call	.Ltimer.TimerModule.removeTimer
        mov	rdi, rbx
        mov	rsi, r14
        mov	edx, ebp
        pop	rbx
        pop	r14
        pop	rbp
        mov	qword ptr [rsi + 8], offset .Lcodegen_timer.cb0
        mov	dword ptr [rsi + 28], edx
        mov	qword ptr [rsi], 1
        jmp	.Ltimer.TimerModule.insertTimer

.Ltimer.TimerModule.startOneShot:
        cmp	qword ptr [rsi + 8], 0
        jne	.L1
        lea	rax, [rsi + 16]
        cmp	qword ptr [rdi], rax
        je	.L1
        mov	qword ptr [rsi + 8], offset .Lcodegen_timer.cb0
        mov	dword ptr [rsi + 28], edx
        mov	qword ptr [rsi], 0
        jmp	.Ltimer.TimerModule.insertTimer
.L1:
        push	rbp
        push	r14
        push	rbx
        mov	rbx, rdi
        mov	r14, rsi
        mov	ebp, edx
        call	.Ltimer.TimerModule.removeTimer
        mov	rdi, rbx
        mov	rsi, r14
        mov	edx, ebp
        pop	rbx
        pop	r14
        pop	rbp
        mov	qword ptr [rsi + 8], offset .Lcodegen_timer.cb0
        mov	dword ptr [rsi + 28], edx
        mov	qword ptr [rsi], 0
        jmp	.Ltimer.TimerModule.insertTimer

