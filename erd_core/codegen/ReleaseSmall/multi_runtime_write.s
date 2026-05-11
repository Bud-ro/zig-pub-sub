multi_runtime_write:
        jmp	".Lsystem_data.SystemData(codegen_harness.MultiErdDefs,meta.FieldEnum(codegen_harness.MultiErdDefs),.{ .ram_counter = .{ ... }, .ram_flag = .{ ... }, .ram_value = .{ ... }, .ind_constant = .{ ... }, .ind_computed = .{ ... }, .conv_sum = .{ ... }, .conv_flag_inv = .{ ... } },codegen_harness.MultiComponents).runtimeWrite"

; --- called functions ---

".Lsystem_data.SystemData(codegen_harness.MultiErdDefs,meta.FieldEnum(codegen_harness.MultiErdDefs),.{ .ram_counter = .{ ... }, .ram_flag = .{ ... }, .ram_value = .{ ... }, .ind_constant = .{ ... }, .ind_computed = .{ ... }, .conv_sum = .{ ... }, .conv_flag_inv = .{ ... } },codegen_harness.MultiComponents).runtimeWrite":
        push	rbp
        push	r15
        push	r14
        push	r13
        push	r12
        push	rbx
        push	rax
        movzx	eax, si
        cmp	byte ptr [rax + .L__anon_0], 0
        jne	.LBB268_3
        mov	rbx, rdx
        mov	r14, rdi
        movzx	r15d, word ptr [rax + rax + .L__anon_1]
        movzx	r12d, word ptr [r15 + r15 + .L__anon_2]
        mov	r13, qword ptr [8*r15 + .L__anon_3]
        add	r13, rdi
        mov	rdi, rdx
        mov	rsi, r12
        mov	rdx, r13
        mov	rcx, r12
        call	.Lmem.eql__anon_4
        mov	ebp, eax
        mov	rdi, r13
        mov	rsi, rbx
        mov	rdx, r12
        call	memcpy@PLT
        test	bpl, 1
        jne	.LBB268_3
        cmp	byte ptr [r15 + .L__anon_5], 0
        je	.LBB268_3
        mov	rdi, r14
        mov	esi, r15d
        mov	rdx, rbx
        mov	rcx, r14
        add	rsp, 8
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        jmp	".Lram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_harness.ram_defs))[0..3]).publish"
.LBB268_3:
        add	rsp, 8
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        ret

