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
        mov	esi, 4
        mov	rdx, rdi
        jmp	"ram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_mono_stress.mixed_ram_erds))[0..5]).publish"
.L0:
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

