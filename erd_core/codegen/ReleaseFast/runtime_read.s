runtime_read:
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_0,meta.FieldEnum(codegen_harness.SmallSystem__struct_0),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).runtimeRead"

; --- called functions ---

"system_data.SystemData(codegen_harness.SmallSystem__struct_0,meta.FieldEnum(codegen_harness.SmallSystem__struct_0),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).runtimeRead":
        sub	rsp, 72
        mov	rax, rdx
        movzx	ecx, si
        movzx	ecx, word ptr [rcx + rcx + __anon_1]
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 16]
        movups	xmm2, xmmword ptr [rdi + 32]
        movups	xmm3, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rsp + 48], xmm3
        movaps	xmmword ptr [rsp + 32], xmm2
        movaps	xmmword ptr [rsp + 16], xmm1
        movaps	xmmword ptr [rsp], xmm0
        movzx	edx, word ptr [rcx + rcx + __anon_2]
        mov	rsi, rsp
        add	rsi, qword ptr [8*rcx + __anon_3]
        mov	rdi, rax
        call	memcpy@PLT
        add	rsp, 72
        ret

