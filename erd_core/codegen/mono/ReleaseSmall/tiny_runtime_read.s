; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
tiny_runtime_read:
        jmp	".Lsystem_data.SystemData(codegen_mono_stress.TinySystem__struct_0,meta.FieldEnum(codegen_mono_stress.TinySystem__struct_0),.{ .counter = .{ ... }, .flag = .{ ... }, .pair = .{ ... } },system_data_test_double.create.Components).runtimeRead"

; --- called functions ---

".Lsystem_data.SystemData(codegen_mono_stress.TinySystem__struct_0,meta.FieldEnum(codegen_mono_stress.TinySystem__struct_0),.{ .counter = .{ ... }, .flag = .{ ... }, .pair = .{ ... } },system_data_test_double.create.Components).runtimeRead":
        mov	rcx, rdx
        mov	rax, rdi
        movzx	edx, si
        movzx	edx, word ptr [rdx + rdx + .L__anon_1]
        add	rax, qword ptr [8*rdx + .L__anon_2]
        movzx	edx, word ptr [rdx + rdx + .L__anon_3]
        mov	rdi, rcx
        mov	rsi, rax
        jmp	memcpy@PLT

