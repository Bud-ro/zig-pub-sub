codegen_read_u32:
        push	rbp
        mov	rbp, rsp
        mov	eax, dword ptr [rdi]
        pop	rbp
        ret

codegen_read_bool:
        push	rbp
        mov	rbp, rsp
        movzx	eax, byte ptr [rdi + 4]
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
        sub	rsp, 16
        mov	byte ptr [rbp - 1], sil
        cmp	byte ptr [rdi + 4], sil
        mov	byte ptr [rdi + 4], sil
        je	.LBB5_2
        lea	rdx, [rbp - 1]
        mov	esi, 1
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
.LBB5_2:
        add	rsp, 16
        pop	rbp
        ret

codegen_write_u16_with_subs:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	word ptr [rbp - 2], si
        cmp	word ptr [rdi + 7], si
        mov	word ptr [rdi + 7], si
        je	.LBB7_2
        lea	rdx, [rbp - 2]
        mov	esi, 3
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
.LBB7_2:
        add	rsp, 16
        pop	rbp
        ret

codegen_runtime_read:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rax, rdx
        mov	ecx, esi
        movzx	ecx, word ptr [rcx + rcx + .L__unnamed_3]
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 16], xmm0
        movzx	edx, word ptr [rcx + rcx + .L__unnamed_4]
        lea	rsi, [rbp - 16]
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
        mov	rbx, rdi
        mov	eax, esi
        movzx	ecx, word ptr [rax + rax + .L__unnamed_3]
        movzx	eax, word ptr [rcx + rcx + .L__unnamed_4]
        mov	rdi, qword ptr [8*rcx + .L__unnamed_5]
        add	rdi, rbx
        cmp	rdx, rdi
        je	.LBB9_5
        test	si, si
        je	.LBB9_5
        movzx	ecx, byte ptr [rdx]
        movzx	r8d, byte ptr [rdx + rax - 1]
        mov	r9d, eax
        shr	r9d
        xor	cl, byte ptr [rdi]
        movzx	r10d, byte ptr [rdx + r9]
        xor	r8b, byte ptr [rdi + rax - 1]
        or	r8b, cl
        xor	r10b, byte ptr [rdi + r9]
        or	r10b, r8b
        sete	r15b
        mov	r14, rdx
        mov	r12d, esi
        mov	rsi, rdx
        mov	rdx, rax
        call	memcpy@PLT
        test	r12d, 65533
        je	.LBB9_4
        test	r15b, r15b
        jne	.LBB9_4
        mov	esi, r12d
        mov	rdi, rbx
        mov	rdx, r14
        pop	rbx
        pop	r12
        pop	r14
        pop	r15
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
.LBB9_5:
        mov	rsi, rdx
        mov	rdx, rax
        pop	rbx
        pop	r12
        pop	r14
        pop	r15
        pop	rbp
        jmp	memcpy@PLT
.LBB9_4:
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
        mov	dword ptr [rsi + 4], -1
        pop	rbp
        ret

codegen_many_read_first:
        push	rbp
        mov	rbp, rsp
        movzx	eax, byte ptr [rdi]
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
        je	.LBB16_2
        lea	rsi, [rbp - 8]
        call	"system_data.SystemData(codegen_harness.ManyErdsSystem__struct_2447,meta.FieldEnum(codegen_harness.ManyErdsSystem__struct_2447),.{ .e00 = .{ ... }, .e01 = .{ ... }, .e02 = .{ ... }, .e03 = .{ ... }, .e04 = .{ ... }, .e05 = .{ ... }, .e06 = .{ ... }, .e07 = .{ ... }, .e08 = .{ ... }, .e09 = .{ ... }, .e10 = .{ ... }, .e11 = .{ ... }, .e12 = .{ ... }, .e13 = .{ ... }, .e14 = .{ ... }, .e15 = .{ ... }, .e16 = .{ ... }, .e17 = .{ ... }, .e18 = .{ ... }, .e19 = .{ ... }, .e20 = .{ ... }, .e21 = .{ ... }, .e22 = .{ ... }, .e23 = .{ ... }, .e24 = .{ ... }, .e25 = .{ ... }, .e26 = .{ ... }, .e27 = .{ ... }, .e28 = .{ ... }, .e29 = .{ ... }, .e30 = .{ ... }, .e31 = .{ ... } },testing.create.Components).publish"
.LBB16_2:
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
        push	rbx
        push	rax
        mov	rbx, rdi
        mov	edx, 256
        call	memcpy@PLT
        mov	rax, rbx
        add	rsp, 8
        pop	rbx
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
        sub	rsp, 32
        mov	rax, qword ptr [rsi + 16]
        mov	qword ptr [rbp - 16], rax
        movups	xmm0, xmmword ptr [rsi]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	r10, qword ptr [rdi + 256]
        mov	r9, qword ptr [rdi + 264]
        mov	r8d, dword ptr [rdi + 272]
        movzx	edx, word ptr [rdi + 276]
        movzx	ecx, byte ptr [rdi + 278]
        movzx	eax, byte ptr [rdi + 279]
        movups	xmm0, xmmword ptr [rsi]
        mov	r11, qword ptr [rsi + 16]
        mov	qword ptr [rdi + 272], r11
        movups	xmmword ptr [rdi + 256], xmm0
        cmp	r10, qword ptr [rsi]
        jne	.LBB23_6
        cmp	r9, qword ptr [rsi + 8]
        jne	.LBB23_6
        cmp	r8d, dword ptr [rsi + 16]
        jne	.LBB23_6
        cmp	dx, word ptr [rsi + 20]
        jne	.LBB23_6
        cmp	cl, byte ptr [rsi + 22]
        jne	.LBB23_6
        and	al, 1
        cmp	byte ptr [rsi + 23], al
        je	.LBB23_7
.LBB23_6:
        lea	rsi, [rbp - 32]
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_3683,meta.FieldEnum(codegen_harness.HugeSystem__struct_3683),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).publish"
.LBB23_7:
        add	rsp, 32
        pop	rbp
        ret

codegen_read_modify_write_medium:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        mov	eax, dword ptr [rdi + 272]
        mov	ecx, dword ptr [rdi + 276]
        add	eax, 1
        movups	xmm0, xmmword ptr [rdi + 256]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	dword ptr [rbp - 16], eax
        mov	dword ptr [rbp - 12], ecx
        mov	dword ptr [rdi + 272], eax
        lea	rsi, [rbp - 32]
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_3683,meta.FieldEnum(codegen_harness.HugeSystem__struct_3683),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).publish"
        add	rsp, 32
        pop	rbp
        ret

codegen_read_modify_write_big:
        push	rbp
        mov	rbp, rsp
        add	byte ptr [rdi], 1
        pop	rbp
        ret

codegen_setup_timer_callback:
        push	rbp
        mov	rbp, rsp
        mov	rcx, qword ptr [rsi]
        lea	rax, [rdx + 16]
        cmp	qword ptr [rdx + 8], 0
        setne	r8b
        cmp	rcx, rax
        sete	r9b
        or	r9b, r8b
        je	.LBB27_11
        test	rcx, rcx
        je	.LBB27_5
        mov	r8, rsi
        cmp	rcx, rax
        je	.LBB27_10
.LBB27_3:
        mov	r9, qword ptr [rcx]
        test	r9, r9
        je	.LBB27_5
        mov	r8, rcx
        mov	rcx, r9
        cmp	r9, rax
        jne	.LBB27_3
        jmp	.LBB27_10
.LBB27_5:
        mov	rcx, qword ptr [rsi + 8]
        test	rcx, rcx
        je	.LBB27_11
        cmp	rcx, rax
        je	.LBB27_9
.LBB27_7:
        mov	r9, qword ptr [rcx]
        test	r9, r9
        je	.LBB27_11
        mov	r8, rcx
        mov	rcx, r9
        cmp	r9, rax
        jne	.LBB27_7
        jmp	.LBB27_10
.LBB27_9:
        lea	r8, [rsi + 8]
.LBB27_10:
        mov	rcx, qword ptr [rax]
        mov	qword ptr [r8], rcx
.LBB27_11:
        mov	qword ptr [rdx + 8], offset codegen_harness.timer_callback_read_write
        mov	dword ptr [rdx + 28], 100
        or	rdi, 1
        mov	qword ptr [rdx], rdi
        mov	edi, dword ptr [rsi + 16]
        lea	ecx, [rdi + 100]
        mov	dword ptr [rdx + 24], ecx
        mov	rcx, qword ptr [rsi]
        test	rcx, rcx
        je	.LBB27_17
        mov	edx, dword ptr [rcx + 8]
        sub	edx, edi
        add	edx, -101
        cmp	edx, -65636
        jb	.LBB27_15
.LBB27_13:
        mov	rsi, rcx
        mov	rcx, qword ptr [rcx]
        test	rcx, rcx
        je	.LBB27_17
        mov	edx, dword ptr [rcx + 8]
        sub	edx, edi
        add	edx, 65535
        cmp	edx, 65636
        jb	.LBB27_13
.LBB27_15:
        mov	qword ptr [rax], rcx
        mov	qword ptr [rsi], rax
        pop	rbp
        ret
.LBB27_17:
        xor	ecx, ecx
        mov	qword ptr [rax], rcx
        mov	qword ptr [rsi], rax
        pop	rbp
        ret

codegen_harness.timer_callback_read_write:
        push	rbp
        mov	rbp, rsp
        add	dword ptr [rdi], 1
        pop	rbp
        ret

codegen_triple_read_same_erd:
        push	rbp
        mov	rbp, rsp
        mov	eax, dword ptr [rdi]
        lea	eax, [rax + 2*rax]
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
        add	eax, 1
        mov	dword ptr [rdi], eax
        pop	rbp
        ret

codegen_read_write_other_read:
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 16
        mov	r14d, dword ptr [rdi]
        mov	byte ptr [rbp - 17], sil
        mov	eax, r14d
        cmp	byte ptr [rdi + 4], sil
        mov	byte ptr [rdi + 4], sil
        je	.LBB32_2
        lea	rdx, [rbp - 17]
        mov	rbx, rdi
        mov	esi, 1
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
        mov	eax, dword ptr [rbx]
.LBB32_2:
        add	eax, r14d
        add	rsp, 16
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
        je	.LBB34_3
        test	rax, rax
        jne	.LBB34_4
        mov	qword ptr [rdi + 16], 0
        mov	qword ptr [rdi + 24], offset codegen_harness.accumulate_callback
.LBB34_3:
        ret
.LBB34_4:
        push	rbp
        mov	rbp, rsp
        call	debug.panic__anon_4261

codegen_harness.accumulate_callback:
        push	rbp
        mov	rbp, rsp
        mov	rax, qword ptr [rsi]
        cmp	byte ptr [rax], 0
        je	.LBB35_2
        add	dword ptr [rdx], 1
.LBB35_2:
        pop	rbp
        ret

codegen_write_triggering_callback:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	byte ptr [rbp - 1], 1
        cmp	byte ptr [rdi + 4], 1
        mov	byte ptr [rdi + 4], 1
        je	.LBB130_2
        lea	rdx, [rbp - 1]
        mov	esi, 1
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
.LBB130_2:
        add	rsp, 16
        pop	rbp
        ret

codegen_increment_n_times:
        push	rbp
        mov	rbp, rsp
        test	esi, esi
        je	.LBB131_2
        add	dword ptr [rdi], esi
.LBB131_2:
        pop	rbp
        ret

codegen_conditional_write_chain:
        push	rbp
        mov	rbp, rsp
        test	byte ptr [rdi + 4], 1
        jne	.LBB132_4
        cmp	word ptr [rdi + 5], 100
        ja	.LBB132_2
.LBB132_3:
        pop	rbp
        ret
.LBB132_4:
        add	dword ptr [rdi], 10
        cmp	word ptr [rdi + 5], 100
        jbe	.LBB132_3
.LBB132_2:
        add	dword ptr [rdi], 20
        pop	rbp
        ret

codegen_cross_erd_compute:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        movzx	eax, word ptr [rdi + 5]
        add	ax, word ptr [rdi]
        mov	word ptr [rbp - 2], ax
        cmp	word ptr [rdi + 7], ax
        mov	word ptr [rdi + 7], ax
        je	.LBB133_2
        lea	rdx, [rbp - 2]
        mov	esi, 3
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
.LBB133_2:
        add	rsp, 16
        pop	rbp
        ret

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
        je	.LBB136_2
        lea	rax, [rbp - 4]
        mov	rdi, rsi
        mov	rsi, rax
        call	"system_data.SystemData(codegen_harness.OtherSystem__struct_2193,meta.FieldEnum(codegen_harness.OtherSystem__struct_2193),.{ .sensor_a = .{ ... }, .sensor_b = .{ ... }, .output = .{ ... } },testing.create.Components).publish"
.LBB136_2:
        add	rsp, 16
        pop	rbp
        ret

codegen_double_write_same_value:
        push	rbp
        mov	rbp, rsp
        push	rbx
        push	rax
        mov	byte ptr [rbp - 9], 1
        mov	al, 1
        cmp	byte ptr [rdi + 4], 1
        mov	byte ptr [rdi + 4], 1
        jne	.LBB138_1
        mov	byte ptr [rbp - 10], 1
        mov	byte ptr [rdi + 4], 1
        cmp	al, 1
        jne	.LBB138_3
.LBB138_4:
        add	rsp, 8
        pop	rbx
        pop	rbp
        ret
.LBB138_1:
        lea	rdx, [rbp - 9]
        mov	rbx, rdi
        mov	esi, 1
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
        mov	rdi, rbx
        movzx	eax, byte ptr [rbx + 4]
        mov	byte ptr [rbp - 10], 1
        mov	byte ptr [rdi + 4], 1
        cmp	al, 1
        je	.LBB138_4
.LBB138_3:
        lea	rdx, [rbp - 10]
        mov	esi, 1
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
        add	rsp, 8
        pop	rbx
        pop	rbp
        ret

codegen_double_write_diff_values:
        push	rbp
        mov	rbp, rsp
        push	rbx
        push	rax
        mov	byte ptr [rbp - 9], 1
        mov	al, 1
        cmp	byte ptr [rdi + 4], 1
        mov	byte ptr [rdi + 4], 1
        jne	.LBB139_1
        mov	byte ptr [rbp - 10], 0
        mov	byte ptr [rdi + 4], 0
        cmp	al, 0
        jne	.LBB139_3
.LBB139_4:
        add	rsp, 8
        pop	rbx
        pop	rbp
        ret
.LBB139_1:
        lea	rdx, [rbp - 9]
        mov	rbx, rdi
        mov	esi, 1
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
        mov	rdi, rbx
        movzx	eax, byte ptr [rbx + 4]
        mov	byte ptr [rbp - 10], 0
        mov	byte ptr [rdi + 4], 0
        cmp	al, 0
        je	.LBB139_4
.LBB139_3:
        lea	rdx, [rbp - 10]
        mov	esi, 1
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
        add	rsp, 8
        pop	rbx
        pop	rbp
        ret

codegen_write_junk_read_write:
        push	rbp
        mov	rbp, rsp
        push	rbx
        push	rax
        mov	word ptr [rbp - 12], 1
        cmp	word ptr [rdi + 7], 1
        mov	word ptr [rdi + 7], 1
        jne	.LBB140_2
        mov	word ptr [rbp - 10], 2
        mov	word ptr [rdi + 7], 2
        jmp	.LBB140_3
.LBB140_2:
        lea	rdx, [rbp - 12]
        mov	rbx, rdi
        mov	esi, 3
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
        mov	rdi, rbx
        movzx	eax, word ptr [rbx + 7]
        mov	word ptr [rbp - 10], 2
        mov	word ptr [rbx + 7], 2
        cmp	ax, 2
        je	.LBB140_4
.LBB140_3:
        lea	rdx, [rbp - 10]
        mov	esi, 3
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
.LBB140_4:
        add	rsp, 8
        pop	rbx
        pop	rbp
        ret

codegen_triple_write_increment:
        push	rbp
        mov	rbp, rsp
        push	rbx
        push	rax
        mov	rbx, rdi
        mov	word ptr [rbp - 14], 1
        cmp	word ptr [rdi + 7], 1
        mov	word ptr [rdi + 7], 1
        jne	.LBB141_3
        mov	word ptr [rbp - 10], 2
        mov	word ptr [rbx + 7], 2
        jmp	.LBB141_2
.LBB141_3:
        lea	rdx, [rbp - 14]
        mov	rdi, rbx
        mov	esi, 3
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
        movzx	eax, word ptr [rbx + 7]
        mov	word ptr [rbp - 10], 2
        mov	word ptr [rbx + 7], 2
        cmp	ax, 2
        jne	.LBB141_2
        mov	word ptr [rbp - 12], 3
        mov	word ptr [rbx + 7], 3
        jmp	.LBB141_5
.LBB141_2:
        lea	rdx, [rbp - 10]
        mov	rdi, rbx
        mov	esi, 3
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
        movzx	eax, word ptr [rbx + 7]
        mov	word ptr [rbp - 12], 3
        mov	word ptr [rbx + 7], 3
        cmp	ax, 3
        je	.LBB141_6
.LBB141_5:
        lea	rdx, [rbp - 12]
        mov	rdi, rbx
        mov	esi, 3
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
.LBB141_6:
        add	rsp, 8
        pop	rbx
        pop	rbp
        ret

codegen_double_rmw_struct:
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 32
        mov	rbx, rdi
        mov	eax, dword ptr [rdi + 272]
        mov	ecx, dword ptr [rdi + 276]
        add	eax, 1
        movups	xmm0, xmmword ptr [rdi + 256]
        movaps	xmmword ptr [rbp - 40], xmm0
        mov	dword ptr [rbp - 24], eax
        mov	dword ptr [rbp - 20], ecx
        mov	dword ptr [rdi + 272], eax
        lea	r14, [rbp - 40]
        mov	rsi, r14
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_3683,meta.FieldEnum(codegen_harness.HugeSystem__struct_3683),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).publish"
        movups	xmm0, xmmword ptr [rbx + 264]
        mov	rax, qword ptr [rbx + 256]
        add	rax, 1
        mov	qword ptr [rbp - 40], rax
        movups	xmmword ptr [rbp - 32], xmm0
        mov	qword ptr [rbx + 256], rax
        mov	rdi, rbx
        mov	rsi, r14
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_3683,meta.FieldEnum(codegen_harness.HugeSystem__struct_3683),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).publish"
        add	rsp, 32
        pop	rbx
        pop	r14
        pop	rbp
        ret

; --- called functions ---

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
        test	esi, 65533
        je	.LBB6_4
        mov	r14d, esi
        mov	r15, rdi
        movzx	eax, r14w
        mov	rcx, qword ptr [8*rax + .L__unnamed_1]
        movzx	eax, byte ptr [rax + .L__unnamed_2]
        cmp	al, 1
        adc	eax, 0
        movzx	r13d, al
        shl	r13d, 4
        shl	rcx, 4
        lea	r12, [rdi + rcx]
        add	r12, 24
        xor	ebx, ebx
        jmp	.LBB6_2
.LBB6_3:
        add	rbx, 16
        cmp	r13, rbx
        je	.LBB6_4
.LBB6_2:
        mov	rax, qword ptr [r12 + rbx]
        test	rax, rax
        je	.LBB6_3
        mov	rdi, qword ptr [r12 + rbx - 8]
        mov	word ptr [rbp - 56], r14w
        mov	rcx, qword ptr [rbp - 48]
        mov	qword ptr [rbp - 64], rcx
        lea	rsi, [rbp - 64]
        mov	rdx, r15
        call	rax
        jmp	.LBB6_3
.LBB6_4:
        add	rsp, 24
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        ret

"system_data.SystemData(codegen_harness.ManyErdsSystem__struct_2447,meta.FieldEnum(codegen_harness.ManyErdsSystem__struct_2447),.{ .e00 = .{ ... }, .e01 = .{ ... }, .e02 = .{ ... }, .e03 = .{ ... }, .e04 = .{ ... }, .e05 = .{ ... }, .e06 = .{ ... }, .e07 = .{ ... }, .e08 = .{ ... }, .e09 = .{ ... }, .e10 = .{ ... }, .e11 = .{ ... }, .e12 = .{ ... }, .e13 = .{ ... }, .e14 = .{ ... }, .e15 = .{ ... }, .e16 = .{ ... }, .e17 = .{ ... }, .e18 = .{ ... }, .e19 = .{ ... }, .e20 = .{ ... }, .e21 = .{ ... }, .e22 = .{ ... }, .e23 = .{ ... }, .e24 = .{ ... }, .e25 = .{ ... }, .e26 = .{ ... }, .e27 = .{ ... }, .e28 = .{ ... }, .e29 = .{ ... }, .e30 = .{ ... }, .e31 = .{ ... } },testing.create.Components).publish":
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 16
        mov	r14, rsi
        mov	rbx, rdi
        mov	rax, qword ptr [rdi + 144]
        test	rax, rax
        je	.LBB17_1
        mov	rdi, qword ptr [rbx + 136]
        mov	word ptr [rbp - 24], 31
        mov	qword ptr [rbp - 32], r14
        lea	rsi, [rbp - 32]
        mov	rdx, rbx
        call	rax
.LBB17_1:
        mov	rax, qword ptr [rbx + 160]
        test	rax, rax
        je	.LBB17_3
        mov	rdi, qword ptr [rbx + 152]
        mov	word ptr [rbp - 24], 31
        mov	qword ptr [rbp - 32], r14
        lea	rsi, [rbp - 32]
        mov	rdx, rbx
        call	rax
.LBB17_3:
        mov	rax, qword ptr [rbx + 176]
        test	rax, rax
        je	.LBB17_5
        mov	rdi, qword ptr [rbx + 168]
        mov	word ptr [rbp - 24], 31
        mov	qword ptr [rbp - 32], r14
        lea	rsi, [rbp - 32]
        mov	rdx, rbx
        call	rax
.LBB17_5:
        add	rsp, 16
        pop	rbx
        pop	r14
        pop	rbp
        ret

"system_data.SystemData(codegen_harness.HugeSystem__struct_3683,meta.FieldEnum(codegen_harness.HugeSystem__struct_3683),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).publish":
        mov	rax, qword ptr [rdi + 296]
        test	rax, rax
        je	.LBB24_2
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rdx, rdi
        mov	rdi, qword ptr [rdi + 288]
        mov	word ptr [rbp - 8], 1
        mov	qword ptr [rbp - 16], rsi
        lea	rsi, [rbp - 16]
        call	rax
        add	rsp, 16
        pop	rbp
.LBB24_2:
        ret

debug.panic__anon_4261:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rax, qword ptr [rbp + 8]
        mov	qword ptr [rbp - 16], rax
        mov	byte ptr [rbp - 8], 1
        lea	rdi, [rbp - 16]
        call	debug.panicExtra__anon_4270

"system_data.SystemData(codegen_harness.OtherSystem__struct_2193,meta.FieldEnum(codegen_harness.OtherSystem__struct_2193),.{ .sensor_a = .{ ... }, .sensor_b = .{ ... }, .output = .{ ... } },testing.create.Components).publish":
        mov	rax, qword ptr [rdi + 24]
        test	rax, rax
        je	.LBB137_2
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rdx, rdi
        mov	rdi, qword ptr [rdi + 16]
        mov	word ptr [rbp - 8], 0
        mov	qword ptr [rbp - 16], rsi
        lea	rsi, [rbp - 16]
        call	rax
        add	rsp, 16
        pop	rbp
.LBB137_2:
        ret

