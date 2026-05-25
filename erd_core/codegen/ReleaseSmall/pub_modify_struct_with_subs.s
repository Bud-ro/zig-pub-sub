; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
;
pub_modify_struct_with_subs:
        push	rbx
        sub	rsp, 32
        mov	rbx, rdi
        lea	rdx, [rdi + 6]
        inc	dword ptr [rdi + 22]
        push	2
        pop	rsi
        mov	rcx, rdi
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..6]).publish"
        mov	rax, qword ptr [rbx + 22]
        mov	rdx, rsp
        mov	qword ptr [rdx + 16], rax
        movups	xmm0, xmmword ptr [rbx + 6]
        movaps	xmmword ptr [rdx], xmm0
        push	24
        pop	rcx
        mov	rdi, rbx
        mov	esi, 8194
        call	".Lsystem_data.SystemData(codegen_harness.PubSystem__struct_0,meta.FieldEnum(codegen_harness.PubSystem__struct_0),.{ .pub_with_subs = .{ ... }, .pub_no_subs = .{ ... }, .pub_struct_with_subs = .{ ... }, .pub_struct_no_subs = .{ ... }, .unpub_with_subs = .{ ... }, .unpub_no_subs = .{ ... } },system_data_test_double.create.Components).publishExternal"
        add	rsp, 32
        pop	rbx
        ret

; --- called functions ---

".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..6]).publish":
        mov	r8, rcx
        mov	rcx, rdx
        movzx	eax, si
        mov	rdx, qword ptr [8*rax + .L__anon_1]
        movzx	esi, byte ptr [rax + .L__anon_2]
        shl	rdx, 4
        add	rdi, rdx
        add	rdi, 64
        movzx	edx, word ptr [rax + rax + .L__anon_3]
        jmp	.LSubscription.publish

".Lsystem_data.SystemData(codegen_harness.PubSystem__struct_0,meta.FieldEnum(codegen_harness.PubSystem__struct_0),.{ .pub_with_subs = .{ ... }, .pub_no_subs = .{ ... }, .pub_struct_with_subs = .{ ... }, .pub_struct_no_subs = .{ ... }, .unpub_with_subs = .{ ... }, .unpub_no_subs = .{ ... } },system_data_test_double.create.Components).publishExternal":
        mov	rax, qword ptr [rdi + 112]
        test	rax, rax
        je	.L0
        mov	edi, esi
        mov	rsi, rdx
        mov	rdx, rcx
        jmp	rax
.L0:
        ret

