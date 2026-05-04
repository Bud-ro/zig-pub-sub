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
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_224,meta.FieldEnum(codegen_harness.SmallSystem__struct_224),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).runtimeRead"
        mov	rdi, r15
        mov	esi, r14d
        mov	rdx, rbx
        add	rsp, 8
        pop	rbx
        pop	r14
        pop	r15
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_224,meta.FieldEnum(codegen_harness.SmallSystem__struct_224),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).runtimeRead"

; --- called functions ---

"system_data.SystemData(codegen_harness.SmallSystem__struct_224,meta.FieldEnum(codegen_harness.SmallSystem__struct_224),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).runtimeRead":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 64
        mov	rax, rdx
        movzx	ecx, si
        movzx	ecx, word ptr [rcx + rcx + .L__unnamed_3]
        movups	xmm0, xmmword ptr [rdi]
        movups	xmm1, xmmword ptr [rdi + 16]
        movups	xmm2, xmmword ptr [rdi + 32]
        movups	xmm3, xmmword ptr [rdi + 48]
        movaps	xmmword ptr [rbp - 16], xmm3
        movaps	xmmword ptr [rbp - 32], xmm2
        movaps	xmmword ptr [rbp - 48], xmm1
        movaps	xmmword ptr [rbp - 64], xmm0
        movzx	edx, word ptr [rcx + rcx + .L__unnamed_4]
        lea	rsi, [rbp - 64]
        add	rsi, qword ptr [8*rcx + .L__unnamed_5]
        mov	rdi, rax
        call	memcpy@PLT
        add	rsp, 64
        pop	rbp
        ret

