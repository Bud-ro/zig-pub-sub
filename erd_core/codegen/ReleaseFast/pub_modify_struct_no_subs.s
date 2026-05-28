; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
;
pub_modify_struct_no_subs:
        sub	rsp, 24
        add	dword ptr [rdi + 46], 1
        movups	xmm0, xmmword ptr [rdi + 30]
        movaps	xmmword ptr [rsp], xmm0
        mov	rax, qword ptr [rdi + 46]
        mov	qword ptr [rsp + 16], rax
        mov	rdi, qword ptr [rdi + 112]
        mov	rdx, rsp
        mov	ecx, 24
        mov	esi, 8195
        call	"system_data.SystemData(codegen_harness.PubSystem__struct_0,meta.FieldEnum(codegen_harness.PubSystem__struct_0),.{ .pub_with_subs = .{ ... }, .pub_no_subs = .{ ... }, .pub_struct_with_subs = .{ ... }, .pub_struct_no_subs = .{ ... }, .unpub_with_subs = .{ ... }, .unpub_no_subs = .{ ... } },system_data_test_double.create.Components).publishExternal"
        add	rsp, 24
        ret

; --- called functions ---

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

