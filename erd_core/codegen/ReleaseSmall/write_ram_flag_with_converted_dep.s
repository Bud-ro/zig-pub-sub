write_ram_flag_with_converted_dep:
        push	rax
        and	sil, 1
        mov	byte ptr [rsp + 6], sil
        cmp	byte ptr [rdi + 4], sil
        mov	byte ptr [rdi + 4], sil
        je	.LBB275_2
        push	1
        pop	rsi
        lea	rdx, [rsp + 6]
        mov	rcx, rdi
        call	".Lram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_harness.ram_defs))[0..3]).publish"
.LBB275_2:
        pop	rax
        ret

; --- called functions ---

".Lram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_harness.ram_defs))[0..3]).publish":
        push	rbp
        push	r15
        push	r14
        push	r13
        push	r12
        push	rbx
        sub	rsp, 24
        mov	rbx, rcx
        mov	r14, rdx
        movzx	r12d, si
        mov	rax, qword ptr [8*r12 + .L__anon_0]
        movzx	r13d, byte ptr [r12 + .L__anon_1]
        shl	r13d, 4
        shl	rax, 4
        lea	rbp, [rdi + rax]
        add	rbp, 16
        xor	r15d, r15d
        cmp	r13, r15
        jne	.LBB269_2
        jmp	.LBB269_5
.LBB269_3:
        add	r15, 16
        cmp	r13, r15
        je	.LBB269_5
.LBB269_2:
        mov	rax, qword ptr [rbp + r15]
        test	rax, rax
        je	.LBB269_3
        mov	rdi, qword ptr [rbp + r15 - 8]
        movzx	ecx, word ptr [r12 + r12 + .L__anon_2]
        mov	word ptr [rsp + 16], cx
        mov	qword ptr [rsp + 8], r14
        lea	rsi, [rsp + 8]
        mov	rdx, rbx
        call	rax
        add	r15, 16
        cmp	r13, r15
        jne	.LBB269_2
.LBB269_5:
        add	rsp, 24
        pop	rbx
        pop	r12
        pop	r13
        pop	r14
        pop	r15
        pop	rbp
        ret

