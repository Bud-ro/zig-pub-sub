runtime_write_two:
        push	rbp
        mov	rbp, rsp
        push	r15
        push	r14
        push	rbx
        push	rax
        mov	rbx, r8
        mov	r14d, ecx
        mov	r15, rdi
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_194,meta.FieldEnum(codegen_harness.SmallSystem__struct_194),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).runtimeWrite"
        mov	rdi, r15
        mov	esi, r14d
        mov	rdx, rbx
        add	rsp, 8
        pop	rbx
        pop	r14
        pop	r15
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_194,meta.FieldEnum(codegen_harness.SmallSystem__struct_194),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).runtimeWrite"

; --- called functions ---

"system_data.SystemData(codegen_harness.SmallSystem__struct_194,meta.FieldEnum(codegen_harness.SmallSystem__struct_194),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).runtimeWrite":
        push	rbp
        mov	rbp, rsp
        push	r15
        push	r14
        push	r13
        push	r12
        push	rbx
        sub	rsp, 24
        mov	rbx, rdi
        movzx	eax, si
        movzx	r14d, word ptr [rax + rax + __anon_1938]
        movzx	eax, word ptr [r14 + r14 + __anon_29526]
        movzx	eax, ax
        mov	rdi, qword ptr [8*r14 + __anon_1110]
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
        je	.LBB312_1
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
.LBB312_1:
        cmp	ax, 16
        ja	.LBB312_11
        cmp	ax, 3
        ja	.LBB312_6
        movzx	r12d, byte ptr [rdx]
        movzx	ecx, byte ptr [rdx + rax - 1]
        mov	byte ptr [rbp - 56], cl
        movzx	ecx, byte ptr [rdi + rax - 1]
        mov	byte ptr [rbp - 52], cl
        mov	ecx, eax
        shr	ecx
        movzx	esi, byte ptr [rdx + rcx]
        mov	byte ptr [rbp - 48], sil
        movzx	ecx, byte ptr [rdi + rcx]
        mov	byte ptr [rbp - 44], cl
        movzx	r13d, byte ptr [rdi]
        mov	r15, rdx
        mov	rsi, rdx
        mov	rdx, rax
        call	memcpy@PLT
        cmp	r12b, r13b
        jne	.LBB312_16
        movzx	eax, byte ptr [rbp - 52]
        cmp	byte ptr [rbp - 56], al
        jne	.LBB312_16
        movzx	eax, byte ptr [rbp - 44]
        cmp	byte ptr [rbp - 48], al
        je	.LBB312_10
        jmp	.LBB312_16
.LBB312_11:
        lea	r8, [rax - 1]
        shr	r8, 4
        xor	r9d, r9d
.LBB312_13:
        movdqu	xmm0, xmmword ptr [rsi + r9]
        movdqu	xmm1, xmmword ptr [rcx + r9]
        pcmpeqb	xmm1, xmm0
        pmovmskb	r10d, xmm1
        xor	r10d, 65535
        jne	.LBB312_14
        add	r9, 16
        add	r8, -1
        jne	.LBB312_13
        movdqu	xmm0, xmmword ptr [rsi + rax - 16]
        movdqu	xmm1, xmmword ptr [rcx + rax - 16]
        pcmpeqb	xmm1, xmm0
        pmovmskb	r12d, xmm1
        xor	r12d, 65535
        mov	r15, rdx
        mov	rsi, rdx
        mov	rdx, rax
        call	memcpy@PLT
        test	r12d, r12d
        jne	.LBB312_16
        jmp	.LBB312_10
.LBB312_14:
        mov	r15, rdx
        mov	rsi, rdx
        mov	rdx, rax
        call	memcpy@PLT
.LBB312_16:
        cmp	byte ptr [r14 + __anon_1928], 0
        je	.LBB312_10
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
        jmp	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
.LBB312_6:
        lea	rcx, [rax - 4]
        mov	esi, eax
        shr	esi
        and	esi, 12
        sub	rcx, rsi
        mov	r12d, dword ptr [rdi]
        mov	r8d, dword ptr [rdx + rax - 4]
        mov	dword ptr [rbp - 56], r8d
        mov	r8d, dword ptr [rdi + rax - 4]
        mov	dword ptr [rbp - 52], r8d
        mov	r8d, dword ptr [rdx + rsi]
        mov	dword ptr [rbp - 48], r8d
        mov	esi, dword ptr [rdi + rsi]
        mov	dword ptr [rbp - 44], esi
        mov	esi, dword ptr [rdx + rcx]
        mov	dword ptr [rbp - 64], esi
        mov	ecx, dword ptr [rdi + rcx]
        mov	dword ptr [rbp - 60], ecx
        mov	r13d, dword ptr [rdx]
        mov	r15, rdx
        mov	rsi, rdx
        mov	rdx, rax
        call	memcpy@PLT
        cmp	r12d, r13d
        jne	.LBB312_16
        mov	eax, dword ptr [rbp - 52]
        cmp	eax, dword ptr [rbp - 56]
        jne	.LBB312_16
        mov	eax, dword ptr [rbp - 44]
        cmp	eax, dword ptr [rbp - 48]
        jne	.LBB312_16
        mov	eax, dword ptr [rbp - 60]
        cmp	eax, dword ptr [rbp - 64]
        jne	.LBB312_16
.LBB312_10:
        add	rsp, 24
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        ret

