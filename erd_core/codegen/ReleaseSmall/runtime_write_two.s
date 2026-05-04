runtime_write_two:
        push	rbp
        mov	rbp, rsp
        push	r15
        push	r14
        push	rbx
        push	rax
        mov	rbx, r8
        mov	r14d, ecx
        mov	r15, rdi
        call	".Lsystem_data.SystemData(codegen_harness.SmallSystem__struct_194,meta.FieldEnum(codegen_harness.SmallSystem__struct_194),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).runtimeWrite"
        mov	rdi, r15
        mov	esi, r14d
        mov	rdx, rbx
        add	rsp, 8
        pop	rbx
        pop	r14
        pop	r15
        pop	rbp
        jmp	".Lsystem_data.SystemData(codegen_harness.SmallSystem__struct_194,meta.FieldEnum(codegen_harness.SmallSystem__struct_194),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).runtimeWrite"

; --- called functions ---

".Lsystem_data.SystemData(codegen_harness.SmallSystem__struct_194,meta.FieldEnum(codegen_harness.SmallSystem__struct_194),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).runtimeWrite":
        push	rbp
        mov	rbp, rsp
        push	r15
        push	r14
        push	r13
        push	r12
        push	rbx
        push	rax
        mov	rbx, rdx
        movzx	eax, si
        movzx	r15d, word ptr [rax + rax + .L__anon_1939]
        movzx	r12d, word ptr [r15 + r15 + .L__anon_17324]
        mov	r13, qword ptr [8*r15 + .L__anon_1110]
        mov	qword ptr [rbp - 48], rdi
        add	r13, rdi
        mov	rdi, rdx
        mov	rsi, r12
        mov	rdx, r13
        mov	rcx, r12
        call	.Lmem.eql__anon_8221
        mov	r14d, eax
        mov	rdi, r13
        mov	rsi, rbx
        mov	rdx, r12
        call	memcpy@PLT
        test	r14b, 1
        jne	.LBB306_2
        cmp	byte ptr [r15 + .L__anon_1929], 0
        je	.LBB306_2
        mov	rcx, qword ptr [rbp - 48]
        mov	rdi, rcx
        mov	esi, r15d
        mov	rdx, rbx
        add	rsp, 8
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        jmp	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
.LBB306_2:
        add	rsp, 8
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        ret

