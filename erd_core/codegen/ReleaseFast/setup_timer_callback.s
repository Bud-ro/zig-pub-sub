setup_timer_callback:
        mov	rcx, qword ptr [rsi]
        lea	rax, [rdx + 16]
        cmp	qword ptr [rdx + 8], 0
        setne	r8b
        cmp	rcx, rax
        sete	r9b
        or	r9b, r8b
        je	.LBB295_11
        test	rcx, rcx
        je	.LBB295_5
        mov	r8, rsi
        cmp	rcx, rax
        je	.LBB295_10
.LBB295_3:
        mov	r9, qword ptr [rcx]
        test	r9, r9
        je	.LBB295_5
        mov	r8, rcx
        mov	rcx, r9
        cmp	r9, rax
        jne	.LBB295_3
        jmp	.LBB295_10
.LBB295_5:
        mov	rcx, qword ptr [rsi + 8]
        test	rcx, rcx
        je	.LBB295_11
        cmp	rcx, rax
        je	.LBB295_9
.LBB295_7:
        mov	r9, qword ptr [rcx]
        test	r9, r9
        je	.LBB295_11
        mov	r8, rcx
        mov	rcx, r9
        cmp	r9, rax
        jne	.LBB295_7
        jmp	.LBB295_10
.LBB295_9:
        lea	r8, [rsi + 8]
.LBB295_10:
        mov	rcx, qword ptr [rax]
        mov	qword ptr [r8], rcx
.LBB295_11:
        mov	qword ptr [rdx + 8], offset codegen_harness.timer_callback_read_write
        mov	dword ptr [rdx + 28], 100
        or	rdi, 1
        mov	qword ptr [rdx], rdi
        mov	edi, dword ptr [rsi + 16]
        lea	ecx, [rdi + 100]
        mov	dword ptr [rdx + 24], ecx
        mov	rcx, qword ptr [rsi]
        test	rcx, rcx
        je	.LBB295_17
        mov	edx, dword ptr [rcx + 8]
        sub	edx, edi
        add	edx, -101
        cmp	edx, -65636
        jb	.LBB295_15
.LBB295_13:
        mov	rsi, rcx
        mov	rcx, qword ptr [rcx]
        test	rcx, rcx
        je	.LBB295_17
        mov	edx, dword ptr [rcx + 8]
        sub	edx, edi
        add	edx, 65535
        cmp	edx, 65636
        jb	.LBB295_13
.LBB295_15:
        mov	qword ptr [rax], rcx
        mov	qword ptr [rsi], rax
        ret
.LBB295_17:
        xor	ecx, ecx
        mov	qword ptr [rax], rcx
        mov	qword ptr [rsi], rax
        ret

