; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
pub_write_no_subs:
        movzx	eax, word ptr [rdi + 4]
        mov	word ptr [rdi + 4], si
        cmp	ax, si
        je	.L0
        push	rax
        mov	word ptr [rsp + 6], si
        mov	rdi, qword ptr [rdi + 112]
        lea	rdx, [rsp + 6]
        mov	ecx, 2
        mov	esi, 8193
        call	"system_data.SystemData(codegen_harness.PubSystem__struct_0,meta.FieldEnum(codegen_harness.PubSystem__struct_0),.{ .pub_with_subs = .{ ... }, .pub_no_subs = .{ ... }, .pub_struct_with_subs = .{ ... }, .pub_struct_no_subs = .{ ... }, .unpub_with_subs = .{ ... }, .unpub_no_subs = .{ ... } },system_data_test_double.create.Components).publishExternal"
        add	rsp, 8
.L0:
        ret

; --- called functions ---

"system_data.SystemData(codegen_harness.PubSystem__struct_0,meta.FieldEnum(codegen_harness.PubSystem__struct_0),.{ .pub_with_subs = .{ ... }, .pub_no_subs = .{ ... }, .pub_struct_with_subs = .{ ... }, .pub_struct_no_subs = .{ ... }, .unpub_with_subs = .{ ... }, .unpub_no_subs = .{ ... } },system_data_test_double.create.Components).publishExternal":
        test	rdi, rdi
        je	.L1
        mov	rax, rdi
        mov	edi, esi
        mov	rsi, rdx
        mov	rdx, rcx
        jmp	rax
.L1:
        ret

