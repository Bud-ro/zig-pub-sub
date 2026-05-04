setup_timer_callback:
        push	rbp
        mov	rbp, rsp
        push	r15
        push	r14
        push	r12
        push	rbx
        mov	r15, rdx
        mov	r14, rsi
        mov	r12, rdi
        lea	rbx, [rdx + 16]
        cmp	qword ptr [rdx + 8], 0
        je	.LBB34_1
.LBB34_8:
        mov	rdi, r14
        mov	rsi, rbx
        call	timer.TimerModule.tryRemove
        test	al, 1
        jne	.LBB34_2
        lea	rdi, [r14 + 8]
        mov	rsi, rbx
        call	timer.TimerModule.tryRemove
        jmp	.LBB34_2
.LBB34_1:
        cmp	qword ptr [r14], rbx
        je	.LBB34_8
.LBB34_2:
        mov	qword ptr [r15 + 8], offset codegen_harness.timer_callback_read_write
        mov	dword ptr [r15 + 28], 100
        or	r12, 1
        mov	qword ptr [r15], r12
        mov	ecx, dword ptr [r14 + 16]
        lea	eax, [rcx + 100]
        mov	dword ptr [r15 + 24], eax
        mov	rax, qword ptr [r14]
        test	rax, rax
        je	.LBB34_3
        mov	edx, dword ptr [rax + 8]
        sub	edx, ecx
        add	edx, -101
        cmp	edx, -65636
        jb	.LBB34_7
.LBB34_5:
        mov	r14, rax
        mov	rax, qword ptr [rax]
        test	rax, rax
        je	.LBB34_3
        mov	edx, dword ptr [rax + 8]
        sub	edx, ecx
        add	edx, 65535
        cmp	edx, 65636
        jb	.LBB34_5
        jmp	.LBB34_7
.LBB34_3:
        xor	eax, eax
.LBB34_7:
        mov	qword ptr [rbx], rax
        mov	qword ptr [r14], rbx
        pop	rbx
        pop	r12
        pop	r14
        pop	r15
        pop	rbp
        ret

; --- called functions ---

timer.TimerModule.tryRemove:
        mov	rax, qword ptr [rdi]
        test	rax, rax
        je	.LBB36_1
        push	rbp
        mov	rbp, rsp
        cmp	rax, rsi
        je	.LBB36_7
.LBB36_4:
        mov	rcx, qword ptr [rax]
        test	rcx, rcx
        je	.LBB36_5
        mov	rdi, rax
        mov	rax, rcx
        cmp	rcx, rsi
        jne	.LBB36_4
.LBB36_7:
        mov	rax, qword ptr [rsi]
        mov	qword ptr [rdi], rax
        mov	al, 1
        pop	rbp
        ret
.LBB36_1:
        xor	eax, eax
        ret
.LBB36_5:
        xor	eax, eax
        pop	rbp
        ret

