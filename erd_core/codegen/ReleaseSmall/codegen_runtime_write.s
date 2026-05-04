codegen_runtime_write:
        push	rbp
        mov	rbp, rsp
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.SmallSystem__struct_224,meta.FieldEnum(codegen_harness.SmallSystem__struct_224),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).runtimeWrite"

; --- called functions ---

"system_data.SystemData(codegen_harness.SmallSystem__struct_224,meta.FieldEnum(codegen_harness.SmallSystem__struct_224),.{ .version = .{ ... }, .flag = .{ ... }, .unaligned_u16 = .{ ... }, .subscribable_u16 = .{ ... } },system_data_test_double.create.Components).runtimeWrite":
        push	rbp
        mov	rbp, rsp
        push	r15
        push	r14
        push	r13
        push	r12
        push	rbx
        push	rax
        mov	r15d, esi
        mov	rbx, rdi
        movzx	eax, r15w
        movzx	r14d, word ptr [rax + rax + .L__unnamed_3]
        movzx	eax, word ptr [r14 + r14 + .L__unnamed_4]
        mov	rdi, qword ptr [8*r14 + .L__unnamed_5]
        add	rdi, rbx
        cmp	rdx, rdi
        je	.LBB13_5
        test	r15w, r15w
        je	.LBB13_5
        movzx	ecx, byte ptr [rdx]
        movzx	esi, byte ptr [rdx + rax - 1]
        mov	r8d, eax
        shr	r8d
        xor	cl, byte ptr [rdi]
        movzx	r9d, byte ptr [rdx + r8]
        xor	sil, byte ptr [rdi + rax - 1]
        or	sil, cl
        xor	r9b, byte ptr [rdi + r8]
        or	r9b, sil
        sete	r13b
        mov	r12, rdx
        mov	rsi, rdx
        mov	rdx, rax
        call	memcpy@PLT
        cmp	r15w, 2
        je	.LBB13_4
        test	r13b, r13b
        jne	.LBB13_4
        mov	rdi, rbx
        mov	esi, r14d
        mov	rdx, r12
        mov	rcx, rbx
        add	rsp, 8
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        jmp	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish"
.LBB13_5:
        mov	rsi, rdx
        mov	rdx, rax
        add	rsp, 8
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        jmp	memcpy@PLT
.LBB13_4:
        add	rsp, 8
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        ret

