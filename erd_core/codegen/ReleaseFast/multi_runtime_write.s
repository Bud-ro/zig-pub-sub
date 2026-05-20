multi_runtime_write:
        jmp	"system_data.SystemData(codegen_harness.MultiErdDefs,meta.FieldEnum(codegen_harness.MultiErdDefs),.{ .ram_counter = .{ ... }, .ram_flag = .{ ... }, .ram_value = .{ ... }, .ind_constant = .{ ... }, .ind_computed = .{ ... }, .conv_sum = .{ ... }, .conv_flag_inv = .{ ... } },codegen_harness.MultiComponents).runtimeWrite"

; --- called functions ---

"system_data.SystemData(codegen_harness.MultiErdDefs,meta.FieldEnum(codegen_harness.MultiErdDefs),.{ .ram_counter = .{ ... }, .ram_flag = .{ ... }, .ram_value = .{ ... }, .ind_constant = .{ ... }, .ind_computed = .{ ... }, .conv_sum = .{ ... }, .conv_flag_inv = .{ ... } },codegen_harness.MultiComponents).runtimeWrite":
        push	rbp
        push	r15
        push	r14
        push	r13
        push	r12
        push	rbx
        sub	rsp, 24
        movzx	eax, si
        cmp	byte ptr [rax + __anon_0], 0
        je	.LBB284_1
.LBB284_17:
        add	rsp, 24
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        ret
.LBB284_1:
        mov	rcx, rdi
        movzx	ebx, word ptr [rax + rax + __anon_1]
        movzx	eax, word ptr [rbx + rbx + __anon_2]
        movzx	eax, ax
        mov	rdi, qword ptr [8*rbx + __anon_3]
        add	rdi, rcx
        test	ax, ax
        sete	r9b
        mov	esi, 1
        mov	r8, rdx
        cmove	r8, rsi
        cmovne	rsi, rdi
        cmp	r8, rsi
        sete	r10b
        or	r10b, r9b
        cmp	r10b, 1
        jne	.LBB284_2
        mov	rsi, rdx
        mov	rdx, rax
        add	rsp, 24
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        jmp	memcpy@PLT
.LBB284_2:
        mov	r14, rcx
        cmp	ax, 16
        ja	.LBB284_11
        cmp	ax, 3
        ja	.LBB284_7
        movzx	ebp, byte ptr [rdx]
        movzx	ecx, byte ptr [rdx + rax - 1]
        mov	byte ptr [rsp + 12], cl
        movzx	r15d, byte ptr [rdi + rax - 1]
        mov	ecx, eax
        shr	ecx
        movzx	esi, byte ptr [rdx + rcx]
        mov	byte ptr [rsp + 8], sil
        movzx	ecx, byte ptr [rdi + rcx]
        mov	byte ptr [rsp + 4], cl
        movzx	r13d, byte ptr [rdi]
        mov	rsi, rdx
        mov	r12, rdx
        mov	rdx, rax
        call	memcpy@PLT
        cmp	bpl, r13b
        jne	.LBB284_16
        cmp	byte ptr [rsp + 12], r15b
        jne	.LBB284_16
        movzx	eax, byte ptr [rsp + 4]
        cmp	byte ptr [rsp + 8], al
        je	.LBB284_17
        jmp	.LBB284_16
.LBB284_11:
        lea	rcx, [rax - 1]
        shr	rcx, 4
        xor	r9d, r9d
.LBB284_13:
        movdqu	xmm0, xmmword ptr [r8 + r9]
        movdqu	xmm1, xmmword ptr [rsi + r9]
        pcmpeqb	xmm1, xmm0
        pmovmskb	r10d, xmm1
        xor	r10d, 65535
        jne	.LBB284_14
        add	r9, 16
        add	rcx, -1
        jne	.LBB284_13
        movdqu	xmm0, xmmword ptr [r8 + rax - 16]
        movdqu	xmm1, xmmword ptr [rsi + rax - 16]
        pcmpeqb	xmm1, xmm0
        pmovmskb	ebp, xmm1
        xor	ebp, 65535
        mov	rsi, rdx
        mov	r12, rdx
        mov	rdx, rax
        call	memcpy@PLT
        test	ebp, ebp
        jne	.LBB284_16
        jmp	.LBB284_17
.LBB284_14:
        mov	rsi, rdx
        mov	r12, rdx
        mov	rdx, rax
        call	memcpy@PLT
.LBB284_16:
        cmp	byte ptr [rbx + __anon_4], 0
        je	.LBB284_17
        mov	rcx, r14
        mov	rdi, r14
        mov	esi, ebx
        mov	rdx, r12
        add	rsp, 24
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        jmp	"ram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_harness.ram_defs))[0..3]).publish"
.LBB284_7:
        lea	rcx, [rax - 4]
        mov	esi, eax
        shr	esi
        and	esi, 12
        sub	rcx, rsi
        mov	r13d, dword ptr [rdi]
        mov	r8d, dword ptr [rdx + rax - 4]
        mov	dword ptr [rsp + 12], r8d
        mov	r15d, dword ptr [rdi + rax - 4]
        mov	r8d, dword ptr [rdx + rsi]
        mov	dword ptr [rsp + 8], r8d
        mov	esi, dword ptr [rdi + rsi]
        mov	dword ptr [rsp + 4], esi
        mov	esi, dword ptr [rdx + rcx]
        mov	dword ptr [rsp + 20], esi
        mov	ecx, dword ptr [rdi + rcx]
        mov	dword ptr [rsp + 16], ecx
        mov	ebp, dword ptr [rdx]
        mov	rsi, rdx
        mov	r12, rdx
        mov	rdx, rax
        call	memcpy@PLT
        cmp	r13d, ebp
        jne	.LBB284_16
        cmp	r15d, dword ptr [rsp + 12]
        jne	.LBB284_16
        mov	eax, dword ptr [rsp + 4]
        cmp	eax, dword ptr [rsp + 8]
        jne	.LBB284_16
        mov	eax, dword ptr [rsp + 16]
        cmp	eax, dword ptr [rsp + 20]
        je	.LBB284_17
        jmp	.LBB284_16

