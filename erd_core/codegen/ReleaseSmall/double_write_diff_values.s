double_write_diff_values:
        push	rbp
        mov	rbp, rsp
        push	rbx
        push	rax
        mov	rbx, rdi
        push	1
        pop	rsi
        call	".Lsystem_data.SystemData(codegen_harness.SmallSystem__struct_194,meta.FieldEnum(codegen_harness.SmallSystem__struct_194),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).write__anon_2003"
        mov	rdi, rbx
        xor	esi, esi
        add	rsp, 8
        pop	rbx
        pop	rbp
        jmp	".Lsystem_data.SystemData(codegen_harness.SmallSystem__struct_194,meta.FieldEnum(codegen_harness.SmallSystem__struct_194),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).write__anon_2003"

; --- called functions ---

".Lsystem_data.SystemData(codegen_harness.SmallSystem__struct_194,meta.FieldEnum(codegen_harness.SmallSystem__struct_194),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).write__anon_2003":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        and	sil, 1
        mov	byte ptr [rbp - 1], sil
        cmp	byte ptr [rdi + 4], sil
        mov	byte ptr [rdi + 4], sil
        je	.LBB10_2
        lea	rdx, [rbp - 1]
        mov	esi, 1
        mov	rcx, rdi
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
.LBB10_2:
        add	rsp, 16
        pop	rbp
        ret

