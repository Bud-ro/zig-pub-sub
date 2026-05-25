; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
;
pub_modify_struct_with_subs:
        push	rbx
        sub	rsp, 32
        mov	rbx, rdi
        lea	rdx, [rdi + 6]
        add	dword ptr [rdi + 22], 1
        mov	esi, 2
        mov	rcx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..6]).publish"
        mov	rax, qword ptr [rbx + 22]
        mov	qword ptr [rsp + 16], rax
        movups	xmm0, xmmword ptr [rbx + 6]
        movaps	xmmword ptr [rsp], xmm0
        mov	rdi, qword ptr [rbx + 112]
        mov	rdx, rsp
        mov	ecx, 24
        mov	esi, 8194
        call	"system_data.SystemData(codegen_harness.PubSystem__struct_0,meta.FieldEnum(codegen_harness.PubSystem__struct_0),.{ .pub_with_subs = .{ ... }, .pub_no_subs = .{ ... }, .pub_struct_with_subs = .{ ... }, .pub_struct_no_subs = .{ ... }, .unpub_with_subs = .{ ... }, .unpub_no_subs = .{ ... } },system_data_test_double.create.Components).publishExternal"
        add	rsp, 32
        pop	rbx
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
        je	.L0
        mov	rax, rdi
        mov	edi, esi
        mov	rsi, rdx
        mov	rdx, rcx
        jmp	rax
.L0:
        ret

