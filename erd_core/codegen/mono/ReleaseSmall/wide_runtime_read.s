; snapshot_comments.zig
; Speed: Optimal | Local Size: Optimal | Global Size: Optimal
;
wide_runtime_read:
        jmp	".Lsystem_data.SystemData(codegen_mono_stress.WideSystem__struct_0,meta.FieldEnum(codegen_mono_stress.WideSystem__struct_0),.{ .w00 = .{ ... }, .w01 = .{ ... }, .w02 = .{ ... }, .w03 = .{ ... }, .w04 = .{ ... }, .w05 = .{ ... }, .w06 = .{ ... }, .w07 = .{ ... }, .w08 = .{ ... }, .w09 = .{ ... }, .w10 = .{ ... }, .w11 = .{ ... }, .w12 = .{ ... }, .w13 = .{ ... }, .w14 = .{ ... }, .w15 = .{ ... }, .w_pair = .{ ... } },system_data_test_double.create.Components).runtimeRead"

; --- called functions ---

".Lsystem_data.SystemData(codegen_mono_stress.WideSystem__struct_0,meta.FieldEnum(codegen_mono_stress.WideSystem__struct_0),.{ .w00 = .{ ... }, .w01 = .{ ... }, .w02 = .{ ... }, .w03 = .{ ... }, .w04 = .{ ... }, .w05 = .{ ... }, .w06 = .{ ... }, .w07 = .{ ... }, .w08 = .{ ... }, .w09 = .{ ... }, .w10 = .{ ... }, .w11 = .{ ... }, .w12 = .{ ... }, .w13 = .{ ... }, .w14 = .{ ... }, .w15 = .{ ... }, .w_pair = .{ ... } },system_data_test_double.create.Components).runtimeRead":
        mov	rcx, rdx
        mov	rax, rdi
        movzx	edx, si
        movzx	edx, word ptr [rdx + rdx + .L__anon_1]
        add	rax, qword ptr [8*rdx + .L__anon_2]
        movzx	edx, word ptr [rdx + rdx + .L__anon_3]
        mov	rdi, rcx
        mov	rsi, rax
        jmp	memcpy@PLT

