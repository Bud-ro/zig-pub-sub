codegen_cross_erd_compute:
        push	rbp
        mov	rbp, rsp
        movzx	esi, word ptr [rdi + 5]
        add	si, word ptr [rdi]
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_224,meta.FieldEnum(codegen_harness.SmallSystem__struct_224),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).write__anon_1969"

; --- called functions ---

"system_data.SystemData(codegen_harness.SmallSystem__struct_224,meta.FieldEnum(codegen_harness.SmallSystem__struct_224),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).write__anon_1969":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	word ptr [rbp - 2], si
        cmp	word ptr [rdi + 7], si
        mov	word ptr [rdi + 7], si
        je	.LBB9_2
        lea	rdx, [rbp - 2]
        mov	esi, 3
        mov	rcx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
.LBB9_2:
        add	rsp, 16
        pop	rbp
        ret

