read_write_other_read:
        push	rbp
        mov	rbp, rsp
        push	r14
        push	rbx
        mov	rbx, rdi
        mov	r14d, dword ptr [rdi]
        call	".Lsystem_data.SystemData(codegen_harness.SmallSystem__struct_194,meta.FieldEnum(codegen_harness.SmallSystem__struct_194),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).write__anon_2003"
        add	r14d, dword ptr [rbx]
        mov	eax, r14d
        pop	rbx
        pop	r14
        pop	rbp
        ret

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

