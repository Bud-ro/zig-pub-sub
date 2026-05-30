; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
; Main-loop pattern: calls the shared, noinline run() until it returns false.
;
run_until_idle:
        push	rbx
        mov	rbx, rdi
.L0:
        mov	rdi, rbx
        call	.Ltimer.TimerModule.run
        test	al, 1
        jne	.L0
        pop	rbx
        ret

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
        je	.L1
        sub	ecx, dword ptr [rax + 8]
        cmp	ecx, 65535
        ja	.L1
        mov	rbx, rdi
        lea	r14, [rax - 16]
        mov	r12, qword ptr [r14]
        mov	rdi, r12
        test	r12b, 1
        jne	.L2
        mov	rcx, qword ptr [rax]
        mov	qword ptr [rbx], rcx
        mov	rdi, qword ptr [rax - 16]
.L2:
        mov	r15, qword ptr [r14 + 8]
        mov	qword ptr [r14 + 8], 0
        and	rdi, -2
        mov	rsi, rbx
        mov	rdx, r14
        call	r15
        mov	bpl, 1
        cmp	qword ptr [r14 + 8], 0
        jne	.L3
        test	r12b, 1
        je	.L4
        mov	rax, qword ptr [rbx]
        test	rax, rax
        je	.L4
        mov	rax, qword ptr [rax]
        mov	qword ptr [rbx], rax
.L4:
        test	byte ptr [r14], 1
        je	.L3
        mov	edx, dword ptr [r14 + 28]
        mov	rdi, rbx
        mov	rsi, r14
        call	.Ltimer.TimerModule.insertTimer
        mov	qword ptr [r14 + 8], r15
        jmp	.L3
.L1:
        xor	ebp, ebp
.L3:
        mov	eax, ebp
        pop	rbx
        pop	r12
        pop	r14
        pop	r15
        pop	rbp
        ret

