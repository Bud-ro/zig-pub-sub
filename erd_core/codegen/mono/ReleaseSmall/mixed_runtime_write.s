; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
; NOINLINE-PUB. Shared runtime dispatch path.
;
mixed_runtime_write:
        jmp	".Lsystem_data.SystemData(codegen_mono_stress.MixedDefs,meta.FieldEnum(codegen_mono_stress.MixedDefs),.{ .ram_a = .{ ... }, .ram_b = .{ ... }, .ram_c = .{ ... }, .ram_d = .{ ... }, .ind_x = .{ ... }, .ind_y = .{ ... }, .conv_sum = .{ ... }, .conv_flag = .{ ... }, .conv_wide = .{ ... }, .ram_pair = .{ ... } },codegen_mono_stress.MixedComponents).runtimeWrite"

; --- called functions ---

".Lsystem_data.SystemData(codegen_mono_stress.MixedDefs,meta.FieldEnum(codegen_mono_stress.MixedDefs),.{ .ram_a = .{ ... }, .ram_b = .{ ... }, .ram_c = .{ ... }, .ram_d = .{ ... }, .ind_x = .{ ... }, .ind_y = .{ ... }, .conv_sum = .{ ... }, .conv_flag = .{ ... }, .conv_wide = .{ ... }, .ram_pair = .{ ... } },codegen_mono_stress.MixedComponents).runtimeWrite":
        push	rbp
        push	r15
        push	r14
        push	r13
        push	r12
        push	rbx
        push	rax
        mov	r15, rdx
        mov	rbx, rdi
        movzx	eax, si
        movzx	r14d, word ptr [rax + rax + .L__anon_0]
        movzx	r12d, word ptr [r14 + r14 + .L__anon_1]
        mov	r13, qword ptr [8*r14 + .L__anon_2]
        add	r13, rdi
        mov	rdi, rdx
        mov	rsi, r13
        mov	rdx, r12
        call	.Lram_data_component.runtimeBytesEqual
        mov	ebp, eax
        mov	rdi, r13
        mov	rsi, r15
        mov	rdx, r12
        call	memcpy@PLT
        test	bpl, 1
        jne	.L0
        cmp	byte ptr [r14 + .L__anon_3], 0
        je	.L0
        mov	rdi, rbx
        mov	esi, r14d
        mov	rdx, rbx
        add	rsp, 8
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        jmp	".Lram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_mono_stress.mixed_ram_erds))[0..5]).publish"
.L0:
        add	rsp, 8
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        ret

