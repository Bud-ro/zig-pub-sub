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
        mov	dword ptr [rdi], -559038737
        pop	rbp
        ret

codegen_write_u16_no_subs:
        push	rbp
        mov	rbp, rsp
        mov	word ptr [rdi + 5], si
        pop	rbp
        ret

codegen_write_bool_with_subs:
        push	rbp
        mov	rbp, rsp
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1131"

codegen_write_u16_with_subs:
        push	rbp
        mov	rbp, rsp
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_2103"

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
        call	mem.eql__anon_1148
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
        mov	dword ptr [rdi], 42
        or	dword ptr [rsi + 4], -1
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
        push	r14
        push	rbx
        sub	rsp, 16
        mov	r14, rsi
        mov	rbx, rdi
        mov	qword ptr [rbp - 24], rsi
        lea	rdx, [rbp - 32]
        mov	qword ptr [rdx], rsi
        add	rdi, 112
        push	8
        pop	rcx
        mov	rsi, rcx
        call	mem.eql__anon_1148
        mov	qword ptr [rbx + 112], r14
        test	al, 1
        jne	.LBB17_2
        lea	rsi, [rbp - 24]
        mov	rdi, rbx
        call	"system_data.SystemData(codegen_harness.ManyErdsSystem__struct_2415,meta.FieldEnum(codegen_harness.ManyErdsSystem__struct_2415),.{ .e00 = .{ ... }, .e01 = .{ ... }, .e02 = .{ ... }, .e03 = .{ ... }, .e04 = .{ ... }, .e05 = .{ ... }, .e06 = .{ ... }, .e07 = .{ ... }, .e08 = .{ ... }, .e09 = .{ ... }, .e10 = .{ ... }, .e11 = .{ ... }, .e12 = .{ ... }, .e13 = .{ ... }, .e14 = .{ ... }, .e15 = .{ ... }, .e16 = .{ ... }, .e17 = .{ ... }, .e18 = .{ ... }, .e19 = .{ ... }, .e20 = .{ ... }, .e21 = .{ ... }, .e22 = .{ ... }, .e23 = .{ ... }, .e24 = .{ ... }, .e25 = .{ ... }, .e26 = .{ ... }, .e27 = .{ ... }, .e28 = .{ ... }, .e29 = .{ ... }, .e30 = .{ ... }, .e31 = .{ ... } },testing.create.Components).publish"
.LBB17_2:
        add	rsp, 16
        pop	rbx
        pop	r14
        pop	rbp
        ret

codegen_many_write_middle_no_subs:
        push	rbp
        mov	rbp, rsp
        mov	dword ptr [rdi + 48], esi
        pop	rbp
        ret

codegen_read_big_struct:
        push	rbp
        mov	rbp, rsp
        mov	rax, rdi
        mov	ecx, 256
        rep movsb es:[rdi], [rsi]
        pop	rbp
        ret

codegen_read_medium_struct:
        push	rbp
        mov	rbp, rsp
        mov	rax, rdi
        mov	rcx, qword ptr [rsi + 272]
        mov	qword ptr [rdi + 16], rcx
        movups	xmm0, xmmword ptr [rsi + 256]
        movups	xmmword ptr [rdi], xmm0
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
        mov	edx, 256
        pop	rbp
        jmp	memmove@PLT

codegen_write_medium_with_subs:
        push	rbp
        mov	rbp, rsp
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.HugeSystem__struct_3644,meta.FieldEnum(codegen_harness.HugeSystem__struct_3644),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).write__anon_3921"

codegen_read_modify_write_medium:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        mov	rax, qword ptr [rdi + 272]
        lea	rsi, [rbp - 32]
        mov	qword ptr [rsi + 16], rax
        movups	xmm0, xmmword ptr [rdi + 256]
        movaps	xmmword ptr [rsi], xmm0
        inc	eax
        mov	dword ptr [rsi + 16], eax
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_3644,meta.FieldEnum(codegen_harness.HugeSystem__struct_3644),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).write__anon_3921"
        add	rsp, 32
        pop	rbp
        ret

codegen_read_modify_write_big:
        push	rbp
        mov	rbp, rsp
        inc	byte ptr [rdi]
        pop	rbp
        ret

codegen_setup_timer_callback:
        push	rbp
        mov	rbp, rsp
        push	r15
        push	r14
        push	r12
        push	rbx
        mov	r15, rdx
        mov	r14, rsi
        mov	r12, rdi
        lea	rbx, [rdx + 16]
        cmp	qword ptr [rdx + 8], 0
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
        mov	qword ptr [r15 + 8], offset codegen_harness.timer_callback_read_write
        mov	dword ptr [r15 + 28], 100
        or	r12, 1
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
        inc	dword ptr [rdi]
        pop	rbp
        ret

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
        mov	eax, dword ptr [rdi]
        inc	eax
        mov	dword ptr [rdi], eax
        pop	rbp
        ret

codegen_read_write_other_read:
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        mov	rbx, rdi
        mov	r14d, dword ptr [rdi]
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1131"
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
        call	debug.panic__anon_4134

codegen_harness.accumulate_callback:
        push	rbp
        mov	rbp, rsp
        mov	rax, qword ptr [rsi]
        cmp	byte ptr [rax], 0
        je	.LBB38_2
        inc	dword ptr [rdx]
.LBB38_2:
        pop	rbp
        ret

codegen_write_triggering_callback:
        push	rbp
        mov	rbp, rsp
        mov	esi, 1
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1131"

codegen_increment_n_times:
        push	rbp
        mov	rbp, rsp
.LBB60_1:
        cmp	esi, 1
        jb	.LBB60_3
        inc	dword ptr [rdi]
        dec	esi
        jmp	.LBB60_1
.LBB60_3:
        pop	rbp
        ret

codegen_conditional_write_chain:
        push	rbp
        mov	rbp, rsp
        test	byte ptr [rdi + 4], 1
        je	.LBB61_1
        add	dword ptr [rdi], 10
.LBB61_1:
        cmp	word ptr [rdi + 5], 100
        jbe	.LBB61_3
        add	dword ptr [rdi], 20
.LBB61_3:
        pop	rbp
        ret

codegen_cross_erd_compute:
        push	rbp
        mov	rbp, rsp
        movzx	esi, word ptr [rdi + 5]
        add	si, word ptr [rdi]
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_2103"

codegen_cross_system_read_add:
        push	rbp
        mov	rbp, rsp
        mov	eax, dword ptr [rdi]
        movsxd	rcx, dword ptr [rsi]
        add	rcx, rax
        movzx	edx, word ptr [rdi + 5]
        movsxd	rax, dword ptr [rsi + 4]
        add	rax, rdx
        add	rax, rcx
        pop	rbp
        ret

codegen_cross_system_read_write:
        push	rbp
        mov	rbp, rsp
        mov	eax, dword ptr [rsi]
        mov	dword ptr [rdi], eax
        pop	rbp
        ret

codegen_cross_system_swap:
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 16
        mov	rbx, rsi
        mov	r14d, dword ptr [rdi]
        mov	eax, dword ptr [rsi]
        mov	dword ptr [rdi], eax
        mov	dword ptr [rbp - 20], r14d
        lea	rdx, [rbp - 24]
        mov	dword ptr [rdx], r14d
        push	4
        pop	rcx
        mov	rdi, rsi
        mov	rsi, rcx
        call	mem.eql__anon_1148
        mov	dword ptr [rbx], r14d
        test	al, 1
        jne	.LBB65_2
        lea	rsi, [rbp - 20]
        mov	rdi, rbx
        call	"system_data.SystemData(codegen_harness.OtherSystem__struct_2161,meta.FieldEnum(codegen_harness.OtherSystem__struct_2161),.{ .sensor_a = .{ ... }, .sensor_b = .{ ... }, .output = .{ ... } },testing.create.Components).publish"
.LBB65_2:
        add	rsp, 16
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

"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1131":
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 16
        mov	r14d, esi
        mov	rbx, rdi
        and	r14b, 1
        mov	byte ptr [rbp - 17], r14b
        lea	rdx, [rbp - 18]
        mov	byte ptr [rdx], r14b
        add	rdi, 4
        push	1
        pop	rcx
        mov	rsi, rcx
        call	mem.eql__anon_1148
        mov	byte ptr [rbx + 4], r14b
        test	al, 1
        jne	.LBB6_2
        push	1
        pop	rsi
        lea	rdx, [rbp - 17]
        mov	rdi, rbx
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
.LBB6_2:
        add	rsp, 16
        pop	rbx
        pop	r14
        pop	rbp
        ret

mem.eql__anon_1148:
        cmp	rsi, rcx
        jne	.LBB8_7
        cmp	rdi, rdx
        je	.LBB8_5
        cmp	rsi, 17
        jae	.LBB8_6
        cmp	rsi, 3
        ja	.LBB8_9
        mov	al, byte ptr [rdi]
        mov	cl, byte ptr [rdi + rsi - 1]
        mov	r8, rsi
        shr	r8
        xor	al, byte ptr [rdx]
        mov	dil, byte ptr [rdi + r8]
        xor	cl, byte ptr [rdx + rsi - 1]
        or	cl, al
        xor	dil, byte ptr [rdx + r8]
        or	dil, cl
        jmp	.LBB8_14
.LBB8_5:
        mov	al, 1
        ret
.LBB8_6:
        movdqu	xmm0, xmmword ptr [rdi]
        movdqu	xmm1, xmmword ptr [rdx]
        pcmpeqb	xmm1, xmm0
        pmovmskb	eax, xmm1
        xor	eax, 65535
        je	.LBB8_13
.LBB8_7:
        xor	eax, eax
        ret
.LBB8_9:
        push	rbp
        mov	rbp, rsp
        lea	rax, [rsi - 4]
        and	qword ptr [rbp - 32], 0
        shr	esi
        and	esi, 12
        mov	qword ptr [rbp - 24], rax
        sub	rax, rsi
        mov	qword ptr [rbp - 16], rsi
        mov	qword ptr [rbp - 8], rax
        xor	eax, eax
        xor	ecx, ecx
.LBB8_10:
        cmp	rcx, 4
        je	.LBB8_12
        mov	rsi, qword ptr [rbp + 8*rcx - 32]
        mov	r8d, dword ptr [rdx + rsi]
        xor	r8d, dword ptr [rdi + rsi]
        or	eax, r8d
        inc	rcx
        jmp	.LBB8_10
.LBB8_12:
        test	eax, eax
        sete	al
        pop	rbp
        ret
.LBB8_13:
        movdqu	xmm0, xmmword ptr [rdi + rsi - 16]
        movdqu	xmm1, xmmword ptr [rdx + rsi - 16]
        pcmpeqb	xmm1, xmm0
        pmovmskb	eax, xmm1
        xor	eax, 65535
.LBB8_14:
        sete	al
        ret

"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_2103":
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 16
        mov	r14d, esi
        mov	rbx, rdi
        mov	word ptr [rbp - 18], r14w
        lea	rdx, [rbp - 20]
        mov	word ptr [rdx], r14w
        add	rdi, 7
        push	2
        pop	rcx
        mov	rsi, rcx
        call	mem.eql__anon_1148
        mov	word ptr [rbx + 7], r14w
        test	al, 1
        jne	.LBB10_2
        push	3
        pop	rsi
        lea	rdx, [rbp - 18]
        mov	rdi, rbx
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
.LBB10_2:
        add	rsp, 16
        pop	rbx
        pop	r14
        pop	rbp
        ret

"system_data.SystemData(codegen_harness.ManyErdsSystem__struct_2415,meta.FieldEnum(codegen_harness.ManyErdsSystem__struct_2415),.{ .e00 = .{ ... }, .e01 = .{ ... }, .e02 = .{ ... }, .e03 = .{ ... }, .e04 = .{ ... }, .e05 = .{ ... }, .e06 = .{ ... }, .e07 = .{ ... }, .e08 = .{ ... }, .e09 = .{ ... }, .e10 = .{ ... }, .e11 = .{ ... }, .e12 = .{ ... }, .e13 = .{ ... }, .e14 = .{ ... }, .e15 = .{ ... }, .e16 = .{ ... }, .e17 = .{ ... }, .e18 = .{ ... }, .e19 = .{ ... }, .e20 = .{ ... }, .e21 = .{ ... }, .e22 = .{ ... }, .e23 = .{ ... }, .e24 = .{ ... }, .e25 = .{ ... }, .e26 = .{ ... }, .e27 = .{ ... }, .e28 = .{ ... }, .e29 = .{ ... }, .e30 = .{ ... }, .e31 = .{ ... } },testing.create.Components).publish":
        push	rbp
        mov	rbp, rsp
        push	r15
        push	r14
        push	r12
        push	rbx
        sub	rsp, 16
        mov	rbx, rsi
        mov	r14, rdi
        mov	r12d, 144
        lea	r15, [rbp - 48]
.LBB18_1:
        cmp	r12, 192
        je	.LBB18_5
        mov	rax, qword ptr [r14 + r12]
        test	rax, rax
        je	.LBB18_3
        mov	rdi, qword ptr [r14 + r12 - 8]
        mov	word ptr [rbp - 40], 31
        mov	qword ptr [rbp - 48], rbx
        mov	rsi, r15
        mov	rdx, r14
        call	rax
.LBB18_3:
        add	r12, 16
        jmp	.LBB18_1
.LBB18_5:
        add	rsp, 16
        pop	rbx
        pop	r12
        pop	r14
        pop	r15
        pop	rbp
        ret

"system_data.SystemData(codegen_harness.HugeSystem__struct_3644,meta.FieldEnum(codegen_harness.HugeSystem__struct_3644),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).write__anon_3921":
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 64
        mov	r14, rsi
        mov	rbx, rdi
        mov	rax, qword ptr [rsi + 16]
        mov	qword ptr [rbp - 32], rax
        movups	xmm0, xmmword ptr [rsi]
        movaps	xmmword ptr [rbp - 48], xmm0
        mov	rax, qword ptr [rsi + 16]
        lea	rdx, [rbp - 80]
        mov	qword ptr [rdx + 16], rax
        movups	xmm0, xmmword ptr [rsi]
        movaps	xmmword ptr [rdx], xmm0
        add	rdi, 256
        push	24
        pop	rcx
        mov	rsi, rcx
        call	mem.eql__anon_1148
        mov	rcx, qword ptr [r14 + 16]
        movups	xmm0, xmmword ptr [r14]
        movups	xmmword ptr [rbx + 256], xmm0
        mov	qword ptr [rbx + 272], rcx
        test	al, 1
        jne	.LBB25_2
        lea	rsi, [rbp - 48]
        mov	rdi, rbx
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_3644,meta.FieldEnum(codegen_harness.HugeSystem__struct_3644),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).publish"
.LBB25_2:
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

debug.panic__anon_4134:
        push	rbp
        mov	rbp, rsp
        call	debug.panicExtra__anon_4143

"system_data.SystemData(codegen_harness.OtherSystem__struct_2161,meta.FieldEnum(codegen_harness.OtherSystem__struct_2161),.{ .sensor_a = .{ ... }, .sensor_b = .{ ... }, .output = .{ ... } },testing.create.Components).publish":
        mov	rcx, qword ptr [rdi + 24]
        test	rcx, rcx
        je	.LBB66_2
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rdx, rdi
        mov	rdi, qword ptr [rdi + 16]
        lea	rax, [rbp - 16]
        and	word ptr [rax + 8], 0
        mov	qword ptr [rax], rsi
        mov	rsi, rax
        call	rcx
        add	rsp, 16
        pop	rbp
.LBB66_2:
        ret

