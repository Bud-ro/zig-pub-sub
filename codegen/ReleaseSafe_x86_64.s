codegen_read_u32:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        vmovups	xmm0, xmmword ptr [rdi]
        lea	rax, [rbp - 28]
        lea	rdx, [rbp - 4]
        lea	rcx, [rbp]
        mov	dword ptr [rbp - 4], -1431655766
        cmp	rdx, rax
        lea	rdx, [rbp - 32]
        setae	al
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        vmovaps	xmmword ptr [rbp - 32], xmm0
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
        vmovups	xmm0, xmmword ptr [rdi]
        lea	rcx, [rbp - 27]
        lea	rsi, [rbp - 1]
        lea	rax, [rbp - 28]
        lea	rdx, [rbp]
        mov	byte ptr [rbp - 1], -86
        cmp	rsi, rcx
        setae	cl
        cmp	rax, rdx
        setae	al
        or	al, cl
        vmovaps	xmmword ptr [rbp - 32], xmm0
        je	.LBB186_2
        movzx	eax, byte ptr [rbp - 28]
        and	al, 1
        add	rsp, 32
        pop	rbp
        ret
.LBB186_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_read_u16_unaligned:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        vmovups	xmm0, xmmword ptr [rdi]
        lea	rcx, [rbp - 25]
        lea	rsi, [rbp - 2]
        lea	rax, [rbp - 27]
        lea	rdx, [rbp]
        mov	word ptr [rbp - 2], -21846
        cmp	rsi, rcx
        setae	cl
        cmp	rax, rdx
        setae	al
        or	al, cl
        vmovaps	xmmword ptr [rbp - 32], xmm0
        je	.LBB187_2
        movzx	eax, word ptr [rbp - 27]
        add	rsp, 32
        pop	rbp
        ret
.LBB187_2:
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
        sub	rsp, 32
        mov	byte ptr [rbp - 1], sil
        cmp	sil, byte ptr [rdi + 4]
        mov	byte ptr [rdi + 4], sil
        je	.LBB190_3
        mov	rax, qword ptr [rdi + 24]
        mov	rdx, rdi
        test	rax, rax
        je	.LBB190_3
        mov	rdi, qword ptr [rdx + 16]
        lea	rsi, [rbp - 24]
        lea	rcx, [rbp - 1]
        mov	word ptr [rbp - 16], 1
        mov	qword ptr [rbp - 24], rcx
        call	rax
.LBB190_3:
        add	rsp, 32
        pop	rbp
        ret

codegen_write_u16_with_subs:
        push	rbp
        mov	rbp, rsp
        push	rbx
        sub	rsp, 24
        mov	word ptr [rbp - 10], si
        mov	rbx, rdi
        movzx	eax, byte ptr [rdi + 8]
        cmp	byte ptr [rdi + 7], sil
        mov	word ptr [rdi + 7], si
        jne	.LBB191_2
        shr	esi, 8
        cmp	al, sil
        jne	.LBB191_2
.LBB191_5:
        add	rsp, 24
        pop	rbx
        pop	rbp
        ret
.LBB191_2:
        mov	rax, qword ptr [rbx + 40]
        test	rax, rax
        je	.LBB191_3
        mov	rdi, qword ptr [rbx + 32]
        lea	rcx, [rbp - 10]
        lea	rsi, [rbp - 32]
        mov	word ptr [rbp - 24], 3
        mov	rdx, rbx
        mov	qword ptr [rbp - 32], rcx
        call	rax
.LBB191_3:
        mov	rax, qword ptr [rbx + 56]
        test	rax, rax
        je	.LBB191_5
        mov	rdi, qword ptr [rbx + 48]
        lea	rcx, [rbp - 10]
        lea	rsi, [rbp - 32]
        mov	word ptr [rbp - 24], 3
        mov	rdx, rbx
        mov	qword ptr [rbp - 32], rcx
        call	rax
        add	rsp, 24
        pop	rbx
        pop	rbp
        ret

codegen_runtime_read_u32:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        mov	dword ptr [rbp - 4], -1431655766
        lea	rax, [rbp - 28]
        lea	rdx, [rbp - 4]
        lea	rcx, [rbp]
        vmovups	xmm0, xmmword ptr [rdi]
        cmp	rdx, rax
        lea	rdx, [rbp - 32]
        setae	al
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        vmovaps	xmmword ptr [rbp - 32], xmm0
        je	.LBB192_2
        mov	eax, dword ptr [rbp - 32]
        add	rsp, 32
        pop	rbp
        ret
.LBB192_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_runtime_write_u32:
        cmp	rdi, offset __anon_18232+4
        lea	rax, [rdi + 4]
        setae	cl
        cmp	rax, offset __anon_18232
        setbe	al
        or	al, cl
        je	.LBB193_2
        mov	dword ptr [rdi], -559038737
        ret
.LBB193_2:
        push	rbp
        mov	rbp, rsp
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_dual_read:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        vmovups	xmm0, xmmword ptr [rdi]
        lea	rax, [rbp - 28]
        lea	rdx, [rbp - 4]
        lea	rcx, [rbp]
        mov	dword ptr [rbp - 4], -1431655766
        cmp	rdx, rax
        lea	rdx, [rbp - 32]
        setae	al
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        vmovaps	xmmword ptr [rbp - 32], xmm0
        je	.LBB194_2
        vmovups	xmm0, xmmword ptr [rsi]
        mov	ecx, dword ptr [rbp - 32]
        vmovaps	xmmword ptr [rbp - 32], xmm0
        movsxd	rax, dword ptr [rbp - 32]
        add	rax, rcx
        add	rsp, 32
        pop	rbp
        ret
.LBB194_2:
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
        vmovups	zmm0, zmmword ptr [rdi]
        vmovups	zmm1, zmmword ptr [rdi + 56]
        lea	rax, [rbp - 127]
        lea	rdx, [rbp - 1]
        lea	rcx, [rbp]
        mov	byte ptr [rbp - 1], -86
        cmp	rdx, rax
        lea	rdx, [rbp - 128]
        setae	al
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        vmovups	zmmword ptr [rbp - 72], zmm1
        vmovups	zmmword ptr [rbp - 128], zmm0
        je	.LBB196_2
        movzx	eax, byte ptr [rbp - 128]
        add	rsp, 128
        pop	rbp
        vzeroupper
        ret
.LBB196_2:
        vzeroupper
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_many_read_middle:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 128
        vmovups	zmm0, zmmword ptr [rdi]
        vmovups	zmm1, zmmword ptr [rdi + 56]
        lea	rcx, [rbp - 76]
        lea	rsi, [rbp - 4]
        lea	rax, [rbp - 80]
        lea	rdx, [rbp]
        mov	dword ptr [rbp - 4], -1431655766
        cmp	rsi, rcx
        setae	cl
        cmp	rax, rdx
        setae	al
        or	al, cl
        vmovups	zmmword ptr [rbp - 72], zmm1
        vmovups	zmmword ptr [rbp - 128], zmm0
        je	.LBB197_2
        mov	eax, dword ptr [rbp - 80]
        add	rsp, 128
        pop	rbp
        vzeroupper
        ret
.LBB197_2:
        vzeroupper
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_many_read_last:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 128
        vmovups	zmm0, zmmword ptr [rdi]
        vmovups	zmm1, zmmword ptr [rdi + 56]
        movabs	rax, -6148914691236517206
        lea	rcx, [rbp - 8]
        lea	rsi, [rbp - 8]
        lea	rdx, [rbp]
        cmp	rsi, rcx
        mov	qword ptr [rbp - 8], rax
        lea	rax, [rbp - 16]
        setae	cl
        cmp	rax, rdx
        setae	al
        or	al, cl
        vmovups	zmmword ptr [rbp - 72], zmm1
        vmovups	zmmword ptr [rbp - 128], zmm0
        je	.LBB198_2
        mov	rax, qword ptr [rbp - 16]
        add	rsp, 128
        pop	rbp
        vzeroupper
        ret
.LBB198_2:
        vzeroupper
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_many_write_last_with_subs:
        push	rbp
        mov	rbp, rsp
        push	rbx
        sub	rsp, 24
        mov	qword ptr [rbp - 32], rsi
        mov	rcx, rsi
        shr	rcx, 32
        mov	rbx, rdi
        mov	eax, dword ptr [rdi + 112]
        cmp	dword ptr [rdi + 116], ecx
        mov	qword ptr [rdi + 112], rsi
        jne	.LBB199_2
        cmp	eax, esi
        jne	.LBB199_2
.LBB199_7:
        add	rsp, 24
        pop	rbx
        pop	rbp
        ret
.LBB199_2:
        mov	rax, qword ptr [rbx + 144]
        test	rax, rax
        je	.LBB199_3
        mov	rdi, qword ptr [rbx + 136]
        lea	rcx, [rbp - 32]
        lea	rsi, [rbp - 24]
        mov	word ptr [rbp - 16], 31
        mov	rdx, rbx
        mov	qword ptr [rbp - 24], rcx
        call	rax
.LBB199_3:
        mov	rax, qword ptr [rbx + 160]
        test	rax, rax
        je	.LBB199_5
        mov	rdi, qword ptr [rbx + 152]
        lea	rcx, [rbp - 32]
        lea	rsi, [rbp - 24]
        mov	word ptr [rbp - 16], 31
        mov	rdx, rbx
        mov	qword ptr [rbp - 24], rcx
        call	rax
.LBB199_5:
        mov	rax, qword ptr [rbx + 176]
        test	rax, rax
        je	.LBB199_7
        mov	rdi, qword ptr [rbx + 168]
        lea	rcx, [rbp - 32]
        lea	rsi, [rbp - 24]
        mov	word ptr [rbp - 16], 31
        mov	rdx, rbx
        mov	qword ptr [rbp - 24], rcx
        call	rax
        add	rsp, 24
        pop	rbx
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
        sub	rsp, 544
        vmovups	zmm0, zmmword ptr [rsi + 224]
        lea	rax, [rbp - 32]
        lea	rdx, [rbp - 544]
        lea	rcx, [rbp - 288]
        cmp	rdx, rax
        lea	rdx, [rbp - 288]
        setae	al
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        vmovups	zmmword ptr [rbp - 64], zmm0
        vmovups	zmm1, zmmword ptr [rsi + 64]
        vmovups	zmm0, zmmword ptr [rsi]
        vmovups	zmm2, zmmword ptr [rsi + 128]
        vmovups	zmm3, zmmword ptr [rsi + 192]
        vmovups	zmmword ptr [rbp - 224], zmm1
        vbroadcastss	zmm1, dword ptr [rip + .LCPI201_1]
        vmovups	zmmword ptr [rbp - 96], zmm3
        vmovups	zmmword ptr [rbp - 160], zmm2
        vmovups	zmmword ptr [rbp - 288], zmm0
        vmovups	zmmword ptr [rbp - 544], zmm1
        vmovups	zmmword ptr [rbp - 480], zmm1
        vmovups	zmmword ptr [rbp - 416], zmm1
        vmovups	zmmword ptr [rbp - 352], zmm1
        je	.LBB201_2
        vmovups	zmm0, zmmword ptr [rsi]
        vmovups	zmm1, zmmword ptr [rsi + 64]
        vmovups	zmm2, zmmword ptr [rsi + 128]
        vmovups	zmm3, zmmword ptr [rsi + 192]
        mov	rax, rdi
        vmovups	zmmword ptr [rdi + 192], zmm3
        vmovups	zmmword ptr [rdi + 128], zmm2
        vmovups	zmmword ptr [rdi + 64], zmm1
        vmovups	zmmword ptr [rdi], zmm0
        add	rsp, 544
        pop	rbp
        vzeroupper
        ret
.LBB201_2:
        vzeroupper
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_read_medium_struct:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 320
        vmovups	zmm0, zmmword ptr [rsi + 224]
        movabs	rax, -6148914691236517206
        lea	rcx, [rbp - 40]
        lea	r8, [rbp - 32]
        lea	rdx, [rbp - 8]
        cmp	r8, rcx
        setae	cl
        vmovups	zmmword ptr [rbp - 96], zmm0
        vmovups	zmm1, zmmword ptr [rsi + 64]
        vmovups	zmm0, zmmword ptr [rsi]
        vmovups	zmm2, zmmword ptr [rsi + 128]
        vmovups	zmm3, zmmword ptr [rsi + 192]
        mov	qword ptr [rbp - 16], rax
        lea	rax, [rbp - 64]
        cmp	rax, rdx
        setae	al
        or	al, cl
        vmovups	zmmword ptr [rbp - 256], zmm1
        vbroadcastss	xmm1, dword ptr [rip + .LCPI202_1]
        vmovups	zmmword ptr [rbp - 128], zmm3
        vmovups	zmmword ptr [rbp - 192], zmm2
        vmovups	zmmword ptr [rbp - 320], zmm0
        vmovaps	xmmword ptr [rbp - 32], xmm1
        je	.LBB202_2
        mov	rax, qword ptr [rsi + 272]
        mov	qword ptr [rdi + 16], rax
        mov	rax, rdi
        vmovups	xmm0, xmmword ptr [rsi + 256]
        vmovups	xmmword ptr [rdi], xmm0
        add	rsp, 320
        pop	rbp
        vzeroupper
        ret
.LBB202_2:
        vzeroupper
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_read_u32_after_big:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 304
        vmovups	zmm0, zmmword ptr [rdi + 224]
        lea	rcx, [rbp - 20]
        lea	rsi, [rbp - 4]
        lea	rax, [rbp - 24]
        lea	rdx, [rbp]
        cmp	rsi, rcx
        setae	cl
        cmp	rax, rdx
        setae	al
        or	al, cl
        vmovups	zmmword ptr [rbp - 80], zmm0
        vmovups	zmm0, zmmword ptr [rdi]
        vmovups	zmm1, zmmword ptr [rdi + 64]
        vmovups	zmm2, zmmword ptr [rdi + 128]
        vmovups	zmm3, zmmword ptr [rdi + 192]
        mov	dword ptr [rbp - 4], -1431655766
        vmovups	zmmword ptr [rbp - 112], zmm3
        vmovups	zmmword ptr [rbp - 176], zmm2
        vmovups	zmmword ptr [rbp - 240], zmm1
        vmovups	zmmword ptr [rbp - 304], zmm0
        je	.LBB203_2
        mov	eax, dword ptr [rbp - 24]
        add	rsp, 304
        pop	rbp
        vzeroupper
        ret
.LBB203_2:
        vzeroupper
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_write_big_struct:
        push	rbp
        mov	rbp, rsp
        vmovups	zmm0, zmmword ptr [rsi]
        vmovups	zmm1, zmmword ptr [rsi + 64]
        vmovups	zmm2, zmmword ptr [rsi + 128]
        vmovups	zmm3, zmmword ptr [rsi + 192]
        vmovups	zmmword ptr [rdi], zmm0
        vmovups	zmmword ptr [rdi + 64], zmm1
        vmovups	zmmword ptr [rdi + 128], zmm2
        vmovups	zmmword ptr [rdi + 192], zmm3
        pop	rbp
        vzeroupper
        ret

codegen_write_medium_with_subs:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 64
        mov	rax, qword ptr [rsi + 16]
        mov	qword ptr [rbp - 48], rax
        vmovups	xmm0, xmmword ptr [rsi]
        vmovaps	xmmword ptr [rbp - 64], xmm0
        mov	rax, qword ptr [rsi + 16]
        mov	qword ptr [rbp - 16], rax
        vmovdqu	xmm0, xmmword ptr [rsi]
        vmovdqa	xmmword ptr [rbp - 32], xmm0
        vmovdqu	xmm1, xmmword ptr [rbp - 24]
        vpcmpneqb	k0, xmm0, xmmword ptr [rdi + 256]
        vmovups	xmm0, xmmword ptr [rsi]
        mov	rax, qword ptr [rsi + 16]
        vpcmpneqb	k1, xmm1, xmmword ptr [rdi + 264]
        mov	qword ptr [rdi + 272], rax
        vmovups	xmmword ptr [rdi + 256], xmm0
        kortestw	k0, k1
        je	.LBB205_3
        mov	rax, qword ptr [rdi + 296]
        mov	rdx, rdi
        test	rax, rax
        je	.LBB205_3
        mov	rdi, qword ptr [rdx + 288]
        lea	rsi, [rbp - 32]
        lea	rcx, [rbp - 64]
        mov	word ptr [rbp - 24], 1
        mov	qword ptr [rbp - 32], rcx
        call	rax
.LBB205_3:
        add	rsp, 64
        pop	rbp
        ret

codegen_read_modify_write_medium:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 320
        vmovups	zmm0, zmmword ptr [rdi + 224]
        movabs	rax, -6148914691236517206
        lea	rsi, [rbp - 40]
        mov	rdx, rdi
        lea	rcx, [rbp - 64]
        vmovups	zmmword ptr [rbp - 96], zmm0
        vmovups	zmm1, zmmword ptr [rdi + 64]
        vmovups	zmm0, zmmword ptr [rdi]
        vmovups	zmm2, zmmword ptr [rdi + 128]
        vmovups	zmm3, zmmword ptr [rdi + 192]
        mov	qword ptr [rbp - 16], rax
        lea	rax, [rbp - 32]
        lea	rdi, [rbp - 8]
        cmp	rax, rsi
        setae	sil
        cmp	rcx, rdi
        setae	cl
        or	cl, sil
        vmovups	zmmword ptr [rbp - 256], zmm1
        vbroadcastss	xmm1, dword ptr [rip + .LCPI206_1]
        vmovups	zmmword ptr [rbp - 128], zmm3
        vmovups	zmmword ptr [rbp - 192], zmm2
        vmovups	zmmword ptr [rbp - 320], zmm0
        vmovaps	xmmword ptr [rbp - 32], xmm1
        je	.LBB206_5
        vmovups	xmm0, xmmword ptr [rdx + 256]
        mov	ecx, dword ptr [rdx + 272]
        mov	esi, dword ptr [rdx + 276]
        inc	ecx
        vmovaps	xmmword ptr [rbp - 32], xmm0
        mov	dword ptr [rbp - 16], ecx
        mov	dword ptr [rbp - 12], esi
        vmovdqu	xmm0, xmmword ptr [rdx + 256]
        vmovdqa	xmmword ptr [rbp - 320], xmm0
        mov	dword ptr [rbp - 304], ecx
        mov	dword ptr [rbp - 300], esi
        vmovdqu	xmm1, xmmword ptr [rbp - 312]
        vpcmpneqb	k0, xmm0, xmmword ptr [rdx + 256]
        vpcmpneqb	k1, xmm1, xmmword ptr [rdx + 264]
        mov	dword ptr [rdx + 272], ecx
        kortestw	k0, k1
        je	.LBB206_4
        mov	rcx, qword ptr [rdx + 296]
        test	rcx, rcx
        je	.LBB206_4
        mov	rdi, qword ptr [rdx + 288]
        lea	rsi, [rbp - 320]
        mov	word ptr [rbp - 312], 1
        mov	qword ptr [rbp - 320], rax
        vzeroupper
        call	rcx
.LBB206_4:
        add	rsp, 320
        pop	rbp
        vzeroupper
        ret
.LBB206_5:
        vzeroupper
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_read_modify_write_big:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 544
        vmovups	zmm0, zmmword ptr [rdi + 224]
        lea	rax, [rbp - 32]
        lea	rdx, [rbp - 544]
        lea	rcx, [rbp - 288]
        cmp	rdx, rax
        lea	rdx, [rbp - 288]
        setae	al
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        vmovups	zmmword ptr [rbp - 64], zmm0
        vmovups	zmm1, zmmword ptr [rdi + 64]
        vmovups	zmm0, zmmword ptr [rdi]
        vmovups	zmm2, zmmword ptr [rdi + 128]
        vmovups	zmm3, zmmword ptr [rdi + 192]
        vmovups	zmmword ptr [rbp - 224], zmm1
        vbroadcastss	zmm1, dword ptr [rip + .LCPI207_1]
        vmovups	zmmword ptr [rbp - 96], zmm3
        vmovups	zmmword ptr [rbp - 160], zmm2
        vmovups	zmmword ptr [rbp - 288], zmm0
        vmovups	zmmword ptr [rbp - 544], zmm1
        vmovups	zmmword ptr [rbp - 480], zmm1
        vmovups	zmmword ptr [rbp - 416], zmm1
        vmovups	zmmword ptr [rbp - 352], zmm1
        je	.LBB207_2
        inc	byte ptr [rdi]
        add	rsp, 544
        pop	rbp
        vzeroupper
        ret
.LBB207_2:
        vzeroupper
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_setup_timer_callback:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rcx, qword ptr [rsi]
        cmp	qword ptr [rdx + 8], 0
        lea	rax, [rdx + 16]
        je	.LBB208_9
        test	rcx, rcx
        je	.LBB208_5
        mov	r8, rsi
.LBB208_3:
        cmp	rcx, rax
        je	.LBB208_11
        mov	r8, rcx
        mov	rcx, qword ptr [rcx]
        test	rcx, rcx
        jne	.LBB208_3
.LBB208_5:
        mov	rcx, qword ptr [rsi + 8]
        test	rcx, rcx
        je	.LBB208_12
        cmp	rcx, rax
        je	.LBB208_10
.LBB208_7:
        mov	r9, qword ptr [rcx]
        test	r9, r9
        je	.LBB208_12
        mov	r8, rcx
        mov	rcx, r9
        cmp	r9, rax
        jne	.LBB208_7
        jmp	.LBB208_11
.LBB208_9:
        mov	r8, rsi
        cmp	rcx, rax
        jne	.LBB208_12
        jmp	.LBB208_11
.LBB208_10:
        lea	r8, [rsi + 8]
.LBB208_11:
        mov	rcx, qword ptr [rax]
        mov	qword ptr [r8], rcx
.LBB208_12:
        or	rdi, 1
        mov	qword ptr [rdx + 8], offset codegen_harness.timer_callback_read_write
        mov	dword ptr [rdx + 32], 100
        mov	qword ptr [rdx], rdi
        mov	edi, dword ptr [rsi + 16]
        mov	byte ptr [rbp - 4], 0
        lea	ecx, [rdi + 100]
        mov	dword ptr [rdx + 24], ecx
        movzx	ecx, byte ptr [rbp - 4]
        mov	byte ptr [rdx + 28], cl
        mov	rcx, qword ptr [rsi]
        test	rcx, rcx
        je	.LBB208_19
        cmp	byte ptr [rcx + 12], 1
        je	.LBB208_21
        mov	edx, dword ptr [rcx + 8]
        sub	edx, edi
        add	edx, -101
        cmp	edx, -65636
        jb	.LBB208_20
.LBB208_15:
        mov	rsi, rcx
        mov	rcx, qword ptr [rcx]
        test	rcx, rcx
        je	.LBB208_19
        cmp	byte ptr [rcx + 12], 1
        je	.LBB208_21
        mov	edx, dword ptr [rcx + 8]
        sub	edx, edi
        add	edx, 65535
        cmp	edx, 65636
        jb	.LBB208_15
        jmp	.LBB208_20
.LBB208_19:
        xor	ecx, ecx
.LBB208_20:
        mov	qword ptr [rax], rcx
        mov	qword ptr [rsi], rax
        add	rsp, 16
        pop	rbp
        ret
.LBB208_21:
        call	"debug.FullPanic((function 'defaultPanic')).inactiveUnionField__anon_20141"

codegen_harness.timer_callback_read_write:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        test	rdi, rdi
        je	.LBB209_5
        test	dil, 7
        jne	.LBB209_4
        vmovups	xmm0, xmmword ptr [rdi]
        lea	rax, [rbp - 28]
        lea	rdx, [rbp - 4]
        lea	rcx, [rbp]
        mov	dword ptr [rbp - 4], -1431655766
        cmp	rdx, rax
        lea	rdx, [rbp - 32]
        setae	al
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        vmovaps	xmmword ptr [rbp - 32], xmm0
        je	.LBB209_6
        mov	eax, dword ptr [rbp - 32]
        inc	eax
        mov	dword ptr [rdi], eax
        add	rsp, 32
        pop	rbp
        ret
.LBB209_5:
        call	"debug.FullPanic((function 'defaultPanic')).unwrapNull"
.LBB209_4:
        call	"debug.FullPanic((function 'defaultPanic')).incorrectAlignment"
.LBB209_6:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_triple_read_same_erd:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        vmovups	xmm0, xmmword ptr [rdi]
        lea	rax, [rbp - 28]
        lea	rdx, [rbp - 4]
        lea	rcx, [rbp]
        mov	dword ptr [rbp - 4], -1431655766
        cmp	rdx, rax
        lea	rdx, [rbp - 32]
        setae	al
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        vmovaps	xmmword ptr [rbp - 32], xmm0
        je	.LBB211_2
        vmovups	xmm0, xmmword ptr [rdi]
        mov	eax, dword ptr [rbp - 32]
        vmovaps	xmmword ptr [rbp - 32], xmm0
        vmovups	xmm0, xmmword ptr [rdi]
        add	eax, dword ptr [rbp - 32]
        vmovaps	xmmword ptr [rbp - 32], xmm0
        add	eax, dword ptr [rbp - 32]
        add	rsp, 32
        pop	rbp
        ret
.LBB211_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_read_then_branch:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        vmovups	xmm0, xmmword ptr [rdi]
        lea	rax, [rbp - 28]
        lea	rdx, [rbp - 4]
        lea	rcx, [rbp]
        mov	dword ptr [rbp - 4], -1431655766
        cmp	rdx, rax
        lea	rdx, [rbp - 32]
        setae	al
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        vmovaps	xmmword ptr [rbp - 32], xmm0
        je	.LBB212_2
        vmovups	xmm0, xmmword ptr [rdi]
        mov	ecx, dword ptr [rbp - 32]
        vmovaps	xmmword ptr [rbp - 32], xmm0
        mov	eax, dword ptr [rbp - 32]
        mov	edx, eax
        imul	edx, ecx
        add	eax, ecx
        test	sil, sil
        cmove	eax, edx
        add	rsp, 32
        pop	rbp
        ret
.LBB212_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_read_write_read:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        vmovups	xmm0, xmmword ptr [rdi]
        lea	rax, [rbp - 28]
        lea	rdx, [rbp - 4]
        lea	rcx, [rbp]
        mov	dword ptr [rbp - 4], -1431655766
        cmp	rdx, rax
        lea	rdx, [rbp - 32]
        setae	al
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        vmovaps	xmmword ptr [rbp - 32], xmm0
        je	.LBB213_2
        mov	eax, dword ptr [rbp - 32]
        inc	eax
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
.LBB213_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_read_write_other_read:
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 48
        vmovups	xmm0, xmmword ptr [rdi]
        lea	rax, [rbp - 44]
        lea	rcx, [rbp - 20]
        mov	rbx, rdi
        lea	rdx, [rbp - 16]
        lea	rdi, [rbp - 48]
        mov	dword ptr [rbp - 20], -1431655766
        cmp	rcx, rax
        setae	al
        cmp	rdi, rdx
        setae	dl
        or	dl, al
        vmovaps	xmmword ptr [rbp - 48], xmm0
        je	.LBB214_5
        mov	eax, dword ptr [rbp - 48]
        mov	byte ptr [rbp - 20], sil
        cmp	sil, byte ptr [rbx + 4]
        mov	byte ptr [rbx + 4], sil
        je	.LBB214_4
        mov	r8, qword ptr [rbx + 24]
        test	r8, r8
        je	.LBB214_4
        mov	rdi, qword ptr [rbx + 16]
        lea	rsi, [rbp - 48]
        mov	word ptr [rbp - 40], 1
        mov	rdx, rbx
        mov	qword ptr [rbp - 48], rcx
        mov	r14d, eax
        call	r8
        mov	eax, r14d
.LBB214_4:
        mov	ecx, dword ptr [rbx]
        mov	dword ptr [rbp - 48], ecx
        movzx	ecx, byte ptr [rbx + 4]
        add	eax, dword ptr [rbp - 48]
        mov	byte ptr [rbp - 44], cl
        mov	rcx, qword ptr [rbx + 5]
        mov	qword ptr [rbp - 43], rcx
        movzx	ecx, word ptr [rbx + 13]
        mov	word ptr [rbp - 35], cx
        movzx	ecx, byte ptr [rbx + 15]
        mov	byte ptr [rbp - 33], cl
        add	rsp, 48
        pop	rbx
        pop	r14
        pop	rbp
        ret
.LBB214_5:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_read_across_two_erds:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        vmovups	xmm0, xmmword ptr [rdi]
        lea	rax, [rbp - 28]
        lea	rcx, [rbp - 4]
        lea	rdx, [rbp]
        lea	rsi, [rbp - 32]
        mov	dword ptr [rbp - 4], -1431655766
        cmp	rcx, rax
        setae	al
        cmp	rsi, rdx
        setae	dl
        or	dl, al
        vmovaps	xmmword ptr [rbp - 32], xmm0
        je	.LBB215_3
        vmovups	xmm0, xmmword ptr [rdi]
        mov	eax, dword ptr [rbp - 32]
        lea	rsi, [rbp - 25]
        lea	rdx, [rbp - 27]
        lea	r8, [rbp - 2]
        mov	word ptr [rbp - 4], -21846
        cmp	rcx, rsi
        setae	cl
        cmp	rdx, r8
        setae	dl
        or	dl, cl
        vmovaps	xmmword ptr [rbp - 32], xmm0
        je	.LBB215_3
        vmovups	xmm0, xmmword ptr [rdi]
        movzx	ecx, word ptr [rbp - 27]
        add	eax, ecx
        vmovaps	xmmword ptr [rbp - 32], xmm0
        add	eax, dword ptr [rbp - 32]
        add	rsp, 32
        pop	rbp
        ret
.LBB215_3:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_subscribe_callback:
        mov	rax, qword ptr [rdi + 24]
        cmp	rax, offset codegen_harness.accumulate_callback
        je	.LBB216_3
        test	rax, rax
        jne	.LBB216_4
        mov	qword ptr [rdi + 16], 0
        mov	qword ptr [rdi + 24], offset codegen_harness.accumulate_callback
.LBB216_3:
        ret
.LBB216_4:
        push	rbp
        mov	rbp, rsp
        call	debug.panic__anon_20175

codegen_harness.accumulate_callback:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        test	rsi, rsi
        je	.LBB217_7
        test	sil, 7
        jne	.LBB217_8
        test	dl, 7
        jne	.LBB217_8
        mov	rax, qword ptr [rsi]
        cmp	byte ptr [rax], 0
        je	.LBB217_6
        vmovups	xmm0, xmmword ptr [rdx]
        lea	rax, [rbp - 28]
        lea	rsi, [rbp - 4]
        lea	rcx, [rbp]
        mov	dword ptr [rbp - 4], -1431655766
        cmp	rsi, rax
        lea	rsi, [rbp - 32]
        setae	al
        cmp	rsi, rcx
        setae	cl
        or	cl, al
        vmovaps	xmmword ptr [rbp - 32], xmm0
        je	.LBB217_9
        mov	eax, dword ptr [rbp - 32]
        inc	eax
        mov	dword ptr [rdx], eax
.LBB217_6:
        add	rsp, 32
        pop	rbp
        ret
.LBB217_8:
        call	"debug.FullPanic((function 'defaultPanic')).incorrectAlignment"
.LBB217_7:
        call	"debug.FullPanic((function 'defaultPanic')).unwrapNull"
.LBB217_9:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_write_triggering_callback:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        mov	byte ptr [rbp - 1], 1
        mov	al, 1
        cmp	al, byte ptr [rdi + 4]
        mov	byte ptr [rdi + 4], 1
        je	.LBB220_3
        mov	rax, qword ptr [rdi + 24]
        mov	rdx, rdi
        test	rax, rax
        je	.LBB220_3
        mov	rdi, qword ptr [rdx + 16]
        lea	rsi, [rbp - 24]
        lea	rcx, [rbp - 1]
        mov	word ptr [rbp - 16], 1
        mov	qword ptr [rbp - 24], rcx
        call	rax
.LBB220_3:
        add	rsp, 32
        pop	rbp
        ret

codegen_increment_n_times:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        test	esi, esi
        je	.LBB221_7
        lea	rax, [rbp - 12]
        lea	rdx, [rbp - 20]
        lea	rcx, [rbp - 16]
        cmp	rdx, rax
        lea	rdx, [rbp - 16]
        setb	al
        cmp	rdx, rcx
        setb	cl
        test	cl, al
        jne	.LBB221_8
        mov	eax, esi
        and	eax, 7
        cmp	esi, 8
        jb	.LBB221_5
        and	esi, -8
        neg	esi
.LBB221_4:
        mov	ecx, dword ptr [rdi]
        mov	dword ptr [rbp - 16], ecx
        mov	rcx, qword ptr [rdi + 4]
        mov	edx, dword ptr [rbp - 16]
        mov	qword ptr [rbp - 12], rcx
        inc	edx
        mov	ecx, dword ptr [rdi + 12]
        mov	dword ptr [rbp - 4], ecx
        mov	dword ptr [rdi], edx
        mov	ecx, dword ptr [rdi]
        mov	dword ptr [rbp - 16], ecx
        mov	rcx, qword ptr [rdi + 4]
        mov	qword ptr [rbp - 12], rcx
        mov	ecx, dword ptr [rdi + 12]
        mov	dword ptr [rbp - 4], ecx
        mov	ecx, dword ptr [rbp - 16]
        inc	ecx
        mov	dword ptr [rdi], ecx
        mov	ecx, dword ptr [rdi]
        mov	dword ptr [rbp - 16], ecx
        mov	rcx, qword ptr [rdi + 4]
        mov	edx, dword ptr [rbp - 16]
        mov	qword ptr [rbp - 12], rcx
        inc	edx
        mov	ecx, dword ptr [rdi + 12]
        mov	dword ptr [rbp - 4], ecx
        mov	dword ptr [rdi], edx
        mov	ecx, dword ptr [rdi]
        mov	dword ptr [rbp - 16], ecx
        mov	rcx, qword ptr [rdi + 4]
        mov	qword ptr [rbp - 12], rcx
        mov	ecx, dword ptr [rdi + 12]
        mov	dword ptr [rbp - 4], ecx
        mov	ecx, dword ptr [rbp - 16]
        inc	ecx
        mov	dword ptr [rdi], ecx
        mov	ecx, dword ptr [rdi]
        mov	dword ptr [rbp - 16], ecx
        mov	rcx, qword ptr [rdi + 4]
        mov	edx, dword ptr [rbp - 16]
        mov	qword ptr [rbp - 12], rcx
        inc	edx
        mov	ecx, dword ptr [rdi + 12]
        mov	dword ptr [rbp - 4], ecx
        mov	dword ptr [rdi], edx
        mov	ecx, dword ptr [rdi]
        mov	dword ptr [rbp - 16], ecx
        mov	rcx, qword ptr [rdi + 4]
        mov	qword ptr [rbp - 12], rcx
        mov	ecx, dword ptr [rdi + 12]
        mov	dword ptr [rbp - 4], ecx
        mov	ecx, dword ptr [rbp - 16]
        inc	ecx
        mov	dword ptr [rdi], ecx
        mov	ecx, dword ptr [rdi]
        mov	dword ptr [rbp - 16], ecx
        mov	rcx, qword ptr [rdi + 4]
        mov	edx, dword ptr [rbp - 16]
        mov	qword ptr [rbp - 12], rcx
        inc	edx
        mov	ecx, dword ptr [rdi + 12]
        mov	dword ptr [rbp - 4], ecx
        mov	dword ptr [rdi], edx
        mov	ecx, dword ptr [rdi]
        mov	dword ptr [rbp - 16], ecx
        mov	rcx, qword ptr [rdi + 4]
        mov	edx, dword ptr [rbp - 16]
        mov	qword ptr [rbp - 12], rcx
        inc	edx
        add	esi, 8
        mov	ecx, dword ptr [rdi + 12]
        mov	dword ptr [rbp - 4], ecx
        mov	dword ptr [rdi], edx
        jne	.LBB221_4
.LBB221_5:
        test	eax, eax
        je	.LBB221_7
.LBB221_6:
        mov	ecx, dword ptr [rdi]
        mov	dword ptr [rbp - 16], ecx
        mov	rcx, qword ptr [rdi + 4]
        mov	edx, dword ptr [rbp - 16]
        mov	qword ptr [rbp - 12], rcx
        inc	edx
        dec	eax
        mov	ecx, dword ptr [rdi + 12]
        mov	dword ptr [rbp - 4], ecx
        mov	dword ptr [rdi], edx
        jne	.LBB221_6
.LBB221_7:
        add	rsp, 32
        pop	rbp
        ret
.LBB221_8:
        vmovups	xmm0, xmmword ptr [rdi]
        mov	dword ptr [rbp - 20], -1431655766
        vmovaps	xmmword ptr [rbp - 16], xmm0
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_conditional_write_chain:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        vmovups	xmm0, xmmword ptr [rdi]
        lea	rdx, [rbp - 27]
        lea	rcx, [rbp - 4]
        lea	rax, [rbp - 28]
        lea	rsi, [rbp - 3]
        mov	byte ptr [rbp - 4], -86
        cmp	rcx, rdx
        setae	r8b
        cmp	rax, rsi
        setae	sil
        or	sil, r8b
        vmovaps	xmmword ptr [rbp - 32], xmm0
        je	.LBB222_9
        test	byte ptr [rbp - 28], 1
        je	.LBB222_2
        vmovups	xmm0, xmmword ptr [rdi]
        cmp	rcx, rax
        lea	rsi, [rbp]
        lea	r9, [rbp - 32]
        mov	dword ptr [rbp - 4], -1431655766
        setae	r8b
        cmp	r9, rsi
        setae	sil
        or	sil, r8b
        vmovaps	xmmword ptr [rbp - 32], xmm0
        je	.LBB222_9
        mov	esi, dword ptr [rbp - 32]
        add	esi, 10
        mov	dword ptr [rdi], esi
.LBB222_2:
        mov	esi, dword ptr [rdi]
        lea	r8, [rbp - 2]
        mov	dword ptr [rbp - 32], esi
        mov	rsi, qword ptr [rdi + 4]
        mov	qword ptr [rbp - 28], rsi
        mov	esi, dword ptr [rdi + 12]
        mov	word ptr [rbp - 4], -21846
        mov	dword ptr [rbp - 20], esi
        lea	rsi, [rbp - 25]
        cmp	rcx, rsi
        setae	sil
        cmp	rdx, r8
        setae	dl
        or	dl, sil
        je	.LBB222_9
        cmp	word ptr [rbp - 27], 100
        jbe	.LBB222_4
        vmovups	xmm0, xmmword ptr [rdi]
        cmp	rcx, rax
        lea	rdx, [rbp]
        lea	rcx, [rbp - 32]
        mov	dword ptr [rbp - 4], -1431655766
        setae	al
        cmp	rcx, rdx
        setae	cl
        or	cl, al
        vmovaps	xmmword ptr [rbp - 32], xmm0
        je	.LBB222_9
        mov	eax, dword ptr [rbp - 32]
        add	eax, 20
        mov	dword ptr [rdi], eax
.LBB222_4:
        add	rsp, 32
        pop	rbp
        ret
.LBB222_9:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_cross_erd_compute:
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 32
        vmovups	xmm0, xmmword ptr [rdi]
        lea	rcx, [rbp - 41]
        lea	r14, [rbp - 20]
        lea	rax, [rbp - 43]
        lea	rdx, [rbp - 18]
        mov	word ptr [rbp - 20], -21846
        cmp	r14, rcx
        setae	cl
        cmp	rax, rdx
        setae	al
        or	al, cl
        vmovaps	xmmword ptr [rbp - 48], xmm0
        je	.LBB223_8
        vmovups	xmm0, xmmword ptr [rdi]
        movzx	eax, word ptr [rbp - 43]
        lea	rcx, [rbp - 44]
        lea	rdx, [rbp - 16]
        lea	rsi, [rbp - 48]
        mov	rbx, rdi
        mov	dword ptr [rbp - 20], -1431655766
        cmp	r14, rcx
        setae	cl
        cmp	rsi, rdx
        setae	dl
        or	dl, cl
        vmovaps	xmmword ptr [rbp - 48], xmm0
        je	.LBB223_8
        add	ax, word ptr [rbp - 48]
        mov	word ptr [rbp - 20], ax
        movzx	ecx, byte ptr [rbx + 8]
        cmp	byte ptr [rbx + 7], al
        mov	word ptr [rbx + 7], ax
        jne	.LBB223_4
        shr	eax, 8
        cmp	cl, al
        je	.LBB223_7
.LBB223_4:
        mov	rax, qword ptr [rbx + 40]
        test	rax, rax
        je	.LBB223_5
        mov	rdi, qword ptr [rbx + 32]
        mov	word ptr [rbp - 40], 3
        mov	rdx, rbx
        mov	qword ptr [rbp - 48], r14
        call	rax
.LBB223_5:
        mov	rax, qword ptr [rbx + 56]
        test	rax, rax
        je	.LBB223_7
        mov	rdi, qword ptr [rbx + 48]
        lea	rsi, [rbp - 48]
        mov	word ptr [rbp - 40], 3
        mov	rdx, rbx
        mov	qword ptr [rbp - 48], r14
        call	rax
.LBB223_7:
        add	rsp, 32
        pop	rbx
        pop	r14
        pop	rbp
        ret
.LBB223_8:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_cross_system_read_add:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        vmovups	xmm0, xmmword ptr [rdi]
        lea	rcx, [rbp - 28]
        lea	rax, [rbp - 4]
        lea	rdx, [rbp]
        lea	r8, [rbp - 32]
        mov	dword ptr [rbp - 4], -1431655766
        cmp	rax, rcx
        setae	cl
        cmp	r8, rdx
        setae	dl
        or	dl, cl
        vmovaps	xmmword ptr [rbp - 32], xmm0
        je	.LBB224_4
        vmovups	xmm0, xmmword ptr [rsi]
        mov	edx, dword ptr [rbp - 32]
        lea	r9, [rbp - 25]
        lea	r10, [rbp - 2]
        cmp	rax, r9
        setae	r9b
        vmovaps	xmmword ptr [rbp - 32], xmm0
        vmovups	xmm0, xmmword ptr [rdi]
        movsxd	rcx, dword ptr [rbp - 32]
        lea	rdi, [rbp - 27]
        mov	word ptr [rbp - 4], -21846
        cmp	rdi, r10
        setae	dil
        or	dil, r9b
        vmovaps	xmmword ptr [rbp - 32], xmm0
        je	.LBB224_4
        vmovups	xmm0, xmmword ptr [rsi]
        movzx	edi, word ptr [rbp - 27]
        lea	rsi, [rbp - 24]
        mov	dword ptr [rbp - 4], -1431655766
        cmp	rax, rsi
        setae	sil
        cmp	r8, rax
        setae	al
        or	al, sil
        vmovaps	xmmword ptr [rbp - 32], xmm0
        je	.LBB224_4
        movsxd	rax, dword ptr [rbp - 28]
        add	rcx, rdx
        add	rax, rdi
        add	rax, rcx
        add	rsp, 32
        pop	rbp
        ret
.LBB224_4:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_cross_system_read_write:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        vmovups	xmm0, xmmword ptr [rsi]
        lea	rax, [rbp - 28]
        lea	rdx, [rbp - 4]
        lea	rcx, [rbp]
        mov	dword ptr [rbp - 4], -1431655766
        cmp	rdx, rax
        lea	rdx, [rbp - 32]
        setae	al
        cmp	rdx, rcx
        setae	cl
        or	cl, al
        vmovaps	xmmword ptr [rbp - 32], xmm0
        je	.LBB225_2
        mov	eax, dword ptr [rbp - 32]
        mov	dword ptr [rdi], eax
        add	rsp, 32
        pop	rbp
        ret
.LBB225_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_cross_system_swap:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        vmovups	xmm0, xmmword ptr [rdi]
        lea	rcx, [rbp - 28]
        lea	rax, [rbp - 4]
        mov	rdx, rsi
        lea	rsi, [rbp]
        lea	r8, [rbp - 32]
        mov	dword ptr [rbp - 4], -1431655766
        cmp	rax, rcx
        setae	cl
        cmp	r8, rsi
        setae	sil
        or	sil, cl
        vmovaps	xmmword ptr [rbp - 32], xmm0
        je	.LBB226_5
        vmovups	xmm0, xmmword ptr [rdx]
        mov	ecx, dword ptr [rbp - 32]
        vmovaps	xmmword ptr [rbp - 32], xmm0
        mov	esi, dword ptr [rbp - 32]
        mov	dword ptr [rdi], esi
        mov	dword ptr [rbp - 4], ecx
        cmp	dword ptr [rdx], ecx
        mov	dword ptr [rdx], ecx
        je	.LBB226_4
        mov	rcx, qword ptr [rdx + 24]
        test	rcx, rcx
        je	.LBB226_4
        mov	rdi, qword ptr [rdx + 16]
        lea	rsi, [rbp - 32]
        mov	word ptr [rbp - 24], 0
        mov	qword ptr [rbp - 32], rax
        call	rcx
.LBB226_4:
        add	rsp, 32
        pop	rbp
        ret
.LBB226_5:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

; --- called functions ---

"debug.FullPanic((function 'defaultPanic')).memcpyAlias":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rax, qword ptr [rbp + 8]
        lea	rdx, [rbp - 16]
        mov	edi, offset __anon_1122
        mov	esi, 23
        mov	qword ptr [rbp - 16], rax
        mov	byte ptr [rbp - 8], 1
        call	debug.defaultPanic

"debug.FullPanic((function 'defaultPanic')).unwrapNull":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rax, qword ptr [rbp + 8]
        lea	rdx, [rbp - 16]
        mov	edi, offset __anon_5212
        mov	esi, 25
        mov	qword ptr [rbp - 16], rax
        mov	byte ptr [rbp - 8], 1
        call	debug.defaultPanic
        .text

"debug.FullPanic((function 'defaultPanic')).incorrectAlignment":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rax, qword ptr [rbp + 8]
        lea	rdx, [rbp - 16]
        mov	edi, offset __anon_7113
        mov	esi, 19
        mov	qword ptr [rbp - 16], rax
        mov	byte ptr [rbp - 8], 1
        call	debug.defaultPanic
        .text

"debug.FullPanic((function 'defaultPanic')).inactiveUnionField__anon_20141":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 48
        mov	rax, qword ptr [rbp + 8]
        lea	rdi, [rbp - 16]
        lea	rsi, [rbp - 48]
        mov	qword ptr [rbp - 48], offset .L__unnamed_76
        mov	qword ptr [rbp - 40], 10
        mov	qword ptr [rbp - 32], offset .L__unnamed_77
        mov	qword ptr [rbp - 24], 25
        mov	qword ptr [rbp - 16], rax
        mov	byte ptr [rbp - 8], 1
        call	debug.panicExtra__anon_11430
        .text

debug.panic__anon_20175:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rax, qword ptr [rbp + 8]
        lea	rdi, [rbp - 16]
        mov	qword ptr [rbp - 16], rax
        mov	byte ptr [rbp - 8], 1
        call	debug.panicExtra__anon_20178

