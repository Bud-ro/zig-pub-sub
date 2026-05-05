write_triggering_callback:
        push	rbp
        mov	rbp, rsp
        mov	esi, 1
        pop	rbp
        jmp	".Lsystem_data.SystemData(codegen_harness.SmallSystem__struct_0,meta.FieldEnum(codegen_harness.SmallSystem__struct_0),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).write__anon_1"

; --- called functions ---

".Lsystem_data.SystemData(codegen_harness.SmallSystem__struct_0,meta.FieldEnum(codegen_harness.SmallSystem__struct_0),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).write__anon_1":
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

