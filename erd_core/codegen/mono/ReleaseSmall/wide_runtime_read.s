wide_runtime_read:
        jmp	".Lsystem_data.SystemData(codegen_mono_stress.WideSystem__struct_0,meta.FieldEnum(codegen_mono_stress.WideSystem__struct_0),.{ .w00 = .{ ... }, .w01 = .{ ... }, .w02 = .{ ... }, .w03 = .{ ... }, .w04 = .{ ... }, .w05 = .{ ... }, .w06 = .{ ... }, .w07 = .{ ... }, .w08 = .{ ... }, .w09 = .{ ... }, .w10 = .{ ... }, .w11 = .{ ... }, .w12 = .{ ... }, .w13 = .{ ... }, .w14 = .{ ... }, .w15 = .{ ... }, .w_pair = .{ ... } },system_data_test_double.create.Components).runtimeRead"

; --- called functions ---

".Lsystem_data.SystemData(codegen_mono_stress.WideSystem__struct_0,meta.FieldEnum(codegen_mono_stress.WideSystem__struct_0),.{ .w00 = .{ ... }, .w01 = .{ ... }, .w02 = .{ ... }, .w03 = .{ ... }, .w04 = .{ ... }, .w05 = .{ ... }, .w06 = .{ ... }, .w07 = .{ ... }, .w08 = .{ ... }, .w09 = .{ ... }, .w10 = .{ ... }, .w11 = .{ ... }, .w12 = .{ ... }, .w13 = .{ ... }, .w14 = .{ ... }, .w15 = .{ ... }, .w_pair = .{ ... } },system_data_test_double.create.Components).runtimeRead":
        push	r15
        push	r14
        push	rbx
        sub	rsp, 256
        mov	rbx, rdx
        mov	rax, rdi
        movzx	ecx, si
        movzx	r15d, word ptr [rcx + rcx + .L__anon_1]
        mov	r14, rsp
        mov	edx, 256
        mov	rdi, r14
        mov	rsi, rax
        call	memcpy@PLT
        movzx	edx, word ptr [r15 + r15 + .L__anon_2]
        add	r14, qword ptr [8*r15 + .L__anon_3]
        mov	rdi, rbx
        mov	rsi, r14
        call	memcpy@PLT
        add	rsp, 256
        pop	rbx
        pop	r14
        pop	r15
        ret

