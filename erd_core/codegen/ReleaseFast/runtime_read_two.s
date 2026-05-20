runtime_read_two:
        push	rbp
        push	r14
        push	rbx
        mov	rbx, r8
        mov	ebp, ecx
        mov	r14, rdi
        call	"system_data.SystemData(codegen_harness.SmallSystem__struct_0,meta.FieldEnum(codegen_harness.SmallSystem__struct_0),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).runtimeRead"
        mov	rdi, r14
        mov	esi, ebp
        mov	rdx, rbx
        pop	rbx
        pop	r14
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_0,meta.FieldEnum(codegen_harness.SmallSystem__struct_0),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).runtimeRead"

; --- called functions ---

"system_data.SystemData(codegen_harness.SmallSystem__struct_0,meta.FieldEnum(codegen_harness.SmallSystem__struct_0),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).runtimeRead":
        mov	rcx, rdx
        mov	rax, rdi
        movzx	edx, si
        movzx	edx, word ptr [rdx + rdx + __anon_1]
        add	rax, qword ptr [8*rdx + __anon_2]
        movzx	edx, word ptr [rdx + rdx + __anon_3]
        mov	rdi, rcx
        mov	rsi, rax
        jmp	memcpy@PLT

