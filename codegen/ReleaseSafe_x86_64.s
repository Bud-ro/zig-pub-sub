codegen_read_u32:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 80
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 16]
        movups	xmm2, xmmword ptr [rdi + 32]
        movups	xmm3, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 32], xmm3
        movaps	xmmword ptr [rbp - 48], xmm2
        movaps	xmmword ptr [rbp - 64], xmm1
        movaps	xmmword ptr [rbp - 80], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rax, [rbp - 76]
        lea	rcx, [rbp]
        lea	rdx, [rbp - 4]
        cmp	rdx, rax
        setae	al
        lea	rdx, [rbp - 80]
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        je	.LBB0_2
        mov	eax, dword ptr [rbp - 80]
        add	rsp, 80
        pop	rbp
        ret
.LBB0_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_read_bool:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 80
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 16]
        movups	xmm2, xmmword ptr [rdi + 32]
        movups	xmm3, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 32], xmm3
        movaps	xmmword ptr [rbp - 48], xmm2
        movaps	xmmword ptr [rbp - 64], xmm1
        movaps	xmmword ptr [rbp - 80], xmm0
        mov	byte ptr [rbp - 1], -86
        lea	rax, [rbp - 76]
        lea	rcx, [rbp - 75]
        lea	rdx, [rbp]
        lea	rsi, [rbp - 1]
        cmp	rsi, rcx
        setae	cl
        cmp	rax, rdx
        setae	al
        or	al, cl
        je	.LBB185_2
        movzx	eax, byte ptr [rbp - 76]
        and	al, 1
        add	rsp, 80
        pop	rbp
        ret
.LBB185_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_read_u16_unaligned:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 80
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 16]
        movups	xmm2, xmmword ptr [rdi + 32]
        movups	xmm3, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 32], xmm3
        movaps	xmmword ptr [rbp - 48], xmm2
        movaps	xmmword ptr [rbp - 64], xmm1
        movaps	xmmword ptr [rbp - 80], xmm0
        mov	word ptr [rbp - 2], -21846
        lea	rax, [rbp - 75]
        lea	rcx, [rbp - 73]
        lea	rdx, [rbp]
        lea	rsi, [rbp - 2]
        cmp	rsi, rcx
        setae	cl
        cmp	rax, rdx
        setae	al
        or	al, cl
        je	.LBB186_2
        movzx	eax, word ptr [rbp - 75]
        add	rsp, 80
        pop	rbp
        ret
.LBB186_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

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
        je	.LBB189_2
        lea	rdx, [rbp - 1]
        mov	esi, 1
        mov	rcx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
.LBB189_2:
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
        je	.LBB191_2
        lea	rdx, [rbp - 2]
        mov	esi, 3
        mov	rcx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
.LBB191_2:
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
        sub	rsp, 80
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 16]
        movups	xmm2, xmmword ptr [rdi + 32]
        movups	xmm3, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 32], xmm3
        movaps	xmmword ptr [rbp - 48], xmm2
        movaps	xmmword ptr [rbp - 64], xmm1
        movaps	xmmword ptr [rbp - 80], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rax, [rbp - 76]
        lea	rcx, [rbp]
        lea	rdx, [rbp - 4]
        cmp	rdx, rax
        setae	al
        lea	rdx, [rbp - 80]
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        je	.LBB199_2
        mov	ecx, dword ptr [rbp - 80]
        movups	xmm0, xmmword ptr [rsi]
        movaps	xmmword ptr [rbp - 80], xmm0
        movsxd	rax, dword ptr [rbp - 80]
        add	rax, rcx
        add	rsp, 80
        pop	rbp
        ret
.LBB199_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

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
        push	rbx
        sub	rsp, 200
        mov	rsi, rdi
        lea	rbx, [rbp - 200]
        mov	edx, 184
        mov	rdi, rbx
        call	memcpy@PLT
        mov	byte ptr [rbp - 9], -86
        lea	rax, [rbp - 199]
        lea	rcx, [rbp - 8]
        lea	rdx, [rbp - 9]
        cmp	rdx, rax
        setae	al
        cmp	rbx, rcx
        setae	cl
        or	cl, al
        je	.LBB201_2
        movzx	eax, byte ptr [rbp - 200]
        add	rsp, 200
        pop	rbx
        pop	rbp
        ret
.LBB201_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_many_read_middle:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 192
        mov	rsi, rdi
        lea	rdi, [rbp - 192]
        mov	edx, 184
        call	memcpy@PLT
        mov	dword ptr [rbp - 4], -1431655766
        lea	rax, [rbp - 144]
        lea	rcx, [rbp - 140]
        lea	rdx, [rbp]
        lea	rsi, [rbp - 4]
        cmp	rsi, rcx
        setae	cl
        cmp	rax, rdx
        setae	al
        or	al, cl
        je	.LBB202_2
        mov	eax, dword ptr [rbp - 144]
        add	rsp, 192
        pop	rbp
        ret
.LBB202_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_many_read_last:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 192
        mov	rsi, rdi
        lea	rdi, [rbp - 192]
        mov	edx, 184
        call	memcpy@PLT
        movabs	rax, -6148914691236517206
        mov	qword ptr [rbp - 8], rax
        lea	rax, [rbp - 80]
        lea	rcx, [rbp - 72]
        lea	rdx, [rbp]
        lea	rsi, [rbp - 8]
        cmp	rsi, rcx
        setae	cl
        cmp	rax, rdx
        setae	al
        or	al, cl
        je	.LBB203_2
        mov	rax, qword ptr [rbp - 80]
        add	rsp, 192
        pop	rbp
        ret
.LBB203_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_many_write_last_with_subs:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	qword ptr [rbp - 8], rsi
        cmp	qword ptr [rdi + 112], rsi
        mov	qword ptr [rdi + 112], rsi
        je	.LBB204_2
        lea	rsi, [rbp - 8]
        mov	rdx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..32]).publish"
.LBB204_2:
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
        push	r15
        push	r14
        push	rbx
        sub	rsp, 568
        mov	r14, rsi
        mov	rbx, rdi
        lea	r15, [rbp - 592]
        mov	edx, 304
        mov	rdi, r15
        call	memcpy@PLT
        movaps	xmm0, xmmword ptr [rip + .LCPI207_0]
        movaps	xmmword ptr [rbp - 288], xmm0
        movaps	xmmword ptr [rbp - 272], xmm0
        movaps	xmmword ptr [rbp - 256], xmm0
        movaps	xmmword ptr [rbp - 240], xmm0
        movaps	xmmword ptr [rbp - 224], xmm0
        movaps	xmmword ptr [rbp - 208], xmm0
        movaps	xmmword ptr [rbp - 192], xmm0
        movaps	xmmword ptr [rbp - 176], xmm0
        movaps	xmmword ptr [rbp - 160], xmm0
        movaps	xmmword ptr [rbp - 144], xmm0
        movaps	xmmword ptr [rbp - 128], xmm0
        movaps	xmmword ptr [rbp - 112], xmm0
        movaps	xmmword ptr [rbp - 96], xmm0
        movaps	xmmword ptr [rbp - 80], xmm0
        movaps	xmmword ptr [rbp - 64], xmm0
        movaps	xmmword ptr [rbp - 48], xmm0
        lea	rax, [rbp - 336]
        lea	rcx, [rbp - 32]
        lea	rdx, [rbp - 288]
        cmp	rdx, rax
        setae	al
        cmp	r15, rcx
        setae	cl
        or	cl, al
        je	.LBB207_2
        mov	edx, 256
        mov	rdi, rbx
        mov	rsi, r14
        call	memcpy@PLT
        mov	rax, rbx
        add	rsp, 568
        pop	rbx
        pop	r14
        pop	r15
        pop	rbp
        ret
.LBB207_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_read_medium_struct:
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 336
        mov	r14, rsi
        mov	rbx, rdi
        lea	rdi, [rbp - 352]
        mov	edx, 304
        call	memcpy@PLT
        movaps	xmm0, xmmword ptr [rip + .LCPI208_0]
        movaps	xmmword ptr [rbp - 48], xmm0
        movabs	rax, -6148914691236517206
        mov	qword ptr [rbp - 32], rax
        lea	rax, [rbp - 96]
        lea	rcx, [rbp - 72]
        lea	rdx, [rbp - 24]
        lea	rsi, [rbp - 48]
        cmp	rsi, rcx
        setae	cl
        cmp	rax, rdx
        setae	al
        or	al, cl
        je	.LBB208_2
        mov	rax, qword ptr [r14 + 272]
        mov	qword ptr [rbx + 16], rax
        movups	xmm0, xmmword ptr [r14 + 256]
        movups	xmmword ptr [rbx], xmm0
        mov	rax, rbx
        add	rsp, 336
        pop	rbx
        pop	r14
        pop	rbp
        ret
.LBB208_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_read_u32_after_big:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 320
        mov	rsi, rdi
        lea	rdi, [rbp - 312]
        mov	edx, 304
        call	memcpy@PLT
        mov	dword ptr [rbp - 4], -1431655766
        lea	rax, [rbp - 32]
        lea	rcx, [rbp - 28]
        lea	rdx, [rbp]
        lea	rsi, [rbp - 4]
        cmp	rsi, rcx
        setae	cl
        cmp	rax, rdx
        setae	al
        or	al, cl
        je	.LBB209_2
        mov	eax, dword ptr [rbp - 32]
        add	rsp, 320
        pop	rbp
        ret
.LBB209_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_write_big_struct:
        push	rbp
        mov	rbp, rsp
        mov	edx, 256
        pop	rbp
        jmp	memmove@PLT

codegen_write_medium_with_subs:
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 368
        mov	r14, rsi
        mov	rbx, rdi
        mov	rax, qword ptr [rsi + 16]
        mov	qword ptr [rbp - 64], rax
        movups	xmm0, xmmword ptr [rsi]
        movaps	xmmword ptr [rbp - 80], xmm0
        lea	rdi, [rbp - 384]
        mov	edx, 304
        mov	rsi, rbx
        call	memcpy@PLT
        movaps	xmm0, xmmword ptr [rip + .LCPI211_0]
        movaps	xmmword ptr [rbp - 48], xmm0
        movabs	rax, -6148914691236517206
        mov	qword ptr [rbp - 32], rax
        lea	rax, [rbp - 128]
        lea	rcx, [rbp - 104]
        lea	rdx, [rbp - 24]
        lea	rsi, [rbp - 48]
        cmp	rsi, rcx
        setae	cl
        cmp	rax, rdx
        setae	al
        or	al, cl
        je	.LBB211_9
        mov	r8, qword ptr [rbx + 256]
        mov	rdi, qword ptr [rbx + 264]
        mov	esi, dword ptr [rbx + 272]
        movzx	edx, word ptr [rbx + 276]
        movzx	ecx, byte ptr [rbx + 278]
        movzx	eax, byte ptr [rbx + 279]
        movups	xmm0, xmmword ptr [r14]
        mov	r9, qword ptr [r14 + 16]
        mov	qword ptr [rbx + 272], r9
        movups	xmmword ptr [rbx + 256], xmm0
        cmp	r8, qword ptr [r14]
        jne	.LBB211_7
        cmp	rdi, qword ptr [r14 + 8]
        jne	.LBB211_7
        cmp	esi, dword ptr [r14 + 16]
        jne	.LBB211_7
        cmp	dx, word ptr [r14 + 20]
        jne	.LBB211_7
        cmp	cl, byte ptr [r14 + 22]
        jne	.LBB211_7
        and	al, 1
        cmp	byte ptr [r14 + 23], al
        je	.LBB211_8
.LBB211_7:
        mov	rdi, qword ptr [rbx + 288]
        mov	rsi, qword ptr [rbx + 296]
        lea	rdx, [rbp - 80]
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
.LBB211_8:
        add	rsp, 368
        pop	rbx
        pop	r14
        pop	rbp
        ret
.LBB211_9:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_read_modify_write_medium:
        push	rbp
        mov	rbp, rsp
        push	rbx
        sub	rsp, 328
        mov	rbx, rdi
        lea	rdi, [rbp - 336]
        mov	edx, 304
        mov	rsi, rbx
        call	memcpy@PLT
        movaps	xmm0, xmmword ptr [rip + .LCPI213_0]
        movaps	xmmword ptr [rbp - 32], xmm0
        movabs	rax, -6148914691236517206
        mov	qword ptr [rbp - 16], rax
        lea	rax, [rbp - 80]
        lea	rcx, [rbp - 56]
        lea	rdx, [rbp - 8]
        lea	rsi, [rbp - 32]
        cmp	rsi, rcx
        setae	cl
        cmp	rax, rdx
        setae	al
        or	al, cl
        je	.LBB213_2
        mov	eax, dword ptr [rbx + 272]
        mov	ecx, dword ptr [rbx + 276]
        add	eax, 1
        movups	xmm0, xmmword ptr [rbx + 256]
        movaps	xmmword ptr [rbp - 336], xmm0
        mov	dword ptr [rbp - 320], eax
        mov	dword ptr [rbp - 316], ecx
        mov	dword ptr [rbx + 272], eax
        mov	rdi, qword ptr [rbx + 288]
        mov	rsi, qword ptr [rbx + 296]
        lea	rdx, [rbp - 336]
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
        add	rsp, 328
        pop	rbx
        pop	rbp
        ret
.LBB213_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_read_modify_write_big:
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 560
        mov	rbx, rdi
        lea	r14, [rbp - 576]
        mov	edx, 304
        mov	rdi, r14
        mov	rsi, rbx
        call	memcpy@PLT
        movaps	xmm0, xmmword ptr [rip + .LCPI214_0]
        movaps	xmmword ptr [rbp - 272], xmm0
        movaps	xmmword ptr [rbp - 256], xmm0
        movaps	xmmword ptr [rbp - 240], xmm0
        movaps	xmmword ptr [rbp - 224], xmm0
        movaps	xmmword ptr [rbp - 208], xmm0
        movaps	xmmword ptr [rbp - 192], xmm0
        movaps	xmmword ptr [rbp - 176], xmm0
        movaps	xmmword ptr [rbp - 160], xmm0
        movaps	xmmword ptr [rbp - 144], xmm0
        movaps	xmmword ptr [rbp - 128], xmm0
        movaps	xmmword ptr [rbp - 112], xmm0
        movaps	xmmword ptr [rbp - 96], xmm0
        movaps	xmmword ptr [rbp - 80], xmm0
        movaps	xmmword ptr [rbp - 64], xmm0
        movaps	xmmword ptr [rbp - 48], xmm0
        movaps	xmmword ptr [rbp - 32], xmm0
        lea	rax, [rbp - 320]
        lea	rcx, [rbp - 16]
        lea	rdx, [rbp - 272]
        cmp	rdx, rax
        setae	al
        cmp	r14, rcx
        setae	cl
        or	cl, al
        je	.LBB214_2
        add	byte ptr [rbx], 1
        add	rsp, 560
        pop	rbx
        pop	r14
        pop	rbp
        ret
.LBB214_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_setup_timer_callback:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rcx, qword ptr [rsi]
        lea	rax, [rdx + 16]
        cmp	qword ptr [rdx + 8], 0
        je	.LBB215_9
        test	rcx, rcx
        je	.LBB215_5
        mov	r8, rsi
.LBB215_3:
        cmp	rcx, rax
        je	.LBB215_11
        mov	r8, rcx
        mov	rcx, qword ptr [rcx]
        test	rcx, rcx
        jne	.LBB215_3
.LBB215_5:
        mov	rcx, qword ptr [rsi + 8]
        test	rcx, rcx
        je	.LBB215_12
        cmp	rcx, rax
        je	.LBB215_10
.LBB215_7:
        mov	r9, qword ptr [rcx]
        test	r9, r9
        je	.LBB215_12
        mov	r8, rcx
        mov	rcx, r9
        cmp	r9, rax
        jne	.LBB215_7
        jmp	.LBB215_11
.LBB215_9:
        mov	r8, rsi
        cmp	rcx, rax
        jne	.LBB215_12
        jmp	.LBB215_11
.LBB215_10:
        lea	r8, [rsi + 8]
.LBB215_11:
        mov	rcx, qword ptr [rax]
        mov	qword ptr [r8], rcx
.LBB215_12:
        mov	qword ptr [rdx + 8], offset codegen_harness.timer_callback_read_write
        mov	dword ptr [rdx + 32], 100
        or	rdi, 1
        mov	qword ptr [rdx], rdi
        mov	edi, dword ptr [rsi + 16]
        lea	ecx, [rdi + 100]
        mov	byte ptr [rbp - 4], 0
        mov	dword ptr [rdx + 24], ecx
        movzx	ecx, byte ptr [rbp - 4]
        mov	byte ptr [rdx + 28], cl
        mov	rcx, qword ptr [rsi]
        test	rcx, rcx
        je	.LBB215_19
        cmp	byte ptr [rcx + 12], 1
        je	.LBB215_21
        mov	edx, dword ptr [rcx + 8]
        sub	edx, edi
        add	edx, -101
        cmp	edx, -65636
        jb	.LBB215_20
.LBB215_15:
        mov	rsi, rcx
        mov	rcx, qword ptr [rcx]
        test	rcx, rcx
        je	.LBB215_19
        cmp	byte ptr [rcx + 12], 1
        je	.LBB215_21
        mov	edx, dword ptr [rcx + 8]
        sub	edx, edi
        add	edx, 65535
        cmp	edx, 65636
        jb	.LBB215_15
        jmp	.LBB215_20
.LBB215_19:
        xor	ecx, ecx
.LBB215_20:
        mov	qword ptr [rax], rcx
        mov	qword ptr [rsi], rax
        add	rsp, 16
        pop	rbp
        ret
.LBB215_21:
        call	"debug.FullPanic((function 'defaultPanic')).inactiveUnionField__anon_19897"

codegen_harness.timer_callback_read_write:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 80
        test	rdi, rdi
        je	.LBB216_5
        test	dil, 7
        jne	.LBB216_4
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 16]
        movups	xmm2, xmmword ptr [rdi + 32]
        movups	xmm3, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 32], xmm3
        movaps	xmmword ptr [rbp - 48], xmm2
        movaps	xmmword ptr [rbp - 64], xmm1
        movaps	xmmword ptr [rbp - 80], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rax, [rbp - 76]
        lea	rcx, [rbp]
        lea	rdx, [rbp - 4]
        cmp	rdx, rax
        setae	al
        lea	rdx, [rbp - 80]
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        je	.LBB216_6
        mov	eax, dword ptr [rbp - 80]
        add	eax, 1
        mov	dword ptr [rdi], eax
        add	rsp, 80
        pop	rbp
        ret
.LBB216_5:
        call	"debug.FullPanic((function 'defaultPanic')).unwrapNull"
.LBB216_4:
        call	"debug.FullPanic((function 'defaultPanic')).incorrectAlignment"
.LBB216_6:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_triple_read_same_erd:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 80
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 16]
        movups	xmm2, xmmword ptr [rdi + 32]
        movups	xmm3, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 32], xmm3
        movaps	xmmword ptr [rbp - 48], xmm2
        movaps	xmmword ptr [rbp - 64], xmm1
        movaps	xmmword ptr [rbp - 80], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rax, [rbp - 76]
        lea	rcx, [rbp]
        lea	rdx, [rbp - 4]
        cmp	rdx, rax
        setae	al
        lea	rdx, [rbp - 80]
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        je	.LBB218_2
        mov	eax, dword ptr [rbp - 80]
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 32]
        movups	xmm2, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 80], xmm0
        movaps	xmmword ptr [rbp - 32], xmm2
        movaps	xmmword ptr [rbp - 48], xmm1
        add	eax, dword ptr [rbp - 80]
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 32]
        movups	xmm2, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 80], xmm0
        movaps	xmmword ptr [rbp - 32], xmm2
        movaps	xmmword ptr [rbp - 48], xmm1
        add	eax, dword ptr [rbp - 80]
        add	rsp, 80
        pop	rbp
        ret
.LBB218_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_read_then_branch:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 80
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 16]
        movups	xmm2, xmmword ptr [rdi + 32]
        movups	xmm3, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 32], xmm3
        movaps	xmmword ptr [rbp - 48], xmm2
        movaps	xmmword ptr [rbp - 64], xmm1
        movaps	xmmword ptr [rbp - 80], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rax, [rbp - 76]
        lea	rcx, [rbp]
        lea	rdx, [rbp - 4]
        cmp	rdx, rax
        setae	al
        lea	rdx, [rbp - 80]
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        je	.LBB219_2
        mov	ecx, dword ptr [rbp - 80]
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 80], xmm0
        movaps	xmmword ptr [rbp - 32], xmm1
        mov	eax, dword ptr [rbp - 80]
        mov	edx, eax
        imul	edx, ecx
        add	eax, ecx
        test	sil, sil
        cmove	eax, edx
        add	rsp, 80
        pop	rbp
        ret
.LBB219_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_read_write_read:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 80
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 16]
        movups	xmm2, xmmword ptr [rdi + 32]
        movups	xmm3, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 32], xmm3
        movaps	xmmword ptr [rbp - 48], xmm2
        movaps	xmmword ptr [rbp - 64], xmm1
        movaps	xmmword ptr [rbp - 80], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rax, [rbp - 76]
        lea	rcx, [rbp]
        lea	rdx, [rbp - 4]
        cmp	rdx, rax
        setae	al
        lea	rdx, [rbp - 80]
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        je	.LBB220_2
        mov	eax, dword ptr [rbp - 80]
        add	eax, 1
        mov	dword ptr [rdi], eax
        mov	eax, dword ptr [rdi]
        mov	rcx, qword ptr [rdi + 4]
        mov	edx, dword ptr [rdi + 12]
        movups	xmm0, xmmword ptr [rdi + 32]
        movups	xmm1, xmmword ptr [rdi + 48]
        mov	dword ptr [rbp - 80], eax
        mov	qword ptr [rbp - 76], rcx
        mov	dword ptr [rbp - 68], edx
        movaps	xmmword ptr [rbp - 32], xmm1
        movaps	xmmword ptr [rbp - 48], xmm0
        mov	eax, dword ptr [rbp - 80]
        add	rsp, 80
        pop	rbp
        ret
.LBB220_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_read_write_other_read:
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 96
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 16]
        movups	xmm2, xmmword ptr [rdi + 32]
        movups	xmm3, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 48], xmm3
        movaps	xmmword ptr [rbp - 64], xmm2
        movaps	xmmword ptr [rbp - 80], xmm1
        movaps	xmmword ptr [rbp - 96], xmm0
        mov	dword ptr [rbp - 20], -1431655766
        lea	rax, [rbp - 92]
        lea	rcx, [rbp - 16]
        lea	rdx, [rbp - 20]
        cmp	rdx, rax
        setae	al
        lea	rdx, [rbp - 96]
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        je	.LBB221_4
        mov	rbx, rdi
        mov	r14d, dword ptr [rbp - 96]
        mov	byte ptr [rbp - 96], sil
        cmp	byte ptr [rdi + 4], sil
        mov	byte ptr [rdi + 4], sil
        je	.LBB221_3
        mov	rdi, rbx
        mov	esi, 1
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
.LBB221_3:
        mov	eax, dword ptr [rbx]
        movzx	ecx, byte ptr [rbx + 4]
        mov	rdx, qword ptr [rbx + 5]
        movzx	esi, word ptr [rbx + 13]
        movzx	edi, byte ptr [rbx + 15]
        movups	xmm0, xmmword ptr [rbx + 32]
        movups	xmm1, xmmword ptr [rbx + 48]
        mov	dword ptr [rbp - 96], eax
        mov	byte ptr [rbp - 92], cl
        mov	qword ptr [rbp - 91], rdx
        mov	word ptr [rbp - 83], si
        mov	byte ptr [rbp - 81], dil
        movaps	xmmword ptr [rbp - 48], xmm1
        movaps	xmmword ptr [rbp - 64], xmm0
        add	r14d, dword ptr [rbp - 96]
        mov	eax, r14d
        add	rsp, 96
        pop	rbx
        pop	r14
        pop	rbp
        ret
.LBB221_4:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_read_across_two_erds:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 80
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 16]
        movups	xmm2, xmmword ptr [rdi + 32]
        movups	xmm3, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 32], xmm3
        movaps	xmmword ptr [rbp - 48], xmm2
        movaps	xmmword ptr [rbp - 64], xmm1
        movaps	xmmword ptr [rbp - 80], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rax, [rbp - 76]
        lea	rdx, [rbp]
        lea	rcx, [rbp - 4]
        cmp	rcx, rax
        setae	al
        lea	rsi, [rbp - 80]
        cmp	rsi, rdx
        setae	dl
        or	dl, al
        je	.LBB222_3
        mov	eax, dword ptr [rbp - 80]
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 16]
        movups	xmm2, xmmword ptr [rdi + 32]
        movups	xmm3, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 32], xmm3
        movaps	xmmword ptr [rbp - 48], xmm2
        movaps	xmmword ptr [rbp - 64], xmm1
        movaps	xmmword ptr [rbp - 80], xmm0
        mov	word ptr [rbp - 4], -21846
        lea	rdx, [rbp - 75]
        lea	rsi, [rbp - 73]
        lea	r8, [rbp - 2]
        cmp	rcx, rsi
        setae	cl
        cmp	rdx, r8
        setae	dl
        or	dl, cl
        je	.LBB222_3
        movzx	ecx, word ptr [rbp - 75]
        add	eax, ecx
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 32]
        movups	xmm2, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 80], xmm0
        movaps	xmmword ptr [rbp - 32], xmm2
        movaps	xmmword ptr [rbp - 48], xmm1
        add	eax, dword ptr [rbp - 80]
        add	rsp, 80
        pop	rbp
        ret
.LBB222_3:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_subscribe_callback:
        mov	rax, qword ptr [rdi + 24]
        cmp	rax, offset codegen_harness.accumulate_callback
        je	.LBB223_3
        test	rax, rax
        jne	.LBB223_4
        mov	qword ptr [rdi + 16], 0
        mov	qword ptr [rdi + 24], offset codegen_harness.accumulate_callback
.LBB223_3:
        ret
.LBB223_4:
        push	rbp
        mov	rbp, rsp
        mov	edi, offset __anon_19928
        mov	esi, 23
        mov	edx, offset .L__unnamed_36
        call	debug.defaultPanic

codegen_harness.accumulate_callback:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 80
        test	rsi, rsi
        je	.LBB224_7
        test	sil, 7
        jne	.LBB224_8
        test	dl, 7
        jne	.LBB224_8
        mov	rax, qword ptr [rsi]
        cmp	byte ptr [rax], 0
        je	.LBB224_6
        movups	xmm0, xmmword ptr [rdx]
        movups	xmm1, xmmword ptr [rdx + 16]
        movups	xmm2, xmmword ptr [rdx + 32]
        movups	xmm3, xmmword ptr [rdx + 48]
        movaps	xmmword ptr [rbp - 32], xmm3
        movaps	xmmword ptr [rbp - 48], xmm2
        movaps	xmmword ptr [rbp - 64], xmm1
        movaps	xmmword ptr [rbp - 80], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rax, [rbp - 76]
        lea	rcx, [rbp]
        lea	rsi, [rbp - 4]
        cmp	rsi, rax
        setae	al
        lea	rsi, [rbp - 80]
        cmp	rsi, rcx
        setae	cl
        or	cl, al
        je	.LBB224_9
        mov	eax, dword ptr [rbp - 80]
        add	eax, 1
        mov	dword ptr [rdx], eax
.LBB224_6:
        add	rsp, 80
        pop	rbp
        ret
.LBB224_8:
        call	"debug.FullPanic((function 'defaultPanic')).incorrectAlignment"
.LBB224_7:
        call	"debug.FullPanic((function 'defaultPanic')).unwrapNull"
.LBB224_9:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_write_triggering_callback:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	byte ptr [rbp - 1], 1
        cmp	byte ptr [rdi + 4], 1
        mov	byte ptr [rdi + 4], 1
        je	.LBB225_2
        lea	rdx, [rbp - 1]
        mov	esi, 1
        mov	rcx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
.LBB225_2:
        add	rsp, 16
        pop	rbp
        ret

codegen_increment_n_times:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 80
        test	esi, esi
        je	.LBB226_7
        lea	rax, [rbp - 76]
        lea	rcx, [rbp]
        lea	rdx, [rbp - 4]
        cmp	rdx, rax
        setb	al
        lea	rdx, [rbp - 80]
        cmp	rdx, rcx
        setb	cl
        test	cl, al
        jne	.LBB226_8
        cmp	esi, 1
        je	.LBB226_6
        mov	eax, esi
        and	eax, -2
        neg	eax
.LBB226_4:
        mov	ecx, dword ptr [rdi]
        mov	rdx, qword ptr [rdi + 4]
        mov	r8d, dword ptr [rdi + 12]
        movups	xmm0, xmmword ptr [rdi + 48]
        mov	dword ptr [rbp - 80], ecx
        mov	qword ptr [rbp - 76], rdx
        mov	dword ptr [rbp - 68], r8d
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	ecx, dword ptr [rbp - 80]
        add	ecx, 1
        mov	dword ptr [rdi], ecx
        mov	ecx, dword ptr [rdi]
        mov	rdx, qword ptr [rdi + 4]
        mov	r8d, dword ptr [rdi + 12]
        movups	xmm0, xmmword ptr [rdi + 48]
        mov	dword ptr [rbp - 80], ecx
        mov	qword ptr [rbp - 76], rdx
        mov	dword ptr [rbp - 68], r8d
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	ecx, dword ptr [rbp - 80]
        add	ecx, 1
        mov	dword ptr [rdi], ecx
        add	eax, 2
        jne	.LBB226_4
        test	sil, 1
        je	.LBB226_7
.LBB226_6:
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 32]
        movups	xmm2, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 80], xmm0
        movaps	xmmword ptr [rbp - 32], xmm2
        movaps	xmmword ptr [rbp - 48], xmm1
        mov	eax, dword ptr [rbp - 80]
        add	eax, 1
        mov	dword ptr [rdi], eax
.LBB226_7:
        add	rsp, 80
        pop	rbp
        ret
.LBB226_8:
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 16]
        movups	xmm2, xmmword ptr [rdi + 32]
        movups	xmm3, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 32], xmm3
        movaps	xmmword ptr [rbp - 48], xmm2
        movaps	xmmword ptr [rbp - 64], xmm1
        movaps	xmmword ptr [rbp - 80], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_conditional_write_chain:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 80
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 16]
        movups	xmm2, xmmword ptr [rdi + 32]
        movups	xmm3, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 32], xmm3
        movaps	xmmword ptr [rbp - 48], xmm2
        movaps	xmmword ptr [rbp - 64], xmm1
        movaps	xmmword ptr [rbp - 80], xmm0
        mov	byte ptr [rbp - 4], -86
        lea	rax, [rbp - 76]
        lea	rdx, [rbp - 75]
        lea	rsi, [rbp - 3]
        lea	rcx, [rbp - 4]
        cmp	rcx, rdx
        setae	r8b
        cmp	rax, rsi
        setae	sil
        or	sil, r8b
        je	.LBB227_9
        test	byte ptr [rbp - 76], 1
        je	.LBB227_2
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 16]
        movups	xmm2, xmmword ptr [rdi + 32]
        movups	xmm3, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 32], xmm3
        movaps	xmmword ptr [rbp - 48], xmm2
        movaps	xmmword ptr [rbp - 64], xmm1
        movaps	xmmword ptr [rbp - 80], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rsi, [rbp]
        cmp	rcx, rax
        setae	r8b
        lea	r9, [rbp - 80]
        cmp	r9, rsi
        setae	sil
        or	sil, r8b
        je	.LBB227_9
        mov	esi, dword ptr [rbp - 80]
        add	esi, 10
        mov	dword ptr [rdi], esi
.LBB227_2:
        mov	esi, dword ptr [rdi]
        mov	r8, qword ptr [rdi + 4]
        mov	r9d, dword ptr [rdi + 12]
        movups	xmm0, xmmword ptr [rdi + 16]
        movups	xmm1, xmmword ptr [rdi + 32]
        movups	xmm2, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 32], xmm2
        movaps	xmmword ptr [rbp - 48], xmm1
        movaps	xmmword ptr [rbp - 64], xmm0
        mov	dword ptr [rbp - 80], esi
        mov	qword ptr [rbp - 76], r8
        mov	dword ptr [rbp - 68], r9d
        mov	word ptr [rbp - 4], -21846
        lea	rsi, [rbp - 73]
        lea	r8, [rbp - 2]
        cmp	rcx, rsi
        setae	sil
        cmp	rdx, r8
        setae	dl
        or	dl, sil
        je	.LBB227_9
        cmp	word ptr [rbp - 75], 100
        jbe	.LBB227_4
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 16]
        movups	xmm2, xmmword ptr [rdi + 32]
        movups	xmm3, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 32], xmm3
        movaps	xmmword ptr [rbp - 48], xmm2
        movaps	xmmword ptr [rbp - 64], xmm1
        movaps	xmmword ptr [rbp - 80], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rdx, [rbp]
        cmp	rcx, rax
        setae	al
        lea	rcx, [rbp - 80]
        cmp	rcx, rdx
        setae	cl
        or	cl, al
        je	.LBB227_9
        mov	eax, dword ptr [rbp - 80]
        add	eax, 20
        mov	dword ptr [rdi], eax
.LBB227_4:
        add	rsp, 80
        pop	rbp
        ret
.LBB227_9:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_cross_erd_compute:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 80
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 16]
        movups	xmm2, xmmword ptr [rdi + 32]
        movups	xmm3, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 32], xmm3
        movaps	xmmword ptr [rbp - 48], xmm2
        movaps	xmmword ptr [rbp - 64], xmm1
        movaps	xmmword ptr [rbp - 80], xmm0
        mov	word ptr [rbp - 4], -21846
        lea	rax, [rbp - 75]
        lea	rdx, [rbp - 73]
        lea	rsi, [rbp - 2]
        lea	rcx, [rbp - 4]
        cmp	rcx, rdx
        setae	dl
        cmp	rax, rsi
        setae	al
        or	al, dl
        je	.LBB228_5
        movzx	eax, word ptr [rbp - 75]
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 16]
        movups	xmm2, xmmword ptr [rdi + 32]
        movups	xmm3, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 32], xmm3
        movaps	xmmword ptr [rbp - 48], xmm2
        movaps	xmmword ptr [rbp - 64], xmm1
        movaps	xmmword ptr [rbp - 80], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rdx, [rbp - 76]
        lea	rsi, [rbp]
        cmp	rcx, rdx
        setae	cl
        lea	rdx, [rbp - 80]
        cmp	rdx, rsi
        setae	dl
        or	dl, cl
        je	.LBB228_5
        add	ax, word ptr [rbp - 80]
        mov	word ptr [rbp - 80], ax
        cmp	word ptr [rdi + 7], ax
        mov	word ptr [rdi + 7], ax
        je	.LBB228_4
        lea	rdx, [rbp - 80]
        mov	esi, 3
        mov	rcx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
.LBB228_4:
        add	rsp, 80
        pop	rbp
        ret
.LBB228_5:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_cross_system_read_add:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 80
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 16]
        movups	xmm2, xmmword ptr [rdi + 32]
        movups	xmm3, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 32], xmm3
        movaps	xmmword ptr [rbp - 48], xmm2
        movaps	xmmword ptr [rbp - 64], xmm1
        movaps	xmmword ptr [rbp - 80], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rcx, [rbp - 76]
        lea	rdx, [rbp]
        lea	rax, [rbp - 4]
        cmp	rax, rcx
        setae	cl
        lea	r8, [rbp - 80]
        cmp	r8, rdx
        setae	dl
        or	dl, cl
        je	.LBB229_4
        mov	edx, dword ptr [rbp - 80]
        movups	xmm0, xmmword ptr [rsi]
        movaps	xmmword ptr [rbp - 80], xmm0
        movsxd	rcx, dword ptr [rbp - 80]
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 16]
        movups	xmm2, xmmword ptr [rdi + 32]
        movups	xmm3, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 32], xmm3
        movaps	xmmword ptr [rbp - 48], xmm2
        movaps	xmmword ptr [rbp - 64], xmm1
        movaps	xmmword ptr [rbp - 80], xmm0
        mov	word ptr [rbp - 4], -21846
        lea	rdi, [rbp - 75]
        lea	r9, [rbp - 73]
        lea	r10, [rbp - 2]
        cmp	rax, r9
        setae	r9b
        cmp	rdi, r10
        setae	dil
        or	dil, r9b
        je	.LBB229_4
        movzx	edi, word ptr [rbp - 75]
        movups	xmm0, xmmword ptr [rsi]
        movups	xmm1, xmmword ptr [rsi + 16]
        movaps	xmmword ptr [rbp - 64], xmm1
        movaps	xmmword ptr [rbp - 80], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rsi, [rbp - 72]
        cmp	rax, rsi
        setae	sil
        cmp	r8, rax
        setae	al
        or	al, sil
        je	.LBB229_4
        add	rcx, rdx
        movsxd	rax, dword ptr [rbp - 76]
        add	rax, rdi
        add	rax, rcx
        add	rsp, 80
        pop	rbp
        ret
.LBB229_4:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_cross_system_read_write:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 48
        movups	xmm0, xmmword ptr [rsi]
        movups	xmm1, xmmword ptr [rsi + 16]
        movaps	xmmword ptr [rbp - 32], xmm1
        movaps	xmmword ptr [rbp - 48], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rax, [rbp - 44]
        lea	rcx, [rbp]
        lea	rdx, [rbp - 4]
        cmp	rdx, rax
        setae	al
        lea	rdx, [rbp - 48]
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        je	.LBB230_2
        mov	eax, dword ptr [rbp - 48]
        mov	dword ptr [rdi], eax
        add	rsp, 48
        pop	rbp
        ret
.LBB230_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_cross_system_swap:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 80
        mov	rcx, rsi
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 16]
        movups	xmm2, xmmword ptr [rdi + 32]
        movups	xmm3, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 32], xmm3
        movaps	xmmword ptr [rbp - 48], xmm2
        movaps	xmmword ptr [rbp - 64], xmm1
        movaps	xmmword ptr [rbp - 80], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rax, [rbp - 76]
        lea	rdx, [rbp]
        lea	rsi, [rbp - 4]
        cmp	rsi, rax
        setae	al
        lea	rsi, [rbp - 80]
        cmp	rsi, rdx
        setae	dl
        or	dl, al
        je	.LBB231_4
        mov	eax, dword ptr [rbp - 80]
        movups	xmm0, xmmword ptr [rcx]
        movaps	xmmword ptr [rbp - 80], xmm0
        mov	edx, dword ptr [rbp - 80]
        mov	dword ptr [rdi], edx
        mov	dword ptr [rbp - 80], eax
        cmp	dword ptr [rcx], eax
        mov	dword ptr [rcx], eax
        je	.LBB231_3
        mov	rdi, qword ptr [rcx + 16]
        mov	rsi, qword ptr [rcx + 24]
        lea	rdx, [rbp - 80]
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish.2"
.LBB231_3:
        add	rsp, 80
        pop	rbp
        ret
.LBB231_4:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

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
        jne	.LBB233_1
        mov	byte ptr [rbp - 10], 1
        mov	byte ptr [rbx + 4], 1
        cmp	al, 1
        jne	.LBB233_3
.LBB233_4:
        add	rsp, 8
        pop	rbx
        pop	rbp
        ret
.LBB233_1:
        lea	rdx, [rbp - 9]
        mov	rdi, rbx
        mov	esi, 1
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
        movzx	eax, byte ptr [rbx + 4]
        mov	byte ptr [rbp - 10], 1
        mov	byte ptr [rbx + 4], 1
        cmp	al, 1
        je	.LBB233_4
.LBB233_3:
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
        jne	.LBB234_1
        mov	byte ptr [rbp - 10], 0
        mov	byte ptr [rbx + 4], 0
        cmp	al, 0
        jne	.LBB234_3
.LBB234_4:
        add	rsp, 8
        pop	rbx
        pop	rbp
        ret
.LBB234_1:
        lea	rdx, [rbp - 9]
        mov	rdi, rbx
        mov	esi, 1
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
        movzx	eax, byte ptr [rbx + 4]
        mov	byte ptr [rbp - 10], 0
        mov	byte ptr [rbx + 4], 0
        cmp	al, 0
        je	.LBB234_4
.LBB234_3:
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
        sub	rsp, 72
        mov	rbx, rdi
        mov	word ptr [rbp - 80], 1
        cmp	word ptr [rdi + 7], 1
        mov	word ptr [rdi + 7], 1
        je	.LBB235_2
        lea	rdx, [rbp - 80]
        mov	rdi, rbx
        mov	esi, 3
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
.LBB235_2:
        mov	eax, dword ptr [rbx]
        movzx	ecx, word ptr [rbx + 4]
        movzx	edx, byte ptr [rbx + 6]
        movzx	esi, word ptr [rbx + 7]
        mov	edi, dword ptr [rbx + 9]
        movzx	r8d, word ptr [rbx + 13]
        movzx	r9d, byte ptr [rbx + 15]
        movups	xmm0, xmmword ptr [rbx + 16]
        movups	xmm1, xmmword ptr [rbx + 32]
        movups	xmm2, xmmword ptr [rbx + 48]
        movaps	xmmword ptr [rbp - 32], xmm2
        movaps	xmmword ptr [rbp - 48], xmm1
        movaps	xmmword ptr [rbp - 64], xmm0
        mov	dword ptr [rbp - 80], eax
        mov	word ptr [rbp - 76], cx
        mov	byte ptr [rbp - 74], dl
        mov	word ptr [rbp - 73], si
        mov	dword ptr [rbp - 71], edi
        mov	word ptr [rbp - 67], r8w
        mov	byte ptr [rbp - 65], r9b
        mov	dword ptr [rbp - 12], -1431655766
        lea	rax, [rbp - 76]
        lea	rcx, [rbp - 8]
        lea	rdx, [rbp - 12]
        cmp	rdx, rax
        setae	al
        lea	rdx, [rbp - 80]
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        je	.LBB235_6
        mov	word ptr [rbp - 80], 2
        cmp	word ptr [rbx + 7], 2
        mov	word ptr [rbx + 7], 2
        je	.LBB235_5
        mov	rdi, rbx
        mov	esi, 3
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
.LBB235_5:
        add	rsp, 72
        pop	rbx
        pop	rbp
        ret
.LBB235_6:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_triple_write_increment:
        push	rbp
        mov	rbp, rsp
        push	rbx
        push	rax
        mov	rbx, rdi
        mov	word ptr [rbp - 14], 1
        cmp	word ptr [rdi + 7], 1
        mov	word ptr [rdi + 7], 1
        jne	.LBB236_3
        mov	word ptr [rbp - 10], 2
        mov	word ptr [rbx + 7], 2
        jmp	.LBB236_2
.LBB236_3:
        lea	rdx, [rbp - 14]
        mov	rdi, rbx
        mov	esi, 3
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
        movzx	eax, word ptr [rbx + 7]
        mov	word ptr [rbp - 10], 2
        mov	word ptr [rbx + 7], 2
        cmp	ax, 2
        jne	.LBB236_2
        mov	word ptr [rbp - 12], 3
        mov	word ptr [rbx + 7], 3
        jmp	.LBB236_5
.LBB236_2:
        lea	rdx, [rbp - 10]
        mov	rdi, rbx
        mov	esi, 3
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
        movzx	eax, word ptr [rbx + 7]
        mov	word ptr [rbp - 12], 3
        mov	word ptr [rbx + 7], 3
        cmp	ax, 3
        je	.LBB236_6
.LBB236_5:
        lea	rdx, [rbp - 12]
        mov	rdi, rbx
        mov	esi, 3
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
.LBB236_6:
        add	rsp, 8
        pop	rbx
        pop	rbp
        ret

codegen_double_rmw_struct:
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 336
        mov	rbx, rdi
        lea	rdi, [rbp - 352]
        mov	edx, 304
        mov	rsi, rbx
        call	memcpy@PLT
        movaps	xmm0, xmmword ptr [rip + .LCPI237_0]
        movaps	xmmword ptr [rbp - 48], xmm0
        movabs	rax, -6148914691236517206
        mov	qword ptr [rbp - 32], rax
        lea	rax, [rbp - 96]
        lea	rcx, [rbp - 72]
        lea	rdx, [rbp - 24]
        lea	rsi, [rbp - 48]
        cmp	rsi, rcx
        setae	cl
        cmp	rax, rdx
        setae	al
        or	al, cl
        je	.LBB237_2
        mov	eax, dword ptr [rbx + 272]
        mov	ecx, dword ptr [rbx + 276]
        add	eax, 1
        movups	xmm0, xmmword ptr [rbx + 256]
        movaps	xmmword ptr [rbp - 352], xmm0
        mov	dword ptr [rbp - 336], eax
        mov	dword ptr [rbp - 332], ecx
        mov	dword ptr [rbx + 272], eax
        mov	rdi, qword ptr [rbx + 288]
        mov	rsi, qword ptr [rbx + 296]
        lea	r14, [rbp - 352]
        mov	rdx, r14
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
        mov	rax, qword ptr [rbx + 256]
        movups	xmm0, xmmword ptr [rbx + 264]
        add	rax, 1
        mov	qword ptr [rbp - 352], rax
        movups	xmmword ptr [rbp - 344], xmm0
        mov	qword ptr [rbx + 256], rax
        mov	rdi, qword ptr [rbx + 288]
        mov	rsi, qword ptr [rbx + 296]
        mov	rdx, r14
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
        add	rsp, 336
        pop	rbx
        pop	r14
        pop	rbp
        ret
.LBB237_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

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
        movzx	r14d, si
        cmp	r14w, 3
        ja	.LBB190_9
        mov	rcx, qword ptr [8*r14 + .L__unnamed_76]
        movzx	r13d, byte ptr [r14 + .L__unnamed_77]
        mov	rax, rcx
        add	rax, r13
        jb	.LBB190_10
        cmp	rax, 3
        ja	.LBB190_11
        cmp	rax, rcx
        jne	.LBB190_4
.LBB190_7:
        add	rsp, 24
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        ret
.LBB190_4:
        mov	r15, rdx
        cmp	r13, 1
        adc	r13, 0
        shl	r13d, 4
        shl	rcx, 4
        lea	r12, [rdi + rcx]
        add	r12, 24
        xor	ebx, ebx
        jmp	.LBB190_5
.LBB190_6:
        add	rbx, 16
        cmp	r13, rbx
        je	.LBB190_7
.LBB190_5:
        mov	rax, qword ptr [r12 + rbx]
        test	rax, rax
        je	.LBB190_6
        mov	rdi, qword ptr [r12 + rbx - 8]
        movzx	ecx, word ptr [r14 + r14 + .L__unnamed_78]
        mov	word ptr [rbp - 56], cx
        mov	qword ptr [rbp - 64], r15
        lea	rsi, [rbp - 64]
        mov	rdx, qword ptr [rbp - 48]
        call	rax
        jmp	.LBB190_6
.LBB190_9:
        mov	esi, 4
        mov	rdi, r14
        call	"debug.FullPanic((function 'defaultPanic')).outOfBounds"
.LBB190_10:
        call	"debug.FullPanic((function 'defaultPanic')).integerOverflow"
.LBB190_11:
        mov	esi, 3
        mov	rdi, rax
        call	"debug.FullPanic((function 'defaultPanic')).outOfBounds"

"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).runtime_read":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 64
        movzx	eax, si
        cmp	ax, 4
        jae	.LBB193_6
        movzx	ecx, word ptr [rax + rax + .L__unnamed_78]
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 16]
        movups	xmm2, xmmword ptr [rdi + 32]
        movups	xmm3, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 16], xmm3
        movaps	xmmword ptr [rbp - 32], xmm2
        movaps	xmmword ptr [rbp - 48], xmm1
        movaps	xmmword ptr [rbp - 64], xmm0
        movzx	eax, word ptr [rcx + rcx + .L__unnamed_79]
        mov	rcx, qword ptr [8*rcx + .L__unnamed_80]
        mov	rdi, rcx
        add	rdi, rax
        jb	.LBB193_7
        cmp	rdi, 10
        jae	.LBB193_8
        sub	rdi, rcx
        cmp	rdi, rax
        jne	.LBB193_9
        lea	rsi, [rcx + rbp]
        add	rsi, -64
        lea	rcx, [rsi + rax]
        lea	rdi, [rdx + rax]
        cmp	rdx, rcx
        setae	cl
        cmp	rsi, rdi
        setae	dil
        or	dil, cl
        je	.LBB193_10
        mov	rdi, rdx
        mov	rdx, rax
        call	memcpy@PLT
        add	rsp, 64
        pop	rbp
        ret
.LBB193_6:
        mov	esi, 4
        mov	rdi, rax
        call	"debug.FullPanic((function 'defaultPanic')).outOfBounds"
.LBB193_7:
        call	"debug.FullPanic((function 'defaultPanic')).integerOverflow"
.LBB193_8:
        mov	esi, 9
        call	"debug.FullPanic((function 'defaultPanic')).outOfBounds"
.LBB193_9:
        call	"debug.FullPanic((function 'defaultPanic')).copyLenMismatch"
.LBB193_10:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).runtime_write":
        push	rbp
        mov	rbp, rsp
        push	r15
        push	r14
        push	r13
        push	r12
        push	rbx
        sub	rsp, 24
        mov	rcx, rdi
        movzx	edi, si
        cmp	di, 4
        jae	.LBB195_8
        mov	rbx, rdx
        movzx	edx, word ptr [rdi + rdi + .L__unnamed_78]
        movzx	r13d, word ptr [rdx + rdx + .L__unnamed_79]
        mov	rax, qword ptr [8*rdx + .L__unnamed_80]
        mov	r15, rax
        add	r15, r13
        jb	.LBB195_9
        mov	dword ptr [rbp - 48], esi
        mov	qword ptr [rbp - 56], rdx
        cmp	r15, 10
        jae	.LBB195_10
        mov	qword ptr [rbp - 64], rcx
        lea	r14, [rcx + rax]
        mov	r12, r15
        sub	r12, rax
        mov	rdi, rbx
        mov	rsi, r13
        mov	rdx, r14
        mov	rcx, r12
        call	mem.eql__anon_3258
        cmp	r12, r13
        jne	.LBB195_11
        mov	byte ptr [rbp - 41], al
        lea	rax, [rbx + r13]
        cmp	r14, rax
        mov	r12, qword ptr [rbp - 64]
        jae	.LBB195_6
        add	r15, r12
        cmp	rbx, r15
        jb	.LBB195_12
.LBB195_6:
        mov	rdi, r14
        mov	rsi, rbx
        mov	rdx, r13
        call	memcpy@PLT
        test	byte ptr [rbp - 48], 1
        sete	al
        or	al, byte ptr [rbp - 41]
        test	al, 1
        je	.LBB195_7
        add	rsp, 24
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        ret
.LBB195_7:
        mov	rdi, r12
        mov	rsi, qword ptr [rbp - 56]
        mov	rdx, rbx
        mov	rcx, r12
        add	rsp, 24
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        jmp	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
.LBB195_8:
        mov	esi, 4
        call	"debug.FullPanic((function 'defaultPanic')).outOfBounds"
.LBB195_9:
        call	"debug.FullPanic((function 'defaultPanic')).integerOverflow"
.LBB195_10:
        mov	esi, 9
        mov	rdi, r15
        call	"debug.FullPanic((function 'defaultPanic')).outOfBounds"
.LBB195_11:
        call	"debug.FullPanic((function 'defaultPanic')).copyLenMismatch"
.LBB195_12:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

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
        je	.LBB205_1
        mov	rdi, qword ptr [r15 + 136]
        mov	word ptr [rbp - 32], 31
        mov	qword ptr [rbp - 40], r14
        lea	rsi, [rbp - 40]
        mov	rdx, rbx
        call	rax
.LBB205_1:
        mov	rax, qword ptr [r15 + 160]
        test	rax, rax
        je	.LBB205_3
        mov	rdi, qword ptr [r15 + 152]
        mov	word ptr [rbp - 32], 31
        mov	qword ptr [rbp - 40], r14
        lea	rsi, [rbp - 40]
        mov	rdx, rbx
        call	rax
.LBB205_3:
        mov	rax, qword ptr [r15 + 176]
        test	rax, rax
        je	.LBB205_5
        mov	rdi, qword ptr [r15 + 168]
        mov	word ptr [rbp - 32], 31
        mov	qword ptr [rbp - 40], r14
        lea	rsi, [rbp - 40]
        mov	rdx, rbx
        call	rax
.LBB205_5:
        add	rsp, 24
        pop	rbx
        pop	r14
        pop	r15
        pop	rbp
        ret

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish":
        test	rsi, rsi
        je	.LBB212_2
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rax, rsi
        mov	word ptr [rbp - 8], 1
        mov	qword ptr [rbp - 16], rdx
        lea	rsi, [rbp - 16]
        mov	rdx, rcx
        call	rax
        add	rsp, 16
        pop	rbp
.LBB212_2:
        ret

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish.2":
        test	rsi, rsi
        je	.LBB232_2
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rax, rsi
        mov	word ptr [rbp - 8], 0
        mov	qword ptr [rbp - 16], rdx
        lea	rsi, [rbp - 16]
        mov	rdx, rcx
        call	rax
        add	rsp, 16
        pop	rbp
.LBB232_2:
        ret

