multi_runtime_read:
        jmp	".Lsystem_data.SystemData(codegen_harness.MultiErdDefs,meta.FieldEnum(codegen_harness.MultiErdDefs),.{ .ram_counter = .{ ... }, .ram_flag = .{ ... }, .ram_value = .{ ... }, .ind_constant = .{ ... }, .ind_computed = .{ ... }, .conv_sum = .{ ... }, .conv_flag_inv = .{ ... } },codegen_harness.MultiComponents).runtimeRead"

; --- called functions ---

".Lsystem_data.SystemData(codegen_harness.MultiErdDefs,meta.FieldEnum(codegen_harness.MultiErdDefs),.{ .ram_counter = .{ ... }, .ram_flag = .{ ... }, .ram_value = .{ ... }, .ind_constant = .{ ... }, .ind_computed = .{ ... }, .conv_sum = .{ ... }, .conv_flag_inv = .{ ... } },codegen_harness.MultiComponents).runtimeRead":
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
        mov	rcx, qword ptr [rax + 8*rcx + 88]
        mov	rsi, qword ptr [rax + 168]
        mov	rdi, rdx
        jmp	rcx
.L3:
        mov	rdi, rdx
        jmp	qword ptr [rax + 8*rcx + 72]
.L2:
        add	rax, qword ptr [8*rcx + .L__anon_5]
        movzx	ecx, word ptr [rcx + rcx + .L__anon_6]
        mov	rdi, rdx
        mov	rsi, rax
        mov	rdx, rcx
        jmp	memcpy@PLT
.L4:
        ret

