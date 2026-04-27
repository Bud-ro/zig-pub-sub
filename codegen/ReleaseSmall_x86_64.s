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
        je	.LBB15_2
        lea	rsi, [rbp - 8]
        call	"system_data.SystemData(codegen_harness.ManyErdsSystem__struct_2446,meta.FieldEnum(codegen_harness.ManyErdsSystem__struct_2446),.{ .e00 = .{ ... }, .e01 = .{ ... }, .e02 = .{ ... }, .e03 = .{ ... }, .e04 = .{ ... }, .e05 = .{ ... }, .e06 = .{ ... }, .e07 = .{ ... }, .e08 = .{ ... }, .e09 = .{ ... }, .e10 = .{ ... }, .e11 = .{ ... }, .e12 = .{ ... }, .e13 = .{ ... }, .e14 = .{ ... }, .e15 = .{ ... }, .e16 = .{ ... }, .e17 = .{ ... }, .e18 = .{ ... }, .e19 = .{ ... }, .e20 = .{ ... }, .e21 = .{ ... }, .e22 = .{ ... }, .e23 = .{ ... }, .e24 = .{ ... }, .e25 = .{ ... }, .e26 = .{ ... }, .e27 = .{ ... }, .e28 = .{ ... }, .e29 = .{ ... }, .e30 = .{ ... }, .e31 = .{ ... } },testing.create.Components).publish"
.LBB15_2:
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
        jmp	"system_data.SystemData(codegen_harness.HugeSystem__struct_3680,meta.FieldEnum(codegen_harness.HugeSystem__struct_3680),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).write__anon_3957"

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
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_3680,meta.FieldEnum(codegen_harness.HugeSystem__struct_3680),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).write__anon_3957"
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
        je	.LBB27_1
.LBB27_8:
        mov	rdi, r14
        mov	rsi, rbx
        call	timer.TimerModule.try_remove
        test	al, 1
        jne	.LBB27_2
        lea	rdi, [r14 + 8]
        mov	rsi, rbx
        call	timer.TimerModule.try_remove
        jmp	.LBB27_2
.LBB27_1:
        cmp	qword ptr [r14], rbx
        je	.LBB27_8
.LBB27_2:
        mov	qword ptr [r15 + 8], offset codegen_harness.timer_callback_read_write
        mov	dword ptr [r15 + 28], 100
        or	r12, 1
        mov	qword ptr [r15], r12
        mov	ecx, dword ptr [r14 + 16]
        lea	eax, [rcx + 100]
        mov	dword ptr [r15 + 24], eax
        mov	rax, qword ptr [r14]
        test	rax, rax
        je	.LBB27_3
        mov	edx, dword ptr [rax + 8]
        sub	edx, ecx
        add	edx, -101
        cmp	edx, -65636
        jb	.LBB27_7
.LBB27_5:
        mov	r14, rax
        mov	rax, qword ptr [rax]
        test	rax, rax
        je	.LBB27_3
        mov	edx, dword ptr [rax + 8]
        sub	edx, ecx
        add	edx, 65535
        cmp	edx, 65636
        jb	.LBB27_5
        jmp	.LBB27_7
.LBB27_3:
        xor	eax, eax
.LBB27_7:
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
        je	.LBB35_3
        test	rax, rax
        jne	.LBB35_4
        and	qword ptr [rdi + 16], 0
        mov	qword ptr [rdi + 24], offset codegen_harness.accumulate_callback
.LBB35_3:
        ret
.LBB35_4:
        push	rbp
        mov	rbp, rsp
        call	debug.panic__anon_4179

codegen_harness.accumulate_callback:
        push	rbp
        mov	rbp, rsp
        mov	rax, qword ptr [rsi]
        cmp	byte ptr [rax], 0
        je	.LBB36_2
        inc	dword ptr [rdx]
.LBB36_2:
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
.LBB58_1:
        cmp	esi, 1
        jb	.LBB58_3
        inc	dword ptr [rdi]
        dec	esi
        jmp	.LBB58_1
.LBB58_3:
        pop	rbp
        ret

codegen_conditional_write_chain:
        push	rbp
        mov	rbp, rsp
        test	byte ptr [rdi + 4], 1
        je	.LBB59_1
        add	dword ptr [rdi], 10
.LBB59_1:
        cmp	word ptr [rdi + 5], 100
        jbe	.LBB59_3
        add	dword ptr [rdi], 20
.LBB59_3:
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
        je	.LBB63_2
        lea	rax, [rbp - 4]
        mov	rdi, rsi
        mov	rsi, rax
        call	"system_data.SystemData(codegen_harness.OtherSystem__struct_2192,meta.FieldEnum(codegen_harness.OtherSystem__struct_2192),.{ .sensor_a = .{ ... }, .sensor_b = .{ ... }, .output = .{ ... } },testing.create.Components).publish"
.LBB63_2:
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

"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1131":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        and	sil, 1
        mov	byte ptr [rbp - 1], sil
        cmp	byte ptr [rdi + 4], sil
        mov	byte ptr [rdi + 4], sil
        je	.LBB5_2
        push	1
        pop	rsi
        lea	rdx, [rbp - 1]
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
.LBB5_2:
        add	rsp, 16
        pop	rbp
        ret

"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1930":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	word ptr [rbp - 2], si
        cmp	word ptr [rdi + 7], si
        mov	word ptr [rdi + 7], si
        je	.LBB8_2
        push	3
        pop	rsi
        lea	rdx, [rbp - 2]
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
.LBB8_2:
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
.LBB16_1:
        cmp	r12, 192
        je	.LBB16_5
        mov	rax, qword ptr [r14 + r12]
        test	rax, rax
        je	.LBB16_3
        mov	rdi, qword ptr [r14 + r12 - 8]
        mov	word ptr [rbp - 40], 31
        mov	qword ptr [rbp - 48], rbx
        mov	rsi, r15
        mov	rdx, r14
        call	rax
.LBB16_3:
        add	r12, 16
        jmp	.LBB16_1
.LBB16_5:
        add	rsp, 16
        pop	rbx
        pop	r12
        pop	r14
        pop	r15
        pop	rbp
        ret

"system_data.SystemData(codegen_harness.HugeSystem__struct_3680,meta.FieldEnum(codegen_harness.HugeSystem__struct_3680),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).write__anon_3957":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        mov	rax, qword ptr [rsi + 16]
        mov	qword ptr [rbp - 16], rax
        movups	xmm0, xmmword ptr [rsi]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	rax, qword ptr [rsi]
        mov	rcx, qword ptr [rsi + 8]
        mov	rdx, qword ptr [rsi + 16]
        mov	rsi, qword ptr [rdi + 272]
        xor	rsi, rdx
        mov	r8, qword ptr [rdi + 256]
        xor	r8, rax
        or	r8, rsi
        mov	rsi, qword ptr [rdi + 264]
        xor	rsi, rcx
        or	rsi, r8
        mov	qword ptr [rdi + 272], rdx
        mov	qword ptr [rdi + 256], rax
        mov	qword ptr [rdi + 264], rcx
        je	.LBB23_2
        lea	rsi, [rbp - 32]
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_3680,meta.FieldEnum(codegen_harness.HugeSystem__struct_3680),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).publish"
.LBB23_2:
        add	rsp, 32
        pop	rbp
        ret

timer.TimerModule.try_remove:
        mov	rax, qword ptr [rdi]
        test	rax, rax
        je	.LBB29_5
        push	rbp
        mov	rbp, rsp
        cmp	rax, rsi
        je	.LBB29_4
.LBB29_2:
        mov	rcx, qword ptr [rax]
        test	rcx, rcx
        je	.LBB29_7
        mov	rdi, rax
        mov	rax, rcx
        cmp	rcx, rsi
        jne	.LBB29_2
.LBB29_4:
        mov	rax, qword ptr [rsi]
        mov	qword ptr [rdi], rax
        mov	al, 1
        jmp	.LBB29_8
.LBB29_5:
        xor	eax, eax
        ret
.LBB29_7:
        xor	eax, eax
.LBB29_8:
        pop	rbp
        ret

debug.panic__anon_4179:
        push	rbp
        mov	rbp, rsp
        call	debug.panicExtra__anon_4188

"system_data.SystemData(codegen_harness.OtherSystem__struct_2192,meta.FieldEnum(codegen_harness.OtherSystem__struct_2192),.{ .sensor_a = .{ ... }, .sensor_b = .{ ... }, .output = .{ ... } },testing.create.Components).publish":
        mov	rcx, qword ptr [rdi + 24]
        test	rcx, rcx
        je	.LBB64_2
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
.LBB64_2:
        ret

