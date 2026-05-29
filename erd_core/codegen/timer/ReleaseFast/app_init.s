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
        mov	edx, 10
        call	timer.TimerModule.startPeriodic
        lea	rsi, [rbx + 32]
        mov	rdi, r14
        mov	edx, 20
        call	timer.TimerModule.startPeriodic
        lea	rsi, [rbx + 64]
        mov	rdi, r14
        mov	edx, 30
        call	timer.TimerModule.startPeriodic
        lea	rsi, [rbx + 96]
        mov	rdi, r14
        mov	edx, 40
        call	timer.TimerModule.startOneShot
        lea	rsi, [rbx + 128]
        mov	rdi, r14
        mov	edx, 50
        call	timer.TimerModule.startOneShot
        lea	rsi, [rbx + 160]
        mov	rdi, r14
        mov	edx, 60
        call	timer.TimerModule.startOneShot
        lea	rsi, [rbx + 192]
        mov	rdi, r14
        mov	edx, 70
        call	timer.TimerModule.startPeriodic
        add	rbx, 224
        mov	rdi, r14
        mov	rsi, rbx
        mov	edx, 80
        add	rsp, 8
        pop	rbx
        pop	r14
        jmp	timer.TimerModule.startOneShot

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

timer.TimerModule.startOneShot:
        cmp	qword ptr [rsi + 8], 0
        jne	.L1
        lea	rax, [rsi + 16]
        cmp	qword ptr [rdi], rax
        je	.L1
        mov	qword ptr [rsi + 8], offset codegen_timer.cb0
        mov	dword ptr [rsi + 28], edx
        mov	qword ptr [rsi], 0
        jmp	timer.TimerModule.insertTimer
.L1:
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
        mov	qword ptr [rsi], 0
        jmp	timer.TimerModule.insertTimer

