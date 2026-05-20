mixed_runtime_read:
        jmp	"system_data.SystemData(codegen_mono_stress.MixedDefs,meta.FieldEnum(codegen_mono_stress.MixedDefs),.{ .ram_a = .{ ... }, .ram_b = .{ ... }, .ram_c = .{ ... }, .ram_d = .{ ... }, .ind_x = .{ ... }, .ind_y = .{ ... }, .conv_sum = .{ ... }, .conv_flag = .{ ... }, .conv_wide = .{ ... }, .ram_pair = .{ ... } },codegen_mono_stress.MixedComponents).runtimeRead"

; --- called functions ---

"system_data.SystemData(codegen_mono_stress.MixedDefs,meta.FieldEnum(codegen_mono_stress.MixedDefs),.{ .ram_a = .{ ... }, .ram_b = .{ ... }, .ram_c = .{ ... }, .ram_d = .{ ... }, .ind_x = .{ ... }, .ind_y = .{ ... }, .conv_sum = .{ ... }, .conv_flag = .{ ... }, .conv_wide = .{ ... }, .ram_pair = .{ ... } },codegen_mono_stress.MixedComponents).runtimeRead":
        sub	rsp, 104
        movzx	ecx, si
        movzx	eax, byte ptr [rcx + __anon_0]
        movzx	ecx, word ptr [rcx + rcx + __anon_1]
        test	eax, eax
        je	.L2
        cmp	eax, 1
        je	.L3
        cmp	eax, 2
        jne	.L4
        movups	xmm0, xmmword ptr [rdi + 200]
        movaps	xmmword ptr [rsp + 80], xmm0
        mov	rax, qword ptr [rdi + 216]
        mov	qword ptr [rsp + 96], rax
        movups	xmm0, xmmword ptr [rdi + 184]
        movaps	xmmword ptr [rsp + 64], xmm0
        movups	xmm0, xmmword ptr [rdi + 120]
        movups	xmm1, xmmword ptr [rdi + 136]
        movups	xmm2, xmmword ptr [rdi + 152]
        movups	xmm3, xmmword ptr [rdi + 168]
        movaps	xmmword ptr [rsp + 48], xmm3
        movaps	xmmword ptr [rsp + 32], xmm2
        movaps	xmmword ptr [rsp + 16], xmm1
        movaps	xmmword ptr [rsp], xmm0
        mov	rsi, qword ptr [rsp + 88]
        mov	rdi, rdx
        call	qword ptr [rsp + 8*rcx]
        add	rsp, 104
        ret
.L3:
        movups	xmm0, xmmword ptr [rdi + 104]
        movaps	xmmword ptr [rsp], xmm0
        mov	rdi, rdx
        call	qword ptr [rsp + 8*rcx]
        add	rsp, 104
        ret
.L2:
        mov	rax, qword ptr [rdi + 96]
        mov	qword ptr [rsp + 96], rax
        movups	xmm0, xmmword ptr [rdi + 80]
        movaps	xmmword ptr [rsp + 80], xmm0
        movups	xmm0, xmmword ptr [rdi + 64]
        movaps	xmmword ptr [rsp + 64], xmm0
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 16]
        movups	xmm2, xmmword ptr [rdi + 32]
        movups	xmm3, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rsp + 48], xmm3
        movaps	xmmword ptr [rsp + 32], xmm2
        movaps	xmmword ptr [rsp + 16], xmm1
        movaps	xmmword ptr [rsp], xmm0
        movzx	eax, word ptr [rcx + rcx + __anon_5]
        mov	rsi, rsp
        add	rsi, qword ptr [8*rcx + __anon_6]
        mov	rdi, rdx
        mov	rdx, rax
        call	memcpy@PLT
.L4:
        add	rsp, 104
        ret

