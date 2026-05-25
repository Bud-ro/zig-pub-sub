; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
; NOINLINE-PUB. In-place modify.
;
mixed_modify:
        lea	rdx, [rdi + 15]
        inc	dword ptr [rdi + 15]
        push	4
        pop	rsi
        mov	rcx, rdi
        jmp	".Lram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_mono_stress.mixed_ram_erds))[0..5]).publish"

; --- called functions ---

".Lram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_mono_stress.mixed_ram_erds))[0..5]).publish":
        mov	r8, rcx
        mov	rcx, rdx
        movzx	eax, si
        mov	rdx, qword ptr [8*rax + .L__anon_0]
        movzx	esi, byte ptr [rax + .L__anon_1]
        shl	rdx, 4
        add	rdi, rdx
        add	rdi, 24
        movzx	edx, word ptr [rax + rax + .L__anon_2]
        jmp	.LSubscription.publish

