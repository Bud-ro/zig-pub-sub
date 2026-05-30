; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
; NOINLINE-PUB. Read-modify-write of a struct field (proven change).
;
mixed_rmw:
        mov	rax, qword ptr [rdi + 16]
        movabs	rcx, -4294967296
        and	rcx, rax
        lea	edx, [rax + 1]
        or	rdx, rcx
        mov	qword ptr [rdi + 16], rdx
        cmp	rdx, rax
        je	.L0
        push	4
        pop	rsi
        mov	rdx, rdi
        jmp	".Lram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_mono_stress.mixed_ram_erds))[0..5]).publish"
.L0:
        ret

; --- called functions ---

".Lram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_mono_stress.mixed_ram_erds))[0..5]).publish":
        mov	r8, rdx
        movzx	eax, si
        movzx	esi, byte ptr [rax + .L__anon_0]
        movzx	edx, word ptr [rax + rax + .L__anon_1]
        shl	eax, 3
        mov	r9, qword ptr [rax + .L__anon_2]
        mov	rcx, qword ptr [rax + .L__anon_3]
        add	rcx, rdi
        shl	r9, 4
        add	rdi, r9
        add	rdi, 24
        jmp	.Lsystem_data.publishOnChange

