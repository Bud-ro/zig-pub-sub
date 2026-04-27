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
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1930"

codegen_runtime_read:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rax, rdx
        mov	ecx, esi
        movzx	ecx, word ptr [rcx + rcx + .L__unnamed_3]
        movups	xmm0, xmmword ptr [rdi]
        lea	rsi, [rbp - 16]
        movaps	xmmword ptr [rsi], xmm0
        movzx	edx, word ptr [rcx + rcx + .L__unnamed_4]
        add	rsi, qword ptr [8*rcx + .L__unnamed_5]
        mov	rdi, rax
        call	memcpy@PLT
        add	rsp, 16
        pop	rbp
        ret

codegen_runtime_write:
        push	rbp
        mov	rbp, rsp
        push	r15
        push	r14
        push	r12
        push	rbx
        sub	rsp, 32
        mov	rbx, rdx
        mov	r14d, esi
        mov	r15, rdi
        mov	eax, esi
        movzx	eax, word ptr [rax + rax + .L__unnamed_3]
        movzx	edx, word ptr [rax + rax + .L__unnamed_4]
        mov	rdi, qword ptr [8*rax + .L__unnamed_5]
        add	rdi, r15
        cmp	rbx, rdi
        je	.LBB11_1
        test	r14w, r14w
        je	.LBB11_4
        mov	al, byte ptr [rbx]
        mov	cl, byte ptr [rbx + rdx - 1]
        mov	esi, edx
        shr	esi
        xor	al, byte ptr [rdi]
        mov	r8b, byte ptr [rbx + rsi]
        xor	cl, byte ptr [rdi + rdx - 1]
        or	cl, al
        xor	r8b, byte ptr [rdi + rsi]
        or	r8b, cl
        jmp	.LBB11_8
.LBB11_1:
        mov	r12b, 1
        jmp	.LBB11_9
.LBB11_4:
        lea	rax, [rdx - 4]
        mov	ecx, edx
        and	qword ptr [rbp - 64], 0
        shr	ecx
        and	ecx, 12
        mov	qword ptr [rbp - 56], rax
        sub	rax, rcx
        mov	qword ptr [rbp - 48], rcx
        mov	qword ptr [rbp - 40], rax
        xor	eax, eax
        xor	ecx, ecx
.LBB11_5:
        cmp	rcx, 4
        je	.LBB11_7
        mov	rsi, qword ptr [rbp + 8*rcx - 64]
        mov	r8d, dword ptr [rdi + rsi]
        xor	r8d, dword ptr [rbx + rsi]
        or	eax, r8d
        inc	rcx
        jmp	.LBB11_5
.LBB11_7:
        test	eax, eax
.LBB11_8:
        sete	r12b
.LBB11_9:
        mov	rsi, rbx
        call	memcpy@PLT
        test	r14w, -3
        je	.LBB11_11
        test	r12b, r12b
        jne	.LBB11_11
        mov	rdi, r15
        mov	esi, r14d
        mov	rdx, rbx
        add	rsp, 32
        pop	rbx
        pop	r12
        pop	r14
        pop	r15
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
.LBB11_11:
        add	rsp, 32
        pop	rbx
        pop	r12
        pop	r14
        pop	r15
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
        sub	rsp, 16
        mov	qword ptr [rbp - 8], rsi
        cmp	qword ptr [rdi + 112], rsi
        mov	qword ptr [rdi + 112], rsi
        je	.LBB17_2
        lea	rsi, [rbp - 8]
        call	"system_data.SystemData(codegen_harness.ManyErdsSystem__struct_2446,meta.FieldEnum(codegen_harness.ManyErdsSystem__struct_2446),.{ .e00 = .{ ... }, .e01 = .{ ... }, .e02 = .{ ... }, .e03 = .{ ... }, .e04 = .{ ... }, .e05 = .{ ... }, .e06 = .{ ... }, .e07 = .{ ... }, .e08 = .{ ... }, .e09 = .{ ... }, .e10 = .{ ... }, .e11 = .{ ... }, .e12 = .{ ... }, .e13 = .{ ... }, .e14 = .{ ... }, .e15 = .{ ... }, .e16 = .{ ... }, .e17 = .{ ... }, .e18 = .{ ... }, .e19 = .{ ... }, .e20 = .{ ... }, .e21 = .{ ... }, .e22 = .{ ... }, .e23 = .{ ... }, .e24 = .{ ... }, .e25 = .{ ... }, .e26 = .{ ... }, .e27 = .{ ... }, .e28 = .{ ... }, .e29 = .{ ... }, .e30 = .{ ... }, .e31 = .{ ... } },testing.create.Components).publish"
.LBB17_2:
        add	rsp, 16
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
        jmp	"system_data.SystemData(codegen_harness.HugeSystem__struct_3682,meta.FieldEnum(codegen_harness.HugeSystem__struct_3682),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).write__anon_3959"

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
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_3682,meta.FieldEnum(codegen_harness.HugeSystem__struct_3682),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).write__anon_3959"
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
        call	debug.panic__anon_4259

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
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1930"

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
        sub	rsp, 16
        mov	eax, dword ptr [rdi]
        mov	ecx, dword ptr [rsi]
        mov	dword ptr [rdi], ecx
        mov	dword ptr [rbp - 4], eax
        mov	dword ptr [rsi], eax
        cmp	ecx, eax
        je	.LBB65_2
        lea	rax, [rbp - 4]
        mov	rdi, rsi
        mov	rsi, rax
        call	"system_data.SystemData(codegen_harness.OtherSystem__struct_2192,meta.FieldEnum(codegen_harness.OtherSystem__struct_2192),.{ .sensor_a = .{ ... }, .sensor_b = .{ ... }, .output = .{ ... } },testing.create.Components).publish"
.LBB65_2:
        add	rsp, 16
        pop	rbp
        ret

codegen_double_write_same_value:
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        mov	rbx, rdi
        push	1
        pop	r14
        mov	esi, r14d
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1131"
        mov	rdi, rbx
        mov	esi, r14d
        pop	rbx
        pop	r14
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1131"

codegen_double_write_diff_values:
        push	rbp
        mov	rbp, rsp
        push	rbx
        push	rax
        mov	rbx, rdi
        push	1
        pop	rsi
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1131"
        mov	rdi, rbx
        xor	esi, esi
        add	rsp, 8
        pop	rbx
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1131"

codegen_write_junk_read_write:
        push	rbp
        mov	rbp, rsp
        push	rbx
        push	rax
        mov	rbx, rdi
        push	1
        pop	rsi
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1930"
        push	2
        pop	rsi
        mov	rdi, rbx
        add	rsp, 8
        pop	rbx
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1930"

codegen_triple_write_increment:
        push	rbp
        mov	rbp, rsp
        push	rbx
        push	rax
        mov	rbx, rdi
        push	1
        pop	rsi
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1930"
        push	2
        pop	rsi
        mov	rdi, rbx
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1930"
        push	3
        pop	rsi
        mov	rdi, rbx
        add	rsp, 8
        pop	rbx
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1930"

codegen_double_rmw_struct:
        push	rbp
        mov	rbp, rsp
        push	rbx
        sub	rsp, 56
        mov	rbx, rdi
        mov	rax, qword ptr [rdi + 272]
        lea	rsi, [rbp - 32]
        mov	qword ptr [rsi + 16], rax
        movups	xmm0, xmmword ptr [rdi + 256]
        movaps	xmmword ptr [rsi], xmm0
        inc	eax
        mov	dword ptr [rsi + 16], eax
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_3682,meta.FieldEnum(codegen_harness.HugeSystem__struct_3682),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).write__anon_3959"
        movups	xmm0, xmmword ptr [rbx + 256]
        lea	rsi, [rbp - 64]
        movaps	xmmword ptr [rsi], xmm0
        mov	rax, qword ptr [rbx + 272]
        mov	qword ptr [rsi + 16], rax
        inc	qword ptr [rsi]
        mov	rdi, rbx
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_3682,meta.FieldEnum(codegen_harness.HugeSystem__struct_3682),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).write__anon_3959"
        add	rsp, 56
        pop	rbx
        pop	rbp
        ret

; --- called functions ---

"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1131":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        and	sil, 1
        mov	byte ptr [rbp - 1], sil
        cmp	byte ptr [rdi + 4], sil
        mov	byte ptr [rdi + 4], sil
        je	.LBB6_2
        push	1
        pop	rsi
        lea	rdx, [rbp - 1]
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
.LBB6_2:
        add	rsp, 16
        pop	rbp
        ret

"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish":
        push	rbp
        mov	rbp, rsp
        push	r15
        push	r14
        push	r13
        push	r12
        push	rbx
        sub	rsp, 24
        mov	qword ptr [rbp - 48], rdx
        mov	r14d, esi
        mov	r15, rdi
        movzx	eax, r14w
        mov	rcx, qword ptr [8*rax + .L__unnamed_1]
        movzx	r13d, byte ptr [rax + .L__unnamed_2]
        shl	r13d, 4
        shl	rcx, 4
        lea	r12, [rdi + rcx]
        add	r12, 24
        xor	ebx, ebx
.LBB7_1:
        cmp	r13, rbx
        je	.LBB7_5
        mov	rax, qword ptr [r12 + rbx]
        test	rax, rax
        je	.LBB7_3
        mov	rdi, qword ptr [r12 + rbx - 8]
        mov	word ptr [rbp - 56], r14w
        mov	rcx, qword ptr [rbp - 48]
        mov	qword ptr [rbp - 64], rcx
        lea	rsi, [rbp - 64]
        mov	rdx, r15
        call	rax
.LBB7_3:
        add	rbx, 16
        jmp	.LBB7_1
.LBB7_5:
        add	rsp, 24
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        ret

"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1930":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	word ptr [rbp - 2], si
        cmp	word ptr [rdi + 7], si
        mov	word ptr [rdi + 7], si
        je	.LBB9_2
        push	3
        pop	rsi
        lea	rdx, [rbp - 2]
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
.LBB9_2:
        add	rsp, 16
        pop	rbp
        ret

"system_data.SystemData(codegen_harness.ManyErdsSystem__struct_2446,meta.FieldEnum(codegen_harness.ManyErdsSystem__struct_2446),.{ .e00 = .{ ... }, .e01 = .{ ... }, .e02 = .{ ... }, .e03 = .{ ... }, .e04 = .{ ... }, .e05 = .{ ... }, .e06 = .{ ... }, .e07 = .{ ... }, .e08 = .{ ... }, .e09 = .{ ... }, .e10 = .{ ... }, .e11 = .{ ... }, .e12 = .{ ... }, .e13 = .{ ... }, .e14 = .{ ... }, .e15 = .{ ... }, .e16 = .{ ... }, .e17 = .{ ... }, .e18 = .{ ... }, .e19 = .{ ... }, .e20 = .{ ... }, .e21 = .{ ... }, .e22 = .{ ... }, .e23 = .{ ... }, .e24 = .{ ... }, .e25 = .{ ... }, .e26 = .{ ... }, .e27 = .{ ... }, .e28 = .{ ... }, .e29 = .{ ... }, .e30 = .{ ... }, .e31 = .{ ... } },testing.create.Components).publish":
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

"system_data.SystemData(codegen_harness.HugeSystem__struct_3682,meta.FieldEnum(codegen_harness.HugeSystem__struct_3682),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).write__anon_3959":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        mov	rax, qword ptr [rsi + 16]
        mov	qword ptr [rbp - 16], rax
        movups	xmm0, xmmword ptr [rsi]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	r10, qword ptr [rdi + 256]
        mov	r9, qword ptr [rdi + 264]
        mov	r8d, dword ptr [rdi + 272]
        movzx	edx, word ptr [rdi + 276]
        mov	cl, byte ptr [rdi + 278]
        mov	al, byte ptr [rdi + 279]
        movups	xmm0, xmmword ptr [rsi]
        mov	r11, qword ptr [rsi + 16]
        mov	qword ptr [rdi + 272], r11
        movups	xmmword ptr [rdi + 256], xmm0
        cmp	r10, qword ptr [rsi]
        jne	.LBB25_6
        cmp	r9, qword ptr [rsi + 8]
        jne	.LBB25_6
        cmp	r8d, dword ptr [rsi + 16]
        jne	.LBB25_6
        cmp	dx, word ptr [rsi + 20]
        jne	.LBB25_6
        cmp	cl, byte ptr [rsi + 22]
        jne	.LBB25_6
        and	al, 1
        cmp	byte ptr [rsi + 23], al
        je	.LBB25_7
.LBB25_6:
        lea	rsi, [rbp - 32]
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_3682,meta.FieldEnum(codegen_harness.HugeSystem__struct_3682),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).publish"
.LBB25_7:
        add	rsp, 32
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

debug.panic__anon_4259:
        push	rbp
        mov	rbp, rsp
        call	debug.panicExtra__anon_4268

"system_data.SystemData(codegen_harness.OtherSystem__struct_2192,meta.FieldEnum(codegen_harness.OtherSystem__struct_2192),.{ .sensor_a = .{ ... }, .sensor_b = .{ ... }, .output = .{ ... } },testing.create.Components).publish":
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

