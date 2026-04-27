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
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_2110"

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
        call	mem.eql__anon_1161
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
        sub	rsp, 16
        lea	rdx, [rbp - 8]
        mov	qword ptr [rdx], rsi
        lea	rsi, [rdi + 112]
        call	"system_data.SystemData(codegen_harness.ManyErdsSystem__struct_2420,meta.FieldEnum(codegen_harness.ManyErdsSystem__struct_2420),.{ .e00 = .{ ... }, .e01 = .{ ... }, .e02 = .{ ... }, .e03 = .{ ... }, .e04 = .{ ... }, .e05 = .{ ... }, .e06 = .{ ... }, .e07 = .{ ... }, .e08 = .{ ... }, .e09 = .{ ... }, .e10 = .{ ... }, .e11 = .{ ... }, .e12 = .{ ... }, .e13 = .{ ... }, .e14 = .{ ... }, .e15 = .{ ... }, .e16 = .{ ... }, .e17 = .{ ... }, .e18 = .{ ... }, .e19 = .{ ... }, .e20 = .{ ... }, .e21 = .{ ... }, .e22 = .{ ... }, .e23 = .{ ... }, .e24 = .{ ... }, .e25 = .{ ... }, .e26 = .{ ... }, .e27 = .{ ... }, .e28 = .{ ... }, .e29 = .{ ... }, .e30 = .{ ... }, .e31 = .{ ... } },testing.create.Components).writeAndPublish"
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
        jmp	"system_data.SystemData(codegen_harness.HugeSystem__struct_3653,meta.FieldEnum(codegen_harness.HugeSystem__struct_3653),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).write__anon_3930"

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
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_3653,meta.FieldEnum(codegen_harness.HugeSystem__struct_3653),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).write__anon_3930"
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
        je	.LBB31_1
.LBB31_8:
        mov	rdi, r14
        mov	rsi, rbx
        call	timer.TimerModule.try_remove
        test	al, 1
        jne	.LBB31_2
        lea	rdi, [r14 + 8]
        mov	rsi, rbx
        call	timer.TimerModule.try_remove
        jmp	.LBB31_2
.LBB31_1:
        cmp	qword ptr [r14], rbx
        je	.LBB31_8
.LBB31_2:
        mov	qword ptr [r15 + 8], offset codegen_harness.timer_callback_read_write
        mov	dword ptr [r15 + 28], 100
        or	r12, 1
        mov	qword ptr [r15], r12
        mov	ecx, dword ptr [r14 + 16]
        lea	eax, [rcx + 100]
        mov	dword ptr [r15 + 24], eax
        mov	rax, qword ptr [r14]
        test	rax, rax
        je	.LBB31_3
        mov	edx, dword ptr [rax + 8]
        sub	edx, ecx
        add	edx, -101
        cmp	edx, -65636
        jb	.LBB31_7
.LBB31_5:
        mov	r14, rax
        mov	rax, qword ptr [rax]
        test	rax, rax
        je	.LBB31_3
        mov	edx, dword ptr [rax + 8]
        sub	edx, ecx
        add	edx, 65535
        cmp	edx, 65636
        jb	.LBB31_5
        jmp	.LBB31_7
.LBB31_3:
        xor	eax, eax
.LBB31_7:
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
        je	.LBB39_3
        test	rax, rax
        jne	.LBB39_4
        and	qword ptr [rdi + 16], 0
        mov	qword ptr [rdi + 24], offset codegen_harness.accumulate_callback
.LBB39_3:
        ret
.LBB39_4:
        push	rbp
        mov	rbp, rsp
        call	debug.panic__anon_4227

codegen_harness.accumulate_callback:
        push	rbp
        mov	rbp, rsp
        mov	rax, qword ptr [rsi]
        cmp	byte ptr [rax], 0
        je	.LBB40_2
        inc	dword ptr [rdx]
.LBB40_2:
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
.LBB62_1:
        cmp	esi, 1
        jb	.LBB62_3
        inc	dword ptr [rdi]
        dec	esi
        jmp	.LBB62_1
.LBB62_3:
        pop	rbp
        ret

codegen_conditional_write_chain:
        push	rbp
        mov	rbp, rsp
        test	byte ptr [rdi + 4], 1
        je	.LBB63_1
        add	dword ptr [rdi], 10
.LBB63_1:
        cmp	word ptr [rdi + 5], 100
        jbe	.LBB63_3
        add	dword ptr [rdi], 20
.LBB63_3:
        pop	rbp
        ret

codegen_cross_erd_compute:
        push	rbp
        mov	rbp, rsp
        movzx	esi, word ptr [rdi + 5]
        add	si, word ptr [rdi]
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_2110"

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
        lea	rdx, [rbp - 4]
        mov	dword ptr [rdx], eax
        mov	rdi, rsi
        call	"system_data.SystemData(codegen_harness.OtherSystem__struct_2166,meta.FieldEnum(codegen_harness.OtherSystem__struct_2166),.{ .sensor_a = .{ ... }, .sensor_b = .{ ... }, .output = .{ ... } },testing.create.Components).writeAndPublish"
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
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_2110"
        push	2
        pop	rsi
        mov	rdi, rbx
        add	rsp, 8
        pop	rbx
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_2110"

codegen_triple_write_increment:
        push	rbp
        mov	rbp, rsp
        push	rbx
        push	rax
        mov	rbx, rdi
        push	1
        pop	rsi
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_2110"
        push	2
        pop	rsi
        mov	rdi, rbx
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_2110"
        push	3
        pop	rsi
        mov	rdi, rbx
        add	rsp, 8
        pop	rbx
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_2110"

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
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_3653,meta.FieldEnum(codegen_harness.HugeSystem__struct_3653),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).write__anon_3930"
        movups	xmm0, xmmword ptr [rbx + 256]
        lea	rsi, [rbp - 64]
        movaps	xmmword ptr [rsi], xmm0
        mov	rax, qword ptr [rbx + 272]
        mov	qword ptr [rsi + 16], rax
        inc	qword ptr [rsi]
        mov	rdi, rbx
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_3653,meta.FieldEnum(codegen_harness.HugeSystem__struct_3653),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).write__anon_3930"
        add	rsp, 56
        pop	rbx
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
        sub	rsp, 16
        and	esi, 1
        lea	rcx, [rbp - 1]
        mov	byte ptr [rcx], sil
        lea	rsi, [rdi + 4]
        push	1
        pop	rdx
        push	1
        pop	r8
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).writeAndPublish"
        add	rsp, 16
        pop	rbp
        ret

mem.eql__anon_1161:
        cmp	rsi, rcx
        jne	.LBB8_4
        cmp	rdi, rdx
        je	.LBB8_6
        cmp	rsi, 3
        ja	.LBB8_7
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
        sete	al
        ret
.LBB8_4:
        xor	eax, eax
        ret
.LBB8_6:
        mov	al, 1
        ret
.LBB8_7:
        push	rbp
        mov	rbp, rsp
        lea	rax, [rsi - 4]
        and	qword ptr [rbp - 32], 0
        shr	esi
        and	esi, 4
        mov	qword ptr [rbp - 24], rax
        sub	rax, rsi
        mov	qword ptr [rbp - 16], rsi
        mov	qword ptr [rbp - 8], rax
        xor	eax, eax
        xor	ecx, ecx
.LBB8_8:
        cmp	rcx, 4
        je	.LBB8_10
        mov	rsi, qword ptr [rbp + 8*rcx - 32]
        mov	r8d, dword ptr [rdx + rsi]
        xor	r8d, dword ptr [rdi + rsi]
        or	eax, r8d
        inc	rcx
        jmp	.LBB8_8
.LBB8_10:
        test	eax, eax
        sete	al
        pop	rbp
        ret

"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_2110":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        lea	rcx, [rbp - 2]
        mov	word ptr [rcx], si
        lea	rsi, [rdi + 7]
        push	2
        pop	rdx
        push	3
        pop	r8
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).writeAndPublish"
        add	rsp, 16
        pop	rbp
        ret

"system_data.SystemData(codegen_harness.ManyErdsSystem__struct_2420,meta.FieldEnum(codegen_harness.ManyErdsSystem__struct_2420),.{ .e00 = .{ ... }, .e01 = .{ ... }, .e02 = .{ ... }, .e03 = .{ ... }, .e04 = .{ ... }, .e05 = .{ ... }, .e06 = .{ ... }, .e07 = .{ ... }, .e08 = .{ ... }, .e09 = .{ ... }, .e10 = .{ ... }, .e11 = .{ ... }, .e12 = .{ ... }, .e13 = .{ ... }, .e14 = .{ ... }, .e15 = .{ ... }, .e16 = .{ ... }, .e17 = .{ ... }, .e18 = .{ ... }, .e19 = .{ ... }, .e20 = .{ ... }, .e21 = .{ ... }, .e22 = .{ ... }, .e23 = .{ ... }, .e24 = .{ ... }, .e25 = .{ ... }, .e26 = .{ ... }, .e27 = .{ ... }, .e28 = .{ ... }, .e29 = .{ ... }, .e30 = .{ ... }, .e31 = .{ ... } },testing.create.Components).writeAndPublish":
        push	rbp
        mov	rbp, rsp
        push	r15
        push	r14
        push	rbx
        push	rax
        mov	rbx, rdx
        mov	r15, rsi
        mov	r14, rdi
        push	8
        pop	rcx
        mov	rdi, rsi
        mov	rsi, rcx
        call	mem.eql__anon_1161
        mov	rcx, qword ptr [rbx]
        mov	qword ptr [r15], rcx
        test	al, 1
        je	.LBB19_2
        add	rsp, 8
        pop	rbx
        pop	r14
        pop	r15
        pop	rbp
        ret
.LBB19_2:
        mov	rdi, r14
        mov	rsi, rbx
        add	rsp, 8
        pop	rbx
        pop	r14
        pop	r15
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.ManyErdsSystem__struct_2420,meta.FieldEnum(codegen_harness.ManyErdsSystem__struct_2420),.{ .e00 = .{ ... }, .e01 = .{ ... }, .e02 = .{ ... }, .e03 = .{ ... }, .e04 = .{ ... }, .e05 = .{ ... }, .e06 = .{ ... }, .e07 = .{ ... }, .e08 = .{ ... }, .e09 = .{ ... }, .e10 = .{ ... }, .e11 = .{ ... }, .e12 = .{ ... }, .e13 = .{ ... }, .e14 = .{ ... }, .e15 = .{ ... }, .e16 = .{ ... }, .e17 = .{ ... }, .e18 = .{ ... }, .e19 = .{ ... }, .e20 = .{ ... }, .e21 = .{ ... }, .e22 = .{ ... }, .e23 = .{ ... }, .e24 = .{ ... }, .e25 = .{ ... }, .e26 = .{ ... }, .e27 = .{ ... }, .e28 = .{ ... }, .e29 = .{ ... }, .e30 = .{ ... }, .e31 = .{ ... } },testing.create.Components).publish"

"system_data.SystemData(codegen_harness.HugeSystem__struct_3653,meta.FieldEnum(codegen_harness.HugeSystem__struct_3653),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).write__anon_3930":
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
        jne	.LBB27_6
        cmp	r9, qword ptr [rsi + 8]
        jne	.LBB27_6
        cmp	r8d, dword ptr [rsi + 16]
        jne	.LBB27_6
        cmp	dx, word ptr [rsi + 20]
        jne	.LBB27_6
        cmp	cl, byte ptr [rsi + 22]
        jne	.LBB27_6
        and	al, 1
        cmp	byte ptr [rsi + 23], al
        je	.LBB27_7
.LBB27_6:
        lea	rsi, [rbp - 32]
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_3653,meta.FieldEnum(codegen_harness.HugeSystem__struct_3653),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).publish"
.LBB27_7:
        add	rsp, 32
        pop	rbp
        ret

timer.TimerModule.try_remove:
        mov	rax, qword ptr [rdi]
        test	rax, rax
        je	.LBB33_5
        push	rbp
        mov	rbp, rsp
        cmp	rax, rsi
        je	.LBB33_4
.LBB33_2:
        mov	rcx, qword ptr [rax]
        test	rcx, rcx
        je	.LBB33_7
        mov	rdi, rax
        mov	rax, rcx
        cmp	rcx, rsi
        jne	.LBB33_2
.LBB33_4:
        mov	rax, qword ptr [rsi]
        mov	qword ptr [rdi], rax
        mov	al, 1
        jmp	.LBB33_8
.LBB33_5:
        xor	eax, eax
        ret
.LBB33_7:
        xor	eax, eax
.LBB33_8:
        pop	rbp
        ret

debug.panic__anon_4227:
        push	rbp
        mov	rbp, rsp
        call	debug.panicExtra__anon_4236

"system_data.SystemData(codegen_harness.OtherSystem__struct_2166,meta.FieldEnum(codegen_harness.OtherSystem__struct_2166),.{ .sensor_a = .{ ... }, .sensor_b = .{ ... }, .output = .{ ... } },testing.create.Components).writeAndPublish":
        push	rbp
        mov	rbp, rsp
        push	r15
        push	r14
        push	rbx
        push	rax
        mov	rbx, rdx
        mov	r15, rsi
        mov	r14, rdi
        push	4
        pop	rcx
        mov	rdi, rsi
        mov	rsi, rcx
        call	mem.eql__anon_1161
        mov	ecx, dword ptr [rbx]
        mov	dword ptr [r15], ecx
        test	al, 1
        je	.LBB68_2
        add	rsp, 8
        pop	rbx
        pop	r14
        pop	r15
        pop	rbp
        ret
.LBB68_2:
        mov	rdi, r14
        mov	rsi, rbx
        add	rsp, 8
        pop	rbx
        pop	r14
        pop	r15
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.OtherSystem__struct_2166,meta.FieldEnum(codegen_harness.OtherSystem__struct_2166),.{ .sensor_a = .{ ... }, .sensor_b = .{ ... }, .output = .{ ... } },testing.create.Components).publish"

