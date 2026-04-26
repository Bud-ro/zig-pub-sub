codegen_read_u32:
        push	rbp
        mov	rbp, rsp
        mov	eax, dword ptr [rdi]
        pop	rbp
        ret

codegen_read_bool:
        push	rbp
        mov	rbp, rsp
        mov	al, byte ptr [rdi + 4]
        and	al, 1
        pop	rbp
        ret

codegen_read_u16_unaligned:
        push	rbp
        mov	rbp, rsp
        movzx	eax, word ptr [rdi + 5]
        pop	rbp
        ret

codegen_write_u32_no_subs:
        push	rbp
        mov	rbp, rsp
        mov	esi, -559038737
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1072"

codegen_write_u16_no_subs:
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 16
        mov	r14, rdi
        lea	rdi, [rbp - 18]
        mov	ebx, esi
        lea	rdx, [r14 + 5]
        mov	word ptr [rdi], bx
        push	2
        pop	rcx
        mov	rsi, rcx
        call	mem.eql__anon_1101
        mov	word ptr [r14 + 5], bx
        add	rsp, 16
        pop	rbx
        pop	r14
        pop	rbp
        ret

codegen_write_bool_with_subs:
        push	rbp
        mov	rbp, rsp
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_2428"

codegen_write_u16_with_subs:
        push	rbp
        mov	rbp, rsp
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_2489"

codegen_runtime_write_u32:
        push	rbp
        mov	rbp, rsp
        push	rbx
        push	rax
        mov	rbx, rdi
        push	4
        pop	rcx
        mov	edi, offset __anon_1070
        mov	rsi, rcx
        mov	rdx, rbx
        call	mem.eql__anon_1101
        mov	dword ptr [rbx], -559038737
        add	rsp, 8
        pop	rbx
        pop	rbp
        ret

codegen_dual_read:
        push	rbp
        mov	rbp, rsp
        mov	ecx, dword ptr [rdi]
        movsxd	rax, dword ptr [rsi]
        add	rax, rcx
        pop	rbp
        ret

codegen_dual_write:
        push	rbp
        mov	rbp, rsp
        push	rbx
        push	rax
        mov	rbx, rsi
        push	42
        pop	rsi
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1072"
        lea	rdi, [rbp - 12]
        lea	rdx, [rbx + 4]
        or	dword ptr [rdi], -1
        push	4
        pop	rcx
        mov	rsi, rcx
        call	mem.eql__anon_1101
        or	dword ptr [rbx + 4], -1
        add	rsp, 8
        pop	rbx
        pop	rbp
        ret

codegen_many_read_first:
        push	rbp
        mov	rbp, rsp
        mov	al, byte ptr [rdi]
        pop	rbp
        ret

codegen_many_read_middle:
        push	rbp
        mov	rbp, rsp
        mov	eax, dword ptr [rdi + 48]
        pop	rbp
        ret

codegen_many_read_last:
        push	rbp
        mov	rbp, rsp
        mov	rax, qword ptr [rdi + 112]
        pop	rbp
        ret

codegen_many_write_last_with_subs:
        push	rbp
        mov	rbp, rsp
        push	r15
        push	r14
        push	r12
        push	rbx
        sub	rsp, 32
        mov	rbx, rdi
        lea	rdi, [rbp - 56]
        mov	r14, rsi
        mov	qword ptr [rbp - 40], rsi
        lea	rdx, [rbx + 112]
        mov	qword ptr [rdi], rsi
        push	8
        pop	rcx
        mov	rsi, rcx
        call	mem.eql__anon_1101
        mov	qword ptr [rbx + 112], r14
        test	al, 1
        je	.LBB18_1
.LBB18_6:
        add	rsp, 32
        pop	rbx
        pop	r12
        pop	r14
        pop	r15
        pop	rbp
        ret
.LBB18_1:
        mov	r15d, 144
        lea	r12, [rbp - 40]
        lea	r14, [rbp - 56]
.LBB18_2:
        cmp	r15, 192
        je	.LBB18_6
        mov	rax, qword ptr [rbx + r15]
        test	rax, rax
        je	.LBB18_4
        mov	rdi, qword ptr [rbx + r15 - 8]
        mov	word ptr [rbp - 48], 31
        mov	qword ptr [rbp - 56], r12
        mov	rsi, r14
        mov	rdx, rbx
        call	rax
.LBB18_4:
        add	r15, 16
        jmp	.LBB18_2

codegen_many_write_middle_no_subs:
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 16
        mov	r14, rdi
        lea	rdi, [rbp - 20]
        mov	ebx, esi
        lea	rdx, [r14 + 48]
        mov	dword ptr [rdi], esi
        push	4
        pop	rcx
        mov	rsi, rcx
        call	mem.eql__anon_1101
        mov	dword ptr [r14 + 48], ebx
        add	rsp, 16
        pop	rbx
        pop	r14
        pop	rbp
        ret

codegen_read_big_struct:
        push	rbp
        mov	rbp, rsp
        vmovups	zmm0, zmmword ptr [rsi]
        vmovups	zmm1, zmmword ptr [rsi + 64]
        vmovups	zmm2, zmmword ptr [rsi + 128]
        vmovups	zmm3, zmmword ptr [rsi + 192]
        mov	rax, rdi
        vmovups	zmmword ptr [rdi + 192], zmm3
        vmovups	zmmword ptr [rdi + 128], zmm2
        vmovups	zmmword ptr [rdi + 64], zmm1
        vmovups	zmmword ptr [rdi], zmm0
        pop	rbp
        vzeroupper
        ret

codegen_read_medium_struct:
        push	rbp
        mov	rbp, rsp
        mov	rcx, qword ptr [rsi + 272]
        mov	rax, rdi
        mov	qword ptr [rdi + 16], rcx
        vmovups	xmm0, xmmword ptr [rsi + 256]
        vmovups	xmmword ptr [rdi], xmm0
        pop	rbp
        ret

codegen_read_u32_after_big:
        push	rbp
        mov	rbp, rsp
        mov	eax, dword ptr [rdi + 280]
        pop	rbp
        ret

codegen_write_big_struct:
        push	rbp
        mov	rbp, rsp
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.HugeSystem__struct_3991,meta.FieldEnum(codegen_harness.HugeSystem__struct_3991),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).write__anon_4238"

codegen_write_medium_with_subs:
        push	rbp
        mov	rbp, rsp
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.HugeSystem__struct_3991,meta.FieldEnum(codegen_harness.HugeSystem__struct_3991),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).write__anon_4267"

codegen_read_modify_write_medium:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        mov	rax, qword ptr [rdi + 272]
        lea	rsi, [rbp - 32]
        mov	qword ptr [rsi + 16], rax
        inc	eax
        vmovups	xmm0, xmmword ptr [rdi + 256]
        vmovaps	xmmword ptr [rsi], xmm0
        mov	dword ptr [rsi + 16], eax
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_3991,meta.FieldEnum(codegen_harness.HugeSystem__struct_3991),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).write__anon_4267"
        add	rsp, 32
        pop	rbp
        ret

codegen_read_modify_write_big:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 256
        vmovups	zmm0, zmmword ptr [rdi]
        vmovups	zmm1, zmmword ptr [rdi + 64]
        vmovups	zmm2, zmmword ptr [rdi + 128]
        vmovups	zmm3, zmmword ptr [rdi + 192]
        lea	rsi, [rbp - 256]
        vmovups	zmmword ptr [rsi], zmm0
        inc	byte ptr [rsi]
        vmovups	zmmword ptr [rsi + 192], zmm3
        vmovups	zmmword ptr [rsi + 128], zmm2
        vmovups	zmmword ptr [rsi + 64], zmm1
        vzeroupper
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_3991,meta.FieldEnum(codegen_harness.HugeSystem__struct_3991),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).write__anon_4238"
        add	rsp, 256
        pop	rbp
        ret

codegen_setup_timer_callback:
        push	rbp
        mov	rbp, rsp
        push	r15
        push	r14
        push	r12
        push	rbx
        cmp	qword ptr [rdx + 8], 0
        lea	rbx, [rdx + 16]
        mov	r15, rdx
        mov	r14, rsi
        mov	r12, rdi
        je	.LBB29_1
.LBB29_8:
        mov	rdi, r14
        mov	rsi, rbx
        call	timer.TimerModule.try_remove
        test	al, 1
        jne	.LBB29_2
        lea	rdi, [r14 + 8]
        mov	rsi, rbx
        call	timer.TimerModule.try_remove
        jmp	.LBB29_2
.LBB29_1:
        cmp	qword ptr [r14], rbx
        je	.LBB29_8
.LBB29_2:
        or	r12, 1
        mov	qword ptr [r15 + 8], offset codegen_harness.timer_callback_read_write
        mov	dword ptr [r15 + 28], 100
        mov	qword ptr [r15], r12
        mov	ecx, dword ptr [r14 + 16]
        lea	eax, [rcx + 100]
        mov	dword ptr [r15 + 24], eax
        mov	rax, qword ptr [r14]
        test	rax, rax
        je	.LBB29_3
        mov	edx, dword ptr [rax + 8]
        sub	edx, ecx
        add	edx, -101
        cmp	edx, -65636
        jb	.LBB29_7
.LBB29_5:
        mov	r14, rax
        mov	rax, qword ptr [rax]
        test	rax, rax
        je	.LBB29_3
        mov	edx, dword ptr [rax + 8]
        sub	edx, ecx
        add	edx, 65535
        cmp	edx, 65636
        jb	.LBB29_5
        jmp	.LBB29_7
.LBB29_3:
        xor	eax, eax
.LBB29_7:
        mov	qword ptr [rbx], rax
        mov	qword ptr [r14], rbx
        pop	rbx
        pop	r12
        pop	r14
        pop	r15
        pop	rbp
        ret

codegen_harness.timer_callback_read_write:
        push	rbp
        mov	rbp, rsp
        mov	esi, dword ptr [rdi]
        inc	esi
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1072"

codegen_triple_read_same_erd:
        push	rbp
        mov	rbp, rsp
        imul	eax, dword ptr [rdi], 3
        pop	rbp
        ret

codegen_read_then_branch:
        push	rbp
        mov	rbp, rsp
        mov	eax, dword ptr [rdi]
        mov	ecx, eax
        imul	ecx, eax
        add	eax, eax
        test	esi, esi
        cmove	eax, ecx
        pop	rbp
        ret

codegen_read_write_read:
        push	rbp
        mov	rbp, rsp
        push	rbx
        push	rax
        mov	esi, dword ptr [rdi]
        mov	rbx, rdi
        inc	esi
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1072"
        mov	eax, dword ptr [rbx]
        add	rsp, 8
        pop	rbx
        pop	rbp
        ret

codegen_read_write_other_read:
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        mov	r14d, dword ptr [rdi]
        mov	rbx, rdi
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_2428"
        add	r14d, dword ptr [rbx]
        mov	eax, r14d
        pop	rbx
        pop	r14
        pop	rbp
        ret

codegen_read_across_two_erds:
        push	rbp
        mov	rbp, rsp
        mov	eax, dword ptr [rdi]
        movzx	ecx, word ptr [rdi + 5]
        lea	eax, [rcx + 2*rax]
        pop	rbp
        ret

codegen_subscribe_callback:
        mov	rax, qword ptr [rdi + 24]
        cmp	rax, offset codegen_harness.accumulate_callback
        je	.LBB37_3
        test	rax, rax
        jne	.LBB37_4
        and	qword ptr [rdi + 16], 0
        mov	qword ptr [rdi + 24], offset codegen_harness.accumulate_callback
.LBB37_3:
        ret
.LBB37_4:
        push	rbp
        mov	rbp, rsp
        call	debug.panic__anon_4476

codegen_harness.accumulate_callback:
        push	rbp
        mov	rbp, rsp
        mov	rax, qword ptr [rsi]
        cmp	byte ptr [rax], 0
        je	.LBB38_1
        mov	esi, dword ptr [rdx]
        mov	rdi, rdx
        inc	esi
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1072"
.LBB38_1:
        pop	rbp
        ret

codegen_write_triggering_callback:
        push	rbp
        mov	rbp, rsp
        mov	esi, 1
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_2428"

codegen_increment_n_times:
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        mov	ebx, esi
        mov	r14, rdi
.LBB60_1:
        cmp	ebx, 1
        jb	.LBB60_3
        mov	esi, dword ptr [r14]
        mov	rdi, r14
        inc	esi
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1072"
        dec	ebx
        jmp	.LBB60_1
.LBB60_3:
        pop	rbx
        pop	r14
        pop	rbp
        ret

codegen_conditional_write_chain:
        push	rbp
        mov	rbp, rsp
        push	rbx
        push	rax
        test	byte ptr [rdi + 4], 1
        mov	rbx, rdi
        je	.LBB61_1
        mov	esi, dword ptr [rbx]
        mov	rdi, rbx
        add	esi, 10
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1072"
.LBB61_1:
        cmp	word ptr [rbx + 5], 100
        jbe	.LBB61_4
        mov	esi, dword ptr [rbx]
        mov	rdi, rbx
        add	esi, 20
        add	rsp, 8
        pop	rbx
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1072"
.LBB61_4:
        add	rsp, 8
        pop	rbx
        pop	rbp
        ret

codegen_cross_erd_compute:
        push	rbp
        mov	rbp, rsp
        movzx	esi, word ptr [rdi + 5]
        add	si, word ptr [rdi]
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_2489"

codegen_cross_system_read_add:
        push	rbp
        mov	rbp, rsp
        mov	eax, dword ptr [rdi]
        movsxd	rcx, dword ptr [rsi]
        movzx	edx, word ptr [rdi + 5]
        add	rcx, rax
        movsxd	rax, dword ptr [rsi + 4]
        add	rax, rdx
        add	rax, rcx
        pop	rbp
        ret

codegen_cross_system_read_write:
        push	rbp
        mov	rbp, rsp
        mov	esi, dword ptr [rsi]
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1072"

codegen_cross_system_swap:
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 32
        mov	rbx, rsi
        mov	esi, dword ptr [rsi]
        mov	r14d, dword ptr [rdi]
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1072"
        lea	rdi, [rbp - 40]
        mov	dword ptr [rbp - 20], r14d
        mov	dword ptr [rdi], r14d
        push	4
        pop	rcx
        mov	rsi, rcx
        mov	rdx, rbx
        call	mem.eql__anon_1101
        mov	dword ptr [rbx], r14d
        test	al, 1
        jne	.LBB65_3
        mov	rax, qword ptr [rbx + 24]
        test	rax, rax
        je	.LBB65_3
        lea	rsi, [rbp - 40]
        mov	rdi, qword ptr [rbx + 16]
        lea	rcx, [rbp - 20]
        mov	rdx, rbx
        and	word ptr [rsi + 8], 0
        mov	qword ptr [rsi], rcx
        call	rax
.LBB65_3:
        add	rsp, 32
        pop	rbx
        pop	r14
        pop	rbp
        ret

codegen_runtime_read_u32:
        push	rbp
        mov	rbp, rsp
        pop	rbp
        jmp	codegen_read_u32

; --- called functions ---

"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1072":
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 16
        mov	r14, rdi
        lea	rdi, [rbp - 20]
        mov	ebx, esi
        mov	dword ptr [rdi], esi
        push	4
        pop	rcx
        mov	rsi, rcx
        mov	rdx, r14
        call	mem.eql__anon_1101
        mov	dword ptr [r14], ebx
        add	rsp, 16
        pop	rbx
        pop	r14
        pop	rbp
        ret

mem.eql__anon_1101:
        cmp	rsi, rcx
        jne	.LBB5_17
        cmp	rdi, rdx
        je	.LBB5_5
        cmp	rsi, 16
        ja	.LBB5_6
        cmp	rsi, 4
        jae	.LBB5_8
        mov	al, byte ptr [rdi]
        mov	cl, byte ptr [rdi + rsi - 1]
        mov	r8, rsi
        shr	r8
        mov	dil, byte ptr [rdi + r8]
        xor	al, byte ptr [rdx]
        xor	cl, byte ptr [rdx + rsi - 1]
        xor	dil, byte ptr [rdx + r8]
        or	cl, al
        or	dil, cl
        jmp	.LBB5_20
.LBB5_5:
        mov	al, 1
        ret
.LBB5_6:
        cmp	rsi, 33
        jae	.LBB5_11
        vmovdqu	xmm0, xmmword ptr [rdi]
        vmovdqu	xmm1, xmmword ptr [rdi + rsi - 16]
        vpcmpneqb	k0, xmm0, xmmword ptr [rdx]
        vpcmpneqb	k1, xmm1, xmmword ptr [rdx + rsi - 16]
        kortestw	k0, k1
        jmp	.LBB5_20
.LBB5_8:
        push	rbp
        mov	rbp, rsp
        and	qword ptr [rbp - 32], 0
        lea	rax, [rsi - 4]
        shr	esi
        xor	ecx, ecx
        and	esi, 12
        mov	qword ptr [rbp - 24], rax
        sub	rax, rsi
        mov	qword ptr [rbp - 16], rsi
        mov	qword ptr [rbp - 8], rax
        xor	eax, eax
.LBB5_9:
        cmp	rcx, 4
        je	.LBB5_13
        mov	rsi, qword ptr [rbp + 8*rcx - 32]
        inc	rcx
        mov	r8d, dword ptr [rdx + rsi]
        xor	r8d, dword ptr [rdi + rsi]
        or	eax, r8d
        jmp	.LBB5_9
.LBB5_11:
        cmp	rsi, 64
        ja	.LBB5_14
        vmovdqu	ymm0, ymmword ptr [rdi]
        vmovdqu	ymm1, ymmword ptr [rdi + rsi - 32]
        vpcmpneqb	k0, ymm0, ymmword ptr [rdx]
        vpcmpneqb	k1, ymm1, ymmword ptr [rdx + rsi - 32]
        kortestd	k0, k1
        jmp	.LBB5_20
.LBB5_13:
        test	eax, eax
        sete	al
        pop	rbp
        ret
.LBB5_14:
        lea	rax, [rsi - 1]
        xor	ecx, ecx
        and	rax, -64
.LBB5_15:
        cmp	rax, rcx
        je	.LBB5_19
        vmovdqu64	zmm0, zmmword ptr [rdi + rcx]
        vpcmpneqd	k0, zmm0, zmmword ptr [rdx + rcx]
        add	rcx, 64
        kortestw	k0, k0
        je	.LBB5_15
.LBB5_17:
        xor	eax, eax
        vzeroupper
        ret
.LBB5_19:
        vmovdqu64	zmm0, zmmword ptr [rdi + rsi - 64]
        vpcmpneqd	k0, zmm0, zmmword ptr [rdx + rsi - 64]
        kortestw	k0, k0
.LBB5_20:
        sete	al
        vzeroupper
        ret

"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_2428":
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 16
        mov	r14d, esi
        mov	rbx, rdi
        and	r14b, 1
        lea	rdi, [rbp - 18]
        lea	rdx, [rbx + 4]
        mov	byte ptr [rbp - 17], r14b
        mov	byte ptr [rdi], r14b
        push	1
        pop	rcx
        mov	rsi, rcx
        call	mem.eql__anon_1101
        mov	byte ptr [rbx + 4], r14b
        test	al, 1
        jne	.LBB8_2
        push	1
        pop	rsi
        lea	rdx, [rbp - 17]
        mov	rdi, rbx
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
.LBB8_2:
        add	rsp, 16
        pop	rbx
        pop	r14
        pop	rbp
        ret

"system_data.SystemData(codegen_harness.HugeSystem__struct_3991,meta.FieldEnum(codegen_harness.HugeSystem__struct_3991),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).write__anon_4238":
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 256
        vmovups	zmm0, zmmword ptr [rsi]
        vmovups	zmm1, zmmword ptr [rsi + 64]
        vmovups	zmm2, zmmword ptr [rsi + 128]
        vmovups	zmm3, zmmword ptr [rsi + 192]
        mov	r14, rdi
        lea	rdi, [rbp - 272]
        mov	rbx, rsi
        mov	esi, 256
        mov	ecx, 256
        mov	rdx, r14
        vmovups	zmmword ptr [rdi + 192], zmm3
        vmovups	zmmword ptr [rdi + 128], zmm2
        vmovups	zmmword ptr [rdi + 64], zmm1
        vmovups	zmmword ptr [rdi], zmm0
        vzeroupper
        call	mem.eql__anon_1101
        vmovups	zmm0, zmmword ptr [rbx]
        vmovups	zmm1, zmmword ptr [rbx + 64]
        vmovups	zmm2, zmmword ptr [rbx + 128]
        vmovups	zmm3, zmmword ptr [rbx + 192]
        vmovups	zmmword ptr [r14], zmm0
        vmovups	zmmword ptr [r14 + 192], zmm3
        vmovups	zmmword ptr [r14 + 128], zmm2
        vmovups	zmmword ptr [r14 + 64], zmm1
        add	rsp, 256
        pop	rbx
        pop	r14
        pop	rbp
        vzeroupper
        ret

"system_data.SystemData(codegen_harness.HugeSystem__struct_3991,meta.FieldEnum(codegen_harness.HugeSystem__struct_3991),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).write__anon_4267":
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 64
        mov	rax, qword ptr [rsi + 16]
        mov	rbx, rdi
        lea	rdi, [rbp - 80]
        mov	r14, rsi
        lea	rdx, [rbx + 256]
        mov	qword ptr [rbp - 32], rax
        vmovups	xmm0, xmmword ptr [rsi]
        vmovaps	xmmword ptr [rbp - 48], xmm0
        mov	rax, qword ptr [rsi + 16]
        mov	qword ptr [rdi + 16], rax
        vmovups	xmm0, xmmword ptr [rsi]
        vmovaps	xmmword ptr [rdi], xmm0
        push	24
        pop	rcx
        mov	rsi, rcx
        call	mem.eql__anon_1101
        vmovups	xmm0, xmmword ptr [r14]
        mov	rcx, qword ptr [r14 + 16]
        mov	qword ptr [rbx + 272], rcx
        vmovups	xmmword ptr [rbx + 256], xmm0
        test	al, 1
        jne	.LBB26_3
        mov	rax, qword ptr [rbx + 296]
        test	rax, rax
        je	.LBB26_3
        mov	rdi, qword ptr [rbx + 288]
        lea	rsi, [rbp - 80]
        lea	rcx, [rbp - 48]
        mov	rdx, rbx
        mov	word ptr [rsi + 8], 1
        mov	qword ptr [rsi], rcx
        call	rax
.LBB26_3:
        add	rsp, 64
        pop	rbx
        pop	r14
        pop	rbp
        ret

timer.TimerModule.try_remove:
        mov	rax, qword ptr [rdi]
        test	rax, rax
        je	.LBB31_5
        push	rbp
        mov	rbp, rsp
        cmp	rax, rsi
        je	.LBB31_4
.LBB31_2:
        mov	rcx, qword ptr [rax]
        test	rcx, rcx
        je	.LBB31_7
        mov	rdi, rax
        mov	rax, rcx
        cmp	rcx, rsi
        jne	.LBB31_2
.LBB31_4:
        mov	rax, qword ptr [rsi]
        mov	qword ptr [rdi], rax
        mov	al, 1
        jmp	.LBB31_8
.LBB31_5:
        xor	eax, eax
        ret
.LBB31_7:
        xor	eax, eax
.LBB31_8:
        pop	rbp
        ret

debug.panic__anon_4476:
        push	rbp
        mov	rbp, rsp
        call	debug.panicExtra__anon_4485

