; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
; NOINLINE-PUB. Shared runtime dispatch path.
;
wide_runtime_write:
        jmp	"system_data.SystemData(codegen_mono_stress.WideSystem__struct_0,meta.FieldEnum(codegen_mono_stress.WideSystem__struct_0),.{ .w00 = .{ ... }, .w01 = .{ ... }, .w02 = .{ ... }, .w03 = .{ ... }, .w04 = .{ ... }, .w05 = .{ ... }, .w06 = .{ ... }, .w07 = .{ ... }, .w08 = .{ ... }, .w09 = .{ ... }, .w10 = .{ ... }, .w11 = .{ ... }, .w12 = .{ ... }, .w13 = .{ ... }, .w14 = .{ ... }, .w15 = .{ ... }, .w_pair = .{ ... } },system_data_test_double.create.Components).runtimeWrite"

; --- called functions ---

"system_data.SystemData(codegen_mono_stress.WideSystem__struct_0,meta.FieldEnum(codegen_mono_stress.WideSystem__struct_0),.{ .w00 = .{ ... }, .w01 = .{ ... }, .w02 = .{ ... }, .w03 = .{ ... }, .w04 = .{ ... }, .w05 = .{ ... }, .w06 = .{ ... }, .w07 = .{ ... }, .w08 = .{ ... }, .w09 = .{ ... }, .w10 = .{ ... }, .w11 = .{ ... }, .w12 = .{ ... }, .w13 = .{ ... }, .w14 = .{ ... }, .w15 = .{ ... }, .w_pair = .{ ... } },system_data_test_double.create.Components).runtimeWrite":
        push	rbp
        push	r15
        push	r14
        push	r13
        push	r12
        push	rbx
        push	rax
        mov	r15, rdx
        mov	rbx, rdi
        movzx	eax, si
        movzx	r14d, word ptr [rax + rax + __anon_1]
        movzx	r12d, word ptr [r14 + r14 + __anon_2]
        mov	r13, qword ptr [8*r14 + __anon_3]
        add	r13, rdi
        mov	rdi, rdx
        mov	rsi, r13
        mov	rdx, r12
        call	ram_data_component.runtimeBytesEqual
        mov	ebp, eax
        mov	rdi, r13
        mov	rsi, r15
        mov	rdx, r12
        call	memcpy@PLT
        test	bpl, 1
        jne	.L0
        cmp	byte ptr [r14 + __anon_4], 0
        je	.L0
        mov	rdi, rbx
        mov	esi, r14d
        mov	rdx, rbx
        add	rsp, 8
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        jmp	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.L0:
        add	rsp, 8
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        ret

