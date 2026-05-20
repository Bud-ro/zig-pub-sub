mixed_runtime_read:
        jmp	".Lsystem_data.SystemData(codegen_mono_stress.MixedDefs,meta.FieldEnum(codegen_mono_stress.MixedDefs),.{ .ram_a = .{ ... }, .ram_b = .{ ... }, .ram_c = .{ ... }, .ram_d = .{ ... }, .ind_x = .{ ... }, .ind_y = .{ ... }, .conv_sum = .{ ... }, .conv_flag = .{ ... }, .conv_wide = .{ ... }, .ram_pair = .{ ... } },codegen_mono_stress.MixedComponents).runtimeRead"

; --- called functions ---

".Lsystem_data.SystemData(codegen_mono_stress.MixedDefs,meta.FieldEnum(codegen_mono_stress.MixedDefs),.{ .ram_a = .{ ... }, .ram_b = .{ ... }, .ram_c = .{ ... }, .ram_d = .{ ... }, .ind_x = .{ ... }, .ind_y = .{ ... }, .conv_sum = .{ ... }, .conv_flag = .{ ... }, .conv_wide = .{ ... }, .ram_pair = .{ ... } },codegen_mono_stress.MixedComponents).runtimeRead":
        mov	rax, rdi
        movzx	ecx, si
        movzx	esi, byte ptr [rcx + .L__anon_0]
        movzx	ecx, word ptr [rcx + rcx + .L__anon_1]
        test	esi, esi
        je	.L2
        cmp	esi, 1
        je	.L3
        cmp	esi, 2
        jne	.L4
        mov	rcx, qword ptr [rax + 8*rcx + 120]
        mov	rsi, qword ptr [rax + 208]
        mov	rdi, rdx
        jmp	rcx
.L3:
        mov	rdi, rdx
        jmp	qword ptr [rax + 8*rcx + 104]
.L2:
        add	rax, qword ptr [8*rcx + .L__anon_5]
        movzx	ecx, word ptr [rcx + rcx + .L__anon_6]
        mov	rdi, rdx
        mov	rsi, rax
        mov	rdx, rcx
        jmp	memcpy@PLT
.L4:
        ret

