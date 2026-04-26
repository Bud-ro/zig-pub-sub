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
        sub	rsp, 32
        mov	byte ptr [rbp - 1], sil
        cmp	sil, byte ptr [rdi + 4]
        mov	byte ptr [rdi + 4], sil
        je	.LBB189_3
        mov	rdx, rdi
        mov	rax, qword ptr [rdi + 24]
        test	rax, rax
        je	.LBB189_3
        mov	rdi, qword ptr [rdx + 16]
        mov	word ptr [rbp - 16], 1
        lea	rcx, [rbp - 1]
        mov	qword ptr [rbp - 24], rcx
        lea	rsi, [rbp - 24]
        call	rax
.LBB189_3:
        add	rsp, 32
        pop	rbp
        ret

codegen_write_u16_with_subs:
        push	rbp
        mov	rbp, rsp
        push	rbx
        sub	rsp, 24
        mov	rbx, rdi
        mov	word ptr [rbp - 10], si
        movzx	eax, byte ptr [rdi + 8]
        cmp	byte ptr [rdi + 7], sil
        mov	word ptr [rdi + 7], si
        jne	.LBB190_2
        shr	esi, 8
        cmp	al, sil
        jne	.LBB190_2
.LBB190_5:
        add	rsp, 24
        pop	rbx
        pop	rbp
        ret
.LBB190_2:
        mov	rax, qword ptr [rbx + 40]
        test	rax, rax
        je	.LBB190_3
        mov	rdi, qword ptr [rbx + 32]
        mov	word ptr [rbp - 24], 3
        lea	rcx, [rbp - 10]
        mov	qword ptr [rbp - 32], rcx
        lea	rsi, [rbp - 32]
        mov	rdx, rbx
        call	rax
.LBB190_3:
        mov	rax, qword ptr [rbx + 56]
        test	rax, rax
        je	.LBB190_5
        mov	rdi, qword ptr [rbx + 48]
        mov	word ptr [rbp - 24], 3
        lea	rcx, [rbp - 10]
        mov	qword ptr [rbp - 32], rcx
        lea	rsi, [rbp - 32]
        mov	rdx, rbx
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
        je	.LBB191_2
        mov	eax, dword ptr [rbp - 32]
        add	rsp, 32
        pop	rbp
        ret
.LBB191_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_runtime_write_u32:
        lea	rax, [rdi + 4]
        cmp	rdi, offset __anon_17845+4
        setae	cl
        cmp	rax, offset __anon_17845
        setbe	al
        or	al, cl
        je	.LBB192_2
        mov	dword ptr [rdi], -559038737
        ret
.LBB192_2:
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
        je	.LBB193_2
        mov	ecx, dword ptr [rbp - 32]
        movups	xmm0, xmmword ptr [rsi]
        movaps	xmmword ptr [rbp - 32], xmm0
        movsxd	rax, dword ptr [rbp - 32]
        add	rax, rcx
        add	rsp, 32
        pop	rbp
        ret
.LBB193_2:
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
        je	.LBB195_2
        movzx	eax, byte ptr [rbp - 128]
        add	rsp, 128
        pop	rbp
        ret
.LBB195_2:
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
        je	.LBB196_2
        mov	eax, dword ptr [rbp - 80]
        add	rsp, 128
        pop	rbp
        ret
.LBB196_2:
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
        je	.LBB197_2
        mov	rax, qword ptr [rbp - 16]
        add	rsp, 128
        pop	rbp
        ret
.LBB197_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_many_write_last_with_subs:
        push	rbp
        mov	rbp, rsp
        push	rbx
        sub	rsp, 24
        mov	rbx, rdi
        mov	qword ptr [rbp - 32], rsi
        mov	rcx, rsi
        shr	rcx, 32
        mov	eax, dword ptr [rdi + 112]
        cmp	dword ptr [rdi + 116], ecx
        mov	qword ptr [rdi + 112], rsi
        jne	.LBB198_2
        cmp	eax, esi
        jne	.LBB198_2
.LBB198_7:
        add	rsp, 24
        pop	rbx
        pop	rbp
        ret
.LBB198_2:
        mov	rax, qword ptr [rbx + 144]
        test	rax, rax
        je	.LBB198_3
        mov	rdi, qword ptr [rbx + 136]
        mov	word ptr [rbp - 16], 31
        lea	rcx, [rbp - 32]
        mov	qword ptr [rbp - 24], rcx
        lea	rsi, [rbp - 24]
        mov	rdx, rbx
        call	rax
.LBB198_3:
        mov	rax, qword ptr [rbx + 160]
        test	rax, rax
        je	.LBB198_5
        mov	rdi, qword ptr [rbx + 152]
        mov	word ptr [rbp - 16], 31
        lea	rcx, [rbp - 32]
        mov	qword ptr [rbp - 24], rcx
        lea	rsi, [rbp - 24]
        mov	rdx, rbx
        call	rax
.LBB198_5:
        mov	rax, qword ptr [rbx + 176]
        test	rax, rax
        je	.LBB198_7
        mov	rdi, qword ptr [rbx + 168]
        mov	word ptr [rbp - 16], 31
        lea	rcx, [rbp - 32]
        mov	qword ptr [rbp - 24], rcx
        lea	rsi, [rbp - 24]
        mov	rdx, rbx
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
        movaps	xmm0, xmmword ptr [rip + .LCPI200_0]
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
        je	.LBB200_2
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
.LBB200_2:
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
        movaps	xmm0, xmmword ptr [rip + .LCPI201_0]
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
        je	.LBB201_2
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
.LBB201_2:
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
        je	.LBB202_2
        mov	eax, dword ptr [rbp - 16]
        add	rsp, 304
        pop	rbp
        ret
.LBB202_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_write_big_struct:
        push	rbp
        mov	rbp, rsp
        movups	xmm0, xmmword ptr [rsi]
        movups	xmm1, xmmword ptr [rsi + 16]
        movups	xmm2, xmmword ptr [rsi + 32]
        movups	xmm3, xmmword ptr [rsi + 48]
        movups	xmm4, xmmword ptr [rsi + 64]
        movups	xmm5, xmmword ptr [rsi + 80]
        movups	xmm6, xmmword ptr [rsi + 96]
        movups	xmm7, xmmword ptr [rsi + 112]
        movups	xmm8, xmmword ptr [rsi + 128]
        movups	xmm9, xmmword ptr [rsi + 144]
        movups	xmm10, xmmword ptr [rsi + 160]
        movups	xmm11, xmmword ptr [rsi + 176]
        movups	xmm12, xmmword ptr [rsi + 192]
        movups	xmm13, xmmword ptr [rsi + 208]
        movups	xmm14, xmmword ptr [rsi + 224]
        movups	xmm15, xmmword ptr [rsi + 240]
        movups	xmmword ptr [rdi], xmm0
        movups	xmmword ptr [rdi + 16], xmm1
        movups	xmmword ptr [rdi + 32], xmm2
        movups	xmmword ptr [rdi + 48], xmm3
        movups	xmmword ptr [rdi + 64], xmm4
        movups	xmmword ptr [rdi + 80], xmm5
        movups	xmmword ptr [rdi + 96], xmm6
        movups	xmmword ptr [rdi + 112], xmm7
        movups	xmmword ptr [rdi + 128], xmm8
        movups	xmmword ptr [rdi + 144], xmm9
        movups	xmmword ptr [rdi + 160], xmm10
        movups	xmmword ptr [rdi + 176], xmm11
        movups	xmmword ptr [rdi + 192], xmm12
        movups	xmmword ptr [rdi + 208], xmm13
        movups	xmmword ptr [rdi + 224], xmm14
        movups	xmmword ptr [rdi + 240], xmm15
        pop	rbp
        ret

codegen_write_medium_with_subs:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 64
        mov	rdx, rdi
        mov	rax, qword ptr [rsi + 16]
        mov	qword ptr [rbp - 48], rax
        movups	xmm0, xmmword ptr [rsi]
        movaps	xmmword ptr [rbp - 64], xmm0
        mov	rax, qword ptr [rsi + 16]
        mov	qword ptr [rbp - 16], rax
        movdqu	xmm0, xmmword ptr [rsi]
        movdqa	xmmword ptr [rbp - 32], xmm0
        lea	rax, [rdi + 256]
        movdqu	xmm1, xmmword ptr [rdi + 256]
        pcmpeqb	xmm1, xmm0
        pmovmskb	ecx, xmm1
        xor	ecx, 65535
        je	.LBB204_2
        movups	xmm0, xmmword ptr [rsi]
        mov	rcx, qword ptr [rsi + 16]
        mov	qword ptr [rax + 16], rcx
        movups	xmmword ptr [rax], xmm0
        jmp	.LBB204_3
.LBB204_2:
        movdqu	xmm0, xmmword ptr [rbp - 24]
        movdqu	xmm1, xmmword ptr [rdx + 264]
        pcmpeqb	xmm1, xmm0
        pmovmskb	ecx, xmm1
        xor	ecx, 65535
        movups	xmm0, xmmword ptr [rsi]
        mov	rcx, qword ptr [rsi + 16]
        mov	qword ptr [rax + 16], rcx
        movups	xmmword ptr [rax], xmm0
        je	.LBB204_5
.LBB204_3:
        mov	rax, qword ptr [rdx + 296]
        test	rax, rax
        je	.LBB204_5
        mov	rdi, qword ptr [rdx + 288]
        mov	word ptr [rbp - 24], 1
        lea	rcx, [rbp - 64]
        mov	qword ptr [rbp - 32], rcx
        lea	rsi, [rbp - 32]
        call	rax
.LBB204_5:
        add	rsp, 64
        pop	rbp
        ret

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
        movaps	xmm0, xmmword ptr [rip + .LCPI205_0]
        movaps	xmmword ptr [rbp - 32], xmm0
        movabs	rax, -6148914691236517206
        mov	qword ptr [rbp - 16], rax
        lea	rcx, [rbp - 64]
        lea	rdx, [rbp - 40]
        lea	rsi, [rbp - 8]
        lea	rax, [rbp - 32]
        cmp	rax, rdx
        setae	dl
        cmp	rcx, rsi
        setae	cl
        or	cl, dl
        je	.LBB205_7
        mov	ecx, dword ptr [rbx + 272]
        mov	edx, dword ptr [rbx + 276]
        add	ecx, 1
        movups	xmm0, xmmword ptr [rbx + 256]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	dword ptr [rbp - 16], ecx
        mov	dword ptr [rbp - 12], edx
        movdqu	xmm0, xmmword ptr [rbx + 256]
        movdqa	xmmword ptr [rbp - 320], xmm0
        mov	dword ptr [rbp - 304], ecx
        mov	dword ptr [rbp - 300], edx
        movdqu	xmm1, xmmword ptr [rbx + 256]
        pcmpeqb	xmm1, xmm0
        pmovmskb	edx, xmm1
        xor	edx, 65535
        je	.LBB205_3
        mov	dword ptr [rbx + 272], ecx
        jmp	.LBB205_4
.LBB205_3:
        movdqu	xmm0, xmmword ptr [rbp - 312]
        movdqu	xmm1, xmmword ptr [rbx + 264]
        pcmpeqb	xmm1, xmm0
        pmovmskb	edx, xmm1
        xor	edx, 65535
        mov	dword ptr [rbx + 272], ecx
        je	.LBB205_6
.LBB205_4:
        mov	rcx, qword ptr [rbx + 296]
        test	rcx, rcx
        je	.LBB205_6
        mov	rdi, qword ptr [rbx + 288]
        mov	word ptr [rbp - 312], 1
        mov	qword ptr [rbp - 320], rax
        lea	rsi, [rbp - 320]
        mov	rdx, rbx
        call	rcx
.LBB205_6:
        add	rsp, 312
        pop	rbx
        pop	rbp
        ret
.LBB205_7:
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
        movaps	xmm0, xmmword ptr [rip + .LCPI206_0]
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
        je	.LBB206_2
        add	byte ptr [rbx], 1
        add	rsp, 544
        pop	rbx
        pop	r14
        pop	rbp
        ret
.LBB206_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_setup_timer_callback:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rcx, qword ptr [rsi]
        lea	rax, [rdx + 16]
        cmp	qword ptr [rdx + 8], 0
        je	.LBB207_9
        test	rcx, rcx
        je	.LBB207_5
        mov	r8, rsi
.LBB207_3:
        cmp	rcx, rax
        je	.LBB207_11
        mov	r8, rcx
        mov	rcx, qword ptr [rcx]
        test	rcx, rcx
        jne	.LBB207_3
.LBB207_5:
        mov	rcx, qword ptr [rsi + 8]
        test	rcx, rcx
        je	.LBB207_12
        cmp	rcx, rax
        je	.LBB207_10
.LBB207_7:
        mov	r9, qword ptr [rcx]
        test	r9, r9
        je	.LBB207_12
        mov	r8, rcx
        mov	rcx, r9
        cmp	r9, rax
        jne	.LBB207_7
        jmp	.LBB207_11
.LBB207_9:
        mov	r8, rsi
        cmp	rcx, rax
        jne	.LBB207_12
        jmp	.LBB207_11
.LBB207_10:
        lea	r8, [rsi + 8]
.LBB207_11:
        mov	rcx, qword ptr [rax]
        mov	qword ptr [r8], rcx
.LBB207_12:
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
        je	.LBB207_19
        cmp	byte ptr [rcx + 12], 1
        je	.LBB207_21
        mov	edx, dword ptr [rcx + 8]
        sub	edx, edi
        add	edx, -101
        cmp	edx, -65636
        jb	.LBB207_20
.LBB207_15:
        mov	rsi, rcx
        mov	rcx, qword ptr [rcx]
        test	rcx, rcx
        je	.LBB207_19
        cmp	byte ptr [rcx + 12], 1
        je	.LBB207_21
        mov	edx, dword ptr [rcx + 8]
        sub	edx, edi
        add	edx, 65535
        cmp	edx, 65636
        jb	.LBB207_15
        jmp	.LBB207_20
.LBB207_19:
        xor	ecx, ecx
.LBB207_20:
        mov	qword ptr [rax], rcx
        mov	qword ptr [rsi], rax
        add	rsp, 16
        pop	rbp
        ret
.LBB207_21:
        call	"debug.FullPanic((function 'defaultPanic')).inactiveUnionField__anon_19756"

codegen_harness.timer_callback_read_write:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        test	rdi, rdi
        je	.LBB208_5
        test	dil, 7
        jne	.LBB208_4
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
        je	.LBB208_6
        mov	eax, dword ptr [rbp - 32]
        add	eax, 1
        mov	dword ptr [rdi], eax
        add	rsp, 32
        pop	rbp
        ret
.LBB208_5:
        call	"debug.FullPanic((function 'defaultPanic')).unwrapNull"
.LBB208_4:
        call	"debug.FullPanic((function 'defaultPanic')).incorrectAlignment"
.LBB208_6:
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
        je	.LBB210_2
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
.LBB210_2:
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
        je	.LBB211_2
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
.LBB211_2:
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
        je	.LBB212_2
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
.LBB212_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_read_write_other_read:
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 48
        mov	rbx, rdi
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 48], xmm0
        mov	dword ptr [rbp - 20], -1431655766
        lea	rax, [rbp - 44]
        lea	rdx, [rbp - 16]
        lea	rcx, [rbp - 20]
        cmp	rcx, rax
        setae	al
        lea	rdi, [rbp - 48]
        cmp	rdi, rdx
        setae	dl
        or	dl, al
        je	.LBB213_5
        mov	eax, dword ptr [rbp - 48]
        mov	byte ptr [rbp - 20], sil
        cmp	sil, byte ptr [rbx + 4]
        mov	byte ptr [rbx + 4], sil
        je	.LBB213_4
        mov	r8, qword ptr [rbx + 24]
        test	r8, r8
        je	.LBB213_4
        mov	rdi, qword ptr [rbx + 16]
        mov	word ptr [rbp - 40], 1
        mov	qword ptr [rbp - 48], rcx
        lea	rsi, [rbp - 48]
        mov	rdx, rbx
        mov	r14d, eax
        call	r8
        mov	eax, r14d
.LBB213_4:
        mov	ecx, dword ptr [rbx]
        mov	dword ptr [rbp - 48], ecx
        movzx	ecx, byte ptr [rbx + 4]
        mov	byte ptr [rbp - 44], cl
        mov	rcx, qword ptr [rbx + 5]
        mov	qword ptr [rbp - 43], rcx
        movzx	ecx, word ptr [rbx + 13]
        mov	word ptr [rbp - 35], cx
        movzx	ecx, byte ptr [rbx + 15]
        mov	byte ptr [rbp - 33], cl
        add	eax, dword ptr [rbp - 48]
        add	rsp, 48
        pop	rbx
        pop	r14
        pop	rbp
        ret
.LBB213_5:
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
        je	.LBB214_3
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
        je	.LBB214_3
        movzx	ecx, word ptr [rbp - 27]
        add	eax, ecx
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 32], xmm0
        add	eax, dword ptr [rbp - 32]
        add	rsp, 32
        pop	rbp
        ret
.LBB214_3:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_subscribe_callback:
        mov	rax, qword ptr [rdi + 24]
        cmp	rax, offset codegen_harness.accumulate_callback
        je	.LBB215_3
        test	rax, rax
        jne	.LBB215_4
        mov	qword ptr [rdi + 16], 0
        mov	qword ptr [rdi + 24], offset codegen_harness.accumulate_callback
.LBB215_3:
        ret
.LBB215_4:
        push	rbp
        mov	rbp, rsp
        call	debug.panic__anon_19790

codegen_harness.accumulate_callback:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        test	rsi, rsi
        je	.LBB216_7
        test	sil, 7
        jne	.LBB216_8
        test	dl, 7
        jne	.LBB216_8
        mov	rax, qword ptr [rsi]
        cmp	byte ptr [rax], 0
        je	.LBB216_6
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
        je	.LBB216_9
        mov	eax, dword ptr [rbp - 32]
        add	eax, 1
        mov	dword ptr [rdx], eax
.LBB216_6:
        add	rsp, 32
        pop	rbp
        ret
.LBB216_8:
        call	"debug.FullPanic((function 'defaultPanic')).incorrectAlignment"
.LBB216_7:
        call	"debug.FullPanic((function 'defaultPanic')).unwrapNull"
.LBB216_9:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_write_triggering_callback:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        mov	byte ptr [rbp - 1], 1
        mov	al, 1
        cmp	al, byte ptr [rdi + 4]
        mov	byte ptr [rdi + 4], 1
        je	.LBB219_3
        mov	rdx, rdi
        mov	rax, qword ptr [rdi + 24]
        test	rax, rax
        je	.LBB219_3
        mov	rdi, qword ptr [rdx + 16]
        mov	word ptr [rbp - 16], 1
        lea	rcx, [rbp - 1]
        mov	qword ptr [rbp - 24], rcx
        lea	rsi, [rbp - 24]
        call	rax
.LBB219_3:
        add	rsp, 32
        pop	rbp
        ret

codegen_increment_n_times:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        test	esi, esi
        je	.LBB220_7
        lea	rax, [rbp - 12]
        lea	rcx, [rbp - 16]
        lea	rdx, [rbp - 20]
        cmp	rdx, rax
        setb	al
        lea	rdx, [rbp - 16]
        cmp	rdx, rcx
        setb	cl
        test	cl, al
        jne	.LBB220_8
        cmp	esi, 1
        je	.LBB220_6
        mov	eax, esi
        and	eax, -2
        neg	eax
.LBB220_4:
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
        jne	.LBB220_4
        test	sil, 1
        je	.LBB220_7
.LBB220_6:
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 16], xmm0
        mov	eax, dword ptr [rbp - 16]
        add	eax, 1
        mov	dword ptr [rdi], eax
.LBB220_7:
        add	rsp, 32
        pop	rbp
        ret
.LBB220_8:
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
        je	.LBB221_9
        test	byte ptr [rbp - 28], 1
        je	.LBB221_2
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
        je	.LBB221_9
        mov	esi, dword ptr [rbp - 32]
        add	esi, 10
        mov	dword ptr [rdi], esi
.LBB221_2:
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
        je	.LBB221_9
        cmp	word ptr [rbp - 27], 100
        jbe	.LBB221_4
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
        je	.LBB221_9
        mov	eax, dword ptr [rbp - 32]
        add	eax, 20
        mov	dword ptr [rdi], eax
.LBB221_4:
        add	rsp, 32
        pop	rbp
        ret
.LBB221_9:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_cross_erd_compute:
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        sub	rsp, 32
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 48], xmm0
        mov	word ptr [rbp - 20], -21846
        lea	rax, [rbp - 43]
        lea	rcx, [rbp - 41]
        lea	rdx, [rbp - 18]
        lea	r14, [rbp - 20]
        cmp	r14, rcx
        setae	cl
        cmp	rax, rdx
        setae	al
        or	al, cl
        je	.LBB222_8
        mov	rbx, rdi
        movzx	eax, word ptr [rbp - 43]
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 48], xmm0
        mov	dword ptr [rbp - 20], -1431655766
        lea	rcx, [rbp - 44]
        lea	rdx, [rbp - 16]
        cmp	r14, rcx
        setae	cl
        lea	rsi, [rbp - 48]
        cmp	rsi, rdx
        setae	dl
        or	dl, cl
        je	.LBB222_8
        add	ax, word ptr [rbp - 48]
        mov	word ptr [rbp - 20], ax
        movzx	ecx, byte ptr [rbx + 8]
        cmp	byte ptr [rbx + 7], al
        mov	word ptr [rbx + 7], ax
        jne	.LBB222_4
        shr	eax, 8
        cmp	cl, al
        je	.LBB222_7
.LBB222_4:
        mov	rax, qword ptr [rbx + 40]
        test	rax, rax
        je	.LBB222_5
        mov	rdi, qword ptr [rbx + 32]
        mov	word ptr [rbp - 40], 3
        mov	qword ptr [rbp - 48], r14
        mov	rdx, rbx
        call	rax
.LBB222_5:
        mov	rax, qword ptr [rbx + 56]
        test	rax, rax
        je	.LBB222_7
        mov	rdi, qword ptr [rbx + 48]
        mov	word ptr [rbp - 40], 3
        mov	qword ptr [rbp - 48], r14
        lea	rsi, [rbp - 48]
        mov	rdx, rbx
        call	rax
.LBB222_7:
        add	rsp, 32
        pop	rbx
        pop	r14
        pop	rbp
        ret
.LBB222_8:
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
        je	.LBB223_4
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
        je	.LBB223_4
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
        je	.LBB223_4
        add	rcx, rdx
        movsxd	rax, dword ptr [rbp - 28]
        add	rax, rdi
        add	rax, rcx
        add	rsp, 32
        pop	rbp
        ret
.LBB223_4:
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
        je	.LBB224_2
        mov	eax, dword ptr [rbp - 32]
        mov	dword ptr [rdi], eax
        add	rsp, 32
        pop	rbp
        ret
.LBB224_2:
        call	"debug.FullPanic((function 'defaultPanic')).memcpyAlias"

codegen_cross_system_swap:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        mov	rdx, rsi
        movups	xmm0, xmmword ptr [rdi]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	dword ptr [rbp - 4], -1431655766
        lea	rcx, [rbp - 28]
        lea	rsi, [rbp]
        lea	rax, [rbp - 4]
        cmp	rax, rcx
        setae	cl
        lea	r8, [rbp - 32]
        cmp	r8, rsi
        setae	sil
        or	sil, cl
        je	.LBB225_5
        mov	ecx, dword ptr [rbp - 32]
        movups	xmm0, xmmword ptr [rdx]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	esi, dword ptr [rbp - 32]
        mov	dword ptr [rdi], esi
        mov	dword ptr [rbp - 4], ecx
        cmp	dword ptr [rdx], ecx
        mov	dword ptr [rdx], ecx
        je	.LBB225_4
        mov	rcx, qword ptr [rdx + 24]
        test	rcx, rcx
        je	.LBB225_4
        mov	rdi, qword ptr [rdx + 16]
        mov	word ptr [rbp - 24], 0
        mov	qword ptr [rbp - 32], rax
        lea	rsi, [rbp - 32]
        call	rcx
.LBB225_4:
        add	rsp, 32
        pop	rbp
        ret
.LBB225_5:
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

"debug.FullPanic((function 'defaultPanic')).inactiveUnionField__anon_19756":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 48
        mov	rax, qword ptr [rbp + 8]
        mov	qword ptr [rbp - 16], rax
        mov	byte ptr [rbp - 8], 1
        mov	qword ptr [rbp - 48], offset .L__unnamed_76
        mov	qword ptr [rbp - 40], 10
        mov	qword ptr [rbp - 32], offset .L__unnamed_77
        mov	qword ptr [rbp - 24], 25
        lea	rdi, [rbp - 16]
        lea	rsi, [rbp - 48]
        call	debug.panicExtra__anon_11113
        .text

debug.panic__anon_19790:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rax, qword ptr [rbp + 8]
        mov	qword ptr [rbp - 16], rax
        mov	byte ptr [rbp - 8], 1
        lea	rdi, [rbp - 16]
        call	debug.panicExtra__anon_19793

