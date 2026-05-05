read_write_other_read:
        push	rbp
        push	rbx
        push	rax
        mov	rbx, rdi
        mov	ebp, dword ptr [rdi]
        call	".Lsystem_data.SystemData(codegen_harness.SmallSystem__struct_0,meta.FieldEnum(codegen_harness.SmallSystem__struct_0),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).write__anon_1"
        add	ebp, dword ptr [rbx]
        mov	eax, ebp
        add	rsp, 8
        pop	rbx
        pop	rbp
        ret

; --- called functions ---

".Lsystem_data.SystemData(codegen_harness.SmallSystem__struct_0,meta.FieldEnum(codegen_harness.SmallSystem__struct_0),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).write__anon_1":
        push	rax
        and	sil, 1
        mov	byte ptr [rsp + 6], sil
        cmp	byte ptr [rdi + 4], sil
        mov	byte ptr [rdi + 4], sil
        je	.LBB12_2
        lea	rdx, [rsp + 6]
        mov	esi, 1
        mov	rcx, rdi
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish.2"
.LBB12_2:
        pop	rax
        ret

