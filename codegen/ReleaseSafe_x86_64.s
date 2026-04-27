codegen_read_u32:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rax, [rbp - 28]
        lea	rcx, [rbp]
        lea	rdx, [rbp - 4]
        cmp	rdx, rax
        setae	al
        lea	rdx, [rbp - 32]
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        je	.LBB0_2
        mov	eax, dword ptr [rbp - 32]
        add	rsp, 32
        pop	rbp
        ret
.LBB0_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_read_bool:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	byte ptr [rbp - 1], -86
        lea	rax, [rbp - 28]
        lea	rcx, [rbp - 27]
        lea	rdx, [rbp]
        lea	rsi, [rbp - 1]
        cmp	rsi, rcx
        setae	cl
        cmp	rax, rdx
        setae	al
        or	al, cl
        je	.LBB185_2
        movzx	eax, byte ptr [rbp - 28]
        and	al, 1
        add	rsp, 32
        pop	rbp
        ret
.LBB185_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_read_u16_unaligned:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	word ptr [rbp - 2], -21846
        lea	rax, [rbp - 27]
        lea	rcx, [rbp - 25]
        lea	rdx, [rbp]
        lea	rsi, [rbp - 2]
        cmp	rsi, rcx
        setae	cl
        cmp	rax, rdx
        setae	al
        or	al, cl
        je	.LBB186_2
        movzx	eax, word ptr [rbp - 27]
        add	rsp, 32
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
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
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
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
.LBB191_2:
        add	rsp, 16
        pop	rbp
        ret

codegen_runtime_read:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rax, rdi
        mov	edi, esi
        cmp	si, 4
        jae	.LBB192_6
        movzx	ecx, word ptr [rdi + rdi + .L__unnamed_78]
        movups	xmm0, xmmword ptr [rax]
        movaps	xmmword ptr [rbp - 16], xmm0
        movzx	eax, word ptr [rcx + rcx + .L__unnamed_79]
        mov	rcx, qword ptr [8*rcx + .L__unnamed_80]
        mov	rdi, rcx
        add	rdi, rax
        jb	.LBB192_7
        cmp	rdi, 10
        jae	.LBB192_8
        sub	rdi, rcx
        cmp	rdi, rax
        jne	.LBB192_9
        lea	rsi, [rcx + rbp]
        add	rsi, -16
        lea	rcx, [rsi + rax]
        lea	rdi, [rdx + rax]
        cmp	rdx, rcx
        setae	cl
        cmp	rsi, rdi
        setae	dil
        or	dil, cl
        je	.LBB192_10
        mov	rdi, rdx
        mov	rdx, rax
        call	memcpy@PLT
        add	rsp, 16
        pop	rbp
        ret
.LBB192_6:
        mov	esi, 4
        call	"debug.FullPanic((function 'defaultPanic')).outOfBounds"
.LBB192_7:
        call	"debug.FullPanic((function 'defaultPanic')).integerOverflow"
.LBB192_8:
        mov	esi, 9
        call	"debug.FullPanic((function 'defaultPanic')).outOfBounds"
.LBB192_9:
        call	"debug.FullPanic((function 'defaultPanic')).copyLenMismatch"
.LBB192_10:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_runtime_write:
        push	rbp
        mov	rbp, rsp
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).runtime_write"

codegen_dual_read:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rax, [rbp - 28]
        lea	rcx, [rbp]
        lea	rdx, [rbp - 4]
        cmp	rdx, rax
        setae	al
        lea	rdx, [rbp - 32]
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        je	.LBB195_2
        mov	ecx, dword ptr [rbp - 32]
        movups	xmm0, xmmword ptr [rsi]
        movaps	xmmword ptr [rbp - 32], xmm0
        movsxd	rax, dword ptr [rbp - 32]
        add	rax, rcx
        add	rsp, 32
        pop	rbp
        ret
.LBB195_2:
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
        sub	rsp, 128
        mov	rax, qword ptr [rdi + 112]
        mov	qword ptr [rbp - 16], rax
        movups	xmm0, xmmword ptr [rdi + 96]
        movaps	xmmword ptr [rbp - 32], xmm0
        movups	xmm0, xmmword ptr [rdi + 80]
        movaps	xmmword ptr [rbp - 48], xmm0
        movups	xmm0, xmmword ptr [rdi + 64]
        movaps	xmmword ptr [rbp - 64], xmm0
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 16]
        movups	xmm2, xmmword ptr [rdi + 32]
        movups	xmm3, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 80], xmm3
        movaps	xmmword ptr [rbp - 96], xmm2
        movaps	xmmword ptr [rbp - 112], xmm1
        movaps	xmmword ptr [rbp - 128], xmm0
        mov	byte ptr [rbp - 1], -86
        lea	rax, [rbp - 127]
        lea	rcx, [rbp]
        lea	rdx, [rbp - 1]
        cmp	rdx, rax
        setae	al
        lea	rdx, [rbp - 128]
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        je	.LBB197_2
        movzx	eax, byte ptr [rbp - 128]
        add	rsp, 128
        pop	rbp
        ret
.LBB197_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_many_read_middle:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 128
        mov	rax, qword ptr [rdi + 112]
        mov	qword ptr [rbp - 16], rax
        movups	xmm0, xmmword ptr [rdi + 96]
        movaps	xmmword ptr [rbp - 32], xmm0
        movups	xmm0, xmmword ptr [rdi + 80]
        movaps	xmmword ptr [rbp - 48], xmm0
        movups	xmm0, xmmword ptr [rdi + 64]
        movaps	xmmword ptr [rbp - 64], xmm0
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 16]
        movups	xmm2, xmmword ptr [rdi + 32]
        movups	xmm3, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 80], xmm3
        movaps	xmmword ptr [rbp - 96], xmm2
        movaps	xmmword ptr [rbp - 112], xmm1
        movaps	xmmword ptr [rbp - 128], xmm0
        lea	rax, [rbp - 80]
        mov	dword ptr [rbp - 4], -1431655766
        lea	rcx, [rbp - 76]
        lea	rdx, [rbp]
        lea	rsi, [rbp - 4]
        cmp	rsi, rcx
        setae	cl
        cmp	rax, rdx
        setae	al
        or	al, cl
        je	.LBB198_2
        mov	eax, dword ptr [rbp - 80]
        add	rsp, 128
        pop	rbp
        ret
.LBB198_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_many_read_last:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 128
        mov	rax, qword ptr [rdi + 112]
        mov	qword ptr [rbp - 16], rax
        movups	xmm0, xmmword ptr [rdi + 96]
        movaps	xmmword ptr [rbp - 32], xmm0
        movups	xmm0, xmmword ptr [rdi + 80]
        movaps	xmmword ptr [rbp - 48], xmm0
        movups	xmm0, xmmword ptr [rdi + 64]
        movaps	xmmword ptr [rbp - 64], xmm0
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 16]
        movups	xmm2, xmmword ptr [rdi + 32]
        movups	xmm3, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 80], xmm3
        movaps	xmmword ptr [rbp - 96], xmm2
        movaps	xmmword ptr [rbp - 112], xmm1
        movaps	xmmword ptr [rbp - 128], xmm0
        lea	rax, [rbp - 16]
        movabs	rcx, -6148914691236517206
        mov	qword ptr [rbp - 8], rcx
        lea	rcx, [rbp - 8]
        lea	rdx, [rbp]
        lea	rsi, [rbp - 8]
        cmp	rsi, rcx
        setae	cl
        cmp	rax, rdx
        setae	al
        or	al, cl
        je	.LBB199_2
        mov	rax, qword ptr [rbp - 16]
        add	rsp, 128
        pop	rbp
        ret
.LBB199_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_many_write_last_with_subs:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	qword ptr [rbp - 8], rsi
        cmp	qword ptr [rdi + 112], rsi
        mov	qword ptr [rdi + 112], rsi
        je	.LBB200_2
        lea	rsi, [rbp - 8]
        call	"system_data.SystemData(codegen_harness.ManyErdsSystem__struct_18252,meta.FieldEnum(codegen_harness.ManyErdsSystem__struct_18252),.{ .e00 = .{ ... }, .e01 = .{ ... }, .e02 = .{ ... }, .e03 = .{ ... }, .e04 = .{ ... }, .e05 = .{ ... }, .e06 = .{ ... }, .e07 = .{ ... }, .e08 = .{ ... }, .e09 = .{ ... }, .e10 = .{ ... }, .e11 = .{ ... }, .e12 = .{ ... }, .e13 = .{ ... }, .e14 = .{ ... }, .e15 = .{ ... }, .e16 = .{ ... }, .e17 = .{ ... }, .e18 = .{ ... }, .e19 = .{ ... }, .e20 = .{ ... }, .e21 = .{ ... }, .e22 = .{ ... }, .e23 = .{ ... }, .e24 = .{ ... }, .e25 = .{ ... }, .e26 = .{ ... }, .e27 = .{ ... }, .e28 = .{ ... }, .e29 = .{ ... }, .e30 = .{ ... }, .e31 = .{ ... } },testing.create.Components).publish"
.LBB200_2:
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
        sub	rsp, 552
        mov	r14, rsi
        mov	rbx, rdi
        lea	r15, [rbp - 576]
        mov	edx, 288
        mov	rdi, r15
        call	memcpy@PLT
        movaps	xmm0, xmmword ptr [rip + .LCPI203_0]
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
        lea	rax, [rbp - 320]
        lea	rcx, [rbp - 32]
        lea	rdx, [rbp - 288]
        cmp	rdx, rax
        setae	al
        cmp	r15, rcx
        setae	cl
        or	cl, al
        je	.LBB203_2
        mov	edx, 256
        mov	rdi, rbx
        mov	rsi, r14
        call	memcpy@PLT
        mov	rax, rbx
        add	rsp, 552
        pop	rbx
        pop	r14
        pop	r15
        pop	rbp
        ret
.LBB203_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_read_medium_struct:
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 320
        mov	r14, rsi
        mov	rbx, rdi
        lea	rdi, [rbp - 336]
        mov	edx, 288
        call	memcpy@PLT
        movaps	xmm0, xmmword ptr [rip + .LCPI204_0]
        movaps	xmmword ptr [rbp - 48], xmm0
        movabs	rax, -6148914691236517206
        mov	qword ptr [rbp - 32], rax
        lea	rax, [rbp - 80]
        lea	rcx, [rbp - 56]
        lea	rdx, [rbp - 24]
        lea	rsi, [rbp - 48]
        cmp	rsi, rcx
        setae	cl
        cmp	rax, rdx
        setae	al
        or	al, cl
        je	.LBB204_2
        mov	rax, qword ptr [r14 + 272]
        mov	qword ptr [rbx + 16], rax
        movups	xmm0, xmmword ptr [r14 + 256]
        movups	xmmword ptr [rbx], xmm0
        mov	rax, rbx
        add	rsp, 320
        pop	rbx
        pop	r14
        pop	rbp
        ret
.LBB204_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_read_u32_after_big:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 304
        mov	rsi, rdi
        lea	rdi, [rbp - 296]
        mov	edx, 288
        call	memcpy@PLT
        mov	dword ptr [rbp - 4], -1431655766
        lea	rax, [rbp - 16]
        lea	rcx, [rbp - 12]
        lea	rdx, [rbp]
        lea	rsi, [rbp - 4]
        cmp	rsi, rcx
        setae	cl
        cmp	rax, rdx
        setae	al
        or	al, cl
        je	.LBB205_2
        mov	eax, dword ptr [rbp - 16]
        add	rsp, 304
        pop	rbp
        ret
.LBB205_2:
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
        sub	rsp, 352
        mov	r14, rsi
        mov	rbx, rdi
        mov	rax, qword ptr [rsi + 16]
        mov	qword ptr [rbp - 64], rax
        movups	xmm0, xmmword ptr [rsi]
        movaps	xmmword ptr [rbp - 80], xmm0
        lea	rdi, [rbp - 368]
        mov	edx, 288
        mov	rsi, rbx
        call	memcpy@PLT
        movaps	xmm0, xmmword ptr [rip + .LCPI207_0]
        movaps	xmmword ptr [rbp - 48], xmm0
        movabs	rax, -6148914691236517206
        mov	qword ptr [rbp - 32], rax
        lea	rax, [rbp - 112]
        lea	rcx, [rbp - 88]
        lea	rdx, [rbp - 24]
        lea	rsi, [rbp - 48]
        cmp	rsi, rcx
        setae	cl
        cmp	rax, rdx
        setae	al
        or	al, cl
        je	.LBB207_9
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
        jne	.LBB207_7
        cmp	rdi, qword ptr [r14 + 8]
        jne	.LBB207_7
        cmp	esi, dword ptr [r14 + 16]
        jne	.LBB207_7
        cmp	dx, word ptr [r14 + 20]
        jne	.LBB207_7
        cmp	cl, byte ptr [r14 + 22]
        jne	.LBB207_7
        and	al, 1
        cmp	byte ptr [r14 + 23], al
        je	.LBB207_8
.LBB207_7:
        lea	rsi, [rbp - 80]
        mov	rdi, rbx
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_19396,meta.FieldEnum(codegen_harness.HugeSystem__struct_19396),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).publish"
.LBB207_8:
        add	rsp, 352
        pop	rbx
        pop	r14
        pop	rbp
        ret
.LBB207_9:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_read_modify_write_medium:
        push	rbp
        mov	rbp, rsp
        push	rbx
        sub	rsp, 312
        mov	rbx, rdi
        lea	rdi, [rbp - 320]
        mov	edx, 288
        mov	rsi, rbx
        call	memcpy@PLT
        movaps	xmm0, xmmword ptr [rip + .LCPI209_0]
        movaps	xmmword ptr [rbp - 32], xmm0
        movabs	rax, -6148914691236517206
        mov	qword ptr [rbp - 16], rax
        lea	rax, [rbp - 64]
        lea	rcx, [rbp - 40]
        lea	rdx, [rbp - 8]
        lea	rsi, [rbp - 32]
        cmp	rsi, rcx
        setae	cl
        cmp	rax, rdx
        setae	al
        or	al, cl
        je	.LBB209_2
        mov	eax, dword ptr [rbx + 272]
        mov	ecx, dword ptr [rbx + 276]
        add	eax, 1
        movups	xmm0, xmmword ptr [rbx + 256]
        movaps	xmmword ptr [rbp - 320], xmm0
        mov	dword ptr [rbp - 304], eax
        mov	dword ptr [rbp - 300], ecx
        mov	dword ptr [rbx + 272], eax
        lea	rsi, [rbp - 320]
        mov	rdi, rbx
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_19396,meta.FieldEnum(codegen_harness.HugeSystem__struct_19396),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).publish"
        add	rsp, 312
        pop	rbx
        pop	rbp
        ret
.LBB209_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_read_modify_write_big:
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 544
        mov	rbx, rdi
        lea	r14, [rbp - 560]
        mov	edx, 288
        mov	rdi, r14
        mov	rsi, rbx
        call	memcpy@PLT
        movaps	xmm0, xmmword ptr [rip + .LCPI210_0]
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
        lea	rax, [rbp - 304]
        lea	rcx, [rbp - 16]
        lea	rdx, [rbp - 272]
        cmp	rdx, rax
        setae	al
        cmp	r14, rcx
        setae	cl
        or	cl, al
        je	.LBB210_2
        add	byte ptr [rbx], 1
        add	rsp, 544
        pop	rbx
        pop	r14
        pop	rbp
        ret
.LBB210_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_setup_timer_callback:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rcx, qword ptr [rsi]
        lea	rax, [rdx + 16]
        cmp	qword ptr [rdx + 8], 0
        je	.LBB211_9
        test	rcx, rcx
        je	.LBB211_5
        mov	r8, rsi
.LBB211_3:
        cmp	rcx, rax
        je	.LBB211_11
        mov	r8, rcx
        mov	rcx, qword ptr [rcx]
        test	rcx, rcx
        jne	.LBB211_3
.LBB211_5:
        mov	rcx, qword ptr [rsi + 8]
        test	rcx, rcx
        je	.LBB211_12
        cmp	rcx, rax
        je	.LBB211_10
.LBB211_7:
        mov	r9, qword ptr [rcx]
        test	r9, r9
        je	.LBB211_12
        mov	r8, rcx
        mov	rcx, r9
        cmp	r9, rax
        jne	.LBB211_7
        jmp	.LBB211_11
.LBB211_9:
        mov	r8, rsi
        cmp	rcx, rax
        jne	.LBB211_12
        jmp	.LBB211_11
.LBB211_10:
        lea	r8, [rsi + 8]
.LBB211_11:
        mov	rcx, qword ptr [rax]
        mov	qword ptr [r8], rcx
.LBB211_12:
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
        je	.LBB211_19
        cmp	byte ptr [rcx + 12], 1
        je	.LBB211_21
        mov	edx, dword ptr [rcx + 8]
        sub	edx, edi
        add	edx, -101
        cmp	edx, -65636
        jb	.LBB211_20
.LBB211_15:
        mov	rsi, rcx
        mov	rcx, qword ptr [rcx]
        test	rcx, rcx
        je	.LBB211_19
        cmp	byte ptr [rcx + 12], 1
        je	.LBB211_21
        mov	edx, dword ptr [rcx + 8]
        sub	edx, edi
        add	edx, 65535
        cmp	edx, 65636
        jb	.LBB211_15
        jmp	.LBB211_20
.LBB211_19:
        xor	ecx, ecx
.LBB211_20:
        mov	qword ptr [rax], rcx
        mov	qword ptr [rsi], rax
        add	rsp, 16
        pop	rbp
        ret
.LBB211_21:
        call	"debug.FullPanic((function 'defaultPanic')).inactiveUnionField__anon_19864"

codegen_harness.timer_callback_read_write:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        test	rdi, rdi
        je	.LBB212_5
        test	dil, 7
        jne	.LBB212_4
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rax, [rbp - 28]
        lea	rcx, [rbp]
        lea	rdx, [rbp - 4]
        cmp	rdx, rax
        setae	al
        lea	rdx, [rbp - 32]
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        je	.LBB212_6
        mov	eax, dword ptr [rbp - 32]
        add	eax, 1
        mov	dword ptr [rdi], eax
        add	rsp, 32
        pop	rbp
        ret
.LBB212_5:
        call	"debug.FullPanic((function 'defaultPanic')).unwrapNull"
.LBB212_4:
        call	"debug.FullPanic((function 'defaultPanic')).incorrectAlignment"
.LBB212_6:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_triple_read_same_erd:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rax, [rbp - 28]
        lea	rcx, [rbp]
        lea	rdx, [rbp - 4]
        cmp	rdx, rax
        setae	al
        lea	rdx, [rbp - 32]
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        je	.LBB214_2
        mov	eax, dword ptr [rbp - 32]
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 32], xmm0
        add	eax, dword ptr [rbp - 32]
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 32], xmm0
        add	eax, dword ptr [rbp - 32]
        add	rsp, 32
        pop	rbp
        ret
.LBB214_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_read_then_branch:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rax, [rbp - 28]
        lea	rcx, [rbp]
        lea	rdx, [rbp - 4]
        cmp	rdx, rax
        setae	al
        lea	rdx, [rbp - 32]
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        je	.LBB215_2
        mov	ecx, dword ptr [rbp - 32]
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	eax, dword ptr [rbp - 32]
        mov	edx, eax
        imul	edx, ecx
        add	eax, ecx
        test	sil, sil
        cmove	eax, edx
        add	rsp, 32
        pop	rbp
        ret
.LBB215_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_read_write_read:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rax, [rbp - 28]
        lea	rcx, [rbp]
        lea	rdx, [rbp - 4]
        cmp	rdx, rax
        setae	al
        lea	rdx, [rbp - 32]
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        je	.LBB216_2
        mov	eax, dword ptr [rbp - 32]
        add	eax, 1
        mov	dword ptr [rdi], eax
        mov	eax, dword ptr [rdi]
        mov	dword ptr [rbp - 32], eax
        mov	rax, qword ptr [rdi + 4]
        mov	qword ptr [rbp - 28], rax
        mov	eax, dword ptr [rdi + 12]
        mov	dword ptr [rbp - 20], eax
        mov	eax, dword ptr [rbp - 32]
        add	rsp, 32
        pop	rbp
        ret
.LBB216_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_read_write_other_read:
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 32
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	dword ptr [rbp - 36], -1431655766
        lea	rax, [rbp - 28]
        lea	rcx, [rbp - 32]
        lea	rdx, [rbp - 36]
        cmp	rdx, rax
        setae	al
        lea	rdx, [rbp - 32]
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        je	.LBB217_4
        mov	rbx, rdi
        mov	r14d, dword ptr [rbp - 32]
        mov	byte ptr [rbp - 32], sil
        cmp	byte ptr [rdi + 4], sil
        mov	byte ptr [rdi + 4], sil
        je	.LBB217_3
        mov	rdi, rbx
        mov	esi, 1
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
.LBB217_3:
        mov	eax, dword ptr [rbx]
        mov	dword ptr [rbp - 32], eax
        movzx	eax, byte ptr [rbx + 4]
        mov	byte ptr [rbp - 28], al
        mov	rax, qword ptr [rbx + 5]
        mov	qword ptr [rbp - 27], rax
        movzx	eax, word ptr [rbx + 13]
        mov	word ptr [rbp - 19], ax
        movzx	eax, byte ptr [rbx + 15]
        mov	byte ptr [rbp - 17], al
        add	r14d, dword ptr [rbp - 32]
        mov	eax, r14d
        add	rsp, 32
        pop	rbx
        pop	r14
        pop	rbp
        ret
.LBB217_4:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_read_across_two_erds:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rax, [rbp - 28]
        lea	rdx, [rbp]
        lea	rcx, [rbp - 4]
        cmp	rcx, rax
        setae	al
        lea	rsi, [rbp - 32]
        cmp	rsi, rdx
        setae	dl
        or	dl, al
        je	.LBB218_3
        mov	eax, dword ptr [rbp - 32]
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	word ptr [rbp - 4], -21846
        lea	rdx, [rbp - 27]
        lea	rsi, [rbp - 25]
        lea	r8, [rbp - 2]
        cmp	rcx, rsi
        setae	cl
        cmp	rdx, r8
        setae	dl
        or	dl, cl
        je	.LBB218_3
        movzx	ecx, word ptr [rbp - 27]
        add	eax, ecx
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 32], xmm0
        add	eax, dword ptr [rbp - 32]
        add	rsp, 32
        pop	rbp
        ret
.LBB218_3:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_subscribe_callback:
        mov	rax, qword ptr [rdi + 24]
        cmp	rax, offset codegen_harness.accumulate_callback
        je	.LBB219_3
        test	rax, rax
        jne	.LBB219_4
        mov	qword ptr [rdi + 16], 0
        mov	qword ptr [rdi + 24], offset codegen_harness.accumulate_callback
.LBB219_3:
        ret
.LBB219_4:
        push	rbp
        mov	rbp, rsp
        call	debug.panic__anon_19898

codegen_harness.accumulate_callback:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        test	rsi, rsi
        je	.LBB220_7
        test	sil, 7
        jne	.LBB220_8
        test	dl, 7
        jne	.LBB220_8
        mov	rax, qword ptr [rsi]
        cmp	byte ptr [rax], 0
        je	.LBB220_6
        movups	xmm0, xmmword ptr [rdx]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rax, [rbp - 28]
        lea	rcx, [rbp]
        lea	rsi, [rbp - 4]
        cmp	rsi, rax
        setae	al
        lea	rsi, [rbp - 32]
        cmp	rsi, rcx
        setae	cl
        or	cl, al
        je	.LBB220_9
        mov	eax, dword ptr [rbp - 32]
        add	eax, 1
        mov	dword ptr [rdx], eax
.LBB220_6:
        add	rsp, 32
        pop	rbp
        ret
.LBB220_8:
        call	"debug.FullPanic((function 'defaultPanic')).incorrectAlignment"
.LBB220_7:
        call	"debug.FullPanic((function 'defaultPanic')).unwrapNull"
.LBB220_9:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_write_triggering_callback:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	byte ptr [rbp - 1], 1
        cmp	byte ptr [rdi + 4], 1
        mov	byte ptr [rdi + 4], 1
        je	.LBB223_2
        lea	rdx, [rbp - 1]
        mov	esi, 1
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
.LBB223_2:
        add	rsp, 16
        pop	rbp
        ret

codegen_increment_n_times:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        test	esi, esi
        je	.LBB224_7
        lea	rax, [rbp - 12]
        lea	rcx, [rbp - 16]
        lea	rdx, [rbp - 20]
        cmp	rdx, rax
        setb	al
        lea	rdx, [rbp - 16]
        cmp	rdx, rcx
        setb	cl
        test	cl, al
        jne	.LBB224_8
        cmp	esi, 1
        je	.LBB224_6
        mov	eax, esi
        and	eax, -2
        neg	eax
.LBB224_4:
        mov	ecx, dword ptr [rdi]
        mov	dword ptr [rbp - 16], ecx
        mov	rcx, qword ptr [rdi + 4]
        mov	qword ptr [rbp - 12], rcx
        mov	ecx, dword ptr [rdi + 12]
        mov	dword ptr [rbp - 4], ecx
        mov	ecx, dword ptr [rbp - 16]
        add	ecx, 1
        mov	dword ptr [rdi], ecx
        mov	ecx, dword ptr [rdi]
        mov	dword ptr [rbp - 16], ecx
        mov	rcx, qword ptr [rdi + 4]
        mov	qword ptr [rbp - 12], rcx
        mov	ecx, dword ptr [rdi + 12]
        mov	dword ptr [rbp - 4], ecx
        mov	ecx, dword ptr [rbp - 16]
        add	ecx, 1
        mov	dword ptr [rdi], ecx
        add	eax, 2
        jne	.LBB224_4
        test	sil, 1
        je	.LBB224_7
.LBB224_6:
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 16], xmm0
        mov	eax, dword ptr [rbp - 16]
        add	eax, 1
        mov	dword ptr [rdi], eax
.LBB224_7:
        add	rsp, 32
        pop	rbp
        ret
.LBB224_8:
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 16], xmm0
        mov	dword ptr [rbp - 20], -1431655766
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_conditional_write_chain:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	byte ptr [rbp - 4], -86
        lea	rax, [rbp - 28]
        lea	rdx, [rbp - 27]
        lea	rsi, [rbp - 3]
        lea	rcx, [rbp - 4]
        cmp	rcx, rdx
        setae	r8b
        cmp	rax, rsi
        setae	sil
        or	sil, r8b
        je	.LBB225_9
        test	byte ptr [rbp - 28], 1
        je	.LBB225_2
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rsi, [rbp]
        cmp	rcx, rax
        setae	r8b
        lea	r9, [rbp - 32]
        cmp	r9, rsi
        setae	sil
        or	sil, r8b
        je	.LBB225_9
        mov	esi, dword ptr [rbp - 32]
        add	esi, 10
        mov	dword ptr [rdi], esi
.LBB225_2:
        mov	esi, dword ptr [rdi]
        mov	dword ptr [rbp - 32], esi
        mov	rsi, qword ptr [rdi + 4]
        mov	qword ptr [rbp - 28], rsi
        mov	esi, dword ptr [rdi + 12]
        mov	dword ptr [rbp - 20], esi
        mov	word ptr [rbp - 4], -21846
        lea	rsi, [rbp - 25]
        lea	r8, [rbp - 2]
        cmp	rcx, rsi
        setae	sil
        cmp	rdx, r8
        setae	dl
        or	dl, sil
        je	.LBB225_9
        cmp	word ptr [rbp - 27], 100
        jbe	.LBB225_4
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rdx, [rbp]
        cmp	rcx, rax
        setae	al
        lea	rcx, [rbp - 32]
        cmp	rcx, rdx
        setae	cl
        or	cl, al
        je	.LBB225_9
        mov	eax, dword ptr [rbp - 32]
        add	eax, 20
        mov	dword ptr [rdi], eax
.LBB225_4:
        add	rsp, 32
        pop	rbp
        ret
.LBB225_9:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_cross_erd_compute:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	word ptr [rbp - 4], -21846
        lea	rax, [rbp - 27]
        lea	rdx, [rbp - 25]
        lea	rsi, [rbp - 2]
        lea	rcx, [rbp - 4]
        cmp	rcx, rdx
        setae	dl
        cmp	rax, rsi
        setae	al
        or	al, dl
        je	.LBB226_5
        movzx	eax, word ptr [rbp - 27]
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rdx, [rbp - 28]
        lea	rsi, [rbp]
        cmp	rcx, rdx
        setae	cl
        lea	rdx, [rbp - 32]
        cmp	rdx, rsi
        setae	dl
        or	dl, cl
        je	.LBB226_5
        add	ax, word ptr [rbp - 32]
        mov	word ptr [rbp - 32], ax
        cmp	word ptr [rdi + 7], ax
        mov	word ptr [rdi + 7], ax
        je	.LBB226_4
        lea	rdx, [rbp - 32]
        mov	esi, 3
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
.LBB226_4:
        add	rsp, 32
        pop	rbp
        ret
.LBB226_5:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_cross_system_read_add:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rcx, [rbp - 28]
        lea	rdx, [rbp]
        lea	rax, [rbp - 4]
        cmp	rax, rcx
        setae	cl
        lea	r8, [rbp - 32]
        cmp	r8, rdx
        setae	dl
        or	dl, cl
        je	.LBB227_4
        mov	edx, dword ptr [rbp - 32]
        movups	xmm0, xmmword ptr [rsi]
        movaps	xmmword ptr [rbp - 32], xmm0
        movsxd	rcx, dword ptr [rbp - 32]
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	word ptr [rbp - 4], -21846
        lea	rdi, [rbp - 27]
        lea	r9, [rbp - 25]
        lea	r10, [rbp - 2]
        cmp	rax, r9
        setae	r9b
        cmp	rdi, r10
        setae	dil
        or	dil, r9b
        je	.LBB227_4
        movzx	edi, word ptr [rbp - 27]
        movups	xmm0, xmmword ptr [rsi]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rsi, [rbp - 24]
        cmp	rax, rsi
        setae	sil
        cmp	r8, rax
        setae	al
        or	al, sil
        je	.LBB227_4
        add	rcx, rdx
        movsxd	rax, dword ptr [rbp - 28]
        add	rax, rdi
        add	rax, rcx
        add	rsp, 32
        pop	rbp
        ret
.LBB227_4:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_cross_system_read_write:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        movups	xmm0, xmmword ptr [rsi]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rax, [rbp - 28]
        lea	rcx, [rbp]
        lea	rdx, [rbp - 4]
        cmp	rdx, rax
        setae	al
        lea	rdx, [rbp - 32]
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        je	.LBB228_2
        mov	eax, dword ptr [rbp - 32]
        mov	dword ptr [rdi], eax
        add	rsp, 32
        pop	rbp
        ret
.LBB228_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_cross_system_swap:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rax, [rbp - 28]
        lea	rcx, [rbp]
        lea	rdx, [rbp - 4]
        cmp	rdx, rax
        setae	al
        lea	rdx, [rbp - 32]
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        je	.LBB229_4
        mov	eax, dword ptr [rbp - 32]
        movups	xmm0, xmmword ptr [rsi]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	ecx, dword ptr [rbp - 32]
        mov	dword ptr [rdi], ecx
        mov	dword ptr [rbp - 32], eax
        cmp	dword ptr [rsi], eax
        mov	dword ptr [rsi], eax
        je	.LBB229_3
        lea	rax, [rbp - 32]
        mov	rdi, rsi
        mov	rsi, rax
        call	"system_data.SystemData(codegen_harness.OtherSystem__struct_18019,meta.FieldEnum(codegen_harness.OtherSystem__struct_18019),.{ .sensor_a = .{ ... }, .sensor_b = .{ ... }, .output = .{ ... } },testing.create.Components).publish"
.LBB229_3:
        add	rsp, 32
        pop	rbp
        ret
.LBB229_4:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_double_write_same_value:
        push	rbp
        mov	rbp, rsp
        push	rbx
        push	rax
        mov	byte ptr [rbp - 9], 1
        mov	al, 1
        cmp	byte ptr [rdi + 4], 1
        mov	byte ptr [rdi + 4], 1
        jne	.LBB231_1
        mov	byte ptr [rbp - 10], 1
        mov	byte ptr [rdi + 4], 1
        cmp	al, 1
        jne	.LBB231_3
.LBB231_4:
        add	rsp, 8
        pop	rbx
        pop	rbp
        ret
.LBB231_1:
        lea	rdx, [rbp - 9]
        mov	rbx, rdi
        mov	esi, 1
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
        mov	rdi, rbx
        movzx	eax, byte ptr [rbx + 4]
        mov	byte ptr [rbp - 10], 1
        mov	byte ptr [rdi + 4], 1
        cmp	al, 1
        je	.LBB231_4
.LBB231_3:
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
        jne	.LBB232_1
        mov	byte ptr [rbp - 10], 0
        mov	byte ptr [rdi + 4], 0
        cmp	al, 0
        jne	.LBB232_3
.LBB232_4:
        add	rsp, 8
        pop	rbx
        pop	rbp
        ret
.LBB232_1:
        lea	rdx, [rbp - 9]
        mov	rbx, rdi
        mov	esi, 1
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
        mov	rdi, rbx
        movzx	eax, byte ptr [rbx + 4]
        mov	byte ptr [rbp - 10], 0
        mov	byte ptr [rdi + 4], 0
        cmp	al, 0
        je	.LBB232_4
.LBB232_3:
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
        sub	rsp, 40
        mov	word ptr [rbp - 32], 1
        cmp	word ptr [rdi + 7], 1
        mov	word ptr [rdi + 7], 1
        je	.LBB233_2
        lea	rdx, [rbp - 32]
        mov	rbx, rdi
        mov	esi, 3
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
        mov	rdi, rbx
.LBB233_2:
        mov	eax, dword ptr [rdi]
        mov	dword ptr [rbp - 32], eax
        movzx	eax, word ptr [rdi + 4]
        mov	word ptr [rbp - 28], ax
        movzx	eax, byte ptr [rdi + 6]
        mov	byte ptr [rbp - 26], al
        movzx	eax, word ptr [rdi + 7]
        mov	word ptr [rbp - 25], ax
        mov	eax, dword ptr [rdi + 9]
        mov	dword ptr [rbp - 23], eax
        movzx	eax, word ptr [rdi + 13]
        mov	word ptr [rbp - 19], ax
        movzx	eax, byte ptr [rdi + 15]
        mov	byte ptr [rbp - 17], al
        mov	dword ptr [rbp - 36], -1431655766
        lea	rax, [rbp - 28]
        lea	rcx, [rbp - 32]
        lea	rdx, [rbp - 36]
        cmp	rdx, rax
        setae	al
        lea	rdx, [rbp - 32]
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        je	.LBB233_6
        mov	word ptr [rbp - 32], 2
        cmp	word ptr [rdi + 7], 2
        mov	word ptr [rdi + 7], 2
        je	.LBB233_5
        mov	esi, 3
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
.LBB233_5:
        add	rsp, 40
        pop	rbx
        pop	rbp
        ret
.LBB233_6:
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
        jne	.LBB234_3
        mov	word ptr [rbp - 10], 2
        mov	word ptr [rbx + 7], 2
        jmp	.LBB234_2
.LBB234_3:
        lea	rdx, [rbp - 14]
        mov	rdi, rbx
        mov	esi, 3
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
        movzx	eax, word ptr [rbx + 7]
        mov	word ptr [rbp - 10], 2
        mov	word ptr [rbx + 7], 2
        cmp	ax, 2
        jne	.LBB234_2
        mov	word ptr [rbp - 12], 3
        mov	word ptr [rbx + 7], 3
        jmp	.LBB234_5
.LBB234_2:
        lea	rdx, [rbp - 10]
        mov	rdi, rbx
        mov	esi, 3
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
        movzx	eax, word ptr [rbx + 7]
        mov	word ptr [rbp - 12], 3
        mov	word ptr [rbx + 7], 3
        cmp	ax, 3
        je	.LBB234_6
.LBB234_5:
        lea	rdx, [rbp - 12]
        mov	rdi, rbx
        mov	esi, 3
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
.LBB234_6:
        add	rsp, 8
        pop	rbx
        pop	rbp
        ret

codegen_double_rmw_struct:
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 320
        mov	rbx, rdi
        lea	rdi, [rbp - 336]
        mov	edx, 288
        mov	rsi, rbx
        call	memcpy@PLT
        movaps	xmm0, xmmword ptr [rip + .LCPI235_0]
        movaps	xmmword ptr [rbp - 48], xmm0
        movabs	rax, -6148914691236517206
        mov	qword ptr [rbp - 32], rax
        lea	rax, [rbp - 80]
        lea	rcx, [rbp - 56]
        lea	rdx, [rbp - 24]
        lea	rsi, [rbp - 48]
        cmp	rsi, rcx
        setae	cl
        cmp	rax, rdx
        setae	al
        or	al, cl
        je	.LBB235_2
        mov	eax, dword ptr [rbx + 272]
        mov	ecx, dword ptr [rbx + 276]
        add	eax, 1
        movups	xmm0, xmmword ptr [rbx + 256]
        movaps	xmmword ptr [rbp - 336], xmm0
        mov	dword ptr [rbp - 320], eax
        mov	dword ptr [rbp - 316], ecx
        mov	dword ptr [rbx + 272], eax
        lea	r14, [rbp - 336]
        mov	rdi, rbx
        mov	rsi, r14
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_19396,meta.FieldEnum(codegen_harness.HugeSystem__struct_19396),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).publish"
        mov	rax, qword ptr [rbx + 256]
        movups	xmm0, xmmword ptr [rbx + 264]
        add	rax, 1
        mov	qword ptr [rbp - 336], rax
        movups	xmmword ptr [rbp - 328], xmm0
        mov	qword ptr [rbx + 256], rax
        mov	rdi, rbx
        mov	rsi, r14
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_19396,meta.FieldEnum(codegen_harness.HugeSystem__struct_19396),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).publish"
        add	rsp, 320
        pop	rbx
        pop	r14
        pop	rbp
        ret
.LBB235_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

; --- called functions ---

"debug.FullPanic((function 'defaultPanic')).outOfBounds":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rdx, rsi
        mov	rsi, rdi
        mov	rax, qword ptr [rbp + 8]
        mov	qword ptr [rbp - 16], rax
        mov	byte ptr [rbp - 8], 1
        lea	rdi, [rbp - 16]
        call	debug.panicExtra__anon_1120

"debug.FullPanic((function 'defaultPanic')).memcpyAlias":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rax, qword ptr [rbp + 8]
        mov	qword ptr [rbp - 16], rax
        mov	byte ptr [rbp - 8], 1
        lea	rdx, [rbp - 16]
        mov	edi, offset __anon_1122
        mov	esi, 23
        call	debug.defaultPanic

"debug.FullPanic((function 'defaultPanic')).unwrapNull":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rax, qword ptr [rbp + 8]
        mov	qword ptr [rbp - 16], rax
        mov	byte ptr [rbp - 8], 1
        lea	rdx, [rbp - 16]
        mov	edi, offset __anon_4860
        mov	esi, 25
        call	debug.defaultPanic
        .text

"debug.FullPanic((function 'defaultPanic')).integerOverflow":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rax, qword ptr [rbp + 8]
        mov	qword ptr [rbp - 16], rax
        mov	byte ptr [rbp - 8], 1
        lea	rdx, [rbp - 16]
        mov	edi, offset __anon_5706
        mov	esi, 16
        call	debug.defaultPanic

"debug.FullPanic((function 'defaultPanic')).incorrectAlignment":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rax, qword ptr [rbp + 8]
        mov	qword ptr [rbp - 16], rax
        mov	byte ptr [rbp - 8], 1
        lea	rdx, [rbp - 16]
        mov	edi, offset __anon_6806
        mov	esi, 19
        call	debug.defaultPanic
        .text

"debug.FullPanic((function 'defaultPanic')).copyLenMismatch":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rax, qword ptr [rbp + 8]
        mov	qword ptr [rbp - 16], rax
        mov	byte ptr [rbp - 8], 1
        lea	rdx, [rbp - 16]
        mov	edi, offset __anon_7322
        mov	esi, 55
        call	debug.defaultPanic
        .text

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
        movzx	ecx, r14w
        mov	rax, qword ptr [8*rcx + .L__unnamed_76]
        movzx	r13d, byte ptr [rcx + .L__unnamed_77]
        mov	rdi, rax
        add	rdi, r13
        jb	.LBB190_8
        cmp	rdi, 3
        ja	.LBB190_9
        cmp	rdi, rax
        jne	.LBB190_3
.LBB190_6:
        add	rsp, 24
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        ret
.LBB190_3:
        cmp	r13, 1
        adc	r13, 0
        shl	r13d, 4
        shl	rax, 4
        lea	r12, [r15 + rax]
        add	r12, 24
        xor	ebx, ebx
        jmp	.LBB190_4
.LBB190_5:
        add	rbx, 16
        cmp	r13, rbx
        je	.LBB190_6
.LBB190_4:
        mov	rax, qword ptr [r12 + rbx]
        test	rax, rax
        je	.LBB190_5
        mov	rdi, qword ptr [r12 + rbx - 8]
        mov	word ptr [rbp - 56], r14w
        mov	rcx, qword ptr [rbp - 48]
        mov	qword ptr [rbp - 64], rcx
        lea	rsi, [rbp - 64]
        mov	rdx, r15
        call	rax
        jmp	.LBB190_5
.LBB190_8:
        call	"debug.FullPanic((function 'defaultPanic')).integerOverflow"
.LBB190_9:
        mov	esi, 3
        call	"debug.FullPanic((function 'defaultPanic')).outOfBounds"

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
        jae	.LBB194_8
        movzx	eax, word ptr [rdi + rdi + .L__unnamed_78]
        movzx	r12d, word ptr [rax + rax + .L__unnamed_79]
        mov	rax, qword ptr [8*rax + .L__unnamed_80]
        mov	rbx, rax
        add	rbx, r12
        jb	.LBB194_9
        mov	dword ptr [rbp - 44], esi
        cmp	rbx, 10
        jae	.LBB194_10
        mov	qword ptr [rbp - 64], rcx
        lea	r15, [rcx + rax]
        mov	r13, rbx
        sub	r13, rax
        mov	rdi, rdx
        mov	rsi, r12
        mov	qword ptr [rbp - 56], rdx
        mov	rdx, r15
        mov	rcx, r13
        call	mem.eql__anon_3244
        cmp	r13, r12
        jne	.LBB194_11
        mov	r14d, eax
        mov	rsi, qword ptr [rbp - 56]
        lea	rax, [rsi + r12]
        cmp	r15, rax
        mov	r13, qword ptr [rbp - 64]
        jae	.LBB194_6
        add	rbx, r13
        cmp	rsi, rbx
        jb	.LBB194_12
.LBB194_6:
        mov	rdi, r15
        mov	rbx, rsi
        mov	rdx, r12
        call	memcpy@PLT
        not	r14b
        mov	esi, dword ptr [rbp - 44]
        and	r14b, sil
        test	r14b, 1
        jne	.LBB194_7
        add	rsp, 24
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        ret
.LBB194_7:
        mov	rdi, r13
        mov	rdx, rbx
        add	rsp, 24
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
.LBB194_8:
        mov	esi, 4
        call	"debug.FullPanic((function 'defaultPanic')).outOfBounds"
.LBB194_9:
        call	"debug.FullPanic((function 'defaultPanic')).integerOverflow"
.LBB194_10:
        mov	esi, 9
        mov	rdi, rbx
        call	"debug.FullPanic((function 'defaultPanic')).outOfBounds"
.LBB194_11:
        call	"debug.FullPanic((function 'defaultPanic')).copyLenMismatch"
.LBB194_12:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"
        .text

"system_data.SystemData(codegen_harness.ManyErdsSystem__struct_18252,meta.FieldEnum(codegen_harness.ManyErdsSystem__struct_18252),.{ .e00 = .{ ... }, .e01 = .{ ... }, .e02 = .{ ... }, .e03 = .{ ... }, .e04 = .{ ... }, .e05 = .{ ... }, .e06 = .{ ... }, .e07 = .{ ... }, .e08 = .{ ... }, .e09 = .{ ... }, .e10 = .{ ... }, .e11 = .{ ... }, .e12 = .{ ... }, .e13 = .{ ... }, .e14 = .{ ... }, .e15 = .{ ... }, .e16 = .{ ... }, .e17 = .{ ... }, .e18 = .{ ... }, .e19 = .{ ... }, .e20 = .{ ... }, .e21 = .{ ... }, .e22 = .{ ... }, .e23 = .{ ... }, .e24 = .{ ... }, .e25 = .{ ... }, .e26 = .{ ... }, .e27 = .{ ... }, .e28 = .{ ... }, .e29 = .{ ... }, .e30 = .{ ... }, .e31 = .{ ... } },testing.create.Components).publish":
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 16
        mov	r14, rsi
        mov	rbx, rdi
        mov	rax, qword ptr [rdi + 144]
        test	rax, rax
        je	.LBB201_1
        mov	rdi, qword ptr [rbx + 136]
        mov	word ptr [rbp - 24], 31
        mov	qword ptr [rbp - 32], r14
        lea	rsi, [rbp - 32]
        mov	rdx, rbx
        call	rax
.LBB201_1:
        mov	rax, qword ptr [rbx + 160]
        test	rax, rax
        je	.LBB201_3
        mov	rdi, qword ptr [rbx + 152]
        mov	word ptr [rbp - 24], 31
        mov	qword ptr [rbp - 32], r14
        lea	rsi, [rbp - 32]
        mov	rdx, rbx
        call	rax
.LBB201_3:
        mov	rax, qword ptr [rbx + 176]
        test	rax, rax
        je	.LBB201_5
        mov	rdi, qword ptr [rbx + 168]
        mov	word ptr [rbp - 24], 31
        mov	qword ptr [rbp - 32], r14
        lea	rsi, [rbp - 32]
        mov	rdx, rbx
        call	rax
.LBB201_5:
        add	rsp, 16
        pop	rbx
        pop	r14
        pop	rbp
        ret

"system_data.SystemData(codegen_harness.HugeSystem__struct_19396,meta.FieldEnum(codegen_harness.HugeSystem__struct_19396),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).publish":
        mov	rax, qword ptr [rdi + 296]
        test	rax, rax
        je	.LBB208_2
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
.LBB208_2:
        ret

"debug.FullPanic((function 'defaultPanic')).inactiveUnionField__anon_19864":
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
        call	debug.panicExtra__anon_11113
        .text

debug.panic__anon_19898:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rax, qword ptr [rbp + 8]
        mov	qword ptr [rbp - 16], rax
        mov	byte ptr [rbp - 8], 1
        lea	rdi, [rbp - 16]
        call	debug.panicExtra__anon_19901

"system_data.SystemData(codegen_harness.OtherSystem__struct_18019,meta.FieldEnum(codegen_harness.OtherSystem__struct_18019),.{ .sensor_a = .{ ... }, .sensor_b = .{ ... }, .output = .{ ... } },testing.create.Components).publish":
        mov	rax, qword ptr [rdi + 24]
        test	rax, rax
        je	.LBB230_2
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
.LBB230_2:
        ret

