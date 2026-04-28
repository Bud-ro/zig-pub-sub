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
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1147"

codegen_write_u16_with_subs:
        push	rbp
        mov	rbp, rsp
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1940"

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
        je	.LBB22_2
        lea	rsi, [rbp - 8]
        mov	rdx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..32]).publish"
.LBB22_2:
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
        jmp	"system_data.SystemData(codegen_harness.HugeSystem__struct_3719,meta.FieldEnum(codegen_harness.HugeSystem__struct_3719),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).write__anon_3998"

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
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_3719,meta.FieldEnum(codegen_harness.HugeSystem__struct_3719),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).write__anon_3998"
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
        je	.LBB34_1
.LBB34_8:
        mov	rdi, r14
        mov	rsi, rbx
        call	timer.TimerModule.try_remove
        test	al, 1
        jne	.LBB34_2
        lea	rdi, [r14 + 8]
        mov	rsi, rbx
        call	timer.TimerModule.try_remove
        jmp	.LBB34_2
.LBB34_1:
        cmp	qword ptr [r14], rbx
        je	.LBB34_8
.LBB34_2:
        mov	qword ptr [r15 + 8], offset codegen_harness.timer_callback_read_write
        mov	dword ptr [r15 + 28], 100
        or	r12, 1
        mov	qword ptr [r15], r12
        mov	ecx, dword ptr [r14 + 16]
        lea	eax, [rcx + 100]
        mov	dword ptr [r15 + 24], eax
        mov	rax, qword ptr [r14]
        test	rax, rax
        je	.LBB34_3
        mov	edx, dword ptr [rax + 8]
        sub	edx, ecx
        add	edx, -101
        cmp	edx, -65636
        jb	.LBB34_7
.LBB34_5:
        mov	r14, rax
        mov	rax, qword ptr [rax]
        test	rax, rax
        je	.LBB34_3
        mov	edx, dword ptr [rax + 8]
        sub	edx, ecx
        add	edx, 65535
        cmp	edx, 65636
        jb	.LBB34_5
        jmp	.LBB34_7
.LBB34_3:
        xor	eax, eax
.LBB34_7:
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
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1147"
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
        je	.LBB42_3
        test	rax, rax
        jne	.LBB42_4
        and	qword ptr [rdi + 16], 0
        mov	qword ptr [rdi + 24], offset codegen_harness.accumulate_callback
.LBB42_3:
        ret
.LBB42_4:
        push	rbp
        mov	rbp, rsp
        call	debug.defaultPanic

codegen_harness.accumulate_callback:
        push	rbp
        mov	rbp, rsp
        mov	rax, qword ptr [rsi]
        cmp	byte ptr [rax], 0
        je	.LBB43_2
        inc	dword ptr [rdx]
.LBB43_2:
        pop	rbp
        ret

codegen_write_triggering_callback:
        push	rbp
        mov	rbp, rsp
        mov	esi, 1
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1147"

codegen_increment_n_times:
        push	rbp
        mov	rbp, rsp
.LBB59_1:
        cmp	esi, 1
        jb	.LBB59_3
        inc	dword ptr [rdi]
        dec	esi
        jmp	.LBB59_1
.LBB59_3:
        pop	rbp
        ret

codegen_conditional_write_chain:
        push	rbp
        mov	rbp, rsp
        test	byte ptr [rdi + 4], 1
        je	.LBB60_1
        add	dword ptr [rdi], 10
.LBB60_1:
        cmp	word ptr [rdi + 5], 100
        jbe	.LBB60_3
        add	dword ptr [rdi], 20
.LBB60_3:
        pop	rbp
        ret

codegen_cross_erd_compute:
        push	rbp
        mov	rbp, rsp
        movzx	esi, word ptr [rdi + 5]
        add	si, word ptr [rdi]
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1940"

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
        je	.LBB64_2
        mov	rdx, rsi
        lea	rsi, [rbp - 4]
        mov	rdi, rdx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish.2"
.LBB64_2:
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
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1147"
        mov	rdi, rbx
        mov	esi, r14d
        pop	rbx
        pop	r14
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1147"

codegen_double_write_diff_values:
        push	rbp
        mov	rbp, rsp
        push	rbx
        push	rax
        mov	rbx, rdi
        push	1
        pop	rsi
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1147"
        mov	rdi, rbx
        xor	esi, esi
        add	rsp, 8
        pop	rbx
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1147"

codegen_write_junk_read_write:
        push	rbp
        mov	rbp, rsp
        push	rbx
        push	rax
        mov	rbx, rdi
        push	1
        pop	rsi
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1940"
        push	2
        pop	rsi
        mov	rdi, rbx
        add	rsp, 8
        pop	rbx
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1940"

codegen_triple_write_increment:
        push	rbp
        mov	rbp, rsp
        push	rbx
        push	rax
        mov	rbx, rdi
        push	1
        pop	rsi
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1940"
        push	2
        pop	rsi
        mov	rdi, rbx
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1940"
        push	3
        pop	rsi
        mov	rdi, rbx
        add	rsp, 8
        pop	rbx
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1940"

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
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_3719,meta.FieldEnum(codegen_harness.HugeSystem__struct_3719),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).write__anon_3998"
        movups	xmm0, xmmword ptr [rbx + 256]
        lea	rsi, [rbp - 64]
        movaps	xmmword ptr [rsi], xmm0
        mov	rax, qword ptr [rbx + 272]
        mov	qword ptr [rsi + 16], rax
        inc	qword ptr [rsi]
        mov	rdi, rbx
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_3719,meta.FieldEnum(codegen_harness.HugeSystem__struct_3719),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).write__anon_3998"
        add	rsp, 56
        pop	rbx
        pop	rbp
        ret

; --- called functions ---

"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1147":
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
        mov	rcx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
.LBB6_2:
        add	rsp, 16
        pop	rbp
        ret

"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).write__anon_1940":
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
        mov	rcx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
.LBB9_2:
        add	rsp, 16
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
        lea	rsi, [rbp - 64]
        movaps	xmmword ptr [rsi + 48], xmm3
        movaps	xmmword ptr [rsi + 32], xmm2
        movaps	xmmword ptr [rsi + 16], xmm1
        movaps	xmmword ptr [rsi], xmm0
        movzx	edx, word ptr [rcx + rcx + .L__unnamed_4]
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
        sub	rsp, 40
        mov	rbx, rdx
        mov	r12d, esi
        mov	r14, rdi
        movzx	eax, r12w
        movzx	r15d, word ptr [rax + rax + .L__unnamed_3]
        movzx	edx, word ptr [r15 + r15 + .L__unnamed_4]
        mov	rdi, qword ptr [8*r15 + .L__unnamed_5]
        add	rdi, r14
        cmp	rbx, rdi
        je	.LBB13_1
        test	r12w, r12w
        je	.LBB13_4
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
        jmp	.LBB13_8
.LBB13_1:
        mov	r13b, 1
        jmp	.LBB13_9
.LBB13_4:
        lea	rax, [rdx - 4]
        mov	ecx, edx
        and	qword ptr [rbp - 72], 0
        shr	ecx
        and	ecx, 12
        mov	qword ptr [rbp - 64], rax
        sub	rax, rcx
        mov	qword ptr [rbp - 56], rcx
        mov	qword ptr [rbp - 48], rax
        xor	eax, eax
        xor	ecx, ecx
.LBB13_5:
        cmp	rcx, 4
        je	.LBB13_7
        mov	rsi, qword ptr [rbp + 8*rcx - 72]
        mov	r8d, dword ptr [rdi + rsi]
        xor	r8d, dword ptr [rbx + rsi]
        or	eax, r8d
        inc	rcx
        jmp	.LBB13_5
.LBB13_7:
        test	eax, eax
.LBB13_8:
        sete	r13b
.LBB13_9:
        mov	rsi, rbx
        call	memcpy@PLT
        test	r12w, -3
        je	.LBB13_11
        test	r13b, r13b
        jne	.LBB13_11
        mov	rdi, r14
        mov	esi, r15d
        mov	rdx, rbx
        mov	rcx, r14
        add	rsp, 40
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        jmp	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
.LBB13_11:
        add	rsp, 40
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
        push	r13
        push	r12
        push	rbx
        sub	rsp, 24
        mov	rbx, rdx
        mov	r14, rsi
        mov	r15, rdi
        xor	r13d, r13d
        lea	r12, [rbp - 56]
.LBB23_1:
        cmp	r13, 48
        je	.LBB23_5
        mov	rax, qword ptr [r15 + r13 + 144]
        test	rax, rax
        je	.LBB23_3
        mov	rdi, qword ptr [r15 + r13 + 136]
        mov	word ptr [rbp - 48], 31
        mov	qword ptr [rbp - 56], r14
        mov	rsi, r12
        mov	rdx, rbx
        call	rax
.LBB23_3:
        add	r13, 16
        jmp	.LBB23_1
.LBB23_5:
        add	rsp, 24
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        ret

"system_data.SystemData(codegen_harness.HugeSystem__struct_3719,meta.FieldEnum(codegen_harness.HugeSystem__struct_3719),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).write__anon_3998":
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
        jne	.LBB30_6
        cmp	r9, qword ptr [rsi + 8]
        jne	.LBB30_6
        cmp	r8d, dword ptr [rsi + 16]
        jne	.LBB30_6
        cmp	dx, word ptr [rsi + 20]
        jne	.LBB30_6
        cmp	cl, byte ptr [rsi + 22]
        jne	.LBB30_6
        and	al, 1
        cmp	byte ptr [rsi + 23], al
        je	.LBB30_7
.LBB30_6:
        lea	rsi, [rbp - 32]
        mov	rdx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
.LBB30_7:
        add	rsp, 32
        pop	rbp
        ret

timer.TimerModule.try_remove:
        mov	rax, qword ptr [rdi]
        test	rax, rax
        je	.LBB36_5
        push	rbp
        mov	rbp, rsp
        cmp	rax, rsi
        je	.LBB36_4
.LBB36_2:
        mov	rcx, qword ptr [rax]
        test	rcx, rcx
        je	.LBB36_7
        mov	rdi, rax
        mov	rax, rcx
        cmp	rcx, rsi
        jne	.LBB36_2
.LBB36_4:
        mov	rax, qword ptr [rsi]
        mov	qword ptr [rdi], rax
        mov	al, 1
        jmp	.LBB36_8
.LBB36_5:
        xor	eax, eax
        ret
.LBB36_7:
        xor	eax, eax
.LBB36_8:
        pop	rbp
        ret

debug.defaultPanic:
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 80
        mov	rax, qword ptr fs:[debug.panic_stage@TPOFF]
        test	rax, rax
        jne	.LBB44_29
        mov	qword ptr fs:[debug.panic_stage@TPOFF], 1
        lock		inc	byte ptr [rip + debug.panicking]
        call	Thread.getCurrentId
        cmp	dword ptr [rip + Progress.stderr_mutex+12], eax
        jne	.LBB44_3
        mov	rax, qword ptr [rip + Progress.stderr_mutex]
        inc	rax
        jmp	.LBB44_10
.LBB44_3:
        mov	r8d, eax
        lock		bts	dword ptr [rip + Progress.stderr_mutex+8], 0
        jae	.LBB44_9
        mov	eax, dword ptr [rip + Progress.stderr_mutex+8]
        cmp	eax, 3
        jne	.LBB44_6
        push	3
        pop	rdx
        mov	eax, 202
        mov	edi, offset Progress.stderr_mutex+8
        mov	esi, 128
        xor	r10d, r10d
        #APP
        syscall
        #NO_APP
.LBB44_6:
        push	3
        pop	r9
        push	3
        pop	rdx
        mov	edi, offset Progress.stderr_mutex+8
        mov	esi, 128
.LBB44_7:
        mov	eax, r9d
        xchg	dword ptr [rip + Progress.stderr_mutex+8], eax
        test	eax, eax
        je	.LBB44_9
        mov	eax, 202
        xor	r10d, r10d
        #APP
        syscall
        #NO_APP
        jmp	.LBB44_7
.LBB44_9:
        mov	dword ptr [rip + Progress.stderr_mutex+12], r8d
        push	1
        pop	rax
.LBB44_10:
        mov	qword ptr [rip + Progress.stderr_mutex], rax
        cmp	byte ptr [rip + Progress.global_progress+118], 1
        jne	.LBB44_12
        mov	byte ptr [rip + Progress.global_progress+118], 0
        push	11
        pop	rdx
        mov	edi, offset Progress.global_progress+96
        mov	esi, offset __anon_6347
        call	fs.File.writeAll
.LBB44_12:
        movabs	r14, -6148914691236517206
        mov	rax, qword ptr [rip + Progress.stderr_file_writer+8]
        mov	edi, offset Progress.stderr_file_writer+8
        call	qword ptr [rax + 16]
        mov	qword ptr [rip + Progress.stderr_file_writer+16], r14
        and	qword ptr [rip + Progress.stderr_file_writer+24], 0
        call	Thread.getCurrentId
        mov	ebx, eax
        push	7
        pop	rsi
        mov	edi, offset __anon_4946
        call	Io.Writer.writeAll
        test	ax, ax
        jne	.LBB44_31
        mov	ecx, ebx
        push	63
        pop	r8
        push	100
        pop	rsi
        mov	dil, 10
.LBB44_14:
        cmp	rcx, 100
        jb	.LBB44_16
        mov	rax, rcx
        xor	edx, edx
        div	rsi
        movzx	edx, dl
        mov	rcx, rax
        mov	eax, edx
        div	dil
        movzx	edx, ah
        or	dl, 48
        movzx	edx, dl
        shl	edx, 8
        movzx	eax, al
        add	eax, edx
        add	eax, 48
        mov	word ptr [rbp + r8 - 85], ax
        add	r8, -2
        jmp	.LBB44_14
.LBB44_16:
        cmp	rcx, 9
        ja	.LBB44_18
        or	cl, 48
        mov	byte ptr [rbp + r8 - 84], cl
        inc	r8
        jmp	.LBB44_19
.LBB44_18:
        movzx	eax, cl
        mov	cl, 10
        div	cl
        movzx	ecx, ah
        or	cl, 48
        movzx	ecx, cl
        shl	ecx, 8
        movzx	eax, al
        add	eax, ecx
        add	eax, 48
        mov	word ptr [rbp + r8 - 85], ax
.LBB44_19:
        lea	rdi, [r8 + rbp]
        add	rdi, -85
        push	65
        pop	rsi
        sub	rsi, r8
        call	Io.Writer.writeAll
        test	ax, ax
        jne	.LBB44_31
        push	8
        pop	rsi
        mov	edi, offset __anon_5098
        call	Io.Writer.writeAll
        test	ax, ax
        jne	.LBB44_31
        push	23
        pop	rsi
        mov	edi, offset __anon_4293
        call	Io.Writer.writeAll
        test	ax, ax
        jne	.LBB44_31
        push	1
        pop	rsi
        mov	edi, offset __anon_5314
        call	Io.Writer.writeAll
        test	ax, ax
        jne	.LBB44_31
        push	48
        pop	rsi
        mov	edi, offset __anon_4776
        call	Io.Writer.writeAll
        mov	rax, qword ptr [rip + Progress.stderr_file_writer+8]
        mov	edi, offset Progress.stderr_file_writer+8
        call	qword ptr [rax + 16]
        mov	qword ptr [rip + Progress.stderr_file_writer+16], r14
        xorps	xmm0, xmm0
        movups	xmmword ptr [rip + Progress.stderr_file_writer+24], xmm0
        dec	qword ptr [rip + Progress.stderr_mutex]
        jne	.LBB44_26
        mov	dword ptr [rip + Progress.stderr_mutex+12], -1
        xor	eax, eax
        xchg	dword ptr [rip + Progress.stderr_mutex+8], eax
        cmp	eax, 3
        jne	.LBB44_26
        push	1
        pop	rdx
        mov	eax, 202
        mov	edi, offset Progress.stderr_mutex+8
        mov	esi, 129
        #APP
        syscall
        #NO_APP
.LBB44_26:
        lock		dec	byte ptr [rip + debug.panicking]
        je	.LBB44_31
        lea	rdi, [rbp - 85]
        and	dword ptr [rdi], 0
        mov	esi, 128
.LBB44_28:
        mov	eax, 202
        xor	edx, edx
        xor	r10d, r10d
        #APP
        syscall
        #NO_APP
        jmp	.LBB44_28
.LBB44_29:
        cmp	rax, 1
        jne	.LBB44_31
        mov	qword ptr fs:[debug.panic_stage@TPOFF], 2
        lea	rdi, [rbp - 20]
        mov	dword ptr [rdi], 2
        push	32
        pop	rdx
        mov	esi, offset __anon_4821
        call	fs.File.writeAll
.LBB44_31:
        call	posix.abort
        .text

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish.2":
        mov	rcx, qword ptr [rdi + 24]
        test	rcx, rcx
        je	.LBB65_2
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rdi, qword ptr [rdi + 16]
        lea	rax, [rbp - 16]
        and	word ptr [rax + 8], 0
        mov	qword ptr [rax], rsi
        mov	rsi, rax
        call	rcx
        add	rsp, 16
        pop	rbp
.LBB65_2:
        ret

