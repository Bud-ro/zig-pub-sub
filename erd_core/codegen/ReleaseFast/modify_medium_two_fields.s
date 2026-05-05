modify_medium_two_fields:
        mov	esi, offset codegen_harness.modify_medium_two_fields__struct_0.m
        mov	rdx, rdi
        jmp	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).modifyInner__anon_1"

; --- called functions ---

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).modifyInner__anon_1":
        push	r15
        push	r14
        push	rbx
        sub	rsp, 32
        mov	rbx, rdx
        mov	r14, rdi
        mov	rax, qword ptr [rdi + 272]
        mov	qword ptr [rsp + 16], rax
        movups	xmm0, xmmword ptr [rdi + 256]
        movaps	xmmword ptr [rsp], xmm0
        mov	r15, rsp
        mov	rdi, r15
        call	rsi
        mov	rax, qword ptr [rsp + 16]
        mov	qword ptr [r14 + 272], rax
        movaps	xmm0, xmmword ptr [rsp]
        movups	xmmword ptr [r14 + 256], xmm0
        mov	rdi, r14
        mov	rsi, r15
        mov	rdx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
        add	rsp, 32
        pop	rbx
        pop	r14
        pop	r15
        ret

