; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 2 calls)
;
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
        je	.L0
.L1:
        mov	rdi, r14
        mov	rsi, rbx
        call	.Ltimer.TimerModule.tryRemove
        test	al, 1
        jne	.L2
        lea	rdi, [r14 + 8]
        mov	rsi, rbx
        call	.Ltimer.TimerModule.tryRemove
        jmp	.L2
.L0:
        cmp	qword ptr [r14], rbx
        je	.L1
.L2:
        mov	qword ptr [r15 + 8], offset .Lcodegen_harness.timer_callback_read_write
        mov	dword ptr [r15 + 28], 100
        or	r12, 1
        mov	qword ptr [r15], r12
        mov	ecx, dword ptr [r14 + 16]
        lea	eax, [rcx + 100]
        mov	dword ptr [r15 + 24], eax
        mov	rax, qword ptr [r14]
        test	rax, rax
        je	.L3
        mov	edx, dword ptr [rax + 8]
        sub	edx, ecx
        add	edx, -101
        cmp	edx, -65636
        jb	.L4
.L5:
        mov	r14, rax
        mov	rax, qword ptr [rax]
        test	rax, rax
        je	.L3
        mov	edx, dword ptr [rax + 8]
        sub	edx, ecx
        add	edx, 65535
        cmp	edx, 65636
        jb	.L5
        jmp	.L4
.L3:
        xor	eax, eax
.L4:
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
        je	.L6
        cmp	rax, rsi
        je	.L7
.L8:
        mov	rcx, qword ptr [rax]
        test	rcx, rcx
        je	.L6
        mov	rdi, rax
        mov	rax, rcx
        cmp	rcx, rsi
        jne	.L8
.L7:
        mov	rax, qword ptr [rsi]
        mov	qword ptr [rdi], rax
        mov	al, 1
        ret
.L6:
        xor	eax, eax
        ret

