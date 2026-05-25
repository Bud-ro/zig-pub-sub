; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
multi_runtime_read:
        jmp	".Lsystem_data.SystemData(codegen_harness.MultiErdDefs,meta.FieldEnum(codegen_harness.MultiErdDefs),.{ .ram_counter = .{ ... }, .ram_flag = .{ ... }, .ram_value = .{ ... }, .ind_constant = .{ ... }, .ind_computed = .{ ... }, .conv_sum = .{ ... }, .conv_flag_inv = .{ ... } },codegen_harness.MultiComponents).runtimeRead"

; --- called functions ---

".Lsystem_data.SystemData(codegen_harness.MultiErdDefs,meta.FieldEnum(codegen_harness.MultiErdDefs),.{ .ram_counter = .{ ... }, .ram_flag = .{ ... }, .ram_value = .{ ... }, .ind_constant = .{ ... }, .ind_computed = .{ ... }, .conv_sum = .{ ... }, .conv_flag_inv = .{ ... } },codegen_harness.MultiComponents).runtimeRead":
        mov	rax, rdx
        movzx	ecx, si
        movzx	edx, byte ptr [rcx + .L__anon_0]
        movzx	ecx, word ptr [rcx + rcx + .L__anon_1]
        cmp	edx, 2
        je	.L0
        cmp	edx, 1
        jne	.L1
        mov	rdi, rax
        jmp	qword ptr [8*rcx + .L__anon_2]
.L0:
        mov	rsi, qword ptr [rdi + 136]
        mov	rdi, rax
        jmp	qword ptr [8*rcx + .L__anon_3]
.L1:
        add	rdi, qword ptr [8*rcx + .L__anon_4]
        movzx	edx, word ptr [rcx + rcx + .L__anon_5]
        mov	rsi, rdi
        mov	rdi, rax
        jmp	memcpy@PLT

