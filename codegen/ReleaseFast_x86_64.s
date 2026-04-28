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
        mov	rcx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
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
        mov	rcx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
.LBB7_2:
        add	rsp, 16
        pop	rbp
        ret

codegen_runtime_read:
        push	rbp
        mov	rbp, rsp
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).runtime_read"

codegen_runtime_write:
        push	rbp
        mov	rbp, rsp
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).runtime_write"

codegen_runtime_read_two:
        push	rbp
        mov	rbp, rsp
        push	r15
        push	r14
        push	rbx
        push	rax
        mov	rbx, r8
        mov	r14d, ecx
        mov	r15, rdi
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).runtime_read"
        mov	rdi, r15
        mov	esi, r14d
        mov	rdx, rbx
        add	rsp, 8
        pop	rbx
        pop	r14
        pop	r15
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).runtime_read"

codegen_runtime_write_two:
        push	rbp
        mov	rbp, rsp
        push	r15
        push	r14
        push	rbx
        push	rax
        mov	rbx, r8
        mov	r14d, ecx
        mov	r15, rdi
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).runtime_write"
        mov	rdi, r15
        mov	esi, r14d
        mov	rdx, rbx
        add	rsp, 8
        pop	rbx
        pop	r14
        pop	r15
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).runtime_write"

codegen_runtime_write_three:
        push	rbp
        mov	rbp, rsp
        push	r15
        push	r14
        push	r13
        push	r12
        push	rbx
        push	rax
        mov	ebx, r9d
        mov	r14, r8
        mov	r15d, ecx
        mov	r12, rdi
        mov	r13, qword ptr [rbp + 16]
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).runtime_write"
        mov	rdi, r12
        mov	esi, r15d
        mov	rdx, r14
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).runtime_write"
        mov	rdi, r12
        mov	esi, ebx
        mov	rdx, r13
        add	rsp, 8
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).runtime_write"

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
        je	.LBB21_2
        lea	rsi, [rbp - 8]
        mov	rdx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..32]).publish"
.LBB21_2:
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
        jne	.LBB28_6
        cmp	r9, qword ptr [rsi + 8]
        jne	.LBB28_6
        cmp	r8d, dword ptr [rsi + 16]
        jne	.LBB28_6
        cmp	dx, word ptr [rsi + 20]
        jne	.LBB28_6
        cmp	cl, byte ptr [rsi + 22]
        jne	.LBB28_6
        and	al, 1
        cmp	byte ptr [rsi + 23], al
        je	.LBB28_7
.LBB28_6:
        lea	rsi, [rbp - 32]
        mov	rdx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
.LBB28_7:
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
        mov	rdx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
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
        je	.LBB32_11
        test	rcx, rcx
        je	.LBB32_5
        mov	r8, rsi
        cmp	rcx, rax
        je	.LBB32_10
.LBB32_3:
        mov	r9, qword ptr [rcx]
        test	r9, r9
        je	.LBB32_5
        mov	r8, rcx
        mov	rcx, r9
        cmp	r9, rax
        jne	.LBB32_3
        jmp	.LBB32_10
.LBB32_5:
        mov	rcx, qword ptr [rsi + 8]
        test	rcx, rcx
        je	.LBB32_11
        cmp	rcx, rax
        je	.LBB32_9
.LBB32_7:
        mov	r9, qword ptr [rcx]
        test	r9, r9
        je	.LBB32_11
        mov	r8, rcx
        mov	rcx, r9
        cmp	r9, rax
        jne	.LBB32_7
        jmp	.LBB32_10
.LBB32_9:
        lea	r8, [rsi + 8]
.LBB32_10:
        mov	rcx, qword ptr [rax]
        mov	qword ptr [r8], rcx
.LBB32_11:
        mov	qword ptr [rdx + 8], offset codegen_harness.timer_callback_read_write
        mov	dword ptr [rdx + 28], 100
        or	rdi, 1
        mov	qword ptr [rdx], rdi
        mov	edi, dword ptr [rsi + 16]
        lea	ecx, [rdi + 100]
        mov	dword ptr [rdx + 24], ecx
        mov	rcx, qword ptr [rsi]
        test	rcx, rcx
        je	.LBB32_17
        mov	edx, dword ptr [rcx + 8]
        sub	edx, edi
        add	edx, -101
        cmp	edx, -65636
        jb	.LBB32_15
.LBB32_13:
        mov	rsi, rcx
        mov	rcx, qword ptr [rcx]
        test	rcx, rcx
        je	.LBB32_17
        mov	edx, dword ptr [rcx + 8]
        sub	edx, edi
        add	edx, 65535
        cmp	edx, 65636
        jb	.LBB32_13
.LBB32_15:
        mov	qword ptr [rax], rcx
        mov	qword ptr [rsi], rax
        pop	rbp
        ret
.LBB32_17:
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
        je	.LBB37_2
        lea	rdx, [rbp - 17]
        mov	rbx, rdi
        mov	esi, 1
        mov	rcx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
        mov	eax, dword ptr [rbx]
.LBB37_2:
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
        je	.LBB39_3
        test	rax, rax
        jne	.LBB39_4
        mov	qword ptr [rdi + 16], 0
        mov	qword ptr [rdi + 24], offset codegen_harness.accumulate_callback
.LBB39_3:
        ret
.LBB39_4:
        push	rbp
        mov	rbp, rsp
        call	debug.defaultPanic

codegen_harness.accumulate_callback:
        push	rbp
        mov	rbp, rsp
        mov	rax, qword ptr [rsi]
        cmp	byte ptr [rax], 0
        je	.LBB40_2
        add	dword ptr [rdx], 1
.LBB40_2:
        pop	rbp
        ret

codegen_write_triggering_callback:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	byte ptr [rbp - 1], 1
        cmp	byte ptr [rdi + 4], 1
        mov	byte ptr [rdi + 4], 1
        je	.LBB133_2
        lea	rdx, [rbp - 1]
        mov	esi, 1
        mov	rcx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
.LBB133_2:
        add	rsp, 16
        pop	rbp
        ret

codegen_increment_n_times:
        push	rbp
        mov	rbp, rsp
        test	esi, esi
        je	.LBB134_2
        add	dword ptr [rdi], esi
.LBB134_2:
        pop	rbp
        ret

codegen_conditional_write_chain:
        push	rbp
        mov	rbp, rsp
        test	byte ptr [rdi + 4], 1
        jne	.LBB135_4
        cmp	word ptr [rdi + 5], 100
        ja	.LBB135_2
.LBB135_3:
        pop	rbp
        ret
.LBB135_4:
        add	dword ptr [rdi], 10
        cmp	word ptr [rdi + 5], 100
        jbe	.LBB135_3
.LBB135_2:
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
        je	.LBB136_2
        lea	rdx, [rbp - 2]
        mov	esi, 3
        mov	rcx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
.LBB136_2:
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
        je	.LBB139_2
        mov	rdx, rsi
        lea	rsi, [rbp - 4]
        mov	rdi, rdx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish.2"
.LBB139_2:
        add	rsp, 16
        pop	rbp
        ret

codegen_double_write_same_value:
        push	rbp
        mov	rbp, rsp
        push	rbx
        push	rax
        mov	rbx, rdi
        mov	byte ptr [rbp - 9], 1
        mov	al, 1
        cmp	byte ptr [rdi + 4], 1
        mov	byte ptr [rdi + 4], 1
        jne	.LBB141_1
        mov	byte ptr [rbp - 10], 1
        mov	byte ptr [rbx + 4], 1
        cmp	al, 1
        jne	.LBB141_3
.LBB141_4:
        add	rsp, 8
        pop	rbx
        pop	rbp
        ret
.LBB141_1:
        lea	rdx, [rbp - 9]
        mov	rdi, rbx
        mov	esi, 1
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
        movzx	eax, byte ptr [rbx + 4]
        mov	byte ptr [rbp - 10], 1
        mov	byte ptr [rbx + 4], 1
        cmp	al, 1
        je	.LBB141_4
.LBB141_3:
        lea	rdx, [rbp - 10]
        mov	rdi, rbx
        mov	esi, 1
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
        add	rsp, 8
        pop	rbx
        pop	rbp
        ret

codegen_double_write_diff_values:
        push	rbp
        mov	rbp, rsp
        push	rbx
        push	rax
        mov	rbx, rdi
        mov	byte ptr [rbp - 9], 1
        mov	al, 1
        cmp	byte ptr [rdi + 4], 1
        mov	byte ptr [rdi + 4], 1
        jne	.LBB142_1
        mov	byte ptr [rbp - 10], 0
        mov	byte ptr [rbx + 4], 0
        cmp	al, 0
        jne	.LBB142_3
.LBB142_4:
        add	rsp, 8
        pop	rbx
        pop	rbp
        ret
.LBB142_1:
        lea	rdx, [rbp - 9]
        mov	rdi, rbx
        mov	esi, 1
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
        movzx	eax, byte ptr [rbx + 4]
        mov	byte ptr [rbp - 10], 0
        mov	byte ptr [rbx + 4], 0
        cmp	al, 0
        je	.LBB142_4
.LBB142_3:
        lea	rdx, [rbp - 10]
        mov	rdi, rbx
        mov	esi, 1
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
        add	rsp, 8
        pop	rbx
        pop	rbp
        ret

codegen_write_junk_read_write:
        push	rbp
        mov	rbp, rsp
        push	rbx
        push	rax
        mov	rbx, rdi
        mov	word ptr [rbp - 12], 1
        cmp	word ptr [rdi + 7], 1
        mov	word ptr [rdi + 7], 1
        jne	.LBB143_2
        mov	word ptr [rbp - 10], 2
        mov	word ptr [rbx + 7], 2
        jmp	.LBB143_3
.LBB143_2:
        lea	rdx, [rbp - 12]
        mov	rdi, rbx
        mov	esi, 3
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
        movzx	eax, word ptr [rbx + 7]
        mov	word ptr [rbp - 10], 2
        mov	word ptr [rbx + 7], 2
        cmp	ax, 2
        je	.LBB143_4
.LBB143_3:
        lea	rdx, [rbp - 10]
        mov	rdi, rbx
        mov	esi, 3
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
.LBB143_4:
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
        jne	.LBB144_3
        mov	word ptr [rbp - 10], 2
        mov	word ptr [rbx + 7], 2
        jmp	.LBB144_2
.LBB144_3:
        lea	rdx, [rbp - 14]
        mov	rdi, rbx
        mov	esi, 3
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
        movzx	eax, word ptr [rbx + 7]
        mov	word ptr [rbp - 10], 2
        mov	word ptr [rbx + 7], 2
        cmp	ax, 2
        jne	.LBB144_2
        mov	word ptr [rbp - 12], 3
        mov	word ptr [rbx + 7], 3
        jmp	.LBB144_5
.LBB144_2:
        lea	rdx, [rbp - 10]
        mov	rdi, rbx
        mov	esi, 3
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
        movzx	eax, word ptr [rbx + 7]
        mov	word ptr [rbp - 12], 3
        mov	word ptr [rbx + 7], 3
        cmp	ax, 3
        je	.LBB144_6
.LBB144_5:
        lea	rdx, [rbp - 12]
        mov	rdi, rbx
        mov	esi, 3
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
.LBB144_6:
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
        mov	rdx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
        movups	xmm0, xmmword ptr [rbx + 264]
        mov	rax, qword ptr [rbx + 256]
        add	rax, 1
        mov	qword ptr [rbp - 40], rax
        movups	xmmword ptr [rbp - 32], xmm0
        mov	qword ptr [rbx + 256], rax
        mov	rdi, rbx
        mov	rsi, r14
        mov	rdx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
        add	rsp, 32
        pop	rbx
        pop	r14
        pop	rbp
        ret

; --- called functions ---

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish":
        push	rbp
        mov	rbp, rsp
        push	r15
        push	r14
        push	r13
        push	r12
        push	rbx
        sub	rsp, 24
        mov	qword ptr [rbp - 48], rcx
        test	esi, 65533
        je	.LBB6_4
        mov	r14, rdx
        movzx	r12d, si
        mov	rax, qword ptr [8*r12 + .L__unnamed_1]
        movzx	ecx, byte ptr [r12 + .L__unnamed_2]
        cmp	cl, 1
        adc	ecx, 0
        movzx	r13d, cl
        shl	r13d, 4
        shl	rax, 4
        lea	r15, [rdi + rax]
        add	r15, 24
        xor	ebx, ebx
        jmp	.LBB6_2
.LBB6_3:
        add	rbx, 16
        cmp	r13, rbx
        je	.LBB6_4
.LBB6_2:
        mov	rax, qword ptr [r15 + rbx]
        test	rax, rax
        je	.LBB6_3
        mov	rdi, qword ptr [r15 + rbx - 8]
        movzx	ecx, word ptr [r12 + r12 + .L__unnamed_3]
        mov	word ptr [rbp - 56], cx
        mov	qword ptr [rbp - 64], r14
        lea	rsi, [rbp - 64]
        mov	rdx, qword ptr [rbp - 48]
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

"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).runtime_read":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 64
        mov	rax, rdx
        movzx	ecx, si
        movzx	ecx, word ptr [rcx + rcx + .L__unnamed_3]
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 16]
        movups	xmm2, xmmword ptr [rdi + 32]
        movups	xmm3, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 16], xmm3
        movaps	xmmword ptr [rbp - 32], xmm2
        movaps	xmmword ptr [rbp - 48], xmm1
        movaps	xmmword ptr [rbp - 64], xmm0
        movzx	edx, word ptr [rcx + rcx + .L__unnamed_4]
        lea	rsi, [rbp - 64]
        add	rsi, qword ptr [8*rcx + .L__unnamed_5]
        mov	rdi, rax
        call	memcpy@PLT
        add	rsp, 64
        pop	rbp
        ret

"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).runtime_write":
        push	rbp
        mov	rbp, rsp
        push	r15
        push	r14
        push	r13
        push	r12
        push	rbx
        push	rax
        mov	r15d, esi
        mov	rbx, rdi
        movzx	eax, r15w
        movzx	r14d, word ptr [rax + rax + .L__unnamed_3]
        movzx	eax, word ptr [r14 + r14 + .L__unnamed_4]
        mov	rdi, qword ptr [8*r14 + .L__unnamed_5]
        add	rdi, rbx
        cmp	rdx, rdi
        je	.LBB11_5
        test	r15w, r15w
        je	.LBB11_5
        movzx	ecx, byte ptr [rdx]
        movzx	esi, byte ptr [rdx + rax - 1]
        mov	r8d, eax
        shr	r8d
        xor	cl, byte ptr [rdi]
        movzx	r9d, byte ptr [rdx + r8]
        xor	sil, byte ptr [rdi + rax - 1]
        or	sil, cl
        xor	r9b, byte ptr [rdi + r8]
        or	r9b, sil
        sete	r13b
        mov	r12, rdx
        mov	rsi, rdx
        mov	rdx, rax
        call	memcpy@PLT
        cmp	r15w, 2
        je	.LBB11_4
        test	r13b, r13b
        jne	.LBB11_4
        mov	rdi, rbx
        mov	esi, r14d
        mov	rdx, r12
        mov	rcx, rbx
        add	rsp, 8
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        jmp	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
.LBB11_5:
        mov	rsi, rdx
        mov	rdx, rax
        add	rsp, 8
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        jmp	memcpy@PLT
.LBB11_4:
        add	rsp, 8
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        ret

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..32]).publish":
        push	rbp
        mov	rbp, rsp
        push	r15
        push	r14
        push	rbx
        sub	rsp, 24
        mov	rbx, rdx
        mov	r14, rsi
        mov	r15, rdi
        mov	rax, qword ptr [rdi + 144]
        test	rax, rax
        je	.LBB22_1
        mov	rdi, qword ptr [r15 + 136]
        mov	word ptr [rbp - 32], 31
        mov	qword ptr [rbp - 40], r14
        lea	rsi, [rbp - 40]
        mov	rdx, rbx
        call	rax
.LBB22_1:
        mov	rax, qword ptr [r15 + 160]
        test	rax, rax
        je	.LBB22_3
        mov	rdi, qword ptr [r15 + 152]
        mov	word ptr [rbp - 32], 31
        mov	qword ptr [rbp - 40], r14
        lea	rsi, [rbp - 40]
        mov	rdx, rbx
        call	rax
.LBB22_3:
        mov	rax, qword ptr [r15 + 176]
        test	rax, rax
        je	.LBB22_5
        mov	rdi, qword ptr [r15 + 168]
        mov	word ptr [rbp - 32], 31
        mov	qword ptr [rbp - 40], r14
        lea	rsi, [rbp - 40]
        mov	rdx, rbx
        call	rax
.LBB22_5:
        add	rsp, 24
        pop	rbx
        pop	r14
        pop	r15
        pop	rbp
        ret

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish":
        mov	rax, qword ptr [rdi + 296]
        test	rax, rax
        je	.LBB29_2
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rdi, qword ptr [rdi + 288]
        mov	word ptr [rbp - 8], 1
        mov	qword ptr [rbp - 16], rsi
        lea	rsi, [rbp - 16]
        call	rax
        add	rsp, 16
        pop	rbp
.LBB29_2:
        ret

debug.defaultPanic:
        push	rbp
        mov	rbp, rsp
        push	r15
        push	r14
        push	r13
        push	r12
        push	rbx
        sub	rsp, 2360
        mov	rax, qword ptr fs:[debug.panic_stage@TPOFF]
        test	rax, rax
        jne	.LBB41_188
        mov	qword ptr fs:[debug.panic_stage@TPOFF], 1
        lock		add	byte ptr [rip + debug.panicking], 1
        cmp	byte ptr fs:[Thread.LinuxThreadImpl.tls_thread_id.1@TPOFF], 1
        jne	.LBB41_5
        mov	eax, dword ptr fs:[Thread.LinuxThreadImpl.tls_thread_id.0@TPOFF]
        cmp	dword ptr [rip + Progress.stderr_mutex+12], eax
        je	.LBB41_6
.LBB41_3:
        lock		bts	dword ptr [rip + Progress.stderr_mutex+8], 0
        jb	.LBB41_165
.LBB41_4:
        mov	dword ptr [rip + Progress.stderr_mutex+12], eax
        mov	eax, 1
        jmp	.LBB41_7
.LBB41_5:
        mov	eax, 186
        #APP
        syscall
        #NO_APP
        mov	dword ptr fs:[Thread.LinuxThreadImpl.tls_thread_id.0@TPOFF], eax
        mov	byte ptr fs:[Thread.LinuxThreadImpl.tls_thread_id.1@TPOFF], 1
        cmp	dword ptr [rip + Progress.stderr_mutex+12], eax
        jne	.LBB41_3
.LBB41_6:
        mov	rax, qword ptr [rip + Progress.stderr_mutex]
        add	rax, 1
.LBB41_7:
        movabs	rbx, -6148914691236517206
        mov	qword ptr [rip + Progress.stderr_mutex], rax
        mov	rax, qword ptr [rip + Progress.stderr_file_writer+8]
        mov	edi, offset Progress.stderr_file_writer+8
        call	qword ptr [rax + 16]
        mov	qword ptr [rip + Progress.stderr_file_writer+16], rbx
        mov	qword ptr [rip + Progress.stderr_file_writer+24], 0
        cmp	byte ptr fs:[Thread.LinuxThreadImpl.tls_thread_id.1@TPOFF], 1
        jne	.LBB41_9
        mov	ebx, dword ptr fs:[Thread.LinuxThreadImpl.tls_thread_id.0@TPOFF]
        jmp	.LBB41_10
.LBB41_9:
        mov	eax, 186
        #APP
        syscall
        #NO_APP
        mov	rbx, rax
        mov	dword ptr fs:[Thread.LinuxThreadImpl.tls_thread_id.0@TPOFF], ebx
        mov	byte ptr fs:[Thread.LinuxThreadImpl.tls_thread_id.1@TPOFF], 1
.LBB41_10:
        mov	rdi, qword ptr [rip + Progress.stderr_file_writer+32]
        xor	r13d, r13d
        lea	r14, [rbp - 2336]
        lea	r15, [rbp - 960]
.LBB41_11:
        lea	rsi, [r13 + __anon_6717]
        mov	r12, r13
        xor	r12, 7
        lea	rax, [r12 + rdi]
        cmp	rax, qword ptr [rip + Progress.stderr_file_writer+24]
        ja	.LBB41_13
        add	rdi, qword ptr [rip + Progress.stderr_file_writer+16]
        mov	rdx, r12
        call	memcpy@PLT
        mov	rdi, qword ptr [rip + Progress.stderr_file_writer+32]
        add	rdi, r12
        mov	qword ptr [rip + Progress.stderr_file_writer+32], rdi
        add	r13, r12
        cmp	r13, 7
        jb	.LBB41_11
        jmp	.LBB41_15
.LBB41_13:
        mov	rax, qword ptr [rip + Progress.stderr_file_writer+8]
        mov	rax, qword ptr [rax]
        mov	qword ptr [rbp - 960], rsi
        mov	qword ptr [rbp - 952], r12
        mov	esi, offset Progress.stderr_file_writer+8
        mov	ecx, 1
        mov	r8d, 1
        mov	rdi, r14
        mov	rdx, r15
        call	rax
        cmp	word ptr [rbp - 2328], 0
        jne	.LBB41_190
        mov	r12, qword ptr [rbp - 2336]
        mov	rdi, qword ptr [rip + Progress.stderr_file_writer+32]
        add	r13, r12
        cmp	r13, 7
        jb	.LBB41_11
.LBB41_15:
        mov	edx, ebx
        mov	eax, 65
        cmp	ebx, 100
        jb	.LBB41_19
.LBB41_16:
        imul	rcx, rdx, 1374389535
        shr	rcx, 37
        imul	esi, ecx, 100
        mov	r8d, edx
        sub	r8d, esi
        movzx	esi, word ptr [r8 + r8 + __anon_16926]
        mov	word ptr [rbp + rax - 2338], si
        add	rax, -2
        cmp	rdx, 9999
        mov	rdx, rcx
        ja	.LBB41_16
        cmp	ecx, 9
        ja	.LBB41_20
.LBB41_18:
        or	cl, 48
        mov	byte ptr [rbp + rax - 2337], cl
        add	rax, -1
        mov	r12, rax
        sub	r12, 65
        je	.LBB41_21
        jmp	.LBB41_45
.LBB41_19:
        mov	rcx, rdx
        cmp	ecx, 9
        jbe	.LBB41_18
.LBB41_20:
        movzx	ecx, word ptr [rcx + rcx + __anon_16926]
        mov	word ptr [rbp + rax - 2338], cx
        add	rax, -2
        mov	r12, rax
        sub	r12, 65
        jne	.LBB41_45
.LBB41_21:
        xor	r12d, r12d
        lea	rbx, [rbp - 2336]
        lea	r14, [rbp - 960]
.LBB41_22:
        lea	rsi, [r12 + __anon_6865]
        mov	r15d, 8
        sub	r15, r12
        lea	rax, [r15 + rdi]
        cmp	rax, qword ptr [rip + Progress.stderr_file_writer+24]
        ja	.LBB41_24
        add	rdi, qword ptr [rip + Progress.stderr_file_writer+16]
        mov	rdx, r15
        call	memcpy@PLT
        mov	rdi, qword ptr [rip + Progress.stderr_file_writer+32]
        add	rdi, r15
        mov	qword ptr [rip + Progress.stderr_file_writer+32], rdi
        add	r12, r15
        cmp	r12, 8
        jb	.LBB41_22
        jmp	.LBB41_26
.LBB41_24:
        mov	rax, qword ptr [rip + Progress.stderr_file_writer+8]
        mov	rax, qword ptr [rax]
        mov	qword ptr [rbp - 960], rsi
        mov	qword ptr [rbp - 952], r15
        mov	esi, offset Progress.stderr_file_writer+8
        mov	ecx, 1
        mov	r8d, 1
        mov	rdi, rbx
        mov	rdx, r14
        call	rax
        cmp	word ptr [rbp - 2328], 0
        jne	.LBB41_190
        mov	r15, qword ptr [rbp - 2336]
        mov	rdi, qword ptr [rip + Progress.stderr_file_writer+32]
        add	r12, r15
        cmp	r12, 8
        jb	.LBB41_22
.LBB41_26:
        xor	r12d, r12d
        lea	rbx, [rbp - 2336]
        lea	r14, [rbp - 960]
.LBB41_27:
        lea	rsi, [r12 + __anon_4295]
        mov	r15d, 23
        sub	r15, r12
        lea	rax, [rdi + r15]
        cmp	rax, qword ptr [rip + Progress.stderr_file_writer+24]
        ja	.LBB41_29
        add	rdi, qword ptr [rip + Progress.stderr_file_writer+16]
        mov	rdx, r15
        call	memcpy@PLT
        mov	rdi, qword ptr [rip + Progress.stderr_file_writer+32]
        add	rdi, r15
        mov	qword ptr [rip + Progress.stderr_file_writer+32], rdi
        add	r12, r15
        cmp	r12, 23
        jb	.LBB41_27
        jmp	.LBB41_31
.LBB41_29:
        mov	rax, qword ptr [rip + Progress.stderr_file_writer+8]
        mov	rax, qword ptr [rax]
        mov	qword ptr [rbp - 960], rsi
        mov	qword ptr [rbp - 952], r15
        mov	esi, offset Progress.stderr_file_writer+8
        mov	ecx, 1
        mov	r8d, 1
        mov	rdi, rbx
        mov	rdx, r14
        call	rax
        cmp	word ptr [rbp - 2328], 0
        jne	.LBB41_190
        mov	r15, qword ptr [rbp - 2336]
        mov	rdi, qword ptr [rip + Progress.stderr_file_writer+32]
        add	r12, r15
        cmp	r12, 23
        jb	.LBB41_27
.LBB41_31:
        lea	r14, [rbp - 2336]
        lea	rbx, [rbp - 960]
.LBB41_32:
        mov	rax, qword ptr [rip + Progress.stderr_file_writer+32]
        cmp	rax, qword ptr [rip + Progress.stderr_file_writer+24]
        jb	.LBB41_35
        mov	rax, qword ptr [rip + Progress.stderr_file_writer+8]
        mov	rax, qword ptr [rax]
        mov	qword ptr [rbp - 960], offset __anon_7066
        mov	qword ptr [rbp - 952], 1
        mov	esi, offset Progress.stderr_file_writer+8
        mov	ecx, 1
        mov	r8d, 1
        mov	rdi, r14
        mov	rdx, rbx
        call	rax
        cmp	word ptr [rbp - 2328], 0
        jne	.LBB41_190
        cmp	qword ptr [rbp - 2336], 0
        je	.LBB41_32
        jmp	.LBB41_36
.LBB41_35:
        mov	rcx, qword ptr [rip + Progress.stderr_file_writer+16]
        mov	byte ptr [rcx + rax], 10
        add	qword ptr [rip + Progress.stderr_file_writer+32], 1
.LBB41_36:
        mov	r12, qword ptr [rbp + 8]
        cmp	byte ptr [rip + debug.self_debug_info+48], 0
        jne	.LBB41_40
        cmp	byte ptr [rip + debug.debug_info_allocator.2], 0
        jne	.LBB41_39
        movdqu	xmm0, xmmword ptr [rip + .L__unnamed_6]
        movdqa	xmmword ptr [rbp - 2336], xmm0
        pxor	xmm1, xmm1
        movdqa	xmmword ptr [rbp - 2320], xmm1
        movdqu	xmmword ptr [rip + debug.debug_info_arena_allocator], xmm0
        movdqu	xmmword ptr [rip + debug.debug_info_arena_allocator+16], xmm1
        mov	byte ptr [rip + debug.debug_info_allocator.2], 1
.LBB41_39:
        mov	qword ptr [rip + debug.self_debug_info], offset debug.debug_info_arena_allocator
        mov	qword ptr [rip + debug.self_debug_info+8], offset __anon_10090
        pxor	xmm0, xmm0
        movdqu	xmmword ptr [rip + debug.self_debug_info+16], xmm0
        mov	qword ptr [rip + debug.self_debug_info+32], offset debug.debug_info_arena_allocator
        mov	qword ptr [rip + debug.self_debug_info+40], offset __anon_10090
        mov	byte ptr [rip + debug.self_debug_info+48], 1
.LBB41_40:
        lea	rdx, [rbp - 2336]
        xor	r8d, r8d
        mov	edi, 2
        mov	esi, 21523
.LBB41_41:
        mov	eax, 16
        #APP
        syscall
        #NO_APP
        mov	ecx, eax
        neg	ecx
        cmp	rax, -4095
        cmovb	ecx, r8d
        cmp	cx, 4
        je	.LBB41_41
        movzx	eax, cx
        test	eax, eax
        jne	.LBB41_50
        mov	ecx, offset __anon_16955
        mov	eax, offset __anon_16955
        and	eax, 4095
        cmp	eax, 4081
        jae	.LBB41_177
.LBB41_44:
        mov	r14b, 1
        jmp	.LBB41_51
.LBB41_45:
        neg	r12
        lea	r13, [rax + rbp]
        add	r13, -2336
        xor	ebx, ebx
        lea	r14, [rbp - 1392]
.LBB41_46:
        lea	rsi, [rbx + r13]
        mov	r15, r12
        sub	r15, rbx
        lea	rax, [rdi + r15]
        cmp	rax, qword ptr [rip + Progress.stderr_file_writer+24]
        ja	.LBB41_48
        add	rdi, qword ptr [rip + Progress.stderr_file_writer+16]
        mov	rdx, r15
        call	memcpy@PLT
        mov	rdi, qword ptr [rip + Progress.stderr_file_writer+32]
        add	rdi, r15
        mov	qword ptr [rip + Progress.stderr_file_writer+32], rdi
        add	rbx, r15
        cmp	rbx, r12
        jb	.LBB41_46
        jmp	.LBB41_21
.LBB41_48:
        mov	rax, qword ptr [rip + Progress.stderr_file_writer+8]
        mov	rax, qword ptr [rax]
        mov	qword ptr [rbp - 1392], rsi
        mov	qword ptr [rbp - 1384], r15
        mov	esi, offset Progress.stderr_file_writer+8
        mov	ecx, 1
        mov	r8d, 1
        lea	rdi, [rbp - 960]
        mov	rdx, r14
        call	rax
        cmp	word ptr [rbp - 952], 0
        jne	.LBB41_190
        mov	r15, qword ptr [rbp - 960]
        mov	rdi, qword ptr [rip + Progress.stderr_file_writer+32]
        add	rbx, r15
        cmp	rbx, r12
        jb	.LBB41_46
        jmp	.LBB41_21
.LBB41_50:
        xor	r14d, r14d
.LBB41_51:
        lea	rdi, [rbp - 2336]
        #APP
        call	os.linux.x86_64.getContextInternal
        #NO_APP
        test	rax, rax
        mov	qword ptr [rbp - 96], r12
        je	.LBB41_53
.LBB41_52:
        mov	qword ptr [rbp - 1392], r12
        mov	byte ptr [rbp - 1384], 1
        mov	eax, dword ptr [rbp - 87]
        mov	ecx, dword ptr [rbp - 84]
        mov	dword ptr [rbp - 1383], eax
        mov	dword ptr [rbp - 1380], ecx
        mov	qword ptr [rbp - 1376], rbp
        lea	rdi, [rbp - 1368]
        mov	edx, 288
        xor	esi, esi
        call	memset@PLT
        mov	dword ptr [rbp - 1080], -1
        lea	rbx, [rbp - 1392]
        jmp	.LBB41_55
.LBB41_53:
        mov	rdi, qword ptr [rip + debug.self_debug_info]
        mov	rax, qword ptr [rip + debug.self_debug_info+8]
        mov	r15, qword ptr [rbp - 2168]
        mov	esi, 936
        mov	edx, 3
        mov	rcx, r12
        call	qword ptr [rax]
        test	rax, rax
        je	.LBB41_52
        lea	rsi, [rbp - 2336]
        mov	edx, 936
        mov	rdi, rax
        mov	r13, r12
        mov	r12, rax
        call	memcpy@PLT
        movups	xmm0, xmmword ptr [rip + debug.self_debug_info]
        pxor	xmm1, xmm1
        mov	byte ptr [rbp - 176], 0
        mov	qword ptr [rbp - 960], r13
        mov	byte ptr [rbp - 952], 1
        mov	eax, dword ptr [rbp - 87]
        mov	ecx, dword ptr [rbp - 84]
        mov	dword ptr [rbp - 951], eax
        mov	dword ptr [rbp - 948], ecx
        movdqu	xmmword ptr [rbp - 912], xmm1
        movups	xmmword ptr [rbp - 928], xmm0
        mov	dword ptr [rbp - 661], 0
        mov	byte ptr [rbp - 657], 0
        mov	qword ptr [rbp - 944], rbp
        mov	qword ptr [rbp - 936], offset debug.self_debug_info
        mov	qword ptr [rbp - 896], r15
        mov	qword ptr [rbp - 888], r12
        lea	rdi, [rbp - 880]
        mov	esi, offset .L__unnamed_7
        mov	edx, 184
        call	memcpy@PLT
        movdqu	xmm0, xmmword ptr [rip + .L__unnamed_8]
        movdqu	xmmword ptr [rbp - 696], xmm0
        mov	qword ptr [rbp - 680], 0
        mov	word ptr [rbp - 664], 0
        mov	byte ptr [rbp - 662], 0
        mov	byte ptr [rbp - 656], 1
        mov	byte ptr [rbp - 649], 0
        mov	word ptr [rbp - 651], 0
        mov	dword ptr [rbp - 655], 0
        mov	dword ptr [rbp - 648], -1
        mov	byte ptr [rbp - 640], 1
.LBB41_55:
        lea	rdi, [rbp - 608]
        mov	edx, 320
        mov	rsi, rbx
        call	memcpy@PLT
        lea	r13, [rbp - 296]
        lea	r12, [rbp - 256]
        movzx	eax, r14b
        mov	dword ptr [rbp - 44], eax
.LBB41_56:
        cmp	byte ptr [rbp - 304], 0
        je	.LBB41_62
        cmp	byte ptr [rbp - 310], 0
        jne	.LBB41_62
        mov	rdx, qword ptr [rbp - 544]
        test	rdx, rdx
        je	.LBB41_143
        mov	rsi, qword ptr [rbp - 584]
        lea	rdi, [rbp - 176]
        call	debug.SelfInfo.getModuleForAddress
        movzx	eax, word ptr [rbp - 168]
        test	ax, ax
        jne	.LBB41_61
        mov	rdx, qword ptr [rbp - 176]
        mov	rsi, qword ptr [rbp - 584]
        mov	rcx, qword ptr [rdx]
        add	rdx, 8
        mov	rdi, r12
        lea	r8, [rbp - 576]
        mov	r9, r13
        call	debug.SelfInfo.unwindFrameDwarf
        movzx	eax, word ptr [rbp - 248]
        test	ax, ax
        je	.LBB41_108
.LBB41_61:
        mov	word ptr [rbp - 312], ax
        mov	byte ptr [rbp - 310], 1
        mov	rax, qword ptr [rbp - 536]
        mov	rax, qword ptr [rax + 120]
        mov	qword ptr [rbp - 592], rax
.LBB41_62:
        xor	eax, eax
        test	al, al
        jne	.LBB41_143
        mov	r14, qword ptr [rbp - 592]
        test	r14, r14
        je	.LBB41_143
        mov	eax, r14d
        and	eax, 7
        jne	.LBB41_143
        mov	ecx, 8
        mov	rdi, r13
        mov	rsi, r14
        mov	rdx, r12
        call	debug.MemoryAccessor.read
        test	al, 1
        je	.LBB41_143
        xor	eax, eax
        test	al, al
        jne	.LBB41_143
        mov	rbx, qword ptr [rbp - 256]
        test	rbx, rbx
        je	.LBB41_69
        cmp	rbx, qword ptr [rbp - 592]
        jb	.LBB41_143
.LBB41_69:
        add	r14, 8
        setb	byte ptr [rbp - 256]
        jb	.LBB41_143
        mov	ecx, 8
        mov	rdi, r13
        mov	rsi, r14
        mov	rdx, r12
        call	debug.MemoryAccessor.read
        test	al, 1
        je	.LBB41_143
        mov	r13, qword ptr [rbp - 256]
        mov	qword ptr [rbp - 592], rbx
        cmp	byte ptr [rbp - 600], 0
        je	.LBB41_74
.LBB41_72:
        mov	r14, qword ptr [rbp - 608]
        cmp	r13, r14
        jne	.LBB41_89
.LBB41_73:
        pxor	xmm0, xmm0
        movdqa	xmmword ptr [rbp - 608], xmm0
.LBB41_74:
        lea	rdi, [rbp - 608]
        mov	esi, dword ptr [rbp - 44]
        call	debug.printLastUnwindError
        sub	r13, 1
        mov	r15d, 0
        cmovae	r15, r13
        mov	esi, offset debug.self_debug_info
        lea	rdi, [rbp - 272]
        mov	rdx, r15
        call	debug.SelfInfo.getModuleForAddress
        movzx	r14d, word ptr [rbp - 264]
        cmp	r14d, 33
        je	.LBB41_87
        cmp	r14d, 24
        je	.LBB41_87
        test	r14d, r14d
        lea	r13, [rbp - 296]
        jne	.LBB41_88
        mov	r13, qword ptr [rbp - 272]
        mov	rbx, r15
        sub	rbx, qword ptr [r13]
        lea	rsi, [r13 + 8]
        lea	rdi, [rbp - 288]
        mov	r12, rsi
        mov	rdx, rbx
        call	debug.Dwarf.findCompileUnit
        movzx	r14d, word ptr [rbp - 280]
        mov	r8d, offset __anon_6330
        mov	r9d, 3
        mov	eax, offset .L__unnamed_9+32
        mov	ecx, 3
        mov	edx, offset __anon_6330
        cmp	r14d, 33
        je	.LBB41_133
        cmp	r14d, 24
        je	.LBB41_133
        test	r14d, r14d
        jne	.LBB41_139
        mov	rax, qword ptr [r13 + 736]
        test	rax, rax
        je	.LBB41_110
        mov	rcx, qword ptr [r13 + 728]
        add	rcx, 32
        mov	r14, r12
        lea	r12, [rbp - 256]
        jmp	.LBB41_83
.LBB41_82:
        add	rcx, 40
        add	rax, -1
        je	.LBB41_109
.LBB41_83:
        cmp	byte ptr [rcx - 16], 0
        je	.LBB41_82
        cmp	rbx, qword ptr [rcx - 32]
        jb	.LBB41_82
        cmp	rbx, qword ptr [rcx - 24]
        jae	.LBB41_82
        mov	rdx, qword ptr [rcx - 8]
        mov	rcx, qword ptr [rcx]
        jmp	.LBB41_111
.LBB41_87:
        mov	rdi, r15
        call	debug.SelfInfo.getModuleNameForAddress
        mov	r9, rdx
        test	rax, rax
        mov	ecx, offset __anon_6330
        cmove	rax, rcx
        mov	ecx, 3
        cmove	r9, rcx
        mov	ecx, dword ptr [rbp - 44]
        mov	dword ptr [rsp], ecx
        mov	edi, offset .L__unnamed_10
        mov	edx, offset __anon_6330
        mov	ecx, 3
        mov	rsi, r15
        mov	r8, rax
        call	debug.printLineInfo__anon_6474
        mov	r14d, eax
        lea	r13, [rbp - 296]
.LBB41_88:
        test	r14w, r14w
        je	.LBB41_56
        jmp	.LBB41_166
.LBB41_89:
        lea	r13, [rbp - 296]
.LBB41_90:
        cmp	byte ptr [rbp - 304], 0
        je	.LBB41_96
        cmp	byte ptr [rbp - 310], 0
        jne	.LBB41_96
        mov	rdx, qword ptr [rbp - 544]
        test	rdx, rdx
        je	.LBB41_143
        mov	rsi, qword ptr [rbp - 584]
        lea	rdi, [rbp - 176]
        call	debug.SelfInfo.getModuleForAddress
        movzx	eax, word ptr [rbp - 168]
        test	ax, ax
        jne	.LBB41_95
        mov	rdx, qword ptr [rbp - 176]
        mov	rsi, qword ptr [rbp - 584]
        mov	rcx, qword ptr [rdx]
        add	rdx, 8
        mov	rdi, r12
        lea	r8, [rbp - 576]
        mov	r9, r13
        call	debug.SelfInfo.unwindFrameDwarf
        movzx	eax, word ptr [rbp - 248]
        test	ax, ax
        je	.LBB41_106
.LBB41_95:
        mov	word ptr [rbp - 312], ax
        mov	byte ptr [rbp - 310], 1
        mov	rax, qword ptr [rbp - 536]
        mov	rbx, qword ptr [rax + 120]
        mov	qword ptr [rbp - 592], rbx
.LBB41_96:
        xor	eax, eax
        test	al, al
        jne	.LBB41_143
        test	rbx, rbx
        je	.LBB41_143
        mov	eax, ebx
        and	eax, 7
        jne	.LBB41_143
        mov	ecx, 8
        mov	rdi, r13
        mov	rsi, rbx
        mov	rdx, r12
        call	debug.MemoryAccessor.read
        test	al, 1
        je	.LBB41_143
        xor	eax, eax
        test	al, al
        jne	.LBB41_143
        mov	r15, qword ptr [rbp - 256]
        test	r15, r15
        je	.LBB41_103
        cmp	r15, qword ptr [rbp - 592]
        jb	.LBB41_143
.LBB41_103:
        add	rbx, 8
        setb	byte ptr [rbp - 256]
        jb	.LBB41_143
        mov	ecx, 8
        mov	rdi, r13
        mov	rsi, rbx
        mov	rdx, r12
        call	debug.MemoryAccessor.read
        test	al, 1
        je	.LBB41_143
        mov	rax, qword ptr [rbp - 256]
        mov	qword ptr [rbp - 592], r15
        mov	rbx, r15
        cmp	rax, r14
        jne	.LBB41_90
        jmp	.LBB41_107
.LBB41_106:
        mov	rax, qword ptr [rbp - 256]
        mov	rcx, qword ptr [rbp - 536]
        mov	r15, qword ptr [rcx + 120]
        mov	qword ptr [rbp - 592], r15
        mov	rbx, r15
        cmp	rax, r14
        jne	.LBB41_90
.LBB41_107:
        mov	r13, r14
        jmp	.LBB41_73
.LBB41_108:
        mov	r13, qword ptr [rbp - 256]
        mov	rax, qword ptr [rbp - 536]
        mov	rbx, qword ptr [rax + 120]
        mov	qword ptr [rbp - 592], rbx
        cmp	byte ptr [rbp - 600], 0
        jne	.LBB41_72
        jmp	.LBB41_74
.LBB41_109:
        xor	edx, edx
        xor	ecx, ecx
        jmp	.LBB41_111
.LBB41_110:
        xor	edx, edx
        xor	ecx, ecx
        mov	r14, r12
        lea	r12, [rbp - 256]
.LBB41_111:
        test	rdx, rdx
        mov	eax, offset __anon_6330
        cmove	rdx, rax
        mov	eax, 3
        cmove	rcx, rax
        cmp	byte ptr [r13 + 144], 0
        mov	qword ptr [rbp - 80], rcx
        mov	qword ptr [rbp - 72], rdx
        je	.LBB41_113
        mov	qword ptr [rbp - 56], rax
        mov	eax, offset __anon_6330
        mov	qword ptr [rbp - 64], rax
        mov	r9, qword ptr [r13 + 104]
        mov	rax, qword ptr [r13 + 112]
        jmp	.LBB41_114
.LBB41_113:
        mov	qword ptr [rbp - 56], rax
        mov	eax, offset __anon_6330
        mov	qword ptr [rbp - 64], rax
        xor	r9d, r9d
        xor	eax, eax
.LBB41_114:
        mov	r13, qword ptr [rbp - 288]
        mov	rsi, qword ptr [r13 + 8]
        mov	rdx, qword ptr [r13 + 16]
        mov	qword ptr [rsp + 8], r13
        mov	qword ptr [rsp], rax
        mov	r8d, 3
        lea	rdi, [rbp - 632]
        mov	rcx, r14
        call	debug.Dwarf.Die.getAttrString
        cmp	word ptr [rbp - 616], 0
        jne	.LBB41_116
        mov	rax, qword ptr [rbp - 632]
        mov	qword ptr [rbp - 64], rax
        mov	rax, qword ptr [rbp - 624]
        mov	qword ptr [rbp - 56], rax
.LBB41_116:
        cmp	byte ptr [r13 + 168], 0
        jne	.LBB41_119
        mov	rdi, r12
        mov	rsi, r14
        mov	rdx, r13
        call	debug.Dwarf.runLineNumberProgram
        movzx	r14d, word ptr [rbp - 184]
        test	r14w, r14w
        jne	.LBB41_137
        lea	rax, [r13 + 96]
        mov	rcx, qword ptr [rbp - 192]
        mov	qword ptr [rax + 64], rcx
        movdqa	xmm0, xmmword ptr [rbp - 256]
        movdqa	xmm1, xmmword ptr [rbp - 240]
        movdqa	xmm2, xmmword ptr [rbp - 224]
        movaps	xmm3, xmmword ptr [rbp - 208]
        movups	xmmword ptr [rax + 48], xmm3
        movdqu	xmmword ptr [rax + 32], xmm2
        movdqu	xmmword ptr [rax + 16], xmm1
        movdqu	xmmword ptr [rax], xmm0
        mov	byte ptr [r13 + 168], 1
.LBB41_119:
        mov	rax, qword ptr [r13 + 96]
        mov	rdx, qword ptr [r13 + 104]
        mov	rcx, qword ptr [r13 + 112]
        test	rcx, rcx
        mov	rsi, rax
        movabs	rdi, -6148914691236517206
        cmove	rsi, rdi
        sete	dil
        test	rdx, rdx
        sete	r8b
        or	r8b, dil
        jne	.LBB41_131
        xor	edi, edi
        jmp	.LBB41_122
.LBB41_121:
        add	rdi, r8
        add	rdi, 1
        cmp	rdi, rdx
        jae	.LBB41_126
.LBB41_122:
        mov	r8, rdx
        sub	r8, rdi
        shr	r8
        lea	r9, [r8 + rdi]
        xor	r10d, r10d
        mov	r11d, 2
        cmp	rbx, qword ptr [rsi + 8*r9]
        setb	r14b
        je	.LBB41_124
        mov	r10b, r14b
        mov	r11d, r10d
.LBB41_124:
        cmp	r11b, 1
        jne	.LBB41_121
        mov	rdx, r9
        cmp	rdi, rdx
        jb	.LBB41_122
.LBB41_126:
        test	rdi, rdi
        je	.LBB41_131
        lea	rax, [rax + 8*rcx]
        lea	rcx, [rdi + 2*rdi]
        mov	esi, dword ptr [rax + 4*rcx - 4]
        cmp	word ptr [r13 + 160], 5
        sbb	esi, 0
        cmp	qword ptr [r13 + 152], rsi
        jbe	.LBB41_131
        mov	rdx, qword ptr [r13 + 144]
        imul	rdi, rsi, 56
        mov	esi, dword ptr [rdx + rdi + 32]
        cmp	qword ptr [r13 + 136], rsi
        jbe	.LBB41_131
        movsd	xmm0, qword ptr [rax + 4*rcx - 12]
        movaps	xmmword ptr [rbp - 976], xmm0
        add	rdx, rdi
        mov	rax, qword ptr [r13 + 128]
        imul	rcx, rsi, 56
        movdqu	xmm0, xmmword ptr [rax + rcx]
        movdqu	xmm1, xmmword ptr [rdx]
        movdqu	xmmword ptr [rbp - 1072], xmm0
        movdqu	xmmword ptr [rbp - 1056], xmm1
        mov	rsi, qword ptr [rip + debug.self_debug_info]
        mov	rdx, qword ptr [rip + debug.self_debug_info+8]
        mov	r8d, 2
        lea	rdi, [rbp - 1000]
        lea	rcx, [rbp - 1072]
        call	fs.path.join
        movzx	r14d, word ptr [rbp - 984]
        test	r14w, r14w
        jne	.LBB41_137
        movdqu	xmm0, xmmword ptr [rbp - 1000]
        movdqa	xmm1, xmmword ptr [rbp - 976]
        punpckldq	xmm1, xmmword ptr [rip + .LCPI41_3]
        movdqa	xmmword ptr [rbp - 1040], xmm1
        movdqa	xmmword ptr [rbp - 1024], xmm0
        mov	byte ptr [rbp - 1008], 1
        lea	rax, [rbp - 1040]
        jmp	.LBB41_132
.LBB41_131:
        mov	eax, offset .L__unnamed_10
.LBB41_132:
        mov	r8, qword ptr [rbp - 64]
        mov	r9, qword ptr [rbp - 56]
        mov	rcx, qword ptr [rbp - 80]
        mov	rdx, qword ptr [rbp - 72]
.LBB41_133:
        mov	rsi, rdx
        mov	rdx, rcx
        mov	rcx, qword ptr [rax + 32]
        lea	rdi, [rbp - 144]
        mov	qword ptr [rdi + 32], rcx
        mov	rcx, rdx
        mov	rdx, rsi
        movdqu	xmm0, xmmword ptr [rax]
        movdqu	xmm1, xmmword ptr [rax + 16]
        movdqu	xmmword ptr [rdi + 16], xmm1
        movdqu	xmmword ptr [rdi], xmm0
        mov	qword ptr [rbp - 176], rsi
        mov	qword ptr [rbp - 168], rcx
        mov	qword ptr [rbp - 160], r8
        mov	qword ptr [rbp - 152], r9
        mov	word ptr [rbp - 104], 0
        mov	word ptr [rdi + 46], 0
        mov	dword ptr [rdi + 42], 0
.LBB41_134:
        mov	eax, dword ptr [rbp - 44]
        mov	dword ptr [rsp], eax
        mov	rsi, r15
        call	debug.printLineInfo__anon_6474
        mov	r14d, eax
        cmp	byte ptr [rbp - 112], 0
        lea	r13, [rbp - 296]
        lea	r12, [rbp - 256]
        je	.LBB41_88
        mov	rdx, qword ptr [rbp - 120]
        test	rdx, rdx
        je	.LBB41_88
        mov	rax, qword ptr [rip + debug.self_debug_info+8]
        mov	rdi, qword ptr [rip + debug.self_debug_info]
        mov	rsi, qword ptr [rbp - 128]
        xor	ecx, ecx
        mov	r8, qword ptr [rbp - 96]
        call	qword ptr [rax + 24]
        jmp	.LBB41_88
.LBB41_137:
        mov	eax, offset .L__unnamed_10
        cmp	r14w, 33
        je	.LBB41_132
        movzx	ecx, r14w
        cmp	ecx, 24
        mov	r8, qword ptr [rbp - 64]
        mov	r9, qword ptr [rbp - 56]
        mov	rcx, qword ptr [rbp - 80]
        mov	rdx, qword ptr [rbp - 72]
        je	.LBB41_133
.LBB41_139:
        mov	qword ptr [rbp - 176], rdx
        mov	qword ptr [rbp - 168], rcx
        mov	qword ptr [rbp - 160], r8
        mov	qword ptr [rbp - 152], r9
        mov	word ptr [rbp - 104], r14w
        lea	rdi, [rbp - 144]
        mov	word ptr [rdi + 46], 0
        mov	dword ptr [rdi + 42], 0
        test	r14w, r14w
        je	.LBB41_134
        movzx	eax, r14w
        cmp	eax, 24
        lea	r13, [rbp - 296]
        lea	r12, [rbp - 256]
        je	.LBB41_142
        cmp	eax, 33
        jne	.LBB41_88
.LBB41_142:
        mov	rdi, r15
        call	debug.SelfInfo.getModuleNameForAddress
        mov	r9, rdx
        test	rax, rax
        mov	ecx, offset __anon_6330
        cmove	rax, rcx
        mov	ecx, 3
        cmove	r9, rcx
        mov	ecx, dword ptr [rbp - 44]
        mov	dword ptr [rsp], ecx
        mov	edi, offset .L__unnamed_10
        mov	edx, offset __anon_6330
        mov	ecx, 3
        mov	rsi, r15
        mov	r8, rax
        call	debug.printLineInfo__anon_6474
        mov	r14d, eax
        jmp	.LBB41_88
.LBB41_143:
        lea	rdi, [rbp - 608]
        mov	esi, dword ptr [rbp - 44]
        call	debug.printLastUnwindError
        movsxd	rdi, dword ptr [rbp - 296]
        cmp	rdi, -3
        ja	.LBB41_145
        mov	eax, 3
        #APP
        syscall
        #NO_APP
.LBB41_145:
        cmp	byte ptr [rbp - 304], 0
        mov	rbx, qword ptr [rbp - 96]
        je	.LBB41_159
        mov	rcx, qword ptr [rbp - 488]
        mov	rdx, rcx
        shl	rdx, 4
        je	.LBB41_150
        mov	rdi, qword ptr [rbp - 576]
        mov	rax, qword ptr [rbp - 568]
        movabs	rsi, -6148914691236517206
        test	rcx, rcx
        je	.LBB41_149
        mov	rsi, qword ptr [rbp - 504]
.LBB41_149:
        mov	ecx, 3
        mov	r8, rbx
        call	qword ptr [rax + 24]
.LBB41_150:
        mov	rcx, qword ptr [rbp - 512]
        mov	rdx, rcx
        shl	rdx, 5
        je	.LBB41_154
        mov	rdi, qword ptr [rbp - 576]
        mov	rax, qword ptr [rbp - 568]
        movabs	rsi, -6148914691236517206
        test	rcx, rcx
        je	.LBB41_153
        mov	rsi, qword ptr [rbp - 528]
.LBB41_153:
        mov	ecx, 3
        mov	r8, rbx
        call	qword ptr [rax + 24]
.LBB41_154:
        mov	rcx, qword ptr [rbp - 328]
        mov	rdx, rcx
        shl	rdx, 5
        je	.LBB41_158
        mov	rdi, qword ptr [rbp - 576]
        mov	rax, qword ptr [rbp - 568]
        movabs	rsi, -6148914691236517206
        test	rcx, rcx
        je	.LBB41_157
        mov	rsi, qword ptr [rbp - 344]
.LBB41_157:
        mov	ecx, 3
        mov	r8, rbx
        call	qword ptr [rax + 24]
.LBB41_158:
        mov	rsi, qword ptr [rbp - 536]
        mov	rdi, qword ptr [rbp - 576]
        mov	rax, qword ptr [rbp - 568]
        mov	edx, 936
        mov	ecx, 3
        mov	r8, rbx
        call	qword ptr [rax + 24]
.LBB41_159:
        mov	rax, qword ptr [rip + Progress.stderr_file_writer+8]
        mov	edi, offset Progress.stderr_file_writer+8
        call	qword ptr [rax + 16]
        movabs	rax, -6148914691236517206
        mov	qword ptr [rip + Progress.stderr_file_writer+16], rax
        pxor	xmm0, xmm0
        movdqu	xmmword ptr [rip + Progress.stderr_file_writer+24], xmm0
        add	qword ptr [rip + Progress.stderr_mutex], -1
        jne	.LBB41_162
        mov	dword ptr [rip + Progress.stderr_mutex+12], -1
        xor	eax, eax
        xchg	dword ptr [rip + Progress.stderr_mutex+8], eax
        cmp	eax, 3
        jne	.LBB41_162
        mov	eax, 202
        mov	edi, offset Progress.stderr_mutex+8
        mov	esi, 129
        mov	edx, 1
        #APP
        syscall
        #NO_APP
.LBB41_162:
        lock		sub	byte ptr [rip + debug.panicking], 1
        je	.LBB41_190
        mov	dword ptr [rbp - 2336], 0
        lea	rdi, [rbp - 2336]
        mov	esi, 128
.LBB41_164:
        mov	eax, 202
        xor	edx, edx
        xor	r10d, r10d
        #APP
        syscall
        #NO_APP
        jmp	.LBB41_164
.LBB41_165:
        mov	rbx, rax
        call	Thread.Mutex.FutexImpl.lockSlow
        mov	rax, rbx
        jmp	.LBB41_4
.LBB41_166:
        lea	rdi, [rbp - 608]
        call	debug.StackIterator.deinit
        movzx	eax, r14w
        shl	eax, 4
        mov	rbx, qword ptr [rax + .L__unnamed_11]
        mov	r14, qword ptr [rax + .L__unnamed_11+8]
        xor	r15d, r15d
        mov	rdi, qword ptr [rip + Progress.stderr_file_writer+32]
        lea	r12, [rbp - 960]
.LBB41_167:
        lea	rsi, [r15 + __anon_9829]
        mov	r13d, 28
        sub	r13, r15
        lea	rax, [rdi + r13]
        cmp	rax, qword ptr [rip + Progress.stderr_file_writer+24]
        ja	.LBB41_169
        add	rdi, qword ptr [rip + Progress.stderr_file_writer+16]
        mov	rdx, r13
        call	memcpy@PLT
        mov	rdi, qword ptr [rip + Progress.stderr_file_writer+32]
        add	rdi, r13
        mov	qword ptr [rip + Progress.stderr_file_writer+32], rdi
        add	r15, r13
        cmp	r15, 28
        jb	.LBB41_167
        jmp	.LBB41_171
.LBB41_169:
        mov	rax, qword ptr [rip + Progress.stderr_file_writer+8]
        mov	rax, qword ptr [rax]
        mov	qword ptr [rbp - 960], rsi
        mov	qword ptr [rbp - 952], r13
        mov	esi, offset Progress.stderr_file_writer+8
        mov	ecx, 1
        mov	r8d, 1
        lea	rdi, [rbp - 2336]
        mov	rdx, r12
        call	rax
        cmp	word ptr [rbp - 2328], 0
        jne	.LBB41_159
        mov	r13, qword ptr [rbp - 2336]
        mov	rdi, qword ptr [rip + Progress.stderr_file_writer+32]
        add	r15, r13
        cmp	r15, 28
        jb	.LBB41_167
.LBB41_171:
        mov	edi, offset Progress.stderr_file_writer+8
        mov	rsi, rbx
        mov	rdx, r14
        call	Io.Writer.alignBufferOptions
        test	ax, ax
        jne	.LBB41_159
        lea	rbx, [rbp - 2336]
        lea	r14, [rbp - 960]
.LBB41_173:
        mov	rax, qword ptr [rip + Progress.stderr_file_writer+32]
        cmp	rax, qword ptr [rip + Progress.stderr_file_writer+24]
        jb	.LBB41_176
        mov	rax, qword ptr [rip + Progress.stderr_file_writer+8]
        mov	rax, qword ptr [rax]
        mov	qword ptr [rbp - 960], offset __anon_7066
        mov	qword ptr [rbp - 952], 1
        mov	esi, offset Progress.stderr_file_writer+8
        mov	ecx, 1
        mov	r8d, 1
        mov	rdi, rbx
        mov	rdx, r14
        call	rax
        cmp	word ptr [rbp - 2328], 0
        jne	.LBB41_159
        cmp	qword ptr [rbp - 2336], 0
        je	.LBB41_173
        jmp	.LBB41_159
.LBB41_176:
        mov	rcx, qword ptr [rip + Progress.stderr_file_writer+16]
        mov	byte ptr [rcx + rax], 10
        add	qword ptr [rip + Progress.stderr_file_writer+32], 1
        jmp	.LBB41_159
.LBB41_177:
        and	rcx, 15
        je	.LBB41_180
        mov	eax, offset __anon_16955
        and	al, 15
        cmp	al, 12
        jb	.LBB41_44
        mov	eax, 16
        sub	rax, rcx
        jmp	.LBB41_181
.LBB41_180:
        xor	eax, eax
.LBB41_181:
        add	rax, -16
        pxor	xmm1, xmm1
.LBB41_182:
        movdqa	xmm0, xmmword ptr [rax + __anon_16955+16]
        movdqa	xmm2, xmm0
        pcmpeqb	xmm2, xmm1
        pmovmskb	ecx, xmm2
        add	rax, 16
        test	ecx, ecx
        je	.LBB41_182
        pxor	xmm1, xmm1
        pcmpeqb	xmm0, xmm1
        movdqa	xmm1, xmmword ptr [rip + .LCPI41_0]
        movdqa	xmm2, xmm0
        pandn	xmm2, xmm1
        pand	xmm0, xmmword ptr [rip + .LCPI41_1]
        por	xmm0, xmm2
        pshufd	xmm2, xmm0, 238
        pand	xmm2, xmm1
        pminub	xmm2, xmm0
        pshufd	xmm0, xmm2, 85
        pand	xmm0, xmm1
        pminub	xmm0, xmm2
        movdqa	xmm2, xmm0
        psrld	xmm2, 16
        pand	xmm2, xmm1
        pminub	xmm2, xmm0
        movdqa	xmm0, xmm2
        psrlw	xmm0, 8
        pand	xmm0, xmm1
        pminub	xmm0, xmm2
        movd	ecx, xmm0
        movzx	ecx, cx
        add	rcx, rax
        mov	r14b, 1
        cmp	rcx, 33
        jb	.LBB41_51
        mov	eax, 64
        movdqa	xmm0, xmmword ptr [rip + .LCPI41_2]
.LBB41_185:
        movdqu	xmm1, xmmword ptr [rax + __anon_16955-64]
        pcmpeqb	xmm1, xmm0
        pmovmskb	edx, xmm1
        test	edx, edx
        jne	.LBB41_51
        cmp	rax, rcx
        jae	.LBB41_51
        movdqu	xmm1, xmmword ptr [rax + __anon_16955-48]
        pcmpeqb	xmm1, xmm0
        pmovmskb	edx, xmm1
        add	rax, 32
        test	dx, dx
        je	.LBB41_185
        jmp	.LBB41_51
.LBB41_188:
        cmp	rax, 1
        jne	.LBB41_190
        mov	qword ptr fs:[debug.panic_stage@TPOFF], 2
        call	fs.File.writeAll
.LBB41_190:
        call	posix.abort
        .text

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish.2":
        mov	rax, qword ptr [rdi + 24]
        test	rax, rax
        je	.LBB140_2
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rdi, qword ptr [rdi + 16]
        mov	word ptr [rbp - 8], 0
        mov	qword ptr [rbp - 16], rsi
        lea	rsi, [rbp - 16]
        call	rax
        add	rsp, 16
        pop	rbp
.LBB140_2:
        ret

