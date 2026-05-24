; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 2 calls)
;
setup_timer_callback:
        mov	rcx, qword ptr [rsi]
        lea	rax, [rdx + 16]
        cmp	qword ptr [rdx + 8], 0
        setne	r8b
        cmp	rcx, rax
        sete	r9b
        or	r9b, r8b
        je	.L0
        mov	r8, rsi
        cmp	rcx, rax
        je	.L1
        test	rcx, rcx
        je	.L2
.L3:
        mov	r9, qword ptr [rcx]
        test	r9, r9
        je	.L2
        mov	r8, rcx
        mov	rcx, r9
        cmp	r9, rax
        jne	.L3
        jmp	.L1
.L2:
        mov	rcx, qword ptr [rsi + 8]
        cmp	rcx, rax
        je	.L4
        test	rcx, rcx
        je	.L0
.L5:
        mov	r9, qword ptr [rcx]
        test	r9, r9
        je	.L0
        mov	r8, rcx
        mov	rcx, r9
        cmp	r9, rax
        jne	.L5
        jmp	.L1
.L4:
        lea	r8, [rsi + 8]
.L1:
        mov	rcx, qword ptr [rax]
        mov	qword ptr [r8], rcx
.L0:
        mov	qword ptr [rdx + 8], offset codegen_harness.timer_callback_read_write
        mov	dword ptr [rdx + 28], 100
        or	rdi, 1
        mov	qword ptr [rdx], rdi
        mov	edi, dword ptr [rsi + 16]
        lea	ecx, [rdi + 100]
        mov	dword ptr [rdx + 24], ecx
        mov	rcx, qword ptr [rsi]
        test	rcx, rcx
        je	.L6
        mov	edx, dword ptr [rcx + 8]
        sub	edx, edi
        add	edx, -101
        cmp	edx, -65636
        jb	.L7
.L8:
        mov	rsi, rcx
        mov	rcx, qword ptr [rcx]
        test	rcx, rcx
        je	.L6
        mov	edx, dword ptr [rcx + 8]
        sub	edx, edi
        add	edx, 65535
        cmp	edx, 65636
        jb	.L8
.L7:
        mov	qword ptr [rax], rcx
        mov	qword ptr [rsi], rax
        ret
.L6:
        xor	ecx, ecx
        mov	qword ptr [rax], rcx
        mov	qword ptr [rsi], rax
        ret

