runtime_write_three:
        push	rbp
        push	r15
        push	r14
        push	r12
        push	rbx
        mov	ebx, r9d
        mov	r14, r8
        mov	ebp, ecx
        mov	r15, rdi
        mov	r12, qword ptr [rsp + 48]
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_0,meta.FieldEnum(codegen_harness.SmallSystem__struct_0),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).runtimeWrite"
        mov	rdi, r15
        mov	esi, ebp
        mov	rdx, r14
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_0,meta.FieldEnum(codegen_harness.SmallSystem__struct_0),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).runtimeWrite"
        mov	rdi, r15
        mov	esi, ebx
        mov	rdx, r12
        pop	rbx
        pop	r12
        pop	r14
        pop	r15
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_0,meta.FieldEnum(codegen_harness.SmallSystem__struct_0),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).runtimeWrite"

; --- called functions ---

"system_data.SystemData(codegen_harness.SmallSystem__struct_0,meta.FieldEnum(codegen_harness.SmallSystem__struct_0),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).runtimeWrite":
        push	rbp
        push	r15
        push	r14
        push	r13
        push	r12
        push	rbx
        sub	rsp, 24
        mov	rbx, rdi
        movzx	eax, si
        movzx	r14d, word ptr [rax + rax + __anon_1]
        movzx	eax, word ptr [r14 + r14 + __anon_2]
        movzx	eax, ax
        mov	rdi, qword ptr [8*r14 + __anon_3]
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
        je	.LBB318_1
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
.LBB318_1:
        cmp	ax, 16
        ja	.LBB318_11
        cmp	ax, 3
        ja	.LBB318_6
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
        jne	.LBB318_16
        cmp	byte ptr [rsp + 12], r12b
        jne	.LBB318_16
        movzx	eax, byte ptr [rsp + 4]
        cmp	byte ptr [rsp + 8], al
        je	.LBB318_10
        jmp	.LBB318_16
.LBB318_11:
        lea	r8, [rax - 1]
        shr	r8, 4
        xor	r9d, r9d
.LBB318_13:
        movdqu	xmm0, xmmword ptr [rsi + r9]
        movdqu	xmm1, xmmword ptr [rcx + r9]
        pcmpeqb	xmm1, xmm0
        pmovmskb	r10d, xmm1
        xor	r10d, 65535
        jne	.LBB318_14
        add	r9, 16
        add	r8, -1
        jne	.LBB318_13
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
        jne	.LBB318_16
        jmp	.LBB318_10
.LBB318_14:
        mov	r15, rdx
        mov	rsi, rdx
        mov	rdx, rax
        call	memcpy@PLT
.LBB318_16:
        cmp	byte ptr [r14 + __anon_4], 0
        je	.LBB318_10
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
        jmp	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish.2"
.LBB318_6:
        lea	rcx, [rax - 4]
        mov	esi, eax
        shr	esi
        and	esi, 12
        sub	rcx, rsi
        mov	ebp, dword ptr [rdi]
        mov	r8d, dword ptr [rdx + rax - 4]
        mov	dword ptr [rsp + 12], r8d
        mov	r13d, dword ptr [rdi + rax - 4]
        mov	r8d, dword ptr [rdx + rsi]
        mov	dword ptr [rsp + 8], r8d
        mov	esi, dword ptr [rdi + rsi]
        mov	dword ptr [rsp + 4], esi
        mov	esi, dword ptr [rdx + rcx]
        mov	dword ptr [rsp + 20], esi
        mov	ecx, dword ptr [rdi + rcx]
        mov	dword ptr [rsp + 16], ecx
        mov	r12d, dword ptr [rdx]
        mov	r15, rdx
        mov	rsi, rdx
        mov	rdx, rax
        call	memcpy@PLT
        cmp	ebp, r12d
        jne	.LBB318_16
        cmp	r13d, dword ptr [rsp + 12]
        jne	.LBB318_16
        mov	eax, dword ptr [rsp + 4]
        cmp	eax, dword ptr [rsp + 8]
        jne	.LBB318_16
        mov	eax, dword ptr [rsp + 16]
        cmp	eax, dword ptr [rsp + 20]
        jne	.LBB318_16
.LBB318_10:
        add	rsp, 24
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        ret

