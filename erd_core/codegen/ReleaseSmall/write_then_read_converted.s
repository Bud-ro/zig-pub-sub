write_then_read_converted:
        push	r14
        push	rbx
        push	rax
        mov	rbx, rdi
        call	".Lsystem_data.SystemData(codegen_harness.MultiErdDefs,meta.FieldEnum(codegen_harness.MultiErdDefs),.{ .ram_counter = .{ ... }, .ram_flag = .{ ... }, .ram_value = .{ ... }, .ind_constant = .{ ... }, .ind_computed = .{ ... }, .conv_sum = .{ ... }, .conv_flag_inv = .{ ... } },codegen_harness.MultiComponents).write__anon_0"
        mov	rsi, qword ptr [rbx + 168]
        lea	r14, [rsp + 4]
        mov	rdi, r14
        call	qword ptr [rbx + 88]
        mov	eax, dword ptr [r14]
        add	rsp, 8
        pop	rbx
        pop	r14
        ret

; --- called functions ---

".Lsystem_data.SystemData(codegen_harness.MultiErdDefs,meta.FieldEnum(codegen_harness.MultiErdDefs),.{ .ram_counter = .{ ... }, .ram_flag = .{ ... }, .ram_value = .{ ... }, .ind_constant = .{ ... }, .ind_computed = .{ ... }, .conv_sum = .{ ... }, .conv_flag_inv = .{ ... } },codegen_harness.MultiComponents).write__anon_0":
        push	rax
        mov	dword ptr [rsp + 4], esi
        cmp	dword ptr [rdi], esi
        mov	dword ptr [rdi], esi
        je	.LBB273_2
        lea	rdx, [rsp + 4]
        xor	esi, esi
        mov	rcx, rdi
        call	".Lram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_harness.ram_defs))[0..3]).publish"
.LBB273_2:
        pop	rax
        ret

