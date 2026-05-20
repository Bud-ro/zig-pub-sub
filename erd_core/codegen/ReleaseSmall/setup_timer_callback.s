setup_timer_callback:
        push	r15
        push	r14
        push	r12
        push	rbx
        push	rax
        mov	r15, rdx
        mov	r14, rsi
        mov	r12, rdi
        lea	rbx, [rdx + 16]
        cmp	qword ptr [rdx + 8], 0
        je	.LBB320_1
.LBB320_8:
        mov	rdi, r14
        mov	rsi, rbx
        call	.Ltimer.TimerModule.tryRemove
        test	al, 1
        jne	.LBB320_2
        lea	rdi, [r14 + 8]
        mov	rsi, rbx
        call	.Ltimer.TimerModule.tryRemove
        jmp	.LBB320_2
.LBB320_1:
        cmp	qword ptr [r14], rbx
        je	.LBB320_8
.LBB320_2:
        mov	qword ptr [r15 + 8], offset .Lcodegen_harness.timer_callback_read_write
        mov	dword ptr [r15 + 28], 100
        or	r12, 1
        mov	qword ptr [r15], r12
        mov	ecx, dword ptr [r14 + 16]
        lea	eax, [rcx + 100]
        mov	dword ptr [r15 + 24], eax
        mov	rax, qword ptr [r14]
        test	rax, rax
        je	.LBB320_3
        mov	edx, dword ptr [rax + 8]
        sub	edx, ecx
        add	edx, -101
        cmp	edx, -65636
        jb	.LBB320_7
.LBB320_5:
        mov	r14, rax
        mov	rax, qword ptr [rax]
        test	rax, rax
        je	.LBB320_3
        mov	edx, dword ptr [rax + 8]
        sub	edx, ecx
        add	edx, 65535
        cmp	edx, 65636
        jb	.LBB320_5
        jmp	.LBB320_7
.LBB320_3:
        xor	eax, eax
.LBB320_7:
        mov	qword ptr [rbx], rax
        mov	qword ptr [r14], rbx
        add	rsp, 8
        pop	rbx
        pop	r12
        pop	r14
        pop	r15
        ret

; --- called functions ---

.Ltimer.TimerModule.tryRemove:
        mov	rax, qword ptr [rdi]
        test	rax, rax
        je	.LBB321_1
        cmp	rax, rsi
        je	.LBB321_6
.LBB321_4:
        mov	rcx, qword ptr [rax]
        test	rcx, rcx
        je	.LBB321_1
        mov	rdi, rax
        mov	rax, rcx
        cmp	rcx, rsi
        jne	.LBB321_4
.LBB321_6:
        mov	rax, qword ptr [rsi]
        mov	qword ptr [rdi], rax
        mov	al, 1
        ret
.LBB321_1:
        xor	eax, eax
        ret

