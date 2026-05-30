; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal (until 2 calls)
; NOINLINE-PUB. PER-ERD: two writes, junk read eliminated.
;
write_junk_read_write:
        push	rbx
        mov	rbx, rdi
        push	1
        pop	rsi
        call	".Lsystem_data.SystemData(codegen_harness.SmallSystem__struct_0,meta.FieldEnum(codegen_harness.SmallSystem__struct_0),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).write__anon_1"
        push	2
        pop	rsi
        mov	rdi, rbx
        pop	rbx
        jmp	".Lsystem_data.SystemData(codegen_harness.SmallSystem__struct_0,meta.FieldEnum(codegen_harness.SmallSystem__struct_0),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).write__anon_1"

; --- called functions ---

".Lsystem_data.SystemData(codegen_harness.SmallSystem__struct_0,meta.FieldEnum(codegen_harness.SmallSystem__struct_0),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).write__anon_1":
        cmp	word ptr [rdi + 8], si
        mov	word ptr [rdi + 8], si
        je	.L0
        mov	esi, 3
        mov	rdx, rdi
        jmp	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish.2"
.L0:
        ret

