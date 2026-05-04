runtime_write:
        jmp	".Lsystem_data.SystemData(codegen_harness.SmallSystem__struct_0,meta.FieldEnum(codegen_harness.SmallSystem__struct_0),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).runtimeWrite"

; --- called functions ---

".Lsystem_data.SystemData(codegen_harness.SmallSystem__struct_0,meta.FieldEnum(codegen_harness.SmallSystem__struct_0),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).runtimeWrite":
        push	rbp
        push	r15
        push	r14
        push	r13
        push	r12
        push	rbx
        sub	rsp, 24
        mov	rbx, rdi
        movzx	eax, si
        movzx	r14d, word ptr [rax + rax + .L__anon_1]
        movzx	eax, word ptr [r14 + r14 + .L__anon_2]
        movzx	eax, ax
        mov	rdi, qword ptr [8*r14 + .L__anon_3]
        add	rdi, rbx
        test	ax, ax
        mov	ecx, 1
        mov	rsi, rdx
        cmove	rsi, rcx
        cmovne	rcx, rdi
        sete	r8b
        cmp	rsi, rcx
        sete	r9b
        or	r9b, r8b
        je	.LBB44_1
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
.LBB44_1:
        cmp	ax, 16
        ja	.LBB44_11
        cmp	ax, 4
        jae	.LBB44_6
        movzx	ebp, byte ptr [rdx]
        movzx	ecx, byte ptr [rdx + rax - 1]
        mov	byte ptr [rsp + 12], cl
        movzx	r12d, byte ptr [rdi + rax - 1]
        mov	ecx, eax
        shr	ecx
        movzx	esi, byte ptr [rdx + rcx]
        mov	byte ptr [rsp + 8], sil
        movzx	ecx, byte ptr [rdi + rcx]
        mov	byte ptr [rsp + 4], cl
        movzx	r13d, byte ptr [rdi]
        mov	r15, rdx
        mov	rsi, rdx
        mov	rdx, rax
        call	memcpy@PLT
        cmp	bpl, r13b
        jne	.LBB44_16
        cmp	byte ptr [rsp + 12], r12b
        jne	.LBB44_16
        movzx	eax, byte ptr [rsp + 4]
        cmp	byte ptr [rsp + 8], al
        je	.LBB44_10
        jmp	.LBB44_16
.LBB44_11:
        lea	r8, [rax - 1]
        shr	r8, 4
        add	r8, 1
        xor	r9d, r9d
.LBB44_12:
        add	r8, -1
        je	.LBB44_15
        movdqu	xmm0, xmmword ptr [rsi + r9]
        movdqu	xmm1, xmmword ptr [rcx + r9]
        add	r9, 16
        pcmpeqb	xmm1, xmm0
        pmovmskb	r10d, xmm1
        xor	r10d, 65535
        je	.LBB44_12
        mov	r15, rdx
        mov	rsi, rdx
        mov	rdx, rax
        call	memcpy@PLT
        jmp	.LBB44_16
.LBB44_15:
        movdqu	xmm0, xmmword ptr [rsi + rax - 16]
        movdqu	xmm1, xmmword ptr [rcx + rax - 16]
        pcmpeqb	xmm1, xmm0
        pmovmskb	ebp, xmm1
        xor	ebp, 65535
        mov	r15, rdx
        mov	rsi, rdx
        mov	rdx, rax
        call	memcpy@PLT
        test	ebp, ebp
        jne	.LBB44_16
        jmp	.LBB44_10
.LBB44_6:
        lea	rcx, [rax - 4]
        mov	esi, eax
        shr	esi
        and	esi, 12
        sub	rcx, rsi
        mov	ebp, dword ptr [rdi + rcx]
        mov	r8d, dword ptr [rdi + rsi]
        mov	dword ptr [rsp + 12], r8d
        mov	r13d, dword ptr [rdx + rsi]
        mov	esi, dword ptr [rdi + rax - 4]
        mov	dword ptr [rsp + 8], esi
        mov	esi, dword ptr [rdx + rax - 4]
        mov	dword ptr [rsp + 4], esi
        mov	esi, dword ptr [rdi]
        mov	dword ptr [rsp + 20], esi
        mov	esi, dword ptr [rdx]
        mov	dword ptr [rsp + 16], esi
        mov	r12d, dword ptr [rdx + rcx]
        mov	r15, rdx
        mov	rsi, rdx
        mov	rdx, rax
        call	memcpy@PLT
        cmp	ebp, r12d
        jne	.LBB44_16
        cmp	dword ptr [rsp + 12], r13d
        jne	.LBB44_16
        mov	eax, dword ptr [rsp + 4]
        cmp	dword ptr [rsp + 8], eax
        jne	.LBB44_16
        mov	eax, dword ptr [rsp + 16]
        cmp	dword ptr [rsp + 20], eax
        je	.LBB44_10
.LBB44_16:
        cmp	byte ptr [r14 + .L__anon_4], 0
        je	.LBB44_10
        mov	rdi, rbx
        mov	esi, r14d
        mov	rdx, r15
        mov	rcx, rbx
        add	rsp, 24
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        jmp	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
.LBB44_10:
        add	rsp, 24
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        ret

