; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 6 calls)
;
wire_wide_subscribe:
        push	3
        pop	rsi
        mov	ecx, offset .Lcodegen_wire_publisher.downstreamCb
        xor	edx, edx
        jmp	.LSubscription.subscribe

; --- called functions ---

.LSubscription.subscribe:
        mov	r8, qword ptr [rdi + 8]
        cmp	r8, rcx
        je	.L0
        xor	eax, eax
        test	r8, r8
        cmove	rax, rdi
        cmp	rsi, 1
        je	.L1
        lea	r9, [rdi + 16]
        mov	r10, qword ptr [rdi + 24]
        xor	eax, eax
        test	r10, r10
        cmove	rax, r9
        test	r8, r8
        cmove	rax, rdi
        cmp	r10, rcx
        je	.L0
        cmp	rsi, 2
        je	.L1
        mov	rsi, qword ptr [rdi + 40]
        cmp	rsi, rcx
        je	.L0
        add	rdi, 32
        xor	r8d, r8d
        test	rsi, rsi
        cmove	r8, rdi
        test	rax, rax
        cmove	rax, r8
.L1:
        test	rax, rax
        je	.L2
        mov	qword ptr [rax], rdx
        mov	qword ptr [rax + 8], rcx
.L0:
        ret
.L2:
        push	rax
        mov	edi, offset .L__anon_0
        mov	esi, 19
        call	.Ldebug.defaultPanic

