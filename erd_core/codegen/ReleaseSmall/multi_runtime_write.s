; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
; NOINLINE-PUB. Multi-component runtime write.
;
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
        mov	rbx, rdx
        mov	r14, rdi
        movzx	eax, si
        movzx	r15d, word ptr [rax + rax + .L__anon_0]
        movzx	r12d, word ptr [r15 + r15 + .L__anon_1]
        mov	r13, qword ptr [8*r15 + .L__anon_2]
        add	r13, rdi
        mov	rdi, rdx
        mov	rsi, r13
        mov	rdx, r12
        call	.Lram_data_component.runtimeBytesEqual
        mov	ebp, eax
        mov	rdi, r13
        mov	rsi, rbx
        mov	rdx, r12
        call	memcpy@PLT
        test	bpl, 1
        jne	.L0
        cmp	byte ptr [r15 + .L__anon_3], 0
        je	.L0
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
        jmp	".Lram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_harness.multi_ram_erds))[0..3]).publish"
.L0:
        add	rsp, 8
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        ret

