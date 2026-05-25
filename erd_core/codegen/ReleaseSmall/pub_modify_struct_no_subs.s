; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
;
pub_modify_struct_no_subs:
        sub	rsp, 24
        inc	dword ptr [rdi + 46]
        mov	rax, qword ptr [rdi + 46]
        mov	rdx, rsp
        mov	qword ptr [rdx + 16], rax
        movups	xmm0, xmmword ptr [rdi + 30]
        movaps	xmmword ptr [rdx], xmm0
        push	24
        pop	rcx
        mov	esi, 8195
        call	".Lsystem_data.SystemData(codegen_harness.PubSystem__struct_0,meta.FieldEnum(codegen_harness.PubSystem__struct_0),.{ .pub_with_subs = .{ ... }, .pub_no_subs = .{ ... }, .pub_struct_with_subs = .{ ... }, .pub_struct_no_subs = .{ ... }, .unpub_with_subs = .{ ... }, .unpub_no_subs = .{ ... } },system_data_test_double.create.Components).publishExternal"
        add	rsp, 24
        ret

; --- called functions ---

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

