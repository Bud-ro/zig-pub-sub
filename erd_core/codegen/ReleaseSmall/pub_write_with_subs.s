; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
;
pub_write_with_subs:
        push	rbp
        push	rbx
        push	rax
        mov	eax, dword ptr [rdi]
        mov	dword ptr [rsp], esi
        mov	dword ptr [rdi], esi
        cmp	eax, esi
        je	.L0
        mov	ebp, esi
        mov	rbx, rdi
        mov	rdx, rsp
        xor	esi, esi
        mov	rcx, rdi
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..6]).publish"
        lea	rdx, [rsp + 4]
        mov	dword ptr [rdx], ebp
        push	4
        pop	rcx
        mov	rdi, rbx
        mov	esi, 8192
        call	".Lsystem_data.SystemData(codegen_harness.PubSystem__struct_0,meta.FieldEnum(codegen_harness.PubSystem__struct_0),.{ .pub_with_subs = .{ ... }, .pub_no_subs = .{ ... }, .pub_struct_with_subs = .{ ... }, .pub_struct_no_subs = .{ ... }, .unpub_with_subs = .{ ... }, .unpub_no_subs = .{ ... } },system_data_test_double.create.Components).publishExternal"
.L0:
        add	rsp, 8
        pop	rbx
        pop	rbp
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
        je	.L1
        mov	edi, esi
        mov	rsi, rdx
        mov	rdx, rcx
        jmp	rax
.L1:
        ret

