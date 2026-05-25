; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
;
pub_write_with_subs:
        push	r14
        push	rbx
        push	rax
        mov	eax, dword ptr [rdi]
        mov	dword ptr [rsp + 4], esi
        mov	dword ptr [rdi], esi
        cmp	eax, esi
        je	.L0
        mov	ebx, esi
        lea	rdx, [rsp + 4]
        mov	r14, rdi
        xor	esi, esi
        mov	rcx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..6]).publish"
        mov	dword ptr [rsp], ebx
        mov	rdi, qword ptr [r14 + 112]
        mov	rdx, rsp
        mov	ecx, 4
        mov	esi, 8192
        call	"system_data.SystemData(codegen_harness.PubSystem__struct_0,meta.FieldEnum(codegen_harness.PubSystem__struct_0),.{ .pub_with_subs = .{ ... }, .pub_no_subs = .{ ... }, .pub_struct_with_subs = .{ ... }, .pub_struct_no_subs = .{ ... }, .unpub_with_subs = .{ ... }, .unpub_no_subs = .{ ... } },system_data_test_double.create.Components).publishExternal"
.L0:
        add	rsp, 8
        pop	rbx
        pop	r14
        ret

; --- called functions ---

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..6]).publish":
        mov	r8, rcx
        mov	rcx, rdx
        movzx	eax, si
        mov	rdx, qword ptr [8*rax + __anon_1]
        movzx	esi, byte ptr [rax + __anon_2]
        shl	rdx, 4
        add	rdi, rdx
        add	rdi, 64
        movzx	edx, word ptr [rax + rax + __anon_3]
        jmp	Subscription.publish

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

