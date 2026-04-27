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
        lea	rsi, [rdi + 4]
        lea	rcx, [rbp - 1]
        mov	edx, 1
        mov	r8d, 1
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).writeAndPublish"
        add	rsp, 16
        pop	rbp
        ret

codegen_write_u16_with_subs:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	word ptr [rbp - 2], si
        lea	rsi, [rdi + 7]
        lea	rcx, [rbp - 2]
        mov	edx, 2
        mov	r8d, 3
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).writeAndPublish"
        add	rsp, 16
        pop	rbp
        ret

codegen_runtime_read_u32:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        mov	dword ptr [rbp - 4], -1431655766
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 32], xmm0
        lea	rax, [rbp - 28]
        lea	rcx, [rbp]
        lea	rdx, [rbp - 4]
        cmp	rdx, rax
        setae	al
        lea	rdx, [rbp - 32]
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        je	.LBB193_2
        mov	eax, dword ptr [rbp - 32]
        add	rsp, 32
        pop	rbp
        ret
.LBB193_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_runtime_write_u32:
        lea	rax, [rdi + 4]
        cmp	rdi, offset __anon_17845+4
        setae	cl
        cmp	rax, offset __anon_17845
        setbe	al
        or	al, cl
        je	.LBB194_2
        mov	dword ptr [rdi], -559038737
        ret
.LBB194_2:
        push	rbp
        mov	rbp, rsp
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

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
        lea	rsi, [rdi + 112]
        lea	rdx, [rbp - 8]
        call	"system_data.SystemData(codegen_harness.ManyErdsSystem__struct_18244,meta.FieldEnum(codegen_harness.ManyErdsSystem__struct_18244),.{ .e00 = .{ ... }, .e01 = .{ ... }, .e02 = .{ ... }, .e03 = .{ ... }, .e04 = .{ ... }, .e05 = .{ ... }, .e06 = .{ ... }, .e07 = .{ ... }, .e08 = .{ ... }, .e09 = .{ ... }, .e10 = .{ ... }, .e11 = .{ ... }, .e12 = .{ ... }, .e13 = .{ ... }, .e14 = .{ ... }, .e15 = .{ ... }, .e16 = .{ ... }, .e17 = .{ ... }, .e18 = .{ ... }, .e19 = .{ ... }, .e20 = .{ ... }, .e21 = .{ ... }, .e22 = .{ ... }, .e23 = .{ ... }, .e24 = .{ ... }, .e25 = .{ ... }, .e26 = .{ ... }, .e27 = .{ ... }, .e28 = .{ ... }, .e29 = .{ ... }, .e30 = .{ ... }, .e31 = .{ ... } },testing.create.Components).writeAndPublish"
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
        movaps	xmm0, xmmword ptr [rip + .LCPI204_0]
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
        je	.LBB204_2
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
.LBB204_2:
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
        movaps	xmm0, xmmword ptr [rip + .LCPI205_0]
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
        je	.LBB205_2
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
.LBB205_2:
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
        je	.LBB206_2
        mov	eax, dword ptr [rbp - 16]
        add	rsp, 304
        pop	rbp
        ret
.LBB206_2:
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
        movaps	xmm0, xmmword ptr [rip + .LCPI208_0]
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
        je	.LBB208_9
        mov	r8, qword ptr [rbx + 256]
        mov	rdi, qword ptr [rbx + 264]
        mov	esi, dword ptr [rbx + 272]
        movzx	edx, word ptr [rbx + 276]
        movzx	ecx, byte ptr [rbx + 278]
        movzx	eax, byte ptr [rbx + 279]
        mov	r9, qword ptr [r14 + 16]
        movups	xmm0, xmmword ptr [r14]
        movups	xmmword ptr [rbx + 256], xmm0
        mov	qword ptr [rbx + 272], r9
        cmp	r8, qword ptr [r14]
        jne	.LBB208_7
        cmp	rdi, qword ptr [r14 + 8]
        jne	.LBB208_7
        cmp	esi, dword ptr [r14 + 16]
        jne	.LBB208_7
        cmp	dx, word ptr [r14 + 20]
        jne	.LBB208_7
        cmp	cl, byte ptr [r14 + 22]
        jne	.LBB208_7
        and	al, 1
        cmp	byte ptr [r14 + 23], al
        je	.LBB208_8
.LBB208_7:
        lea	rsi, [rbp - 80]
        mov	rdi, rbx
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_19386,meta.FieldEnum(codegen_harness.HugeSystem__struct_19386),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).publish"
.LBB208_8:
        add	rsp, 352
        pop	rbx
        pop	r14
        pop	rbp
        ret
.LBB208_9:
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
        movaps	xmm0, xmmword ptr [rip + .LCPI210_0]
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
        je	.LBB210_2
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
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_19386,meta.FieldEnum(codegen_harness.HugeSystem__struct_19386),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).publish"
        add	rsp, 312
        pop	rbx
        pop	rbp
        ret
.LBB210_2:
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
        movaps	xmm0, xmmword ptr [rip + .LCPI211_0]
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
        je	.LBB211_2
        add	byte ptr [rbx], 1
        add	rsp, 544
        pop	rbx
        pop	r14
        pop	rbp
        ret
.LBB211_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_setup_timer_callback:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rcx, qword ptr [rsi]
        lea	rax, [rdx + 16]
        cmp	qword ptr [rdx + 8], 0
        je	.LBB212_9
        test	rcx, rcx
        je	.LBB212_5
        mov	r8, rsi
.LBB212_3:
        cmp	rcx, rax
        je	.LBB212_11
        mov	r8, rcx
        mov	rcx, qword ptr [rcx]
        test	rcx, rcx
        jne	.LBB212_3
.LBB212_5:
        mov	rcx, qword ptr [rsi + 8]
        test	rcx, rcx
        je	.LBB212_12
        cmp	rcx, rax
        je	.LBB212_10
.LBB212_7:
        mov	r9, qword ptr [rcx]
        test	r9, r9
        je	.LBB212_12
        mov	r8, rcx
        mov	rcx, r9
        cmp	r9, rax
        jne	.LBB212_7
        jmp	.LBB212_11
.LBB212_9:
        mov	r8, rsi
        cmp	rcx, rax
        jne	.LBB212_12
        jmp	.LBB212_11
.LBB212_10:
        lea	r8, [rsi + 8]
.LBB212_11:
        mov	rcx, qword ptr [rax]
        mov	qword ptr [r8], rcx
.LBB212_12:
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
        je	.LBB212_19
        cmp	byte ptr [rcx + 12], 1
        je	.LBB212_21
        mov	edx, dword ptr [rcx + 8]
        sub	edx, edi
        add	edx, -101
        cmp	edx, -65636
        jb	.LBB212_20
.LBB212_15:
        mov	rsi, rcx
        mov	rcx, qword ptr [rcx]
        test	rcx, rcx
        je	.LBB212_19
        cmp	byte ptr [rcx + 12], 1
        je	.LBB212_21
        mov	edx, dword ptr [rcx + 8]
        sub	edx, edi
        add	edx, 65535
        cmp	edx, 65636
        jb	.LBB212_15
        jmp	.LBB212_20
.LBB212_19:
        xor	ecx, ecx
.LBB212_20:
        mov	qword ptr [rax], rcx
        mov	qword ptr [rsi], rax
        add	rsp, 16
        pop	rbp
        ret
.LBB212_21:
        call	"debug.FullPanic((function 'defaultPanic')).inactiveUnionField__anon_19850"

codegen_harness.timer_callback_read_write:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        test	rdi, rdi
        je	.LBB213_5
        test	dil, 7
        jne	.LBB213_4
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
        je	.LBB213_6
        mov	eax, dword ptr [rbp - 32]
        add	eax, 1
        mov	dword ptr [rdi], eax
        add	rsp, 32
        pop	rbp
        ret
.LBB213_5:
        call	"debug.FullPanic((function 'defaultPanic')).unwrapNull"
.LBB213_4:
        call	"debug.FullPanic((function 'defaultPanic')).incorrectAlignment"
.LBB213_6:
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
        je	.LBB215_2
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
.LBB215_2:
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
        je	.LBB216_2
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
.LBB216_2:
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
        je	.LBB217_2
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
.LBB217_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_read_write_other_read:
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 48
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 48], xmm0
        mov	dword ptr [rbp - 20], -1431655766
        lea	rax, [rbp - 44]
        lea	rcx, [rbp - 16]
        lea	rdx, [rbp - 20]
        cmp	rdx, rax
        setae	al
        lea	rdx, [rbp - 48]
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        je	.LBB218_2
        mov	rbx, rdi
        mov	r14d, dword ptr [rbp - 48]
        mov	byte ptr [rbp - 48], sil
        lea	rsi, [rdi + 4]
        lea	rcx, [rbp - 48]
        mov	edx, 1
        mov	r8d, 1
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).writeAndPublish"
        movups	xmm0, xmmword ptr [rbx]
        movaps	xmmword ptr [rbp - 48], xmm0
        add	r14d, dword ptr [rbp - 48]
        mov	eax, r14d
        add	rsp, 48
        pop	rbx
        pop	r14
        pop	rbp
        ret
.LBB218_2:
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
        je	.LBB219_3
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
        je	.LBB219_3
        movzx	ecx, word ptr [rbp - 27]
        add	eax, ecx
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 32], xmm0
        add	eax, dword ptr [rbp - 32]
        add	rsp, 32
        pop	rbp
        ret
.LBB219_3:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_subscribe_callback:
        mov	rax, qword ptr [rdi + 24]
        cmp	rax, offset codegen_harness.accumulate_callback
        je	.LBB220_3
        test	rax, rax
        jne	.LBB220_4
        mov	qword ptr [rdi + 16], 0
        mov	qword ptr [rdi + 24], offset codegen_harness.accumulate_callback
.LBB220_3:
        ret
.LBB220_4:
        push	rbp
        mov	rbp, rsp
        call	debug.panic__anon_19884

codegen_harness.accumulate_callback:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        test	rsi, rsi
        je	.LBB221_7
        test	sil, 7
        jne	.LBB221_8
        test	dl, 7
        jne	.LBB221_8
        mov	rax, qword ptr [rsi]
        cmp	byte ptr [rax], 0
        je	.LBB221_6
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
        je	.LBB221_9
        mov	eax, dword ptr [rbp - 32]
        add	eax, 1
        mov	dword ptr [rdx], eax
.LBB221_6:
        add	rsp, 32
        pop	rbp
        ret
.LBB221_8:
        call	"debug.FullPanic((function 'defaultPanic')).incorrectAlignment"
.LBB221_7:
        call	"debug.FullPanic((function 'defaultPanic')).unwrapNull"
.LBB221_9:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_write_triggering_callback:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	byte ptr [rbp - 1], 1
        lea	rsi, [rdi + 4]
        lea	rcx, [rbp - 1]
        mov	edx, 1
        mov	r8d, 1
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).writeAndPublish"
        add	rsp, 16
        pop	rbp
        ret

codegen_increment_n_times:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        test	esi, esi
        je	.LBB225_7
        lea	rax, [rbp - 12]
        lea	rcx, [rbp - 16]
        lea	rdx, [rbp - 20]
        cmp	rdx, rax
        setb	al
        lea	rdx, [rbp - 16]
        cmp	rdx, rcx
        setb	cl
        test	cl, al
        jne	.LBB225_8
        cmp	esi, 1
        je	.LBB225_6
        mov	eax, esi
        and	eax, -2
        neg	eax
.LBB225_4:
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
        jne	.LBB225_4
        test	sil, 1
        je	.LBB225_7
.LBB225_6:
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 16], xmm0
        mov	eax, dword ptr [rbp - 16]
        add	eax, 1
        mov	dword ptr [rdi], eax
.LBB225_7:
        add	rsp, 32
        pop	rbp
        ret
.LBB225_8:
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
        je	.LBB226_9
        test	byte ptr [rbp - 28], 1
        je	.LBB226_2
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
        je	.LBB226_9
        mov	esi, dword ptr [rbp - 32]
        add	esi, 10
        mov	dword ptr [rdi], esi
.LBB226_2:
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
        je	.LBB226_9
        cmp	word ptr [rbp - 27], 100
        jbe	.LBB226_4
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
        je	.LBB226_9
        mov	eax, dword ptr [rbp - 32]
        add	eax, 20
        mov	dword ptr [rdi], eax
.LBB226_4:
        add	rsp, 32
        pop	rbp
        ret
.LBB226_9:
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
        je	.LBB227_3
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
        je	.LBB227_3
        add	ax, word ptr [rbp - 32]
        mov	word ptr [rbp - 32], ax
        lea	rsi, [rdi + 7]
        lea	rcx, [rbp - 32]
        mov	edx, 2
        mov	r8d, 3
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).writeAndPublish"
        add	rsp, 32
        pop	rbp
        ret
.LBB227_3:
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
        je	.LBB228_4
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
        je	.LBB228_4
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
        je	.LBB228_4
        add	rcx, rdx
        movsxd	rax, dword ptr [rbp - 28]
        add	rax, rdi
        add	rax, rcx
        add	rsp, 32
        pop	rbp
        ret
.LBB228_4:
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
        je	.LBB229_2
        mov	eax, dword ptr [rbp - 32]
        mov	dword ptr [rdi], eax
        add	rsp, 32
        pop	rbp
        ret
.LBB229_2:
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
        je	.LBB230_2
        mov	eax, dword ptr [rbp - 32]
        movups	xmm0, xmmword ptr [rsi]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	ecx, dword ptr [rbp - 32]
        mov	dword ptr [rdi], ecx
        mov	dword ptr [rbp - 32], eax
        mov	rdi, rsi
        call	"system_data.SystemData(codegen_harness.OtherSystem__struct_18011,meta.FieldEnum(codegen_harness.OtherSystem__struct_18011),.{ .sensor_a = .{ ... }, .sensor_b = .{ ... }, .output = .{ ... } },testing.create.Components).writeAndPublish"
        add	rsp, 32
        pop	rbp
        ret
.LBB230_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_double_write_same_value:
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 16
        mov	rbx, rdi
        mov	byte ptr [rbp - 17], 1
        lea	r14, [rdi + 4]
        lea	rcx, [rbp - 17]
        mov	edx, 1
        mov	rsi, r14
        mov	r8d, 1
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).writeAndPublish"
        mov	byte ptr [rbp - 18], 1
        lea	rcx, [rbp - 18]
        mov	edx, 1
        mov	rdi, rbx
        mov	rsi, r14
        mov	r8d, 1
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).writeAndPublish"
        add	rsp, 16
        pop	rbx
        pop	r14
        pop	rbp
        ret

codegen_double_write_diff_values:
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 16
        mov	rbx, rdi
        mov	byte ptr [rbp - 17], 1
        lea	r14, [rdi + 4]
        lea	rcx, [rbp - 17]
        mov	edx, 1
        mov	rsi, r14
        mov	r8d, 1
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).writeAndPublish"
        mov	byte ptr [rbp - 18], 0
        lea	rcx, [rbp - 18]
        mov	edx, 1
        mov	rdi, rbx
        mov	rsi, r14
        mov	r8d, 1
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).writeAndPublish"
        add	rsp, 16
        pop	rbx
        pop	r14
        pop	rbp
        ret

codegen_write_junk_read_write:
        push	rbp
        mov	rbp, rsp
        push	r15
        push	r14
        push	rbx
        sub	rsp, 24
        mov	r14, rdi
        mov	word ptr [rbp - 48], 1
        lea	rbx, [rdi + 7]
        lea	r15, [rbp - 48]
        mov	edx, 2
        mov	rsi, rbx
        mov	rcx, r15
        mov	r8d, 3
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).writeAndPublish"
        movups	xmm0, xmmword ptr [r14]
        movaps	xmmword ptr [rbp - 48], xmm0
        mov	dword ptr [rbp - 28], -1431655766
        lea	rax, [rbp - 44]
        lea	rcx, [rbp - 24]
        lea	rdx, [rbp - 28]
        cmp	rdx, rax
        setae	al
        cmp	r15, rcx
        setae	cl
        or	cl, al
        je	.LBB235_2
        mov	word ptr [rbp - 48], 2
        lea	rcx, [rbp - 48]
        mov	edx, 2
        mov	rdi, r14
        mov	rsi, rbx
        mov	r8d, 3
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).writeAndPublish"
        add	rsp, 24
        pop	rbx
        pop	r14
        pop	r15
        pop	rbp
        ret
.LBB235_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_triple_write_increment:
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 16
        mov	rbx, rdi
        mov	word ptr [rbp - 18], 1
        lea	r14, [rdi + 7]
        lea	rcx, [rbp - 18]
        mov	edx, 2
        mov	rsi, r14
        mov	r8d, 3
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).writeAndPublish"
        mov	word ptr [rbp - 20], 2
        lea	rcx, [rbp - 20]
        mov	edx, 2
        mov	rdi, rbx
        mov	rsi, r14
        mov	r8d, 3
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).writeAndPublish"
        mov	word ptr [rbp - 22], 3
        lea	rcx, [rbp - 22]
        mov	edx, 2
        mov	rdi, rbx
        mov	rsi, r14
        mov	r8d, 3
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).writeAndPublish"
        add	rsp, 16
        pop	rbx
        pop	r14
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
        movaps	xmm0, xmmword ptr [rip + .LCPI237_0]
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
        je	.LBB237_2
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
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_19386,meta.FieldEnum(codegen_harness.HugeSystem__struct_19386),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).publish"
        mov	rax, qword ptr [rbx + 256]
        movups	xmm0, xmmword ptr [rbx + 264]
        add	rax, 1
        mov	qword ptr [rbp - 336], rax
        movups	xmmword ptr [rbp - 328], xmm0
        mov	qword ptr [rbx + 256], rax
        mov	rdi, rbx
        mov	rsi, r14
        call	"system_data.SystemData(codegen_harness.HugeSystem__struct_19386,meta.FieldEnum(codegen_harness.HugeSystem__struct_19386),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).publish"
        add	rsp, 320
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

"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).writeAndPublish":
        push	rbp
        mov	rbp, rsp
        push	r15
        push	r14
        push	r13
        push	r12
        push	rbx
        push	rax
        mov	r14d, r8d
        mov	rbx, rcx
        mov	r13, rdx
        mov	r15, rsi
        mov	r12, rdi
        mov	rdi, rsi
        mov	rsi, rdx
        mov	rdx, rcx
        mov	rcx, r13
        call	mem.eql__anon_3244
        lea	rcx, [rbx + r13]
        lea	rsi, [r15 + r13]
        cmp	r15, rcx
        setae	dil
        cmp	rbx, rsi
        setae	cl
        or	cl, dil
        test	al, 1
        je	.LBB190_1
        test	cl, cl
        je	.LBB190_2
        mov	rdi, r15
        mov	rsi, rbx
        mov	rdx, r13
        add	rsp, 8
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        jmp	memcpy@PLT
.LBB190_1:
        test	cl, cl
        je	.LBB190_2
        mov	rdi, r15
        mov	rsi, rbx
        mov	rdx, r13
        call	memcpy@PLT
        mov	rdi, r12
        mov	esi, r14d
        mov	rdx, rbx
        add	rsp, 8
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_219,meta.FieldEnum(codegen_harness.SmallSystem__struct_219),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },testing.create.Components).publish"
.LBB190_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

"system_data.SystemData(codegen_harness.ManyErdsSystem__struct_18244,meta.FieldEnum(codegen_harness.ManyErdsSystem__struct_18244),.{ .e00 = .{ ... }, .e01 = .{ ... }, .e02 = .{ ... }, .e03 = .{ ... }, .e04 = .{ ... }, .e05 = .{ ... }, .e06 = .{ ... }, .e07 = .{ ... }, .e08 = .{ ... }, .e09 = .{ ... }, .e10 = .{ ... }, .e11 = .{ ... }, .e12 = .{ ... }, .e13 = .{ ... }, .e14 = .{ ... }, .e15 = .{ ... }, .e16 = .{ ... }, .e17 = .{ ... }, .e18 = .{ ... }, .e19 = .{ ... }, .e20 = .{ ... }, .e21 = .{ ... }, .e22 = .{ ... }, .e23 = .{ ... }, .e24 = .{ ... }, .e25 = .{ ... }, .e26 = .{ ... }, .e27 = .{ ... }, .e28 = .{ ... }, .e29 = .{ ... }, .e30 = .{ ... }, .e31 = .{ ... } },testing.create.Components).writeAndPublish":
        push	rbp
        mov	rbp, rsp
        cmp	rsi, rdx
        je	.LBB201_4
        movq	xmm0, qword ptr [rdx]
        movq	rax, xmm0
        cmp	rax, qword ptr [rsi]
        jne	.LBB201_2
.LBB201_4:
        lea	rax, [rdx + 8]
        lea	rcx, [rsi + 8]
        cmp	rsi, rax
        setb	al
        cmp	rdx, rcx
        setb	cl
        test	cl, al
        jne	.LBB201_3
        mov	rax, qword ptr [rdx]
        mov	qword ptr [rsi], rax
        pop	rbp
        ret
.LBB201_2:
        lea	rax, [rdx + 8]
        lea	rcx, [rsi + 8]
        cmp	rsi, rax
        setb	al
        cmp	rdx, rcx
        setb	cl
        test	cl, al
        jne	.LBB201_3
        movq	qword ptr [rsi], xmm0
        mov	rsi, rdx
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.ManyErdsSystem__struct_18244,meta.FieldEnum(codegen_harness.ManyErdsSystem__struct_18244),.{ .e00 = .{ ... }, .e01 = .{ ... }, .e02 = .{ ... }, .e03 = .{ ... }, .e04 = .{ ... }, .e05 = .{ ... }, .e06 = .{ ... }, .e07 = .{ ... }, .e08 = .{ ... }, .e09 = .{ ... }, .e10 = .{ ... }, .e11 = .{ ... }, .e12 = .{ ... }, .e13 = .{ ... }, .e14 = .{ ... }, .e15 = .{ ... }, .e16 = .{ ... }, .e17 = .{ ... }, .e18 = .{ ... }, .e19 = .{ ... }, .e20 = .{ ... }, .e21 = .{ ... }, .e22 = .{ ... }, .e23 = .{ ... }, .e24 = .{ ... }, .e25 = .{ ... }, .e26 = .{ ... }, .e27 = .{ ... }, .e28 = .{ ... }, .e29 = .{ ... }, .e30 = .{ ... }, .e31 = .{ ... } },testing.create.Components).publish"
.LBB201_3:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

"system_data.SystemData(codegen_harness.HugeSystem__struct_19386,meta.FieldEnum(codegen_harness.HugeSystem__struct_19386),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },testing.create.Components).publish":
        mov	rax, qword ptr [rdi + 296]
        test	rax, rax
        je	.LBB209_2
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
.LBB209_2:
        ret

"debug.FullPanic((function 'defaultPanic')).inactiveUnionField__anon_19850":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 48
        mov	rax, qword ptr [rbp + 8]
        mov	qword ptr [rbp - 16], rax
        mov	byte ptr [rbp - 8], 1
        mov	qword ptr [rbp - 48], offset .L__unnamed_78
        mov	qword ptr [rbp - 40], 10
        mov	qword ptr [rbp - 32], offset .L__unnamed_79
        mov	qword ptr [rbp - 24], 25
        lea	rdi, [rbp - 16]
        lea	rsi, [rbp - 48]
        call	debug.panicExtra__anon_11113
        .text

debug.panic__anon_19884:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rax, qword ptr [rbp + 8]
        mov	qword ptr [rbp - 16], rax
        mov	byte ptr [rbp - 8], 1
        lea	rdi, [rbp - 16]
        call	debug.panicExtra__anon_19887

"system_data.SystemData(codegen_harness.OtherSystem__struct_18011,meta.FieldEnum(codegen_harness.OtherSystem__struct_18011),.{ .sensor_a = .{ ... }, .sensor_b = .{ ... }, .output = .{ ... } },testing.create.Components).writeAndPublish":
        push	rbp
        mov	rbp, rsp
        cmp	rsi, rdx
        je	.LBB231_4
        mov	eax, dword ptr [rdx]
        cmp	eax, dword ptr [rsi]
        jne	.LBB231_2
.LBB231_4:
        lea	rax, [rdx + 4]
        lea	rcx, [rsi + 4]
        cmp	rsi, rax
        setb	al
        cmp	rdx, rcx
        setb	cl
        test	cl, al
        jne	.LBB231_3
        mov	eax, dword ptr [rdx]
        mov	dword ptr [rsi], eax
        pop	rbp
        ret
.LBB231_2:
        lea	rcx, [rdx + 4]
        lea	r8, [rsi + 4]
        cmp	rsi, rcx
        setb	cl
        cmp	rdx, r8
        setb	r8b
        test	r8b, cl
        jne	.LBB231_3
        mov	dword ptr [rsi], eax
        mov	rsi, rdx
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.OtherSystem__struct_18011,meta.FieldEnum(codegen_harness.OtherSystem__struct_18011),.{ .sensor_a = .{ ... }, .sensor_b = .{ ... }, .output = .{ ... } },testing.create.Components).publish"
.LBB231_3:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

