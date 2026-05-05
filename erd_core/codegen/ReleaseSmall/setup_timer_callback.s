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
        je	.LBB288_1
.LBB288_8:
        mov	rdi, r14
        mov	rsi, rbx
        call	.Ltimer.TimerModule.tryRemove
        test	al, 1
        jne	.LBB288_2
        lea	rdi, [r14 + 8]
        mov	rsi, rbx
        call	.Ltimer.TimerModule.tryRemove
        jmp	.LBB288_2
.LBB288_1:
        cmp	qword ptr [r14], rbx
        je	.LBB288_8
.LBB288_2:
        mov	qword ptr [r15 + 8], offset .Lcodegen_harness.timer_callback_read_write
        mov	dword ptr [r15 + 28], 100
        or	r12, 1
        mov	qword ptr [r15], r12
        mov	ecx, dword ptr [r14 + 16]
        lea	eax, [rcx + 100]
        mov	dword ptr [r15 + 24], eax
        mov	rax, qword ptr [r14]
        test	rax, rax
        je	.LBB288_3
        mov	edx, dword ptr [rax + 8]
        sub	edx, ecx
        add	edx, -101
        cmp	edx, -65636
        jb	.LBB288_7
.LBB288_5:
        mov	r14, rax
        mov	rax, qword ptr [rax]
        test	rax, rax
        je	.LBB288_3
        mov	edx, dword ptr [rax + 8]
        sub	edx, ecx
        add	edx, 65535
        cmp	edx, 65636
        jb	.LBB288_5
        jmp	.LBB288_7
.LBB288_3:
        xor	eax, eax
.LBB288_7:
        mov	qword ptr [rbx], rax
        mov	qword ptr [r14], rbx
        pop	rbx
        pop	r12
        pop	r14
        pop	r15
        pop	rbp
        ret

