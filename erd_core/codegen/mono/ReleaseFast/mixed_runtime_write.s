mixed_runtime_write:
        jmp	"system_data.SystemData(codegen_mono_stress.MixedDefs,meta.FieldEnum(codegen_mono_stress.MixedDefs),.{ .ram_a = .{ ... }, .ram_b = .{ ... }, .ram_c = .{ ... }, .ram_d = .{ ... }, .ind_x = .{ ... }, .ind_y = .{ ... }, .conv_sum = .{ ... }, .conv_flag = .{ ... }, .conv_wide = .{ ... }, .ram_pair = .{ ... } },codegen_mono_stress.MixedComponents).runtimeWrite"

; --- called functions ---

"system_data.SystemData(codegen_mono_stress.MixedDefs,meta.FieldEnum(codegen_mono_stress.MixedDefs),.{ .ram_a = .{ ... }, .ram_b = .{ ... }, .ram_c = .{ ... }, .ram_d = .{ ... }, .ind_x = .{ ... }, .ind_y = .{ ... }, .conv_sum = .{ ... }, .conv_flag = .{ ... }, .conv_wide = .{ ... }, .ram_pair = .{ ... } },codegen_mono_stress.MixedComponents).runtimeWrite":
        push	rbp
        push	r15
        push	r14
        push	r13
        push	r12
        push	rbx
        push	rax
        movzx	eax, si
        cmp	byte ptr [rax + __anon_0], 0
        jne	.L1
        mov	rbx, rdx
        mov	r14, rdi
        movzx	r15d, word ptr [rax + rax + __anon_2]
        movzx	r12d, word ptr [r15 + r15 + __anon_3]
        mov	r13, qword ptr [8*r15 + __anon_4]
        add	r13, rdi
        mov	rdi, rdx
        mov	rsi, r13
        mov	rdx, r12
        call	ram_data_component.runtimeBytesEqual
        mov	ebp, eax
        mov	rdi, r13
        mov	rsi, rbx
        mov	rdx, r12
        call	memcpy@PLT
        test	bpl, 1
        jne	.L1
        cmp	byte ptr [r15 + __anon_5], 0
        je	.L1
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
        jmp	"ram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_mono_stress.mixed_ram_defs))[0..5]).publish"
.L1:
        add	rsp, 8
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        ret

