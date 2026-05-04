runtime_read:
        push	rbp
        mov	rbp, rsp
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_194,meta.FieldEnum(codegen_harness.SmallSystem__struct_194),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).runtimeRead"

; --- called functions ---

"system_data.SystemData(codegen_harness.SmallSystem__struct_194,meta.FieldEnum(codegen_harness.SmallSystem__struct_194),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).runtimeRead":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 64
        mov	rax, rdx
        movzx	ecx, si
        movzx	ecx, word ptr [rcx + rcx + __anon_1938]
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 16]
        movups	xmm2, xmmword ptr [rdi + 32]
        movups	xmm3, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 16], xmm3
        movaps	xmmword ptr [rbp - 32], xmm2
        movaps	xmmword ptr [rbp - 48], xmm1
        movaps	xmmword ptr [rbp - 64], xmm0
        movzx	edx, word ptr [rcx + rcx + __anon_29526]
        lea	rsi, [rbp - 64]
        add	rsi, qword ptr [8*rcx + __anon_1110]
        mov	rdi, rax
        call	memcpy@PLT
        add	rsp, 64
        pop	rbp
        ret

