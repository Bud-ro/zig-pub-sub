app_control_burst:
        push	r15
        push	r14
        push	rbx
        mov	rbx, rsi
        mov	r14, rdi
        push	10
        pop	rdx
        call	.Ltimer.TimerModule.startPeriodic
        mov	rdi, r14
        mov	rsi, rbx
        call	.Ltimer.TimerModule.pause
        mov	rdi, r14
        mov	rsi, rbx
        call	.Ltimer.TimerModule.unpause
        lea	r15, [rbx + 32]
        push	20
        pop	rdx
        mov	rdi, r14
        mov	rsi, r15
        call	.Ltimer.TimerModule.startOneShot
        mov	rdi, r14
        mov	rsi, r15
        call	.Ltimer.TimerModule.stop
        lea	r15, [rbx + 64]
        push	30
        pop	rdx
        mov	rdi, r14
        mov	rsi, r15
        call	.Ltimer.TimerModule.startPeriodic
        add	rbx, 96
        push	40
        pop	rdx
        mov	rdi, r14
        mov	rsi, rbx
        call	.Ltimer.TimerModule.startOneShot
        mov	rdi, r14
        mov	rsi, r15
        call	.Ltimer.TimerModule.stop
        mov	rdi, r14
        mov	rsi, rbx
        pop	rbx
        pop	r14
        pop	r15
        jmp	.Ltimer.TimerModule.stop

run_until_idle:
        push	rbx
        mov	rbx, rdi
.LBB11_1:
        mov	rdi, rbx
        call	.Ltimer.TimerModule.run
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

app_query_remaining:
        push	r15
        push	r14
        push	rbx
        mov	rbx, rdx
        mov	r14, rsi
        mov	r15, rdi
        call	.Ltimer.TimerModule.remainingTicks
        mov	dword ptr [rbx], eax
        lea	rsi, [r14 + 32]
        mov	rdi, r15
        call	.Ltimer.TimerModule.remainingTicks
        mov	dword ptr [rbx + 4], eax
        lea	rsi, [r14 + 64]
        mov	rdi, r15
        call	.Ltimer.TimerModule.remainingTicks
        mov	dword ptr [rbx + 8], eax
        lea	rsi, [r14 + 96]
        mov	rdi, r15
        call	.Ltimer.TimerModule.remainingTicks
        mov	dword ptr [rbx + 12], eax
        lea	rsi, [r14 + 128]
        mov	rdi, r15
        call	.Ltimer.TimerModule.remainingTicks
        mov	dword ptr [rbx + 16], eax
        lea	rsi, [r14 + 160]
        mov	rdi, r15
        call	.Ltimer.TimerModule.remainingTicks
        mov	dword ptr [rbx + 20], eax
        lea	rsi, [r14 + 192]
        mov	rdi, r15
        call	.Ltimer.TimerModule.remainingTicks
        mov	dword ptr [rbx + 24], eax
        add	r14, 224
        mov	rdi, r15
        mov	rsi, r14
        call	.Ltimer.TimerModule.remainingTicks
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
        call	.Ltimer.TimerModule.unpause
        lea	rsi, [rbx + 32]
        mov	rdi, r14
        call	.Ltimer.TimerModule.unpause
        lea	rsi, [rbx + 64]
        mov	rdi, r14
        call	.Ltimer.TimerModule.unpause
        lea	rsi, [rbx + 96]
        mov	rdi, r14
        call	.Ltimer.TimerModule.unpause
        lea	rsi, [rbx + 128]
        mov	rdi, r14
        call	.Ltimer.TimerModule.unpause
        lea	rsi, [rbx + 160]
        mov	rdi, r14
        call	.Ltimer.TimerModule.unpause
        lea	rsi, [rbx + 192]
        mov	rdi, r14
        call	.Ltimer.TimerModule.unpause
        add	rbx, 224
        mov	rdi, r14
        mov	rsi, rbx
        add	rsp, 8
        pop	rbx
        pop	r14
        jmp	.Ltimer.TimerModule.unpause

app_pause_all:
        push	r14
        push	rbx
        push	rax
        mov	rbx, rsi
        mov	r14, rdi
        call	.Ltimer.TimerModule.pause
        lea	rsi, [rbx + 32]
        mov	rdi, r14
        call	.Ltimer.TimerModule.pause
        lea	rsi, [rbx + 64]
        mov	rdi, r14
        call	.Ltimer.TimerModule.pause
        lea	rsi, [rbx + 96]
        mov	rdi, r14
        call	.Ltimer.TimerModule.pause
        lea	rsi, [rbx + 128]
        mov	rdi, r14
        call	.Ltimer.TimerModule.pause
        lea	rsi, [rbx + 160]
        mov	rdi, r14
        call	.Ltimer.TimerModule.pause
        lea	rsi, [rbx + 192]
        mov	rdi, r14
        call	.Ltimer.TimerModule.pause
        add	rbx, 224
        mov	rdi, r14
        mov	rsi, rbx
        add	rsp, 8
        pop	rbx
        pop	r14
        jmp	.Ltimer.TimerModule.pause

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
        push	-1
        pop	rax
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
        push	61
        pop	rsi
        mov	edi, offset .L__anon_0
        call	.Ldebug.defaultPanic

timer_remaining:
        jmp	.Ltimer.TimerModule.remainingTicks

timer_elapsed:
        push	rbx
        cmp	qword ptr [rsi + 8], 0
        je	.LBB286_1
        mov	ebx, dword ptr [rsi + 28]
        call	.Ltimer.TimerModule.remainingTicks
        sub	ebx, eax
        jmp	.LBB286_3
.LBB286_1:
        xor	ebx, ebx
.LBB286_3:
        mov	eax, ebx
        pop	rbx
        ret

timer_is_paused:
        add	rdi, 8
        add	rsi, 16
.LBB287_1:
        mov	rdi, qword ptr [rdi]
        test	rdi, rdi
        je	.LBB287_3
        cmp	rdi, rsi
        jne	.LBB287_1
.LBB287_3:
        test	rdi, rdi
        setne	al
        ret

timer_is_active:
        add	rsi, 16
.LBB288_1:
        mov	rdi, qword ptr [rdi]
        test	rdi, rdi
        je	.LBB288_3
        cmp	rdi, rsi
        jne	.LBB288_1
.LBB288_3:
        test	rdi, rdi
        setne	al
        ret

timer_is_running:
        jmp	.Ltimer.TimerModule.isRunning

timer_unpause:
        jmp	.Ltimer.TimerModule.unpause

timer_pause:
        jmp	.Ltimer.TimerModule.pause

timer_stop:
        jmp	.Ltimer.TimerModule.stop

timer_start_oneshot:
        push	100
        pop	rdx
        jmp	.Ltimer.TimerModule.startOneShot

timer_start_periodic:
        push	100
        pop	rdx
        jmp	.Ltimer.TimerModule.startPeriodic

timer_run:
        jmp	.Ltimer.TimerModule.run

; --- called functions ---

.Ltimer.TimerModule.startPeriodic:
        cmp	qword ptr [rsi + 8], 0
        jne	.LBB10_2
        lea	rax, [rsi + 16]
        cmp	qword ptr [rdi], rax
        je	.LBB10_2
        mov	qword ptr [rsi + 8], offset .Lcodegen_timer.cb0
        mov	dword ptr [rsi + 28], edx
        mov	qword ptr [rsi], 1
        jmp	.Ltimer.TimerModule.insertTimer
.LBB10_2:
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

.Ltimer.TimerModule.pause:
        push	r15
        push	r14
        push	rbx
        cmp	qword ptr [rsi + 8], 0
        je	.LBB8_7
        mov	rbx, rsi
        mov	r14, rdi
        lea	r15, [rsi + 16]
        mov	rsi, r15
        call	.Ltimer.TimerModule.tryRemove
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
        jmp	.Ltimer.TimerModule.isRunning

.Ltimer.TimerModule.unpause:
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
        call	.Ltimer.TimerModule.tryRemove
        test	al, 1
        je	.LBB7_2
        mov	edx, dword ptr [rbx + 24]
        mov	rdi, r14
        mov	rsi, rbx
        pop	rbx
        pop	r14
        pop	r15
        jmp	.Ltimer.TimerModule.insertTimer
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
        jmp	.Ltimer.TimerModule.isRunning

.Ltimer.TimerModule.startOneShot:
        cmp	qword ptr [rsi + 8], 0
        jne	.LBB3_2
        lea	rax, [rsi + 16]
        cmp	qword ptr [rdi], rax
        je	.LBB3_2
        mov	qword ptr [rsi + 8], offset .Lcodegen_timer.cb0
        mov	dword ptr [rsi + 28], edx
        mov	qword ptr [rsi], 0
        jmp	.Ltimer.TimerModule.insertTimer
.LBB3_2:
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

.Ltimer.TimerModule.stop:
        and	byte ptr [rsi], -2
        cmp	qword ptr [rsi + 8], 0
        jne	.Ltimer.TimerModule.removeTimer
        ret

.Ltimer.TimerModule.run:
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
        call	.Ltimer.TimerModule.insertTimer
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

.Ltimer.TimerModule.isRunning:
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

.Ltimer.TimerModule.remainingTicks:
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

.Ldebug.defaultPanic:
        push	rbp
        push	r15
        push	r14
        push	r12
        push	rbx
        sub	rsp, 128
        mov	rax, qword ptr fs:[.Ldebug.panic_stage@TPOFF]
        test	rax, rax
        jne	.LBB23_16
        mov	rbx, rsi
        mov	r15, rdi
        mov	qword ptr fs:[.Ldebug.panic_stage@TPOFF], 1
        lock		inc	byte ptr [rip + .Ldebug.panicking]
        lea	r12, [rsp + 96]
        mov	rdi, r12
        call	.Ldebug.lockStderr
        mov	r14, qword ptr [r12]
        mov	al, byte ptr [r12 + 8]
        add	r14, 24
        mov	qword ptr [rsp + 8], r14
        and	al, 3
        mov	byte ptr [rsp + 16], al
        call	.LThread.getCurrentId
        mov	ebp, eax
        push	7
        pop	rdx
        mov	esi, offset .L__anon_1
        mov	rdi, r14
        call	.LIo.Writer.writeAll
        test	ax, ax
        jne	.LBB23_13
        mov	ecx, ebp
        push	63
        pop	rdi
        push	100
        pop	rsi
        mov	r8b, 10
.LBB23_3:
        cmp	rcx, 100
        jb	.LBB23_5
        mov	rax, rcx
        xor	edx, edx
        div	rsi
        movzx	edx, dl
        mov	rcx, rax
        mov	eax, edx
        div	r8b
        movzx	edx, ah
        or	dl, 48
        movzx	edx, dl
        shl	edx, 8
        movzx	eax, al
        add	eax, edx
        add	eax, 48
        mov	word ptr [rsp + rdi + 31], ax
        add	rdi, -2
        jmp	.LBB23_3
.LBB23_5:
        cmp	rcx, 9
        ja	.LBB23_7
        or	cl, 48
        mov	byte ptr [rsp + rdi + 32], cl
        inc	rdi
        jmp	.LBB23_8
.LBB23_7:
        movzx	eax, cl
        mov	cl, 10
        div	cl
        movzx	ecx, ah
        or	cl, 48
        movzx	ecx, cl
        shl	ecx, 8
        movzx	eax, al
        add	eax, ecx
        add	eax, 48
        mov	word ptr [rsp + rdi + 31], ax
.LBB23_8:
        lea	rsi, [rsp + rdi]
        add	rsi, 31
        push	65
        pop	rdx
        sub	rdx, rdi
        mov	rdi, r14
        call	.LIo.Writer.writeAll
        test	ax, ax
        jne	.LBB23_13
        push	8
        pop	rdx
        mov	esi, offset .L__anon_2
        mov	rdi, r14
        call	.LIo.Writer.writeAll
        test	ax, ax
        jne	.LBB23_13
        mov	rdi, r14
        mov	rsi, r15
        mov	rdx, rbx
        call	.LIo.Writer.writeAll
        test	ax, ax
        jne	.LBB23_13
        push	1
        pop	rdx
        mov	esi, offset .L__anon_3
        mov	rdi, r14
        call	.LIo.Writer.writeAll
        test	ax, ax
        jne	.LBB23_13
        lea	rdi, [rsp + 8]
        call	.Ldebug.writeCurrentStackTrace
.LBB23_13:
        mov	edi, offset .LIo.Threaded.global_single_threaded_instance
        call	.LIo.Threaded.unlockStderr
        lock		dec	byte ptr [rip + .Ldebug.panicking]
        je	.LBB23_18
        lea	rbx, [rsp + 31]
        and	dword ptr [rbx], 0
.LBB23_15:
        mov	edx, offset .L__anon_4
        mov	rdi, rbx
        xor	esi, esi
        call	.LIo.Threaded.Thread.futexWaitUncancelable
        jmp	.LBB23_15
.LBB23_16:
        cmp	rax, 1
        jne	.LBB23_18
        mov	qword ptr fs:[.Ldebug.panic_stage@TPOFF], 2
        lea	rbx, [rsp + 112]
        mov	rdi, rbx
        call	.Ldebug.lockStderr
        mov	rdi, qword ptr [rbx]
        add	rdi, 24
        push	32
        pop	rdx
        mov	esi, offset .L__anon_5
        call	.LIo.Writer.writeAll
.LBB23_18:
        call	.Lprocess.abort
        .text

.Ltimer.TimerModule.insertTimer:
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

.Ltimer.TimerModule.removeTimer:
        push	r15
        push	r14
        push	rbx
        mov	rbx, rsi
        mov	r15, rdi
        lea	r14, [rsi + 16]
        mov	rsi, r14
        call	.Ltimer.TimerModule.tryRemove
        test	al, 1
        jne	.LBB4_2
        add	r15, 8
        mov	rdi, r15
        mov	rsi, r14
        call	.Ltimer.TimerModule.tryRemove
.LBB4_2:
        mov	qword ptr [rbx + 8], 0
        pop	rbx
        pop	r14
        pop	r15
        ret

.Ltimer.TimerModule.tryRemove:
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

