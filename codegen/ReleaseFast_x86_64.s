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
        je	.LBB4_2
        lea	rdx, [rbp - 1]
        mov	esi, 1
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
.LBB4_2:
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
        je	.LBB6_2
        lea	rdx, [rbp - 2]
        mov	esi, 3
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
.LBB6_2:
        add	rsp, 16
        pop	rbp
        ret

codegen_runtime_write_u32:
        push	rbp
        mov	rbp, rsp
        mov	dword ptr [rdi], -559038737
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
        je	.LBB14_2
        lea	rsi, [rbp - 8]
        call	"system_data.SystemData(codegen_harness.ManyErdsSystem__struct_2448,meta.FieldEnum(codegen_harness.ManyErdsSystem__struct_2448),.{ .e00 = .{ ... }, .e01 = .{ ... }, .e02 = .{ ... }, .e03 = .{ ... }, .e04 = .{ ... }, .e05 = .{ ... }, .e06 = .{ ... }, .e07 = .{ ... }, .e08 = .{ ... }, .e09 = .{ ... }, .e10 = .{ ... }, .e11 = .{ ... }, .e12 = .{ ... }, .e13 = .{ ... }, .e14 = .{ ... }, .e15 = .{ ... }, .e16 = .{ ... }, .e17 = .{ ... }, .e18 = .{ ... }, .e19 = .{ ... }, .e20 = .{ ... }, .e21 = .{ ... }, .e22 = .{ ... }, .e23 = .{ ... }, .e24 = .{ ... }, .e25 = .{ ... }, .e26 = .{ ... }, .e27 = .{ ... }, .e28 = .{ ... }, .e29 = .{ ... }, .e30 = .{ ... }, .e31 = .{ ... } },testing.create.Components).publish"
.LBB14_2:
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
        jne	.LBB21_6
        cmp	r9, qword ptr [rsi + 8]
        jne	.LBB21_6
        cmp	r8d, dword ptr [rsi + 16]
        jne	.LBB21_6
        cmp	dx, word ptr [rsi + 20]
        jne	.LBB21_6
        cmp	cl, byte ptr [rsi + 22]
        jne	.LBB21_6
        and	al, 1
        cmp	byte ptr [rsi + 23], al
        je	.LBB21_7
.LBB21_6:
        lea	rsi, [rbp - 32]
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_3682,meta.FieldEnum(codegen_harness.HugeSystem__struct_3682),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).publish"
.LBB21_7:
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
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_3682,meta.FieldEnum(codegen_harness.HugeSystem__struct_3682),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).publish"
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
        je	.LBB25_11
        test	rcx, rcx
        je	.LBB25_5
        mov	r8, rsi
        cmp	rcx, rax
        je	.LBB25_10
.LBB25_3:
        mov	r9, qword ptr [rcx]
        test	r9, r9
        je	.LBB25_5
        mov	r8, rcx
        mov	rcx, r9
        cmp	r9, rax
        jne	.LBB25_3
        jmp	.LBB25_10
.LBB25_5:
        mov	rcx, qword ptr [rsi + 8]
        test	rcx, rcx
        je	.LBB25_11
        cmp	rcx, rax
        je	.LBB25_9
.LBB25_7:
        mov	r9, qword ptr [rcx]
        test	r9, r9
        je	.LBB25_11
        mov	r8, rcx
        mov	rcx, r9
        cmp	r9, rax
        jne	.LBB25_7
        jmp	.LBB25_10
.LBB25_9:
        lea	r8, [rsi + 8]
.LBB25_10:
        mov	rcx, qword ptr [rax]
        mov	qword ptr [r8], rcx
.LBB25_11:
        mov	qword ptr [rdx + 8], offset codegen_harness.timer_callback_read_write
        mov	dword ptr [rdx + 28], 100
        or	rdi, 1
        mov	qword ptr [rdx], rdi
        mov	edi, dword ptr [rsi + 16]
        lea	ecx, [rdi + 100]
        mov	dword ptr [rdx + 24], ecx
        mov	rcx, qword ptr [rsi]
        test	rcx, rcx
        je	.LBB25_17
        mov	edx, dword ptr [rcx + 8]
        sub	edx, edi
        add	edx, -101
        cmp	edx, -65636
        jb	.LBB25_15
.LBB25_13:
        mov	rsi, rcx
        mov	rcx, qword ptr [rcx]
        test	rcx, rcx
        je	.LBB25_17
        mov	edx, dword ptr [rcx + 8]
        sub	edx, edi
        add	edx, 65535
        cmp	edx, 65636
        jb	.LBB25_13
.LBB25_15:
        mov	qword ptr [rax], rcx
        mov	qword ptr [rsi], rax
        pop	rbp
        ret
.LBB25_17:
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
        je	.LBB30_2
        lea	rdx, [rbp - 17]
        mov	rbx, rdi
        mov	esi, 1
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
        mov	eax, dword ptr [rbx]
.LBB30_2:
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
        je	.LBB32_3
        test	rax, rax
        jne	.LBB32_4
        mov	qword ptr [rdi + 16], 0
        mov	qword ptr [rdi + 24], offset codegen_harness.accumulate_callback
.LBB32_3:
        ret
.LBB32_4:
        push	rbp
        mov	rbp, rsp
        call	debug.panic__anon_4254

codegen_harness.accumulate_callback:
        push	rbp
        mov	rbp, rsp
        mov	rax, qword ptr [rsi]
        cmp	byte ptr [rax], 0
        je	.LBB33_2
        add	dword ptr [rdx], 1
.LBB33_2:
        pop	rbp
        ret

codegen_write_triggering_callback:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	byte ptr [rbp - 1], 1
        cmp	byte ptr [rdi + 4], 1
        mov	byte ptr [rdi + 4], 1
        je	.LBB128_2
        lea	rdx, [rbp - 1]
        mov	esi, 1
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
.LBB128_2:
        add	rsp, 16
        pop	rbp
        ret

codegen_increment_n_times:
        push	rbp
        mov	rbp, rsp
        test	esi, esi
        je	.LBB129_2
        add	dword ptr [rdi], esi
.LBB129_2:
        pop	rbp
        ret

codegen_conditional_write_chain:
        push	rbp
        mov	rbp, rsp
        test	byte ptr [rdi + 4], 1
        jne	.LBB130_4
        cmp	word ptr [rdi + 5], 100
        ja	.LBB130_2
.LBB130_3:
        pop	rbp
        ret
.LBB130_4:
        add	dword ptr [rdi], 10
        cmp	word ptr [rdi + 5], 100
        jbe	.LBB130_3
.LBB130_2:
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
        je	.LBB131_2
        lea	rdx, [rbp - 2]
        mov	esi, 3
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
.LBB131_2:
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
        je	.LBB134_2
        lea	rax, [rbp - 4]
        mov	rdi, rsi
        mov	rsi, rax
        call	"system_data.SystemData(codegen_harness.OtherSystem__struct_2194,meta.FieldEnum(codegen_harness.OtherSystem__struct_2194),.{ .sensor_a = .{ ... }, .sensor_b = .{ ... }, .output = .{ ... } },testing.create.Components).publish"
.LBB134_2:
        add	rsp, 16
        pop	rbp
        ret

codegen_runtime_read_u32:
        push	rbp
        mov	rbp, rsp
        pop	rbp
        jmp	codegen_read_u32

codegen_write_u32_no_subs:
        push	rbp
        mov	rbp, rsp
        pop	rbp
        jmp	codegen_runtime_write_u32

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
        mov	r14d, esi
        cmp	r14w, 2
        jne	.LBB5_1
.LBB5_4:
        add	rsp, 24
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        ret
.LBB5_1:
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
        jmp	.LBB5_2
.LBB5_3:
        add	rbx, 16
        cmp	r13, rbx
        je	.LBB5_4
.LBB5_2:
        mov	rax, qword ptr [r12 + rbx]
        test	rax, rax
        je	.LBB5_3
        mov	rdi, qword ptr [r12 + rbx - 8]
        mov	word ptr [rbp - 56], r14w
        mov	rcx, qword ptr [rbp - 48]
        mov	qword ptr [rbp - 64], rcx
        lea	rsi, [rbp - 64]
        mov	rdx, r15
        call	rax
        jmp	.LBB5_3

"system_data.SystemData(codegen_harness.ManyErdsSystem__struct_2448,meta.FieldEnum(codegen_harness.ManyErdsSystem__struct_2448),.{ .e00 = .{ ... }, .e01 = .{ ... }, .e02 = .{ ... }, .e03 = .{ ... }, .e04 = .{ ... }, .e05 = .{ ... }, .e06 = .{ ... }, .e07 = .{ ... }, .e08 = .{ ... }, .e09 = .{ ... }, .e10 = .{ ... }, .e11 = .{ ... }, .e12 = .{ ... }, .e13 = .{ ... }, .e14 = .{ ... }, .e15 = .{ ... }, .e16 = .{ ... }, .e17 = .{ ... }, .e18 = .{ ... }, .e19 = .{ ... }, .e20 = .{ ... }, .e21 = .{ ... }, .e22 = .{ ... }, .e23 = .{ ... }, .e24 = .{ ... }, .e25 = .{ ... }, .e26 = .{ ... }, .e27 = .{ ... }, .e28 = .{ ... }, .e29 = .{ ... }, .e30 = .{ ... }, .e31 = .{ ... } },testing.create.Components).publish":
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 16
        mov	r14, rsi
        mov	rbx, rdi
        mov	rax, qword ptr [rdi + 144]
        test	rax, rax
        je	.LBB15_1
        mov	rdi, qword ptr [rbx + 136]
        mov	word ptr [rbp - 24], 31
        mov	qword ptr [rbp - 32], r14
        lea	rsi, [rbp - 32]
        mov	rdx, rbx
        call	rax
.LBB15_1:
        mov	rax, qword ptr [rbx + 160]
        test	rax, rax
        je	.LBB15_3
        mov	rdi, qword ptr [rbx + 152]
        mov	word ptr [rbp - 24], 31
        mov	qword ptr [rbp - 32], r14
        lea	rsi, [rbp - 32]
        mov	rdx, rbx
        call	rax
.LBB15_3:
        mov	rax, qword ptr [rbx + 176]
        test	rax, rax
        je	.LBB15_5
        mov	rdi, qword ptr [rbx + 168]
        mov	word ptr [rbp - 24], 31
        mov	qword ptr [rbp - 32], r14
        lea	rsi, [rbp - 32]
        mov	rdx, rbx
        call	rax
.LBB15_5:
        add	rsp, 16
        pop	rbx
        pop	r14
        pop	rbp
        ret

"system_data.SystemData(codegen_harness.HugeSystem__struct_3682,meta.FieldEnum(codegen_harness.HugeSystem__struct_3682),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).publish":
        mov	rax, qword ptr [rdi + 296]
        test	rax, rax
        je	.LBB22_2
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
.LBB22_2:
        ret

debug.panic__anon_4254:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rax, qword ptr [rbp + 8]
        mov	qword ptr [rbp - 16], rax
        mov	byte ptr [rbp - 8], 1
        lea	rdi, [rbp - 16]
        call	debug.panicExtra__anon_4263

"system_data.SystemData(codegen_harness.OtherSystem__struct_2194,meta.FieldEnum(codegen_harness.OtherSystem__struct_2194),.{ .sensor_a = .{ ... }, .sensor_b = .{ ... }, .output = .{ ... } },testing.create.Components).publish":
        mov	rax, qword ptr [rdi + 24]
        test	rax, rax
        je	.LBB135_2
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
.LBB135_2:
        ret

