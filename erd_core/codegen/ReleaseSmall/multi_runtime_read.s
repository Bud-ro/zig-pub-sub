multi_runtime_read:
        jmp	".Lsystem_data.SystemData(codegen_harness.MultiErdDefs,meta.FieldEnum(codegen_harness.MultiErdDefs),.{ .ram_counter = .{ ... }, .ram_flag = .{ ... }, .ram_value = .{ ... }, .ind_constant = .{ ... }, .ind_computed = .{ ... }, .conv_sum = .{ ... }, .conv_flag_inv = .{ ... } },codegen_harness.MultiComponents).runtimeRead"

; --- called functions ---

".Lsystem_data.SystemData(codegen_harness.MultiErdDefs,meta.FieldEnum(codegen_harness.MultiErdDefs),.{ .ram_counter = .{ ... }, .ram_flag = .{ ... }, .ram_value = .{ ... }, .ind_constant = .{ ... }, .ind_computed = .{ ... }, .conv_sum = .{ ... }, .conv_flag_inv = .{ ... } },codegen_harness.MultiComponents).runtimeRead":
        sub	rsp, 104
        movzx	ecx, si
        movzx	eax, byte ptr [rcx + .L__anon_0]
        movzx	ecx, word ptr [rcx + rcx + .L__anon_1]
        test	eax, eax
        je	.LBB278_5
        cmp	eax, 1
        je	.LBB278_4
        cmp	eax, 2
        jne	.LBB278_6
        movups	xmm0, xmmword ptr [rdi + 168]
        movaps	xmmword ptr [rsp + 80], xmm0
        movups	xmm0, xmmword ptr [rdi + 152]
        movaps	xmmword ptr [rsp + 64], xmm0
        movups	xmm0, xmmword ptr [rdi + 88]
        movups	xmm1, xmmword ptr [rdi + 104]
        movups	xmm2, xmmword ptr [rdi + 120]
        movups	xmm3, xmmword ptr [rdi + 136]
        movaps	xmmword ptr [rsp + 48], xmm3
        movaps	xmmword ptr [rsp + 32], xmm2
        movaps	xmmword ptr [rsp + 16], xmm1
        movaps	xmmword ptr [rsp], xmm0
        mov	rsi, qword ptr [rsp + 80]
        mov	rdi, rdx
        call	qword ptr [rsp + 8*rcx]
        add	rsp, 104
        ret
.LBB278_4:
        movups	xmm0, xmmword ptr [rdi + 72]
        movaps	xmmword ptr [rsp], xmm0
        mov	rdi, rdx
        call	qword ptr [rsp + 8*rcx]
        add	rsp, 104
        ret
.LBB278_5:
        mov	rax, qword ptr [rdi + 64]
        mov	qword ptr [rsp + 64], rax
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 16]
        movups	xmm2, xmmword ptr [rdi + 32]
        movups	xmm3, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rsp + 48], xmm3
        movaps	xmmword ptr [rsp + 32], xmm2
        movaps	xmmword ptr [rsp + 16], xmm1
        movaps	xmmword ptr [rsp], xmm0
        movzx	eax, word ptr [rcx + rcx + .L__anon_2]
        mov	rsi, rsp
        add	rsi, qword ptr [8*rcx + .L__anon_3]
        mov	rdi, rdx
        mov	rdx, rax
        call	memcpy@PLT
.LBB278_6:
        add	rsp, 104
        ret

