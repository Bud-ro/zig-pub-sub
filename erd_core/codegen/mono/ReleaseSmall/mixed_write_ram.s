; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal (until 2 calls)
; NOINLINE-PUB. PER-ERD: 4 writes, 3 with subs.
;
mixed_write_ram:
        push	rbp
        push	r15
        push	r14
        push	rbx
        sub	rsp, 24
        mov	r14, r8
        mov	ebp, ecx
        mov	r15d, edx
        mov	rbx, rdi
        mov	dword ptr [rsp + 4], esi
        cmp	dword ptr [rdi], esi
        mov	dword ptr [rdi], esi
        je	.L0
        lea	rdx, [rsp + 4]
        mov	rdi, rbx
        xor	esi, esi
        mov	rcx, rbx
        call	".Lram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_mono_stress.mixed_ram_erds))[0..5]).publish"
.L0:
        mov	word ptr [rsp + 2], r15w
        cmp	word ptr [rbx + 4], r15w
        mov	word ptr [rbx + 4], r15w
        je	.L1
        push	1
        pop	rsi
        lea	rdx, [rsp + 2]
        mov	rdi, rbx
        mov	rcx, rbx
        call	".Lram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_mono_stress.mixed_ram_erds))[0..5]).publish"
.L1:
        and	bpl, 1
        mov	byte ptr [rbx + 6], bpl
        mov	qword ptr [rsp + 8], r14
        cmp	qword ptr [rbx + 7], r14
        mov	qword ptr [rbx + 7], r14
        je	.L2
        push	3
        pop	rsi
        lea	rdx, [rsp + 8]
        mov	rdi, rbx
        mov	rcx, rbx
        call	".Lram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_mono_stress.mixed_ram_erds))[0..5]).publish"
.L2:
        add	rsp, 24
        pop	rbx
        pop	r14
        pop	r15
        pop	rbp
        ret

; --- called functions ---

".Lram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_mono_stress.mixed_ram_erds))[0..5]).publish":
        mov	r8, rcx
        mov	rcx, rdx
        movzx	eax, si
        mov	rdx, qword ptr [8*rax + .L__anon_3]
        movzx	esi, byte ptr [rax + .L__anon_4]
        shl	rdx, 4
        add	rdi, rdx
        add	rdi, 24
        movzx	edx, word ptr [rax + rax + .L__anon_5]
        jmp	.LSubscription.publish

