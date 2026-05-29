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

run_until_idle:
        push	rbx
        mov	rbx, rdi
.LBB11_1:
        mov	rdi, rbx
        call	timer.TimerModule.run
        test	al, 1
        jne	.LBB11_1
        pop	rbx
        ret

app_query_running:
        push	r15
        push	r14
        push	rbx
        mov	rbx, rdx
        mov	r14, rsi
        mov	r15, rdi
        call	timer.TimerModule.isRunning
        and	al, 1
        mov	byte ptr [rbx], al
        lea	rsi, [r14 + 32]
        mov	rdi, r15
        call	timer.TimerModule.isRunning
        and	al, 1
        mov	byte ptr [rbx + 1], al
        lea	rsi, [r14 + 64]
        mov	rdi, r15
        call	timer.TimerModule.isRunning
        and	al, 1
        mov	byte ptr [rbx + 2], al
        lea	rsi, [r14 + 96]
        mov	rdi, r15
        call	timer.TimerModule.isRunning
        and	al, 1
        mov	byte ptr [rbx + 3], al
        lea	rsi, [r14 + 128]
        mov	rdi, r15
        call	timer.TimerModule.isRunning
        and	al, 1
        mov	byte ptr [rbx + 4], al
        lea	rsi, [r14 + 160]
        mov	rdi, r15
        call	timer.TimerModule.isRunning
        and	al, 1
        mov	byte ptr [rbx + 5], al
        lea	rsi, [r14 + 192]
        mov	rdi, r15
        call	timer.TimerModule.isRunning
        and	al, 1
        mov	byte ptr [rbx + 6], al
        add	r14, 224
        mov	rdi, r15
        mov	rsi, r14
        call	timer.TimerModule.isRunning
        and	al, 1
        mov	byte ptr [rbx + 7], al
        pop	rbx
        pop	r14
        pop	r15
        ret

app_query_remaining:
        push	r15
        push	r14
        push	rbx
        mov	rbx, rdx
        mov	r14, rsi
        mov	r15, rdi
        call	timer.TimerModule.remainingTicks
        mov	dword ptr [rbx], eax
        lea	rsi, [r14 + 32]
        mov	rdi, r15
        call	timer.TimerModule.remainingTicks
        mov	dword ptr [rbx + 4], eax
        lea	rsi, [r14 + 64]
        mov	rdi, r15
        call	timer.TimerModule.remainingTicks
        mov	dword ptr [rbx + 8], eax
        lea	rsi, [r14 + 96]
        mov	rdi, r15
        call	timer.TimerModule.remainingTicks
        mov	dword ptr [rbx + 12], eax
        lea	rsi, [r14 + 128]
        mov	rdi, r15
        call	timer.TimerModule.remainingTicks
        mov	dword ptr [rbx + 16], eax
        lea	rsi, [r14 + 160]
        mov	rdi, r15
        call	timer.TimerModule.remainingTicks
        mov	dword ptr [rbx + 20], eax
        lea	rsi, [r14 + 192]
        mov	rdi, r15
        call	timer.TimerModule.remainingTicks
        mov	dword ptr [rbx + 24], eax
        add	r14, 224
        mov	rdi, r15
        mov	rsi, r14
        call	timer.TimerModule.remainingTicks
        mov	dword ptr [rbx + 28], eax
        pop	rbx
        pop	r14
        pop	r15
        ret

app_unpause_all:
        push	r14
        push	rbx
        push	rax
        mov	rbx, rsi
        mov	r14, rdi
        call	timer.TimerModule.unpause
        lea	rsi, [rbx + 32]
        mov	rdi, r14
        call	timer.TimerModule.unpause
        lea	rsi, [rbx + 64]
        mov	rdi, r14
        call	timer.TimerModule.unpause
        lea	rsi, [rbx + 96]
        mov	rdi, r14
        call	timer.TimerModule.unpause
        lea	rsi, [rbx + 128]
        mov	rdi, r14
        call	timer.TimerModule.unpause
        lea	rsi, [rbx + 160]
        mov	rdi, r14
        call	timer.TimerModule.unpause
        lea	rsi, [rbx + 192]
        mov	rdi, r14
        call	timer.TimerModule.unpause
        add	rbx, 224
        mov	rdi, r14
        mov	rsi, rbx
        add	rsp, 8
        pop	rbx
        pop	r14
        jmp	timer.TimerModule.unpause

app_pause_all:
        push	r14
        push	rbx
        push	rax
        mov	rbx, rsi
        mov	r14, rdi
        call	timer.TimerModule.pause
        lea	rsi, [rbx + 32]
        mov	rdi, r14
        call	timer.TimerModule.pause
        lea	rsi, [rbx + 64]
        mov	rdi, r14
        call	timer.TimerModule.pause
        lea	rsi, [rbx + 96]
        mov	rdi, r14
        call	timer.TimerModule.pause
        lea	rsi, [rbx + 128]
        mov	rdi, r14
        call	timer.TimerModule.pause
        lea	rsi, [rbx + 160]
        mov	rdi, r14
        call	timer.TimerModule.pause
        lea	rsi, [rbx + 192]
        mov	rdi, r14
        call	timer.TimerModule.pause
        add	rbx, 224
        mov	rdi, r14
        mov	rsi, rbx
        add	rsp, 8
        pop	rbx
        pop	r14
        jmp	timer.TimerModule.pause

app_stop_all:
        push	r14
        push	rbx
        push	rax
        mov	rbx, rsi
        mov	r14, rdi
        call	timer.TimerModule.stop
        lea	rsi, [rbx + 32]
        mov	rdi, r14
        call	timer.TimerModule.stop
        lea	rsi, [rbx + 64]
        mov	rdi, r14
        call	timer.TimerModule.stop
        lea	rsi, [rbx + 96]
        mov	rdi, r14
        call	timer.TimerModule.stop
        lea	rsi, [rbx + 128]
        mov	rdi, r14
        call	timer.TimerModule.stop
        lea	rsi, [rbx + 160]
        mov	rdi, r14
        call	timer.TimerModule.stop
        lea	rsi, [rbx + 192]
        mov	rdi, r14
        call	timer.TimerModule.stop
        add	rbx, 224
        mov	rdi, r14
        mov	rsi, rbx
        add	rsp, 8
        pop	rbx
        pop	r14
        jmp	timer.TimerModule.stop

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

timer_increment:
        add	dword ptr [rdi + 16], esi
        ret

timer_until_next:
        mov	rax, qword ptr [rdi]
        test	rax, rax
        je	.LBB21_1
        mov	ecx, dword ptr [rdi + 16]
        mov	edx, dword ptr [rax + 8]
        sub	edx, ecx
        xor	eax, eax
        cmp	edx, -65535
        cmovb	eax, edx
        ret
.LBB21_1:
        mov	eax, -1
        ret

timer_ticks_since:
        push	rax
        lea	rax, [rdi + 8]
        lea	rcx, [rsi + 16]
.LBB22_1:
        mov	rax, qword ptr [rax]
        test	rax, rax
        je	.LBB22_3
        cmp	rax, rcx
        jne	.LBB22_1
.LBB22_3:
        test	rax, rax
        jne	.LBB22_5
        mov	ecx, dword ptr [rsi + 28]
        sub	ecx, dword ptr [rsi + 24]
        mov	eax, dword ptr [rdi + 16]
        add	eax, ecx
        pop	rcx
        ret
.LBB22_5:
        mov	edi, offset __anon_0
        mov	esi, 61
        call	debug.defaultPanic

timer_remaining:
        jmp	timer.TimerModule.remainingTicks

timer_elapsed:
        cmp	qword ptr [rsi + 8], 0
        je	.LBB296_1
        push	rbx
        mov	ebx, dword ptr [rsi + 28]
        call	timer.TimerModule.remainingTicks
        mov	ecx, eax
        mov	eax, ebx
        sub	eax, ecx
        pop	rbx
        ret
.LBB296_1:
        xor	eax, eax
        ret

timer_is_paused:
        add	rdi, 8
        add	rsi, 16
.LBB297_1:
        mov	rdi, qword ptr [rdi]
        test	rdi, rdi
        je	.LBB297_3
        cmp	rdi, rsi
        jne	.LBB297_1
.LBB297_3:
        test	rdi, rdi
        setne	al
        ret

timer_is_active:
        add	rsi, 16
.LBB298_1:
        mov	rdi, qword ptr [rdi]
        test	rdi, rdi
        je	.LBB298_3
        cmp	rdi, rsi
        jne	.LBB298_1
.LBB298_3:
        test	rdi, rdi
        setne	al
        ret

timer_is_running:
        jmp	timer.TimerModule.isRunning

timer_unpause:
        jmp	timer.TimerModule.unpause

timer_pause:
        jmp	timer.TimerModule.pause

timer_stop:
        jmp	timer.TimerModule.stop

timer_start_oneshot:
        mov	edx, 100
        jmp	timer.TimerModule.startOneShot

timer_start_periodic:
        mov	edx, 100
        jmp	timer.TimerModule.startPeriodic

timer_run:
        jmp	timer.TimerModule.run

; --- called functions ---

timer.TimerModule.startPeriodic:
        cmp	qword ptr [rsi + 8], 0
        jne	.LBB10_2
        lea	rax, [rsi + 16]
        cmp	qword ptr [rdi], rax
        je	.LBB10_2
        mov	qword ptr [rsi + 8], offset codegen_timer.cb0
        mov	dword ptr [rsi + 28], edx
        mov	qword ptr [rsi], 1
        jmp	timer.TimerModule.insertTimer
.LBB10_2:
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
        je	.LBB8_7
        mov	rbx, rsi
        mov	r14, rdi
        lea	r15, [rsi + 16]
        mov	rsi, r15
        call	timer.TimerModule.tryRemove
        test	al, 1
        je	.LBB8_3
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
.LBB8_3:
        lea	rax, [r14 + 8]
.LBB8_4:
        mov	rax, qword ptr [rax]
        test	rax, rax
        je	.LBB8_6
        cmp	rax, r15
        jne	.LBB8_4
.LBB8_6:
        test	rax, rax
        je	.LBB8_8
.LBB8_7:
        pop	rbx
        pop	r14
        pop	r15
        ret
.LBB8_8:
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
        je	.LBB7_6
        mov	rbx, rsi
        mov	r14, rdi
        add	rdi, 8
        lea	r15, [rsi + 16]
        mov	rsi, r15
        call	timer.TimerModule.tryRemove
        test	al, 1
        je	.LBB7_2
        mov	edx, dword ptr [rbx + 24]
        mov	rdi, r14
        mov	rsi, rbx
        pop	rbx
        pop	r14
        pop	r15
        jmp	timer.TimerModule.insertTimer
.LBB7_2:
        mov	rax, r14
.LBB7_3:
        mov	rax, qword ptr [rax]
        test	rax, rax
        je	.LBB7_5
        cmp	rax, r15
        jne	.LBB7_3
.LBB7_5:
        test	rax, rax
        je	.LBB7_8
.LBB7_6:
        pop	rbx
        pop	r14
        pop	r15
        ret
.LBB7_8:
        mov	rdi, r14
        mov	rsi, rbx
        pop	rbx
        pop	r14
        pop	r15
        jmp	timer.TimerModule.isRunning

timer.TimerModule.startOneShot:
        cmp	qword ptr [rsi + 8], 0
        jne	.LBB3_2
        lea	rax, [rsi + 16]
        cmp	qword ptr [rdi], rax
        je	.LBB3_2
        mov	qword ptr [rsi + 8], offset codegen_timer.cb0
        mov	dword ptr [rsi + 28], edx
        mov	qword ptr [rsi], 0
        jmp	timer.TimerModule.insertTimer
.LBB3_2:
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

timer.TimerModule.run:
        push	rbp
        push	r15
        push	r14
        push	r12
        push	rbx
        mov	ecx, dword ptr [rdi + 16]
        mov	rax, qword ptr [rdi]
        test	rax, rax
        je	.LBB12_1
        sub	ecx, dword ptr [rax + 8]
        cmp	ecx, 65535
        ja	.LBB12_1
        mov	rbx, rdi
        lea	r14, [rax - 16]
        mov	r12, qword ptr [r14]
        mov	rdi, r12
        test	r12b, 1
        jne	.LBB12_5
        mov	rcx, qword ptr [rax]
        mov	qword ptr [rbx], rcx
        mov	rdi, qword ptr [rax - 16]
.LBB12_5:
        mov	r15, qword ptr [r14 + 8]
        mov	qword ptr [r14 + 8], 0
        and	rdi, -2
        mov	rsi, rbx
        mov	rdx, r14
        call	r15
        mov	bpl, 1
        cmp	qword ptr [r14 + 8], 0
        jne	.LBB12_2
        test	r12b, 1
        je	.LBB12_7
        mov	rax, qword ptr [rbx]
        test	rax, rax
        je	.LBB12_7
        mov	rax, qword ptr [rax]
        mov	qword ptr [rbx], rax
.LBB12_7:
        test	byte ptr [r14], 1
        je	.LBB12_2
        mov	edx, dword ptr [r14 + 28]
        mov	rdi, rbx
        mov	rsi, r14
        call	timer.TimerModule.insertTimer
        mov	qword ptr [r14 + 8], r15
        jmp	.LBB12_2
.LBB12_1:
        xor	ebp, ebp
.LBB12_2:
        mov	eax, ebp
        pop	rbx
        pop	r12
        pop	r14
        pop	r15
        pop	rbp
        ret

timer.TimerModule.isRunning:
        add	rsi, 16
        mov	rcx, rdi
.LBB9_1:
        mov	rcx, qword ptr [rcx]
        test	rcx, rcx
        je	.LBB9_3
        cmp	rcx, rsi
        jne	.LBB9_1
.LBB9_3:
        mov	al, 1
        test	rcx, rcx
        jne	.LBB9_7
        add	rdi, 8
.LBB9_5:
        mov	rdi, qword ptr [rdi]
        test	rdi, rdi
        setne	al
        je	.LBB9_7
        cmp	rdi, rsi
        jne	.LBB9_5
.LBB9_7:
        ret

timer.TimerModule.remainingTicks:
        cmp	qword ptr [rsi + 8], 0
        je	.LBB15_1
        lea	rax, [rdi + 8]
        lea	rcx, [rsi + 16]
.LBB15_4:
        mov	rax, qword ptr [rax]
        test	rax, rax
        je	.LBB15_6
        cmp	rax, rcx
        jne	.LBB15_4
.LBB15_6:
        test	rax, rax
        je	.LBB15_8
        mov	eax, dword ptr [rsi + 24]
        ret
.LBB15_1:
        xor	eax, eax
        ret
.LBB15_8:
        mov	eax, dword ptr [rdi + 16]
        mov	ecx, dword ptr [rsi + 24]
        sub	ecx, eax
        xor	eax, eax
        cmp	ecx, -65535
        cmovb	eax, ecx
        ret

debug.defaultPanic:
        push	rbp
        push	r15
        push	r14
        push	r13
        push	r12
        push	rbx
        sub	rsp, 200
        mov	rax, qword ptr fs:[debug.panic_stage@TPOFF]
        test	rax, rax
        jne	.LBB23_1
        mov	r14, rsi
        mov	r15, rdi
        mov	qword ptr fs:[debug.panic_stage@TPOFF], 1
        lock		add	byte ptr [rip + debug.panicking], 1
        lea	rdi, [rsp + 104]
        call	debug.lockStderr
        mov	r13, qword ptr [rsp + 104]
        movzx	eax, byte ptr [rsp + 112]
        lea	rcx, [r13 + 24]
        mov	qword ptr [rsp + 120], rcx
        and	al, 3
        mov	byte ptr [rsp + 128], al
        cmp	byte ptr fs:[Thread.LinuxThreadImpl.tls_thread_id.1@TPOFF], 1
        mov	qword ptr [rsp + 16], rcx
        jne	.LBB23_5
        mov	r12d, dword ptr fs:[Thread.LinuxThreadImpl.tls_thread_id.0@TPOFF]
        jmp	.LBB23_6
.LBB23_5:
        mov	eax, 186
        #APP
        syscall
        #NO_APP
        mov	r12, rax
        mov	dword ptr fs:[Thread.LinuxThreadImpl.tls_thread_id.0@TPOFF], r12d
        mov	byte ptr fs:[Thread.LinuxThreadImpl.tls_thread_id.1@TPOFF], 1
.LBB23_6:
        xor	ebp, ebp
.LBB23_7:
        lea	rsi, [rbp + __anon_1]
        mov	rbx, rbp
        xor	rbx, 7
        mov	rdi, qword ptr [r13 + 48]
        lea	rax, [rdi + rbx]
        cmp	rax, qword ptr [r13 + 40]
        ja	.LBB23_9
        add	rdi, qword ptr [r13 + 32]
        mov	rdx, rbx
        call	memcpy@PLT
        add	qword ptr [r13 + 48], rbx
        add	rbp, rbx
        cmp	rbp, 7
        jb	.LBB23_7
        jmp	.LBB23_12
.LBB23_9:
        mov	rcx, qword ptr [rsp + 16]
        mov	rax, qword ptr [rcx]
        mov	rax, qword ptr [rax]
        mov	qword ptr [rsp], rsi
        mov	qword ptr [rsp + 8], rbx
        mov	rsi, rcx
        mov	ecx, 1
        mov	r8d, 1
        lea	rdi, [rsp + 31]
        mov	rdx, rsp
        call	rax
        cmp	word ptr [rsp + 39], 0
        jne	.LBB23_58
        mov	rbx, qword ptr [rsp + 31]
        add	rbp, rbx
        cmp	rbp, 7
        jb	.LBB23_7
.LBB23_12:
        mov	edx, r12d
        mov	eax, 65
        cmp	r12d, 100
        jb	.LBB23_13
.LBB23_25:
        imul	rcx, rdx, 1374389535
        shr	rcx, 37
        imul	esi, ecx, 100
        mov	edi, edx
        sub	edi, esi
        movzx	esi, word ptr [rdi + rdi + __anon_2]
        mov	word ptr [rsp + rax + 29], si
        add	rax, -2
        cmp	rdx, 9999
        mov	rdx, rcx
        ja	.LBB23_25
        mov	qword ptr [rsp + 96], r15
        cmp	ecx, 9
        ja	.LBB23_14
.LBB23_27:
        or	cl, 48
        mov	byte ptr [rsp + rax + 30], cl
        add	rax, -1
        mov	r12, rax
        sub	r12, 65
        je	.LBB23_22
        jmp	.LBB23_16
.LBB23_13:
        mov	rcx, rdx
        mov	qword ptr [rsp + 96], r15
        cmp	ecx, 9
        jbe	.LBB23_27
.LBB23_14:
        movzx	ecx, word ptr [rcx + rcx + __anon_2]
        mov	word ptr [rsp + rax + 29], cx
        add	rax, -2
        mov	r12, rax
        sub	r12, 65
        jne	.LBB23_16
.LBB23_22:
        xor	r12d, r12d
        mov	rbp, rsp
        mov	r15, qword ptr [rsp + 96]
.LBB23_23:
        lea	rsi, [r12 + __anon_3]
        mov	ebx, 8
        sub	rbx, r12
        mov	rdi, qword ptr [r13 + 48]
        lea	rax, [rdi + rbx]
        cmp	rax, qword ptr [r13 + 40]
        ja	.LBB23_28
        add	rdi, qword ptr [r13 + 32]
        mov	rdx, rbx
        call	memcpy@PLT
        add	qword ptr [r13 + 48], rbx
        add	r12, rbx
        cmp	r12, 8
        jb	.LBB23_23
        jmp	.LBB23_31
.LBB23_28:
        mov	rcx, qword ptr [rsp + 16]
        mov	rax, qword ptr [rcx]
        mov	rax, qword ptr [rax]
        mov	qword ptr [rsp], rsi
        mov	qword ptr [rsp + 8], rbx
        mov	rsi, rcx
        mov	ecx, 1
        mov	r8d, 1
        lea	rdi, [rsp + 31]
        mov	rdx, rbp
        call	rax
        cmp	word ptr [rsp + 39], 0
        jne	.LBB23_58
        mov	rbx, qword ptr [rsp + 31]
        add	r12, rbx
        cmp	r12, 8
        jb	.LBB23_23
.LBB23_31:
        xor	r12d, r12d
        mov	rbp, rsp
.LBB23_32:
        lea	rsi, [r15 + r12]
        mov	rbx, r14
        sub	rbx, r12
        mov	rdi, qword ptr [r13 + 48]
        lea	rax, [rdi + rbx]
        cmp	rax, qword ptr [r13 + 40]
        ja	.LBB23_43
        add	rdi, qword ptr [r13 + 32]
        mov	rdx, rbx
        call	memcpy@PLT
        add	qword ptr [r13 + 48], rbx
        add	r12, rbx
        cmp	r12, r14
        jb	.LBB23_32
        jmp	.LBB23_46
.LBB23_43:
        mov	rcx, qword ptr [rsp + 16]
        mov	rax, qword ptr [rcx]
        mov	rax, qword ptr [rax]
        mov	qword ptr [rsp], rsi
        mov	qword ptr [rsp + 8], rbx
        mov	rsi, rcx
        mov	ecx, 1
        mov	r8d, 1
        lea	rdi, [rsp + 31]
        mov	rdx, rbp
        call	rax
        cmp	word ptr [rsp + 39], 0
        jne	.LBB23_67
        mov	rbx, qword ptr [rsp + 31]
        add	r12, rbx
        cmp	r12, r14
        jb	.LBB23_32
.LBB23_46:
        lea	r14, [rsp + 31]
        mov	r15, rsp
.LBB23_47:
        mov	rax, qword ptr [r13 + 48]
        cmp	rax, qword ptr [r13 + 40]
        mov	rsi, qword ptr [rsp + 16]
        jb	.LBB23_48
        mov	rax, qword ptr [rsi]
        mov	rax, qword ptr [rax]
        mov	qword ptr [rsp], offset __anon_4
        mov	qword ptr [rsp + 8], 1
        mov	ecx, 1
        mov	r8d, 1
        mov	rdi, r14
        mov	rdx, r15
        call	rax
        cmp	word ptr [rsp + 39], 0
        jne	.LBB23_67
        cmp	qword ptr [rsp + 31], 0
        je	.LBB23_47
        jmp	.LBB23_51
.LBB23_48:
        mov	rcx, qword ptr [r13 + 32]
        mov	byte ptr [rcx + rax], 10
        add	qword ptr [r13 + 48], 1
.LBB23_51:
        mov	rax, qword ptr [rsp + 248]
        mov	qword ptr [rsp + 152], rax
        mov	byte ptr [rsp + 160], 1
        mov	qword ptr [rsp + 168], 0
        mov	byte ptr [rsp + 176], 1
        lea	rdi, [rsp + 152]
        lea	rsi, [rsp + 120]
        call	debug.writeCurrentStackTrace
        movzx	eax, word ptr [rip + Io.Threaded.global_single_threaded_instance+64]
        test	ax, ax
        jne	.LBB23_52
        mov	rax, qword ptr [rip + Io.Threaded.global_single_threaded_instance+24]
        mov	edi, offset Io.Threaded.global_single_threaded_instance+24
        call	qword ptr [rax + 16]
        movzx	eax, word ptr [rip + Io.Threaded.global_single_threaded_instance+64]
.LBB23_52:
        test	ax, ax
        je	.LBB23_55
        movzx	eax, ax
        cmp	eax, 2
        jne	.LBB23_54
        lock		xor	qword ptr [8], 1
.LBB23_54:
        mov	word ptr [rip + Io.Threaded.global_single_threaded_instance+64], 0
.LBB23_55:
        mov	qword ptr [rip + Io.Threaded.global_single_threaded_instance+32], 1
        xorps	xmm0, xmm0
        movups	xmmword ptr [rip + Io.Threaded.global_single_threaded_instance+40], xmm0
        add	qword ptr [rip + Io.Threaded.global_single_threaded_instance+800], -1
        jne	.LBB23_40
        mov	dword ptr [rip + Io.Threaded.global_single_threaded_instance+844], -1
        xor	eax, eax
        xchg	dword ptr [rip + Io.Threaded.global_single_threaded_instance+848], eax
        cmp	eax, 2
        je	.LBB23_57
.LBB23_40:
        lock		sub	byte ptr [rip + debug.panicking], 1
        je	.LBB23_2
        mov	dword ptr [rsp + 31], 0
        lea	rdi, [rsp + 31]
        mov	esi, 128
.LBB23_42:
        mov	eax, 202
        xor	edx, edx
        xor	r10d, r10d
        #APP
        syscall
        #NO_APP
        jmp	.LBB23_42
.LBB23_16:
        neg	r12
        lea	rbp, [rsp + rax]
        add	rbp, 31
        xor	r15d, r15d
.LBB23_17:
        lea	rsi, [r15 + rbp]
        mov	rbx, r12
        sub	rbx, r15
        mov	rdi, qword ptr [r13 + 48]
        lea	rax, [rdi + rbx]
        cmp	rax, qword ptr [r13 + 40]
        ja	.LBB23_19
        add	rdi, qword ptr [r13 + 32]
        mov	rdx, rbx
        call	memcpy@PLT
        add	qword ptr [r13 + 48], rbx
        add	r15, rbx
        cmp	r15, r12
        jb	.LBB23_17
        jmp	.LBB23_22
.LBB23_19:
        mov	rcx, qword ptr [rsp + 16]
        mov	rax, qword ptr [rcx]
        mov	rax, qword ptr [rax]
        mov	qword ptr [rsp + 136], rsi
        mov	qword ptr [rsp + 144], rbx
        mov	rsi, rcx
        mov	ecx, 1
        mov	r8d, 1
        mov	rdi, rsp
        lea	rdx, [rsp + 136]
        call	rax
        cmp	word ptr [rsp + 8], 0
        jne	.LBB23_58
        mov	rbx, qword ptr [rsp]
        add	r15, rbx
        cmp	r15, r12
        jb	.LBB23_17
        jmp	.LBB23_22
.LBB23_58:
        movzx	eax, word ptr [rip + Io.Threaded.global_single_threaded_instance+64]
        test	ax, ax
        jne	.LBB23_59
        mov	rax, qword ptr [rip + Io.Threaded.global_single_threaded_instance+24]
        mov	edi, offset Io.Threaded.global_single_threaded_instance+24
        call	qword ptr [rax + 16]
        movzx	eax, word ptr [rip + Io.Threaded.global_single_threaded_instance+64]
.LBB23_59:
        test	ax, ax
        je	.LBB23_62
        movzx	eax, ax
        cmp	eax, 2
        jne	.LBB23_61
        lock		xor	qword ptr [8], 1
.LBB23_61:
        mov	word ptr [rip + Io.Threaded.global_single_threaded_instance+64], 0
.LBB23_62:
        mov	qword ptr [rip + Io.Threaded.global_single_threaded_instance+32], 1
        xorps	xmm0, xmm0
        movups	xmmword ptr [rip + Io.Threaded.global_single_threaded_instance+40], xmm0
        add	qword ptr [rip + Io.Threaded.global_single_threaded_instance+800], -1
        jne	.LBB23_40
        mov	dword ptr [rip + Io.Threaded.global_single_threaded_instance+844], -1
        xor	eax, eax
        xchg	dword ptr [rip + Io.Threaded.global_single_threaded_instance+848], eax
        cmp	eax, 2
        jne	.LBB23_40
        mov	eax, 202
        mov	edi, offset Io.Threaded.global_single_threaded_instance+848
        mov	esi, 129
        mov	edx, 1
        #APP
        syscall
        #NO_APP
        jmp	.LBB23_40
.LBB23_67:
        movzx	eax, word ptr [rip + Io.Threaded.global_single_threaded_instance+64]
        test	ax, ax
        jne	.LBB23_68
        mov	rax, qword ptr [rip + Io.Threaded.global_single_threaded_instance+24]
        mov	edi, offset Io.Threaded.global_single_threaded_instance+24
        call	qword ptr [rax + 16]
        movzx	eax, word ptr [rip + Io.Threaded.global_single_threaded_instance+64]
.LBB23_68:
        test	ax, ax
        je	.LBB23_71
        movzx	eax, ax
        cmp	eax, 2
        jne	.LBB23_70
        lock		xor	qword ptr [8], 1
.LBB23_70:
        mov	word ptr [rip + Io.Threaded.global_single_threaded_instance+64], 0
.LBB23_71:
        mov	qword ptr [rip + Io.Threaded.global_single_threaded_instance+32], 1
        xorps	xmm0, xmm0
        movups	xmmword ptr [rip + Io.Threaded.global_single_threaded_instance+40], xmm0
        add	qword ptr [rip + Io.Threaded.global_single_threaded_instance+800], -1
        jne	.LBB23_40
        mov	dword ptr [rip + Io.Threaded.global_single_threaded_instance+844], -1
        xor	eax, eax
        xchg	dword ptr [rip + Io.Threaded.global_single_threaded_instance+848], eax
        cmp	eax, 2
        jne	.LBB23_40
        mov	eax, 202
        mov	edi, offset Io.Threaded.global_single_threaded_instance+848
        mov	esi, 129
        mov	edx, 1
        #APP
        syscall
        #NO_APP
        jmp	.LBB23_40
.LBB23_57:
        mov	eax, 202
        mov	edi, offset Io.Threaded.global_single_threaded_instance+848
        mov	esi, 129
        mov	edx, 1
        #APP
        syscall
        #NO_APP
        jmp	.LBB23_40
.LBB23_1:
        cmp	rax, 1
        jne	.LBB23_2
        mov	qword ptr fs:[debug.panic_stage@TPOFF], 2
        lea	rdi, [rsp + 184]
        call	debug.lockStderr
        mov	r13, qword ptr [rsp + 184]
        lea	rbx, [r13 + 24]
        xor	ebp, ebp
        lea	r14, [rsp + 31]
        mov	r15, rsp
.LBB23_35:
        lea	rsi, [rbp + __anon_5]
        mov	r12d, 32
        sub	r12, rbp
        mov	rdi, qword ptr [r13 + 48]
        lea	rax, [rdi + r12]
        cmp	rax, qword ptr [r13 + 40]
        ja	.LBB23_37
        add	rdi, qword ptr [r13 + 32]
        mov	rdx, r12
        call	memcpy@PLT
        add	qword ptr [r13 + 48], r12
        add	rbp, r12
        cmp	rbp, 32
        jb	.LBB23_35
        jmp	.LBB23_2
.LBB23_37:
        mov	rax, qword ptr [rbx]
        mov	rax, qword ptr [rax]
        mov	qword ptr [rsp], rsi
        mov	qword ptr [rsp + 8], r12
        mov	ecx, 1
        mov	r8d, 1
        mov	rdi, r14
        mov	rsi, rbx
        mov	rdx, r15
        call	rax
        cmp	word ptr [rsp + 39], 0
        jne	.LBB23_2
        mov	r12, qword ptr [rsp + 31]
        add	rbp, r12
        cmp	rbp, 32
        jb	.LBB23_35
.LBB23_2:
        call	process.abort
        .text

timer.TimerModule.insertTimer:
        mov	eax, dword ptr [rdi + 16]
        lea	ecx, [rax + rdx]
        mov	dword ptr [rsi + 24], ecx
        mov	rcx, qword ptr [rdi]
        test	rcx, rcx
        je	.LBB5_1
        mov	r8d, dword ptr [rcx + 8]
        sub	r8d, eax
        cmp	r8d, -65535
        setb	r9b
        cmp	r8d, edx
        seta	r8b
        test	r9b, r8b
        je	.LBB5_6
        mov	r8, rcx
.LBB5_2:
        mov	qword ptr [rsi + 16], r8
        add	rsi, 16
        mov	qword ptr [rdi], rsi
        ret
.LBB5_6:
        mov	r8, qword ptr [rcx]
        test	r8, r8
        je	.LBB5_7
        mov	edi, dword ptr [r8 + 8]
        sub	edi, eax
        cmp	edi, -65535
        setb	r9b
        cmp	edi, edx
        seta	r10b
        mov	rdi, rcx
        mov	rcx, r8
        test	r9b, r10b
        je	.LBB5_6
        jmp	.LBB5_2
.LBB5_1:
        xor	r8d, r8d
        mov	qword ptr [rsi + 16], r8
        add	rsi, 16
        mov	qword ptr [rdi], rsi
        ret
.LBB5_7:
        xor	r8d, r8d
        mov	rdi, rcx
        mov	qword ptr [rsi + 16], r8
        add	rsi, 16
        mov	qword ptr [rdi], rsi
        ret

timer.TimerModule.removeTimer:
        push	r15
        push	r14
        push	rbx
        mov	rbx, rsi
        mov	r15, rdi
        lea	r14, [rsi + 16]
        mov	rsi, r14
        call	timer.TimerModule.tryRemove
        test	al, 1
        jne	.LBB4_2
        add	r15, 8
        mov	rdi, r15
        mov	rsi, r14
        call	timer.TimerModule.tryRemove
.LBB4_2:
        mov	qword ptr [rbx + 8], 0
        pop	rbx
        pop	r14
        pop	r15
        ret

timer.TimerModule.tryRemove:
        mov	rax, qword ptr [rdi]
        test	rax, rax
        je	.LBB6_1
        cmp	rax, rsi
        je	.LBB6_6
.LBB6_4:
        mov	rcx, qword ptr [rax]
        test	rcx, rcx
        je	.LBB6_1
        mov	rdi, rax
        mov	rax, rcx
        cmp	rcx, rsi
        jne	.LBB6_4
.LBB6_6:
        mov	rax, qword ptr [rsi]
        mov	qword ptr [rdi], rax
        mov	al, 1
        ret
.LBB6_1:
        xor	eax, eax
        ret

