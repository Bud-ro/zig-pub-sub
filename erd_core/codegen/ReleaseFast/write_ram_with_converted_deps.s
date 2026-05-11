write_ram_with_converted_deps:
        push	rax
        mov	dword ptr [rsp + 4], esi
        cmp	dword ptr [rdi], esi
        mov	dword ptr [rdi], esi
        je	.LBB285_2
        lea	rdx, [rsp + 4]
        xor	esi, esi
        mov	rcx, rdi
        call	"ram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_harness.ram_defs))[0..3]).publish"
.LBB285_2:
        pop	rax
        ret

; --- called functions ---

"ram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_harness.ram_defs))[0..3]).publish":
        push	rbp
        push	r15
        push	r14
        push	r13
        push	r12
        push	rbx
        sub	rsp, 24
        movzx	r12d, si
        movzx	r13d, byte ptr [r12 + __anon_0]
        test	r13, r13
        je	.LBB279_4
        mov	rbx, rcx
        mov	r14, rdx
        mov	rax, qword ptr [8*r12 + __anon_1]
        shl	r13d, 4
        shl	rax, 4
        lea	rbp, [rdi + rax]
        add	rbp, 16
        xor	r15d, r15d
        jmp	.LBB279_2
.LBB279_3:
        add	r15, 16
        cmp	r13, r15
        je	.LBB279_4
.LBB279_2:
        mov	rax, qword ptr [rbp + r15]
        test	rax, rax
        je	.LBB279_3
        mov	rdi, qword ptr [rbp + r15 - 8]
        movzx	ecx, word ptr [r12 + r12 + __anon_2]
        mov	word ptr [rsp + 16], cx
        mov	qword ptr [rsp + 8], r14
        lea	rsi, [rsp + 8]
        mov	rdx, rbx
        call	rax
        jmp	.LBB279_3
.LBB279_4:
        add	rsp, 24
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        ret

