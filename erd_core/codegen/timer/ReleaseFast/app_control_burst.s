; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
;
app_control_burst:
        push	r15
        push	r14
        push	rbx
        mov	rbx, rsi
        mov	r14, rdi
        mov	edx, 10
        call	timer.TimerModule.startPeriodic
        mov	rdi, r14
        mov	rsi, rbx
        call	timer.TimerModule.pause
        mov	rdi, r14
        mov	rsi, rbx
        call	timer.TimerModule.unpause
        lea	r15, [rbx + 32]
        mov	rdi, r14
        mov	rsi, r15
        mov	edx, 20
        call	timer.TimerModule.startOneShot
        mov	rdi, r14
        mov	rsi, r15
        call	timer.TimerModule.stop
        lea	r15, [rbx + 64]
        mov	rdi, r14
        mov	rsi, r15
        mov	edx, 30
        call	timer.TimerModule.startPeriodic
        add	rbx, 96
        mov	rdi, r14
        mov	rsi, rbx
        mov	edx, 40
        call	timer.TimerModule.startOneShot
        mov	rdi, r14
        mov	rsi, r15
        call	timer.TimerModule.stop
        mov	rdi, r14
        mov	rsi, rbx
        pop	rbx
        pop	r14
        pop	r15
        jmp	timer.TimerModule.stop

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

timer.TimerModule.pause:
        push	r15
        push	r14
        push	rbx
        cmp	qword ptr [rsi + 8], 0
        je	.L1
        mov	rbx, rsi
        mov	r14, rdi
        lea	r15, [rsi + 16]
        mov	rsi, r15
        call	timer.TimerModule.tryRemove
        test	al, 1
        je	.L2
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
.L2:
        lea	rax, [r14 + 8]
.L3:
        mov	rax, qword ptr [rax]
        test	rax, rax
        je	.L4
        cmp	rax, r15
        jne	.L3
.L4:
        test	rax, rax
        je	.L5
.L1:
        pop	rbx
        pop	r14
        pop	r15
        ret
.L5:
        mov	rdi, r14
        mov	rsi, rbx
        pop	rbx
        pop	r14
        pop	r15
        jmp	timer.TimerModule.isRunning

timer.TimerModule.unpause:
        push	r15
        push	r14
        push	rbx
        cmp	qword ptr [rsi + 8], 0
        je	.L6
        mov	rbx, rsi
        mov	r14, rdi
        add	rdi, 8
        lea	r15, [rsi + 16]
        mov	rsi, r15
        call	timer.TimerModule.tryRemove
        test	al, 1
        je	.L7
        mov	edx, dword ptr [rbx + 24]
        mov	rdi, r14
        mov	rsi, rbx
        pop	rbx
        pop	r14
        pop	r15
        jmp	timer.TimerModule.insertTimer
.L7:
        mov	rax, r14
.L8:
        mov	rax, qword ptr [rax]
        test	rax, rax
        je	.L9
        cmp	rax, r15
        jne	.L8
.L9:
        test	rax, rax
        je	.L10
.L6:
        pop	rbx
        pop	r14
        pop	r15
        ret
.L10:
        mov	rdi, r14
        mov	rsi, rbx
        pop	rbx
        pop	r14
        pop	r15
        jmp	timer.TimerModule.isRunning

timer.TimerModule.startOneShot:
        cmp	qword ptr [rsi + 8], 0
        jne	.L11
        lea	rax, [rsi + 16]
        cmp	qword ptr [rdi], rax
        je	.L11
        mov	qword ptr [rsi + 8], offset codegen_timer.cb0
        mov	dword ptr [rsi + 28], edx
        mov	qword ptr [rsi], 0
        jmp	timer.TimerModule.insertTimer
.L11:
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

timer.TimerModule.stop:
        and	byte ptr [rsi], -2
        cmp	qword ptr [rsi + 8], 0
        jne	timer.TimerModule.removeTimer
        ret

