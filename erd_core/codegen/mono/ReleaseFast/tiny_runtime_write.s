; snapshot_comments.zig
; Speed: Optimal | Local Size: Optimal | Global Size: Optimal
;
tiny_runtime_write:
        jmp	"system_data.SystemData(codegen_mono_stress.TinySystem__struct_0,meta.FieldEnum(codegen_mono_stress.TinySystem__struct_0),.{ .counter = .{ ... }, .flag = .{ ... }, .pair = .{ ... } },system_data_test_double.create.Components).runtimeWrite"

; --- called functions ---

"system_data.SystemData(codegen_mono_stress.TinySystem__struct_0,meta.FieldEnum(codegen_mono_stress.TinySystem__struct_0),.{ .counter = .{ ... }, .flag = .{ ... }, .pair = .{ ... } },system_data_test_double.create.Components).runtimeWrite":
        push	rbp
        push	r15
        push	r14
        push	r13
        push	r12
        push	rbx
        push	rax
        mov	rbx, rdx
        mov	r14, rdi
        movzx	eax, si
        movzx	r15d, word ptr [rax + rax + __anon_1]
        movzx	r12d, word ptr [r15 + r15 + __anon_2]
        mov	r13, qword ptr [8*r15 + __anon_3]
        add	r13, rdi
        mov	rdi, rdx
        mov	rsi, r13
        mov	rdx, r12
        call	ram_data_component.runtimeBytesEqual
        mov	ebp, eax
        mov	rdi, r13
        mov	rsi, rbx
        mov	rdx, r12
        call	memcpy@PLT
        test	bpl, 1
        je	.L4
        add	rsp, 8
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        ret
.L4:
        mov	rdi, r14
        mov	esi, r15d
        mov	rdx, rbx
        mov	rcx, r14
        add	rsp, 8
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        jmp	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"

