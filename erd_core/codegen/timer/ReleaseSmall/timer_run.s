; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
timer_run:
        jmp	.Ltimer.TimerModule.run

; --- called functions ---

.Ltimer.TimerModule.run:
        push	rbp
        push	r15
        push	r14
        push	r12
        push	rbx
        mov	ecx, dword ptr [rdi + 16]
        mov	rax, qword ptr [rdi]
        test	rax, rax
        je	.L0
        sub	ecx, dword ptr [rax + 8]
        cmp	ecx, 65535
        ja	.L0
        mov	rbx, rdi
        lea	r14, [rax - 16]
        mov	r12, qword ptr [r14]
        mov	rdi, r12
        test	r12b, 1
        jne	.L1
        mov	rcx, qword ptr [rax]
        mov	qword ptr [rbx], rcx
        mov	rdi, qword ptr [rax - 16]
.L1:
        mov	r15, qword ptr [r14 + 8]
        mov	qword ptr [r14 + 8], 0
        and	rdi, -2
        mov	rsi, rbx
        mov	rdx, r14
        call	r15
        mov	bpl, 1
        cmp	qword ptr [r14 + 8], 0
        jne	.L2
        test	r12b, 1
        je	.L3
        mov	rax, qword ptr [rbx]
        test	rax, rax
        je	.L3
        mov	rax, qword ptr [rax]
        mov	qword ptr [rbx], rax
.L3:
        test	byte ptr [r14], 1
        je	.L2
        mov	edx, dword ptr [r14 + 28]
        mov	rdi, rbx
        mov	rsi, r14
        call	.Ltimer.TimerModule.insertTimer
        mov	qword ptr [r14 + 8], r15
        jmp	.L2
.L0:
        xor	ebp, ebp
.L2:
        mov	eax, ebp
        pop	rbx
        pop	r12
        pop	r14
        pop	r15
        pop	rbp
        ret

