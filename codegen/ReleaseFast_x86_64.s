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
        je	.LBB5_3
        mov	rdx, rdi
        mov	rax, qword ptr [rdi + 24]
        test	rax, rax
        je	.LBB5_3
        mov	rdi, qword ptr [rdx + 16]
        mov	word ptr [rbp - 16], 1
        lea	rcx, [rbp - 1]
        mov	qword ptr [rbp - 24], rcx
        lea	rsi, [rbp - 24]
        call	rax
.LBB5_3:
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
        jne	.LBB6_2
        shr	esi, 8
        cmp	al, sil
        jne	.LBB6_2
.LBB6_5:
        add	rsp, 24
        pop	rbx
        pop	rbp
        ret
.LBB6_2:
        mov	rax, qword ptr [rbx + 40]
        test	rax, rax
        je	.LBB6_3
        mov	rdi, qword ptr [rbx + 32]
        mov	word ptr [rbp - 24], 3
        lea	rcx, [rbp - 10]
        mov	qword ptr [rbp - 32], rcx
        lea	rsi, [rbp - 32]
        mov	rdx, rbx
        call	rax
.LBB6_3:
        mov	rax, qword ptr [rbx + 56]
        test	rax, rax
        je	.LBB6_5
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
        push	rbx
        sub	rsp, 24
        mov	rbx, rdi
        mov	qword ptr [rbp - 32], rsi
        mov	eax, dword ptr [rdi + 116]
        cmp	dword ptr [rdi + 112], esi
        mov	qword ptr [rdi + 112], rsi
        jne	.LBB13_2
        shr	rsi, 32
        cmp	eax, esi
        jne	.LBB13_2
.LBB13_7:
        add	rsp, 24
        pop	rbx
        pop	rbp
        ret
.LBB13_2:
        mov	rax, qword ptr [rbx + 144]
        test	rax, rax
        je	.LBB13_3
        mov	rdi, qword ptr [rbx + 136]
        mov	word ptr [rbp - 16], 31
        lea	rcx, [rbp - 32]
        mov	qword ptr [rbp - 24], rcx
        lea	rsi, [rbp - 24]
        mov	rdx, rbx
        call	rax
.LBB13_3:
        mov	rax, qword ptr [rbx + 160]
        test	rax, rax
        je	.LBB13_5
        mov	rdi, qword ptr [rbx + 152]
        mov	word ptr [rbp - 16], 31
        lea	rcx, [rbp - 32]
        mov	qword ptr [rbp - 24], rcx
        lea	rsi, [rbp - 24]
        mov	rdx, rbx
        call	rax
.LBB13_5:
        mov	rax, qword ptr [rbx + 176]
        test	rax, rax
        je	.LBB13_7
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
        je	.LBB19_2
        movups	xmm0, xmmword ptr [rsi]
        mov	rcx, qword ptr [rsi + 16]
        mov	qword ptr [rax + 16], rcx
        movups	xmmword ptr [rax], xmm0
        jmp	.LBB19_3
.LBB19_2:
        movdqu	xmm0, xmmword ptr [rbp - 24]
        movdqu	xmm1, xmmword ptr [rdx + 264]
        pcmpeqb	xmm1, xmm0
        pmovmskb	ecx, xmm1
        xor	ecx, 65535
        movups	xmm0, xmmword ptr [rsi]
        mov	rcx, qword ptr [rsi + 16]
        mov	qword ptr [rax + 16], rcx
        movups	xmmword ptr [rax], xmm0
        je	.LBB19_5
.LBB19_3:
        mov	rax, qword ptr [rdx + 296]
        test	rax, rax
        je	.LBB19_5
        mov	rdi, qword ptr [rdx + 288]
        mov	word ptr [rbp - 24], 1
        lea	rcx, [rbp - 64]
        mov	qword ptr [rbp - 32], rcx
        lea	rsi, [rbp - 32]
        call	rax
.LBB19_5:
        add	rsp, 64
        pop	rbp
        ret

codegen_read_modify_write_medium:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 64
        mov	rdx, rdi
        mov	eax, dword ptr [rdi + 272]
        mov	ecx, dword ptr [rdi + 276]
        add	eax, 1
        movups	xmm0, xmmword ptr [rdi + 256]
        movaps	xmmword ptr [rbp - 64], xmm0
        mov	dword ptr [rbp - 48], eax
        mov	dword ptr [rbp - 44], ecx
        movdqu	xmm0, xmmword ptr [rdi + 256]
        movdqa	xmmword ptr [rbp - 32], xmm0
        mov	dword ptr [rbp - 16], eax
        mov	dword ptr [rbp - 12], ecx
        movdqu	xmm1, xmmword ptr [rdi + 256]
        pcmpeqb	xmm1, xmm0
        pmovmskb	ecx, xmm1
        xor	ecx, 65535
        je	.LBB20_2
        mov	dword ptr [rdx + 272], eax
        jmp	.LBB20_3
.LBB20_2:
        movdqu	xmm0, xmmword ptr [rbp - 24]
        movdqu	xmm1, xmmword ptr [rdx + 264]
        pcmpeqb	xmm1, xmm0
        pmovmskb	ecx, xmm1
        xor	ecx, 65535
        mov	dword ptr [rdx + 272], eax
        je	.LBB20_5
.LBB20_3:
        mov	rax, qword ptr [rdx + 296]
        test	rax, rax
        je	.LBB20_5
        mov	rdi, qword ptr [rdx + 288]
        mov	word ptr [rbp - 24], 1
        lea	rcx, [rbp - 64]
        mov	qword ptr [rbp - 32], rcx
        lea	rsi, [rbp - 32]
        call	rax
.LBB20_5:
        add	rsp, 64
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
        je	.LBB22_11
        test	rcx, rcx
        je	.LBB22_5
        mov	r8, rsi
        cmp	rcx, rax
        je	.LBB22_10
.LBB22_3:
        mov	r9, qword ptr [rcx]
        test	r9, r9
        je	.LBB22_5
        mov	r8, rcx
        mov	rcx, r9
        cmp	r9, rax
        jne	.LBB22_3
        jmp	.LBB22_10
.LBB22_5:
        mov	rcx, qword ptr [rsi + 8]
        test	rcx, rcx
        je	.LBB22_11
        cmp	rcx, rax
        je	.LBB22_9
.LBB22_7:
        mov	r9, qword ptr [rcx]
        test	r9, r9
        je	.LBB22_11
        mov	r8, rcx
        mov	rcx, r9
        cmp	r9, rax
        jne	.LBB22_7
        jmp	.LBB22_10
.LBB22_9:
        lea	r8, [rsi + 8]
.LBB22_10:
        mov	rcx, qword ptr [rax]
        mov	qword ptr [r8], rcx
.LBB22_11:
        mov	qword ptr [rdx + 8], offset codegen_harness.timer_callback_read_write
        mov	dword ptr [rdx + 28], 100
        or	rdi, 1
        mov	qword ptr [rdx], rdi
        mov	edi, dword ptr [rsi + 16]
        lea	ecx, [rdi + 100]
        mov	dword ptr [rdx + 24], ecx
        mov	rcx, qword ptr [rsi]
        test	rcx, rcx
        je	.LBB22_17
        mov	edx, dword ptr [rcx + 8]
        sub	edx, edi
        add	edx, -101
        cmp	edx, -65636
        jb	.LBB22_15
.LBB22_13:
        mov	rsi, rcx
        mov	rcx, qword ptr [rcx]
        test	rcx, rcx
        je	.LBB22_17
        mov	edx, dword ptr [rcx + 8]
        sub	edx, edi
        add	edx, 65535
        cmp	edx, 65636
        jb	.LBB22_13
.LBB22_15:
        mov	qword ptr [rax], rcx
        mov	qword ptr [rsi], rax
        pop	rbp
        ret
.LBB22_17:
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
        sub	rsp, 32
        mov	r14d, dword ptr [rdi]
        mov	byte ptr [rbp - 17], sil
        mov	eax, r14d
        cmp	sil, byte ptr [rdi + 4]
        mov	byte ptr [rdi + 4], sil
        je	.LBB27_3
        mov	rcx, qword ptr [rdi + 24]
        mov	eax, r14d
        test	rcx, rcx
        je	.LBB27_3
        mov	rax, qword ptr [rdi + 16]
        mov	word ptr [rbp - 32], 1
        lea	rdx, [rbp - 17]
        mov	qword ptr [rbp - 40], rdx
        lea	rsi, [rbp - 40]
        mov	rbx, rdi
        mov	rdi, rax
        mov	rdx, rbx
        call	rcx
        mov	eax, dword ptr [rbx]
.LBB27_3:
        add	eax, r14d
        add	rsp, 32
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
        je	.LBB29_3
        test	rax, rax
        jne	.LBB29_4
        mov	qword ptr [rdi + 16], 0
        mov	qword ptr [rdi + 24], offset codegen_harness.accumulate_callback
.LBB29_3:
        ret
.LBB29_4:
        push	rbp
        mov	rbp, rsp
        call	debug.panic__anon_4121

codegen_harness.accumulate_callback:
        push	rbp
        mov	rbp, rsp
        mov	rax, qword ptr [rsi]
        cmp	byte ptr [rax], 0
        je	.LBB30_2
        add	dword ptr [rdx], 1
.LBB30_2:
        pop	rbp
        ret

codegen_write_triggering_callback:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        mov	byte ptr [rbp - 1], 1
        mov	al, 1
        cmp	al, byte ptr [rdi + 4]
        mov	byte ptr [rdi + 4], 1
        je	.LBB125_3
        mov	rdx, rdi
        mov	rax, qword ptr [rdi + 24]
        test	rax, rax
        je	.LBB125_3
        mov	rdi, qword ptr [rdx + 16]
        mov	word ptr [rbp - 16], 1
        lea	rcx, [rbp - 1]
        mov	qword ptr [rbp - 24], rcx
        lea	rsi, [rbp - 24]
        call	rax
.LBB125_3:
        add	rsp, 32
        pop	rbp
        ret

codegen_increment_n_times:
        push	rbp
        mov	rbp, rsp
        test	esi, esi
        je	.LBB126_2
        add	dword ptr [rdi], esi
.LBB126_2:
        pop	rbp
        ret

codegen_conditional_write_chain:
        push	rbp
        mov	rbp, rsp
        test	byte ptr [rdi + 4], 1
        jne	.LBB127_4
        cmp	word ptr [rdi + 5], 100
        ja	.LBB127_2
.LBB127_3:
        pop	rbp
        ret
.LBB127_4:
        add	dword ptr [rdi], 10
        cmp	word ptr [rdi + 5], 100
        jbe	.LBB127_3
.LBB127_2:
        add	dword ptr [rdi], 20
        pop	rbp
        ret

codegen_cross_erd_compute:
        push	rbp
        mov	rbp, rsp
        push	rbx
        sub	rsp, 24
        mov	rbx, rdi
        movzx	eax, word ptr [rdi + 5]
        add	ax, word ptr [rdi]
        mov	word ptr [rbp - 10], ax
        movzx	ecx, byte ptr [rdi + 8]
        cmp	byte ptr [rdi + 7], al
        mov	word ptr [rdi + 7], ax
        jne	.LBB128_2
        shr	eax, 8
        cmp	cl, al
        jne	.LBB128_2
.LBB128_5:
        add	rsp, 24
        pop	rbx
        pop	rbp
        ret
.LBB128_2:
        mov	rax, qword ptr [rbx + 40]
        test	rax, rax
        je	.LBB128_3
        mov	rdi, qword ptr [rbx + 32]
        mov	word ptr [rbp - 24], 3
        lea	rcx, [rbp - 10]
        mov	qword ptr [rbp - 32], rcx
        lea	rsi, [rbp - 32]
        mov	rdx, rbx
        call	rax
.LBB128_3:
        mov	rax, qword ptr [rbx + 56]
        test	rax, rax
        je	.LBB128_5
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
        sub	rsp, 32
        mov	eax, dword ptr [rdi]
        mov	ecx, dword ptr [rsi]
        mov	dword ptr [rdi], ecx
        mov	dword ptr [rbp - 4], eax
        mov	dword ptr [rsi], eax
        cmp	ecx, eax
        je	.LBB131_3
        mov	rdx, rsi
        mov	rax, qword ptr [rsi + 24]
        test	rax, rax
        je	.LBB131_3
        mov	rdi, qword ptr [rdx + 16]
        mov	word ptr [rbp - 16], 0
        lea	rcx, [rbp - 4]
        mov	qword ptr [rbp - 24], rcx
        lea	rsi, [rbp - 24]
        call	rax
.LBB131_3:
        add	rsp, 32
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

debug.panic__anon_4121:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rax, qword ptr [rbp + 8]
        mov	qword ptr [rbp - 16], rax
        mov	byte ptr [rbp - 8], 1
        lea	rdi, [rbp - 16]
        call	debug.panicExtra__anon_4130

