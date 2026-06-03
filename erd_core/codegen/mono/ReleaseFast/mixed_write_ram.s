; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal (until 2 calls)
; NOINLINE-PUB. PER-ERD: 4 writes, 3 with subs.
;
mixed_write_ram:
        push	rbp
        push	r15
        push	r14
        push	rbx
        push	rax
        mov	r14, r8
        mov	ebp, ecx
        mov	r15d, edx
        mov	rbx, rdi
        cmp	dword ptr [rdi], esi
        mov	dword ptr [rdi], esi
        je	.L0
        mov	rdi, rbx
        xor	esi, esi
        mov	rdx, rbx
        call	"ram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_mono_stress.mixed_ram_erds))[0..5]).publish"
.L0:
        cmp	word ptr [rbx + 4], r15w
        mov	word ptr [rbx + 4], r15w
        je	.L1
        mov	rdi, rbx
        mov	esi, 1
        mov	rdx, rbx
        call	"ram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_mono_stress.mixed_ram_erds))[0..5]).publish"
.L1:
        and	bpl, 1
        mov	byte ptr [rbx + 6], bpl
        cmp	qword ptr [rbx + 8], r14
        mov	qword ptr [rbx + 8], r14
        je	.L2
        mov	rdi, rbx
        mov	esi, 3
        mov	rdx, rbx
        add	rsp, 8
        pop	rbx
        pop	r14
        pop	r15
        pop	rbp
        jmp	"ram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_mono_stress.mixed_ram_erds))[0..5]).publish"
.L2:
        add	rsp, 8
        pop	rbx
        pop	r14
        pop	r15
        pop	rbp
        ret

; --- called functions ---

"ram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_mono_stress.mixed_ram_erds))[0..5]).publish":
        mov	r8, rdx
        movzx	eax, si
        movzx	esi, byte ptr [rax + __anon_0]
        movzx	edx, word ptr [rax + rax + __anon_1]
        shl	eax, 3
        mov	r9, qword ptr [rax + __anon_2]
        mov	rcx, qword ptr [rax + __anon_3]
        add	rcx, rdi
        shl	r9, 4
        add	rdi, r9
        add	rdi, 24
        jmp	system_data.publishOnChange

