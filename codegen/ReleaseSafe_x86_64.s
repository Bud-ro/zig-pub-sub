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

"debug.FullPanic((function 'defaultPanic')).memcpyAlias":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rax, qword ptr [rbp + 8]
        mov	qword ptr [rbp - 16], rax
        mov	byte ptr [rbp - 8], 1
        lea	rdx, [rbp - 16]
        mov	edi, offset __anon_1137
        mov	esi, 23
        call	debug.defaultPanic

debug.defaultPanic:
        push	rbp
        mov	rbp, rsp
        push	r15
        push	r14
        push	r13
        push	r12
        push	rbx
        sub	rsp, 2392
        mov	rbx, rdx
        mov	r14, rsi
        mov	r15, rdi
        mov	qword ptr [rbp - 2096], 0
        mov	qword ptr [rbp - 2088], 67108864
        mov	qword ptr [rbp - 2080], offset os.linux.x86_64.restore_rt
        mov	qword ptr [rbp - 2072], 0
        xor	r8d, r8d
        lea	rsi, [rbp - 2096]
        mov	eax, 13
        mov	edi, 11
        mov	r10d, 8
        xor	edx, edx
        #APP
        syscall
        #NO_APP
        mov	ecx, eax
        neg	ecx
        test	ax, ax
        cmove	ecx, r8d
        cmp	rax, -4095
        cmovb	ecx, r8d
        test	cx, cx
        jne	.LBB4_1
        mov	qword ptr [rbp - 2096], 0
        mov	qword ptr [rbp - 2088], 67108864
        mov	qword ptr [rbp - 2080], offset os.linux.x86_64.restore_rt
        mov	qword ptr [rbp - 2072], 0
        mov	eax, 13
        mov	edi, 4
        xor	edx, edx
        #APP
        syscall
        #NO_APP
        mov	ecx, eax
        neg	ecx
        test	ax, ax
        cmove	ecx, r8d
        cmp	rax, -4095
        cmovb	ecx, r8d
        test	cx, cx
        jne	.LBB4_1
        mov	qword ptr [rbp - 2096], 0
        mov	qword ptr [rbp - 2088], 67108864
        mov	qword ptr [rbp - 2080], offset os.linux.x86_64.restore_rt
        mov	qword ptr [rbp - 2072], 0
        xor	r8d, r8d
        mov	eax, 13
        mov	edi, 7
        xor	edx, edx
        #APP
        syscall
        #NO_APP
        mov	ecx, eax
        neg	ecx
        test	ax, ax
        cmove	ecx, r8d
        cmp	rax, -4095
        cmovb	ecx, r8d
        test	cx, cx
        jne	.LBB4_1
        mov	qword ptr [rbp - 2096], 0
        mov	qword ptr [rbp - 2088], 67108864
        mov	qword ptr [rbp - 2080], offset os.linux.x86_64.restore_rt
        mov	qword ptr [rbp - 2072], 0
        mov	eax, 13
        mov	edi, 8
        xor	edx, edx
        #APP
        syscall
        #NO_APP
        mov	ecx, eax
        neg	ecx
        test	ax, ax
        cmove	ecx, r8d
        cmp	rax, -4095
        cmovb	ecx, r8d
        test	cx, cx
        jne	.LBB4_1
        mov	rax, qword ptr fs:[debug.panic_stage@TPOFF]
        cmp	rax, 1
        jne	.LBB4_6
        mov	qword ptr fs:[debug.panic_stage@TPOFF], 2
        xor	r8d, r8d
        xor	r9d, r9d
        mov	edi, 2
.LBB4_61:
        lea	rsi, [r9 + __anon_4234]
        mov	edx, 32
        sub	rdx, r9
.LBB4_62:
        mov	eax, 1
        #APP
        syscall
        #NO_APP
        mov	ecx, eax
        neg	ecx
        cmp	rax, -4095
        cmovb	ecx, r8d
        cmp	cx, 4
        je	.LBB4_62
        movzx	ecx, cx
        cmp	ecx, 122
        ja	.LBB4_67
        mov	ecx, ecx
        jmp	qword ptr [8*rcx + .LJTI4_0]
.LBB4_65:
        add	r9, rax
        jb	.LBB4_13
        cmp	r9, 32
        jb	.LBB4_61
        jmp	.LBB4_67
.LBB4_6:
        test	rax, rax
        jne	.LBB4_67
        mov	qword ptr fs:[debug.panic_stage@TPOFF], 1
        lock		add	byte ptr [rip + debug.panicking], 1
        cmp	byte ptr fs:[Thread.LinuxThreadImpl.tls_thread_id.1@TPOFF], 1
        jne	.LBB4_9
        mov	r12d, dword ptr fs:[Thread.LinuxThreadImpl.tls_thread_id.0@TPOFF]
        cmp	dword ptr [rip + Progress.stderr_mutex+12], r12d
        je	.LBB4_11
.LBB4_14:
        lock		bts	dword ptr [rip + Progress.stderr_mutex+8], 0
        jae	.LBB4_16
        call	Thread.Mutex.FutexImpl.lockSlow
.LBB4_16:
        cmp	qword ptr [rip + Progress.stderr_mutex], 0
        jne	.LBB4_236
        mov	dword ptr [rip + Progress.stderr_mutex+12], r12d
        xor	eax, eax
        jmp	.LBB4_12
.LBB4_9:
        mov	eax, 186
        #APP
        syscall
        #NO_APP
        mov	r12, rax
        mov	dword ptr fs:[Thread.LinuxThreadImpl.tls_thread_id.0@TPOFF], r12d
        mov	byte ptr fs:[Thread.LinuxThreadImpl.tls_thread_id.1@TPOFF], 1
        cmp	dword ptr [rip + Progress.stderr_mutex+12], r12d
        jne	.LBB4_14
.LBB4_11:
        mov	rax, qword ptr [rip + Progress.stderr_mutex]
.LBB4_12:
        inc	rax
        je	.LBB4_13
        movabs	r12, -6148914691236517206
        mov	qword ptr [rip + Progress.stderr_mutex], rax
        mov	rax, qword ptr [rip + Progress.stderr_file_writer+8]
        mov	edi, offset Progress.stderr_file_writer+8
        call	qword ptr [rax + 16]
        mov	qword ptr [rip + Progress.stderr_file_writer+16], r12
        mov	qword ptr [rip + Progress.stderr_file_writer+24], 0
        cmp	byte ptr fs:[Thread.LinuxThreadImpl.tls_thread_id.1@TPOFF], 1
        jne	.LBB4_20
        mov	eax, dword ptr fs:[Thread.LinuxThreadImpl.tls_thread_id.0@TPOFF]
        mov	qword ptr [rbp - 56], rax
        jmp	.LBB4_21
.LBB4_20:
        mov	eax, 186
        #APP
        syscall
        #NO_APP
        mov	qword ptr [rbp - 56], rax
        mov	dword ptr fs:[Thread.LinuxThreadImpl.tls_thread_id.0@TPOFF], eax
        mov	byte ptr fs:[Thread.LinuxThreadImpl.tls_thread_id.1@TPOFF], 1
.LBB4_21:
        mov	rdi, qword ptr [rip + Progress.stderr_file_writer+32]
        xor	r12d, r12d
.LBB4_22:
        mov	r13, r12
        xor	r13, 7
        mov	rax, rdi
        add	rax, r13
        jb	.LBB4_13
        lea	rsi, [r12 + __anon_4689]
        cmp	rax, qword ptr [rip + Progress.stderr_file_writer+24]
        ja	.LBB4_28
        add	rdi, qword ptr [rip + Progress.stderr_file_writer+16]
        cmp	rdi, offset __anon_4689+7
        jae	.LBB4_26
        lea	rax, [rdi + r13]
        cmp	rsi, rax
        jb	.LBB4_239
.LBB4_26:
        mov	rdx, r13
        call	memcpy@PLT
        mov	rdi, qword ptr [rip + Progress.stderr_file_writer+32]
        add	rdi, r13
        jb	.LBB4_13
        mov	qword ptr [rip + Progress.stderr_file_writer+32], rdi
        add	r12, r13
        jb	.LBB4_13
.LBB4_31:
        cmp	r12, 7
        jb	.LBB4_22
        jmp	.LBB4_32
.LBB4_28:
        mov	rax, qword ptr [rip + Progress.stderr_file_writer+8]
        mov	rax, qword ptr [rax]
        mov	qword ptr [rbp - 1120], rsi
        mov	qword ptr [rbp - 1112], r13
        mov	esi, offset Progress.stderr_file_writer+8
        mov	ecx, 1
        mov	r8d, 1
        lea	rdi, [rbp - 2096]
        lea	rdx, [rbp - 1120]
        call	rax
        cmp	word ptr [rbp - 2088], 0
        jne	.LBB4_67
        mov	r13, qword ptr [rbp - 2096]
        mov	rdi, qword ptr [rip + Progress.stderr_file_writer+32]
        add	r12, r13
        jae	.LBB4_31
        jmp	.LBB4_13
.LBB4_32:
        mov	rcx, qword ptr [rbp - 56]
        mov	edx, ecx
        movaps	xmm0, xmmword ptr [rip + .LCPI4_0]
        movaps	xmmword ptr [rbp - 2048], xmm0
        movaps	xmmword ptr [rbp - 2064], xmm0
        movaps	xmmword ptr [rbp - 2080], xmm0
        movaps	xmmword ptr [rbp - 2096], xmm0
        mov	byte ptr [rbp - 2032], -86
        mov	eax, 65
        cmp	ecx, 100
        jb	.LBB4_33
        mov	esi, 65
.LBB4_35:
        mov	rax, rsi
        sub	rax, 2
        jb	.LBB4_13
        mov	ecx, edx
        imul	rcx, rcx, 1374389535
        shr	rcx, 37
        imul	edi, ecx, 100
        mov	r8d, edx
        sub	r8d, edi
        movzx	edi, word ptr [r8 + r8 + __anon_15010]
        mov	word ptr [rbp + rax - 2096], di
        add	rsi, -2
        cmp	rdx, 9999
        mov	rdx, rcx
        ja	.LBB4_35
        cmp	ecx, 10
        jae	.LBB4_40
.LBB4_38:
        sub	rax, 1
        jb	.LBB4_13
        or	cl, 48
        mov	byte ptr [rbp + rax - 2096], cl
        jmp	.LBB4_42
.LBB4_33:
        mov	rcx, rdx
        cmp	ecx, 10
        jb	.LBB4_38
.LBB4_40:
        sub	rax, 2
        jb	.LBB4_13
        movzx	ecx, word ptr [rcx + rcx + __anon_15010]
        mov	word ptr [rbp + rax - 2096], cx
.LBB4_42:
        mov	ecx, 65
        sub	rcx, rax
        lea	rsi, [rax + rbp]
        add	rsi, -2096
        movzx	r8d, byte ptr [rip + .L__unnamed_1+32]
        mov	edi, offset Progress.stderr_file_writer+8
        mov	rdx, rcx
        mov	dword ptr [rbp - 84], r8d
        call	Io.Writer.alignBuffer
        test	ax, ax
        jne	.LBB4_67
        mov	rdi, qword ptr [rip + Progress.stderr_file_writer+32]
        xor	r13d, r13d
.LBB4_44:
        mov	r12d, 8
        sub	r12, r13
        mov	rax, rdi
        add	rax, r12
        jb	.LBB4_13
        lea	rsi, [r13 + __anon_4726]
        cmp	rax, qword ptr [rip + Progress.stderr_file_writer+24]
        ja	.LBB4_50
        add	rdi, qword ptr [rip + Progress.stderr_file_writer+16]
        cmp	rdi, offset __anon_4726+8
        jae	.LBB4_48
        lea	rax, [rdi + r12]
        cmp	rsi, rax
        jb	.LBB4_239
.LBB4_48:
        mov	rdx, r12
        call	memcpy@PLT
        mov	rdi, qword ptr [rip + Progress.stderr_file_writer+32]
        add	rdi, r12
        jb	.LBB4_13
        mov	qword ptr [rip + Progress.stderr_file_writer+32], rdi
        add	r13, r12
        jb	.LBB4_13
.LBB4_53:
        cmp	r13, 8
        jb	.LBB4_44
        jmp	.LBB4_54
.LBB4_50:
        mov	rax, qword ptr [rip + Progress.stderr_file_writer+8]
        mov	rax, qword ptr [rax]
        mov	qword ptr [rbp - 1120], rsi
        mov	qword ptr [rbp - 1112], r12
        mov	esi, offset Progress.stderr_file_writer+8
        mov	ecx, 1
        mov	r8d, 1
        lea	rdi, [rbp - 2096]
        lea	rdx, [rbp - 1120]
        call	rax
        cmp	word ptr [rbp - 2088], 0
        jne	.LBB4_67
        mov	r12, qword ptr [rbp - 2096]
        mov	rdi, qword ptr [rip + Progress.stderr_file_writer+32]
        add	r13, r12
        jae	.LBB4_53
        jmp	.LBB4_13
.LBB4_54:
        mov	edi, offset Progress.stderr_file_writer+8
        mov	rsi, r15
        mov	rdx, r14
        mov	rcx, r14
        mov	r8d, dword ptr [rbp - 84]
        call	Io.Writer.alignBuffer
        test	ax, ax
        jne	.LBB4_67
        lea	r15, [rbp - 2096]
        lea	r14, [rbp - 1120]
        movabs	r9, -6148914691236517206
.LBB4_56:
        mov	rdi, qword ptr [rip + Progress.stderr_file_writer+32]
        mov	rax, rdi
        inc	rax
        je	.LBB4_13
        mov	rsi, qword ptr [rip + Progress.stderr_file_writer+24]
        cmp	rax, rsi
        jbe	.LBB4_58
        mov	rax, qword ptr [rip + Progress.stderr_file_writer+8]
        mov	rax, qword ptr [rax]
        mov	qword ptr [rbp - 1120], offset __anon_4810
        mov	qword ptr [rbp - 1112], 1
        mov	esi, offset Progress.stderr_file_writer+8
        mov	ecx, 1
        mov	r8d, 1
        mov	rdi, r15
        mov	rdx, r14
        call	rax
        cmp	word ptr [rbp - 2088], 0
        jne	.LBB4_67
        cmp	qword ptr [rbp - 2096], 0
        movabs	r9, -6148914691236517206
        je	.LBB4_56
        jmp	.LBB4_73
.LBB4_58:
        cmp	rdi, rsi
        jae	.LBB4_59
        add	rdi, qword ptr [rip + Progress.stderr_file_writer+16]
        lea	rax, [rdi + 1]
        cmp	rdi, offset __anon_4810+1
        setb	cl
        cmp	rax, offset __anon_4810
        seta	al
        test	cl, al
        jne	.LBB4_239
        mov	byte ptr [rdi], 10
        mov	rax, qword ptr [rip + Progress.stderr_file_writer+32]
        inc	rax
        je	.LBB4_13
        mov	qword ptr [rip + Progress.stderr_file_writer+32], rax
.LBB4_73:
        cmp	byte ptr [rbx + 8], 0
        jne	.LBB4_74
        mov	rax, qword ptr [rbp + 8]
        mov	qword ptr [rbp - 792], rax
        lea	r15, [rbp - 792]
        jmp	.LBB4_75
.LBB4_74:
        mov	rax, qword ptr [rbx]
        mov	qword ptr [rbp - 776], rax
        lea	r15, [rbp - 776]
.LBB4_75:
        mov	byte ptr [r15 + 8], 1
        cmp	byte ptr [rip + debug.self_debug_info+56], 0
        jne	.LBB4_79
        cmp	byte ptr [rip + debug.debug_info_allocator.2], 0
        jne	.LBB4_78
        movups	xmm0, xmmword ptr [rip + .L__unnamed_2]
        movaps	xmmword ptr [rbp - 2096], xmm0
        xorps	xmm0, xmm0
        lea	rax, [rbp - 2080]
        movups	xmmword ptr [rax], xmm0
        movaps	xmm0, xmmword ptr [rbp - 2096]
        movaps	xmm1, xmmword ptr [rbp - 2080]
        movups	xmmword ptr [rip + debug.debug_info_arena_allocator+16], xmm1
        movups	xmmword ptr [rip + debug.debug_info_arena_allocator], xmm0
        mov	byte ptr [rip + debug.debug_info_allocator.2], 1
.LBB4_78:
        mov	qword ptr [rip + debug.self_debug_info], offset debug.debug_info_arena_allocator
        mov	qword ptr [rip + debug.self_debug_info+8], offset __anon_7971
        xorps	xmm0, xmm0
        movups	xmmword ptr [rip + debug.self_debug_info+16], xmm0
        mov	qword ptr [rip + debug.self_debug_info+32], 0
        mov	qword ptr [rip + debug.self_debug_info+40], offset debug.debug_info_arena_allocator
        mov	qword ptr [rip + debug.self_debug_info+48], offset __anon_7971
        mov	byte ptr [rip + debug.self_debug_info+56], 1
.LBB4_79:
        lea	rdx, [rbp - 2096]
        xor	r8d, r8d
        mov	edi, 2
        mov	esi, 21523
.LBB4_80:
        mov	qword ptr [rbp - 2096], r9
        mov	eax, 16
        #APP
        syscall
        #NO_APP
        mov	ecx, eax
        neg	ecx
        cmp	rax, -4095
        cmovb	ecx, r8d
        cmp	cx, 4
        je	.LBB4_80
        movzx	eax, cx
        test	eax, eax
        jne	.LBB4_82
        mov	edi, offset __anon_15054
        call	mem.indexOfSentinel__anon_11703
        movzx	ecx, byte ptr [rax + __anon_15054]
        test	cl, cl
        jne	.LBB4_237
        lea	rdi, [rbp - 2096]
        mov	esi, offset __anon_15054
        mov	rdx, rax
        xor	ecx, ecx
        mov	r8d, 61
        call	mem.indexOfScalarPos__anon_7002
        mov	r12b, 1
        jmp	.LBB4_85
.LBB4_82:
        xor	r12d, r12d
.LBB4_85:
        lea	rbx, [rbp - 2096]
        mov	edx, 936
        mov	rdi, rbx
        mov	esi, 170
        call	memset@PLT
        mov	rdi, rbx
        #APP
        call	os.linux.x86_64.getContextInternal
        #NO_APP
        mov	r13, rbp
        test	rax, rax
        jne	.LBB4_86
        movups	xmm0, xmmword ptr [r15]
        movaps	xmmword ptr [rbp - 192], xmm0
        mov	rdi, qword ptr [rip + debug.self_debug_info]
        mov	rax, qword ptr [rip + debug.self_debug_info+8]
        mov	rcx, qword ptr [rbp - 1928]
        mov	qword ptr [rbp - 56], rcx
        mov	rcx, qword ptr [rbp + 8]
        mov	esi, 936
        mov	edx, 3
        call	qword ptr [rax]
        test	rax, rax
        jne	.LBB4_88
.LBB4_86:
        movups	xmm0, xmmword ptr [r15]
        movaps	xmmword ptr [rbp - 2416], xmm0
        mov	qword ptr [rbp - 2400], r13
        lea	rdi, [rbp - 2392]
        mov	edx, 288
        xor	esi, esi
        call	memset@PLT
        mov	dword ptr [rbp - 2104], -1
        lea	r14, [rbp - 2416]
        jmp	.LBB4_90
.LBB4_88:
        mov	rbx, rax
        mov	edx, 936
        mov	rdi, rax
        mov	esi, 170
        call	memset@PLT
        test	bl, 7
        jne	.LBB4_241
        lea	rsi, [rbp - 2096]
        mov	edx, 936
        mov	rdi, rbx
        call	memcpy@PLT
        movups	xmm0, xmmword ptr [rip + debug.self_debug_info]
        movaps	xmmword ptr [rbp - 288], xmm0
        xorps	xmm1, xmm1
        movaps	xmmword ptr [rbp - 272], xmm1
        mov	byte ptr [rbp - 736], 0
        movaps	xmm2, xmmword ptr [rbp - 192]
        movaps	xmmword ptr [rbp - 1120], xmm2
        movaps	xmmword ptr [rbp - 1072], xmm1
        movaps	xmmword ptr [rbp - 1088], xmm0
        lea	rdi, [rbp - 1040]
        mov	esi, offset .L__unnamed_3
        mov	edx, 184
        call	memcpy@PLT
        movups	xmm0, xmmword ptr [rip + .L__unnamed_4]
        movups	xmmword ptr [rbp - 856], xmm0
        mov	qword ptr [rbp - 840], 0
        mov	qword ptr [rbp - 830], 0
        movzx	eax, byte ptr [rbp - 736]
        mov	dword ptr [rbp - 821], 0
        mov	word ptr [rbp - 817], 256
        mov	qword ptr [rbp - 1104], r13
        mov	qword ptr [rbp - 1096], offset debug.self_debug_info
        mov	rcx, qword ptr [rbp - 56]
        mov	qword ptr [rbp - 1056], rcx
        mov	qword ptr [rbp - 1048], rbx
        mov	word ptr [rbp - 832], -21846
        mov	byte ptr [rbp - 822], al
        mov	byte ptr [rbp - 809], 0
        mov	word ptr [rbp - 811], 0
        mov	dword ptr [rbp - 815], 0
        mov	dword ptr [rbp - 808], -1
        mov	byte ptr [rbp - 800], 1
.LBB4_90:
        lea	r15, [rbp - 656]
        mov	edx, 320
        mov	rdi, r15
        mov	rsi, r14
        call	memcpy@PLT
        movzx	r12d, r12b
        mov	dword ptr [rbp - 44], r12d
        jmp	.LBB4_91
.LBB4_172:
        mov	rdi, r13
        call	debug.SelfInfo.lookupModuleNameDl
        mov	r9, rdx
        test	rax, rax
        mov	ecx, offset __anon_3930
        cmove	rax, rcx
        mov	ecx, 3
        cmove	r9, rcx
        mov	dword ptr [rsp], r12d
        mov	edi, offset .L__unnamed_5
        mov	edx, offset __anon_3930
        mov	rsi, r13
        mov	r8, rax
        call	debug.printLineInfo__anon_4076
        mov	r14d, eax
.LBB4_173:
        test	r14w, r14w
        jne	.LBB4_174
.LBB4_91:
        lea	rdi, [rbp - 192]
        mov	rsi, r15
        call	debug.StackIterator.next_internal
        cmp	byte ptr [rbp - 184], 0
        lea	r14, [rbp - 288]
        je	.LBB4_185
        mov	r13, qword ptr [rbp - 192]
        cmp	byte ptr [rbp - 648], 0
        je	.LBB4_98
        mov	rbx, qword ptr [rbp - 656]
        cmp	r13, rbx
        je	.LBB4_97
.LBB4_94:
        mov	rdi, r14
        mov	rsi, r15
        call	debug.StackIterator.next_internal
        cmp	byte ptr [rbp - 280], 0
        je	.LBB4_185
        cmp	qword ptr [rbp - 288], rbx
        jne	.LBB4_94
        mov	r13, rbx
.LBB4_97:
        xorps	xmm0, xmm0
        movaps	xmmword ptr [rbp - 656], xmm0
.LBB4_98:
        cmp	byte ptr [rbp - 352], 0
        je	.LBB4_101
        movzx	esi, word ptr [rbp - 360]
        test	si, si
        je	.LBB4_101
        mov	word ptr [rbp - 360], 0
        mov	rdi, qword ptr [rbp - 592]
        mov	edx, r12d
        call	debug.printUnwindError
.LBB4_101:
        sub	r13, 1
        mov	eax, 0
        cmovb	r13, rax
        mov	esi, offset debug.self_debug_info
        lea	rdi, [rbp - 672]
        mov	rdx, r13
        call	debug.SelfInfo.getModuleForAddress
        movzx	r14d, word ptr [rbp - 664]
        cmp	r14d, 32
        je	.LBB4_172
        cmp	r14d, 23
        je	.LBB4_172
        test	r14d, r14d
        jne	.LBB4_173
        mov	rbx, qword ptr [rbp - 672]
        mov	r12, r13
        sub	r12, qword ptr [rbx]
        jb	.LBB4_13
        lea	rsi, [rbx + 8]
        lea	rdi, [rbp - 688]
        mov	qword ptr [rbp - 112], rsi
        mov	rdx, r12
        call	debug.Dwarf.findCompileUnit
        movzx	r14d, word ptr [rbp - 680]
        cmp	r14d, 32
        je	.LBB4_162
        cmp	r14d, 23
        je	.LBB4_162
        test	r14d, r14d
        jne	.LBB4_168
        mov	rax, qword ptr [rbx + 736]
        test	rax, rax
        je	.LBB4_109
        mov	rcx, qword ptr [rbx + 728]
        add	rcx, 32
        lea	r14, [rbp - 288]
        jmp	.LBB4_111
.LBB4_112:
        add	rcx, 40
        add	rax, -1
        je	.LBB4_113
.LBB4_111:
        cmp	byte ptr [rcx - 16], 0
        je	.LBB4_112
        cmp	r12, qword ptr [rcx - 32]
        jb	.LBB4_112
        cmp	r12, qword ptr [rcx - 24]
        jae	.LBB4_112
        mov	rax, qword ptr [rcx - 8]
        mov	rcx, qword ptr [rcx]
        jmp	.LBB4_117
.LBB4_162:
        xorps	xmm0, xmm0
        movaps	xmmword ptr [rbp - 320], xmm0
        movaps	xmmword ptr [rbp - 336], xmm0
        mov	qword ptr [rbp - 304], 0
        mov	r10d, 3
        mov	edx, offset __anon_3930
        mov	r8d, offset __anon_3930
        mov	r9d, 3
        mov	r12d, dword ptr [rbp - 44]
        jmp	.LBB4_163
.LBB4_113:
        xor	eax, eax
        xor	ecx, ecx
        jmp	.LBB4_117
.LBB4_109:
        xor	eax, eax
        xor	ecx, ecx
        lea	r14, [rbp - 288]
.LBB4_117:
        test	rax, rax
        mov	esi, offset __anon_3930
        mov	edx, offset __anon_3930
        mov	qword ptr [rbp - 56], rdx
        cmove	rax, rsi
        mov	qword ptr [rbp - 72], rax
        mov	edx, 3
        mov	eax, 3
        mov	qword ptr [rbp - 80], rax
        cmove	rcx, rdx
        mov	qword ptr [rbp - 64], rcx
        cmp	byte ptr [rbx + 144], 0
        je	.LBB4_118
        mov	r8, qword ptr [rbx + 104]
        mov	r9, qword ptr [rbx + 112]
        jmp	.LBB4_120
.LBB4_118:
        xor	r8d, r8d
        xor	r9d, r9d
.LBB4_120:
        mov	rsi, qword ptr [rbp - 688]
        mov	qword ptr [rsp], rsi
        mov	ecx, 3
        lea	rdi, [rbp - 760]
        mov	qword ptr [rbp - 96], rsi
        mov	rbx, qword ptr [rbp - 112]
        mov	rdx, rbx
        call	debug.Dwarf.Die.getAttrString
        movzx	eax, word ptr [rbp - 744]
        test	eax, eax
        je	.LBB4_160
        cmp	eax, 32
        je	.LBB4_122
        cmp	eax, 23
        mov	rdx, qword ptr [rbp - 96]
        je	.LBB4_124
        jmp	.LBB4_161
.LBB4_122:
        mov	rdx, qword ptr [rbp - 96]
.LBB4_124:
        cmp	byte ptr [rdx + 176], 0
        je	.LBB4_125
.LBB4_127:
        mov	r14, qword ptr [rdx + 112]
        movabs	rax, 1537228672809129302
        cmp	r14, rax
        jb	.LBB4_128
        jmp	.LBB4_13
.LBB4_160:
        mov	rax, qword ptr [rbp - 760]
        mov	qword ptr [rbp - 56], rax
        mov	rax, qword ptr [rbp - 752]
        mov	qword ptr [rbp - 80], rax
        mov	rdx, qword ptr [rbp - 96]
        cmp	byte ptr [rdx + 176], 0
        jne	.LBB4_127
.LBB4_125:
        mov	rdi, r14
        mov	rsi, rbx
        mov	rbx, rdx
        call	debug.Dwarf.runLineNumberProgram
        movzx	r14d, word ptr [rbp - 208]
        test	r14w, r14w
        jne	.LBB4_156
        lea	rax, [rbx + 96]
        movaps	xmm0, xmmword ptr [rbp - 224]
        movups	xmmword ptr [rax + 64], xmm0
        movaps	xmm0, xmmword ptr [rbp - 288]
        movaps	xmm1, xmmword ptr [rbp - 272]
        movaps	xmm2, xmmword ptr [rbp - 256]
        movaps	xmm3, xmmword ptr [rbp - 240]
        movups	xmmword ptr [rax + 48], xmm3
        movups	xmmword ptr [rax + 32], xmm2
        movups	xmmword ptr [rax + 16], xmm1
        movups	xmmword ptr [rax], xmm0
        mov	byte ptr [rbx + 176], 1
        mov	rdx, rbx
        mov	r14, qword ptr [rdx + 112]
        movabs	rax, 1537228672809129302
        cmp	r14, rax
        jae	.LBB4_13
.LBB4_128:
        mov	r8, qword ptr [rdx + 96]
        mov	rsi, qword ptr [rdx + 104]
        test	r14, r14
        je	.LBB4_129
        test	r8b, 7
        jne	.LBB4_241
        mov	r9, r8
        mov	rax, rsi
        test	rax, rax
        jne	.LBB4_133
        jmp	.LBB4_155
.LBB4_129:
        movabs	r9, -6148914691236517206
        xor	eax, eax
        test	rax, rax
        je	.LBB4_155
.LBB4_133:
        xor	edi, edi
        mov	r10, rax
        jmp	.LBB4_134
.LBB4_141:
        mov	r10, rcx
        cmp	rdi, rcx
        jae	.LBB4_145
.LBB4_134:
        mov	rcx, r10
        sub	rcx, rdi
        shr	rcx
        add	rcx, rdi
        jb	.LBB4_13
        cmp	rcx, rax
        jae	.LBB4_142
        mov	rbx, qword ptr [r9 + 8*rcx]
        mov	r11b, 2
        cmp	r12, rbx
        je	.LBB4_140
        mov	r11b, 1
        jb	.LBB4_140
        jbe	.LBB4_236
        xor	r11d, r11d
.LBB4_140:
        mov	byte ptr [rbp - 288], r11b
        movzx	r11d, r11b
        jmp	qword ptr [8*r11 + .LJTI4_1]
.LBB4_143:
        mov	rdi, rcx
        add	rdi, 1
        mov	rcx, r10
        cmp	rdi, rcx
        jb	.LBB4_134
.LBB4_145:
        test	rdi, rdi
        mov	r9, qword ptr [rbp - 96]
        je	.LBB4_155
        test	r14, r14
        je	.LBB4_147
        lea	rax, [r8 + 8*r14]
        test	al, 3
        je	.LBB4_149
        jmp	.LBB4_241
.LBB4_147:
        movabs	rax, -6148914691236517206
        xor	esi, esi
.LBB4_149:
        add	rdi, -1
        cmp	rdi, rsi
        jae	.LBB4_238
        lea	rcx, [rdi + 2*rdi]
        mov	edx, dword ptr [rax + 4*rcx + 8]
        cmp	word ptr [r9 + 168], 5
        sbb	edx, 0
        jb	.LBB4_13
        mov	esi, edx
        cmp	qword ptr [r9 + 160], rsi
        jbe	.LBB4_155
        mov	rdx, qword ptr [r9 + 152]
        imul	rdi, rsi, 56
        mov	esi, dword ptr [rdx + rdi + 32]
        cmp	qword ptr [r9 + 144], rsi
        jbe	.LBB4_155
        movsd	xmm0, qword ptr [rax + 4*rcx]
        movaps	xmmword ptr [rbp - 112], xmm0
        add	rdx, rdi
        mov	rax, qword ptr [r9 + 136]
        imul	rcx, rsi, 56
        movups	xmm0, xmmword ptr [rax + rcx]
        movups	xmm1, xmmword ptr [rdx]
        movups	xmmword ptr [rbp - 1152], xmm0
        movups	xmmword ptr [rbp - 1136], xmm1
        mov	esi, offset debug.self_debug_info
        mov	ecx, 2
        lea	rdi, [rbp - 288]
        lea	rdx, [rbp - 1152]
        call	fs.path.joinSepMaybeZ__anon_4031
        movzx	r14d, word ptr [rbp - 272]
        test	r14w, r14w
        jne	.LBB4_156
        mov	rax, qword ptr [rbp - 288]
        mov	rcx, qword ptr [rbp - 280]
        movaps	xmm0, xmmword ptr [rbp - 112]
        unpcklps	xmm0, xmmword ptr [rip + .LCPI4_1]
        movaps	xmmword ptr [rbp - 736], xmm0
        mov	qword ptr [rbp - 720], rax
        mov	qword ptr [rbp - 712], rcx
        mov	byte ptr [rbp - 704], 1
        lea	rax, [rbp - 736]
        jmp	.LBB4_157
.LBB4_155:
        mov	eax, offset .L__unnamed_5
.LBB4_157:
        mov	r12d, dword ptr [rbp - 44]
        mov	rdx, qword ptr [rbp - 72]
        mov	r10, qword ptr [rbp - 64]
.LBB4_159:
        mov	rcx, qword ptr [rax + 32]
        mov	qword ptr [rbp - 304], rcx
        movups	xmm0, xmmword ptr [rax]
        movups	xmm1, xmmword ptr [rax + 16]
        movaps	xmmword ptr [rbp - 320], xmm1
        movaps	xmmword ptr [rbp - 336], xmm0
        mov	r8, qword ptr [rbp - 56]
        mov	r9, qword ptr [rbp - 80]
.LBB4_163:
        mov	qword ptr [rbp - 192], rdx
        mov	qword ptr [rbp - 184], r10
        mov	qword ptr [rbp - 176], r8
        mov	qword ptr [rbp - 168], r9
        mov	rax, qword ptr [rbp - 304]
        lea	rdi, [rbp - 160]
        mov	qword ptr [rdi + 32], rax
        movaps	xmm0, xmmword ptr [rbp - 336]
        movaps	xmm1, xmmword ptr [rbp - 320]
        movups	xmmword ptr [rdi + 16], xmm1
        movups	xmmword ptr [rdi], xmm0
        mov	word ptr [rbp - 120], 0
        mov	word ptr [rdi + 46], 0
        mov	dword ptr [rdi + 42], 0
.LBB4_164:
        mov	dword ptr [rsp], r12d
        mov	rsi, r13
        mov	qword ptr [rbp - 72], rdx
        mov	qword ptr [rbp - 64], r10
        mov	rcx, r10
        mov	qword ptr [rbp - 56], r8
        mov	qword ptr [rbp - 80], r9
        call	debug.printLineInfo__anon_4076
        mov	r14d, eax
        cmp	byte ptr [rbp - 128], 0
        je	.LBB4_173
        mov	r12, qword ptr [rbp - 136]
        test	r12, r12
        je	.LBB4_167
        mov	r13, qword ptr [rbp - 144]
        mov	rbx, qword ptr [rip + debug.self_debug_info+8]
        mov	rax, qword ptr [rip + debug.self_debug_info]
        mov	qword ptr [rbp - 112], rax
        mov	rdi, r13
        mov	esi, 170
        mov	rdx, r12
        call	memset@PLT
        mov	r8, qword ptr [rbp + 8]
        mov	rdi, qword ptr [rbp - 112]
        mov	rsi, r13
        mov	rdx, r12
        xor	ecx, ecx
        call	qword ptr [rbx + 24]
.LBB4_167:
        mov	r12d, dword ptr [rbp - 44]
        jmp	.LBB4_173
.LBB4_156:
        mov	eax, offset .L__unnamed_5
        cmp	r14w, 23
        je	.LBB4_157
        movzx	ecx, r14w
        cmp	ecx, 32
        mov	r12d, dword ptr [rbp - 44]
        mov	rdx, qword ptr [rbp - 72]
        mov	r10, qword ptr [rbp - 64]
        je	.LBB4_159
.LBB4_168:
        mov	rdx, qword ptr [rbp - 72]
        mov	qword ptr [rbp - 192], rdx
        mov	r10, qword ptr [rbp - 64]
        mov	qword ptr [rbp - 184], r10
        mov	rax, qword ptr [rbp - 56]
        mov	qword ptr [rbp - 176], rax
        mov	rax, qword ptr [rbp - 80]
        mov	qword ptr [rbp - 168], rax
        mov	word ptr [rbp - 120], r14w
        lea	rdi, [rbp - 160]
        mov	word ptr [rdi + 46], 0
        mov	dword ptr [rdi + 42], 0
        test	r14w, r14w
        je	.LBB4_169
        movzx	eax, r14w
        cmp	eax, 23
        mov	r12d, dword ptr [rbp - 44]
        je	.LBB4_172
        cmp	eax, 32
        je	.LBB4_172
        jmp	.LBB4_173
.LBB4_169:
        mov	r12d, dword ptr [rbp - 44]
        mov	r8, qword ptr [rbp - 56]
        mov	r9, qword ptr [rbp - 80]
        jmp	.LBB4_164
.LBB4_185:
        cmp	byte ptr [rbp - 352], 0
        je	.LBB4_188
        movzx	esi, word ptr [rbp - 360]
        test	si, si
        je	.LBB4_188
        mov	word ptr [rbp - 360], 0
        mov	rdi, qword ptr [rbp - 592]
        mov	edx, r12d
        call	debug.printUnwindError
.LBB4_188:
        movsxd	rdi, dword ptr [rbp - 344]
        cmp	rdi, -3
        ja	.LBB4_190
        mov	eax, 3
        #APP
        syscall
        #NO_APP
        cmp	rax, -4095
        setb	cl
        cmp	ax, -9
        setne	al
        or	al, cl
        je	.LBB4_236
.LBB4_190:
        mov	dword ptr [rbp - 344], -1431655766
        cmp	byte ptr [rbp - 352], 0
        je	.LBB4_225
        mov	rbx, qword ptr [rbp - 624]
        mov	r13, qword ptr [rbp - 616]
        mov	r14, qword ptr [rbp - 536]
        test	r14, r14
        jne	.LBB4_193
        movabs	r15, -6148914691236517206
        xor	r14d, r14d
        jmp	.LBB4_195
.LBB4_193:
        mov	rax, r14
        shr	rax, 60
        jne	.LBB4_13
        mov	r15, qword ptr [rbp - 552]
        shl	r14, 4
.LBB4_195:
        lea	r12, [rbp - 552]
        test	r14, r14
        je	.LBB4_197
        mov	rdi, r15
        mov	esi, 170
        mov	rdx, r14
        call	memset@PLT
        mov	r8, qword ptr [rbp + 8]
        mov	rdi, rbx
        mov	rsi, r15
        mov	rdx, r14
        mov	ecx, 3
        call	qword ptr [r13 + 24]
        mov	rbx, qword ptr [rbp - 624]
        mov	r13, qword ptr [rbp - 616]
.LBB4_197:
        movaps	xmm0, xmmword ptr [rip + .LCPI4_0]
        movabs	r15, -6148914691236517206
        mov	qword ptr [r12 + 16], r15
        movups	xmmword ptr [r12], xmm0
        mov	r14, qword ptr [rbp - 560]
        test	r14, r14
        jne	.LBB4_199
        xor	r14d, r14d
        jmp	.LBB4_201
.LBB4_199:
        mov	rax, r14
        shr	rax, 59
        jne	.LBB4_13
        mov	r15, qword ptr [rbp - 576]
        shl	r14, 5
.LBB4_201:
        lea	r12, [rbp - 576]
        test	r14, r14
        je	.LBB4_203
        mov	rdi, r15
        mov	esi, 170
        mov	rdx, r14
        call	memset@PLT
        mov	r8, qword ptr [rbp + 8]
        mov	rdi, rbx
        mov	rsi, r15
        mov	rdx, r14
        mov	ecx, 3
        call	qword ptr [r13 + 24]
        movaps	xmm0, xmmword ptr [rip + .LCPI4_0]
        mov	rbx, qword ptr [rbp - 624]
        mov	r13, qword ptr [rbp - 616]
.LBB4_203:
        movabs	r14, -6148914691236517206
        mov	qword ptr [r12 + 176], r14
        movups	xmmword ptr [r12 + 160], xmm0
        movups	xmmword ptr [r12 + 144], xmm0
        movups	xmmword ptr [r12 + 128], xmm0
        movups	xmmword ptr [r12 + 112], xmm0
        movups	xmmword ptr [r12 + 96], xmm0
        movups	xmmword ptr [r12 + 80], xmm0
        movups	xmmword ptr [r12 + 64], xmm0
        movups	xmmword ptr [r12 + 48], xmm0
        movups	xmmword ptr [r12 + 32], xmm0
        movups	xmmword ptr [r12 + 16], xmm0
        movups	xmmword ptr [r12], xmm0
        mov	r15, qword ptr [rbp - 376]
        test	r15, r15
        jne	.LBB4_205
        xor	r15d, r15d
        jmp	.LBB4_207
.LBB4_205:
        mov	rax, r15
        shr	rax, 59
        jne	.LBB4_13
        mov	r14, qword ptr [rbp - 392]
        shl	r15, 5
.LBB4_207:
        lea	rcx, [rbp - 392]
        test	r15, r15
        jne	.LBB4_209
        mov	r12, qword ptr [rbp + 8]
        jmp	.LBB4_210
.LBB4_209:
        mov	rdi, r14
        mov	esi, 170
        mov	rdx, r15
        call	memset@PLT
        mov	r12, qword ptr [rbp + 8]
        mov	rdi, rbx
        mov	rsi, r14
        mov	rdx, r15
        mov	ecx, 3
        mov	r8, r12
        call	qword ptr [r13 + 24]
        lea	rcx, [rbp - 392]
        movaps	xmm0, xmmword ptr [rip + .LCPI4_0]
        mov	rbx, qword ptr [rbp - 624]
        mov	r13, qword ptr [rbp - 616]
.LBB4_210:
        movabs	rax, -6148914691236517206
        mov	qword ptr [rcx + 16], rax
        movups	xmmword ptr [rcx], xmm0
        mov	rsi, qword ptr [rbp - 584]
        mov	edx, 936
        mov	rdi, rbx
        mov	ecx, 3
        mov	r8, r12
        call	qword ptr [r13 + 24]
.LBB4_225:
        mov	rax, qword ptr [rip + Progress.stderr_file_writer+8]
        mov	edi, offset Progress.stderr_file_writer+8
        call	qword ptr [rax + 16]
        movabs	rax, -6148914691236517206
        mov	qword ptr [rip + Progress.stderr_file_writer+16], rax
        xorps	xmm0, xmm0
        movups	xmmword ptr [rip + Progress.stderr_file_writer+24], xmm0
        mov	rax, qword ptr [rip + Progress.stderr_mutex]
        sub	rax, 1
        jb	.LBB4_13
        mov	qword ptr [rip + Progress.stderr_mutex], rax
        jne	.LBB4_230
        mov	dword ptr [rip + Progress.stderr_mutex+12], -1
        xor	eax, eax
        xchg	dword ptr [rip + Progress.stderr_mutex+8], eax
        cmp	eax, 3
        jne	.LBB4_228
        call	Thread.Futex.wake
.LBB4_230:
        lock		sub	byte ptr [rip + debug.panicking], 1
        jne	.LBB4_231
.LBB4_67:
        call	posix.abort
.LBB4_231:
        mov	dword ptr [rbp - 2096], 0
        xor	r8d, r8d
        lea	rdi, [rbp - 2096]
        mov	r9d, 4196369
        mov	esi, 128
.LBB4_232:
        mov	eax, 202
        xor	edx, edx
        xor	r10d, r10d
        #APP
        syscall
        #NO_APP
        mov	ecx, eax
        neg	ecx
        cmp	rax, -4095
        cmovb	ecx, r8d
        movzx	eax, cx
        cmp	ax, 22
        ja	.LBB4_233
        bt	r9d, eax
        jb	.LBB4_232
        cmp	eax, 14
        jne	.LBB4_233
.LBB4_236:
        call	"debug.FullPanic((function 'defaultPanic')).reachedUnreachable"
.LBB4_233:
        cmp	eax, 110
        call	"debug.FullPanic((function 'defaultPanic')).reachedUnreachable"
.LBB4_174:
        movsxd	rdi, dword ptr [rbp - 344]
        cmp	rdi, -3
        ja	.LBB4_176
        mov	eax, 3
        #APP
        syscall
        #NO_APP
        cmp	rax, -4095
        setb	cl
        cmp	ax, -9
        setne	al
        or	al, cl
        je	.LBB4_236
.LBB4_176:
        mov	dword ptr [rbp - 344], -1431655766
        cmp	byte ptr [rbp - 352], 0
        je	.LBB4_178
        movaps	xmm0, xmmword ptr [rbp - 624]
        movaps	xmmword ptr [rbp - 288], xmm0
        mov	rsi, qword ptr [rbp - 552]
        mov	rdx, qword ptr [rbp - 536]
        lea	rbx, [rbp - 288]
        mov	rdi, rbx
        call	mem.Allocator.free__anon_16372
        movabs	r15, -6148914691236517206
        mov	qword ptr [rbp - 536], r15
        movaps	xmm0, xmmword ptr [rip + .LCPI4_0]
        movups	xmmword ptr [rbp - 552], xmm0
        movaps	xmm0, xmmword ptr [rbp - 624]
        movaps	xmmword ptr [rbp - 288], xmm0
        mov	rsi, qword ptr [rbp - 576]
        mov	rdx, qword ptr [rbp - 560]
        mov	rdi, rbx
        call	mem.Allocator.free__anon_14371
        movaps	xmm0, xmmword ptr [rip + .LCPI4_0]
        movaps	xmmword ptr [rbp - 576], xmm0
        movaps	xmmword ptr [rbp - 560], xmm0
        movaps	xmmword ptr [rbp - 544], xmm0
        movaps	xmmword ptr [rbp - 528], xmm0
        movaps	xmmword ptr [rbp - 512], xmm0
        movaps	xmmword ptr [rbp - 496], xmm0
        movaps	xmmword ptr [rbp - 480], xmm0
        movaps	xmmword ptr [rbp - 464], xmm0
        movaps	xmmword ptr [rbp - 448], xmm0
        movaps	xmmword ptr [rbp - 432], xmm0
        movaps	xmmword ptr [rbp - 416], xmm0
        mov	qword ptr [rbp - 400], r15
        movaps	xmm0, xmmword ptr [rbp - 624]
        movaps	xmmword ptr [rbp - 288], xmm0
        mov	rsi, qword ptr [rbp - 392]
        mov	rdx, qword ptr [rbp - 376]
        mov	rdi, rbx
        call	mem.Allocator.free__anon_14371
        mov	qword ptr [rbp - 376], r15
        movaps	xmm0, xmmword ptr [rip + .LCPI4_0]
        movups	xmmword ptr [rbp - 392], xmm0
        mov	rsi, qword ptr [rbp - 584]
        mov	rdi, qword ptr [rbp - 624]
        mov	rax, qword ptr [rbp - 616]
        mov	r8, qword ptr [rbp + 8]
        mov	edx, 936
        mov	ecx, 3
        call	qword ptr [rax + 24]
.LBB4_178:
        movzx	eax, r14w
        shl	eax, 4
        mov	r14, qword ptr [rax + .L__unnamed_6]
        mov	rbx, qword ptr [rax + .L__unnamed_6+8]
        mov	rdi, qword ptr [rip + Progress.stderr_file_writer+32]
        xor	r15d, r15d
        lea	r12, [rbp - 1120]
.LBB4_179:
        mov	r13d, 28
        sub	r13, r15
        mov	rax, rdi
        add	rax, r13
        jb	.LBB4_13
        lea	rsi, [r15 + __anon_7698]
        cmp	rax, qword ptr [rip + Progress.stderr_file_writer+24]
        ja	.LBB4_211
        add	rdi, qword ptr [rip + Progress.stderr_file_writer+16]
        cmp	rdi, offset __anon_7698+28
        jae	.LBB4_183
        lea	rax, [rdi + r13]
        cmp	rsi, rax
        jb	.LBB4_239
.LBB4_183:
        mov	rdx, r13
        call	memcpy@PLT
        mov	rdi, qword ptr [rip + Progress.stderr_file_writer+32]
        add	rdi, r13
        jb	.LBB4_13
        mov	qword ptr [rip + Progress.stderr_file_writer+32], rdi
        add	r15, r13
        jb	.LBB4_13
.LBB4_214:
        cmp	r15, 28
        jb	.LBB4_179
        jmp	.LBB4_215
.LBB4_211:
        mov	rax, qword ptr [rip + Progress.stderr_file_writer+8]
        mov	rax, qword ptr [rax]
        mov	qword ptr [rbp - 1120], rsi
        mov	qword ptr [rbp - 1112], r13
        mov	esi, offset Progress.stderr_file_writer+8
        mov	ecx, 1
        mov	r8d, 1
        lea	rdi, [rbp - 2096]
        mov	rdx, r12
        call	rax
        cmp	word ptr [rbp - 2088], 0
        jne	.LBB4_225
        mov	r13, qword ptr [rbp - 2096]
        mov	rdi, qword ptr [rip + Progress.stderr_file_writer+32]
        add	r15, r13
        jae	.LBB4_214
        jmp	.LBB4_13
.LBB4_215:
        mov	edi, offset Progress.stderr_file_writer+8
        mov	rsi, r14
        mov	rdx, rbx
        mov	rcx, rbx
        mov	r8d, dword ptr [rbp - 84]
        call	Io.Writer.alignBuffer
        test	ax, ax
        jne	.LBB4_225
        lea	rbx, [rbp - 2096]
        lea	r14, [rbp - 1120]
.LBB4_217:
        mov	rdi, qword ptr [rip + Progress.stderr_file_writer+32]
        mov	rax, rdi
        inc	rax
        je	.LBB4_13
        mov	rsi, qword ptr [rip + Progress.stderr_file_writer+24]
        cmp	rax, rsi
        jbe	.LBB4_219
        mov	rax, qword ptr [rip + Progress.stderr_file_writer+8]
        mov	rax, qword ptr [rax]
        mov	qword ptr [rbp - 1120], offset __anon_4810
        mov	qword ptr [rbp - 1112], 1
        mov	esi, offset Progress.stderr_file_writer+8
        mov	ecx, 1
        mov	r8d, 1
        mov	rdi, rbx
        mov	rdx, r14
        call	rax
        cmp	word ptr [rbp - 2088], 0
        jne	.LBB4_225
        cmp	qword ptr [rbp - 2096], 0
        je	.LBB4_217
        jmp	.LBB4_225
.LBB4_219:
        cmp	rdi, rsi
        jae	.LBB4_59
        add	rdi, qword ptr [rip + Progress.stderr_file_writer+16]
        lea	rax, [rdi + 1]
        cmp	rdi, offset __anon_4810+1
        setb	cl
        cmp	rax, offset __anon_4810
        seta	al
        test	cl, al
        jne	.LBB4_239
        mov	byte ptr [rdi], 10
        mov	rax, qword ptr [rip + Progress.stderr_file_writer+32]
        inc	rax
        je	.LBB4_13
        mov	qword ptr [rip + Progress.stderr_file_writer+32], rax
        jmp	.LBB4_225
.LBB4_13:
        call	"debug.FullPanic((function 'defaultPanic')).integerOverflow"
.LBB4_239:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"
.LBB4_1:
        movzx	eax, cx
        cmp	eax, 22
        call	"debug.FullPanic((function 'defaultPanic')).reachedUnreachable"
.LBB4_142:
        mov	rdi, rcx
        mov	rsi, rax
        call	"debug.FullPanic((function 'defaultPanic')).outOfBounds"
.LBB4_228:
        test	eax, eax
        je	.LBB4_236
        jmp	.LBB4_230
.LBB4_161:
        call	"debug.FullPanic((function 'defaultPanic')).corruptSwitch"
.LBB4_59:
        add	rdi, 1
        call	"debug.FullPanic((function 'defaultPanic')).outOfBounds"
.LBB4_237:
        movzx	edi, cl
        call	"debug.FullPanic((function 'defaultPanic')).sentinelMismatch__anon_7004"
.LBB4_241:
        call	"debug.FullPanic((function 'defaultPanic')).incorrectAlignment"
.LBB4_238:
        call	"debug.FullPanic((function 'defaultPanic')).outOfBounds"

"debug.FullPanic((function 'defaultPanic')).unwrapNull":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rax, qword ptr [rbp + 8]
        mov	qword ptr [rbp - 16], rax
        mov	byte ptr [rbp - 8], 1
        lea	rdx, [rbp - 16]
        mov	edi, offset __anon_4873
        mov	esi, 25
        call	debug.defaultPanic
        .text

"debug.FullPanic((function 'defaultPanic')).incorrectAlignment":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rax, qword ptr [rbp + 8]
        mov	qword ptr [rbp - 16], rax
        mov	byte ptr [rbp - 8], 1
        lea	rdx, [rbp - 16]
        mov	edi, offset __anon_6819
        mov	esi, 19
        call	debug.defaultPanic
        .text

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

"debug.FullPanic((function 'defaultPanic')).inactiveUnionField__anon_19897":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 48
        mov	rax, qword ptr [rbp + 8]
        mov	qword ptr [rbp - 16], rax
        mov	byte ptr [rbp - 8], 1
        mov	qword ptr [rbp - 48], offset .L__unnamed_81
        mov	qword ptr [rbp - 40], 10
        mov	qword ptr [rbp - 32], offset .L__unnamed_82
        mov	qword ptr [rbp - 24], 25
        lea	rdi, [rbp - 16]
        lea	rsi, [rbp - 48]
        call	debug.panicExtra__anon_11126
        .text

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

