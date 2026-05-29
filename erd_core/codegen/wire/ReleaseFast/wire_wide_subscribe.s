; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 6 calls)
;
wire_wide_subscribe:
        mov	esi, 3
        mov	ecx, offset codegen_wire_publisher.downstreamCb
        xor	edx, edx
        jmp	Subscription.subscribe

; --- called functions ---

Subscription.subscribe:
        mov	r8, qword ptr [rdi + 8]
        cmp	r8, rcx
        je	.L0
        xor	eax, eax
        test	r8, r8
        cmove	rax, rdi
        cmp	rsi, 1
        je	.L1
        mov	r9, qword ptr [rdi + 24]
        cmp	r9, rcx
        je	.L0
        lea	r10, [rdi + 16]
        xor	eax, eax
        test	r9, r9
        cmove	rax, r10
        test	r8, r8
        cmove	rax, rdi
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
        mov	edi, offset __anon_0
        mov	esi, 19
        call	debug.defaultPanic

