; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal (until 2 calls)
; NOINLINE-PUB. PER-ERD write + converted read inlined.
;
write_then_read_converted:
        push	rbx
        mov	rbx, rdi
        cmp	dword ptr [rdi], esi
        mov	dword ptr [rdi], esi
        je	.L0
        mov	rdi, rbx
        xor	esi, esi
        mov	rdx, rbx
        call	"ram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_harness.multi_ram_erds))[0..3]).publish"
.L0:
        mov	rcx, qword ptr [rbx + 136]
        movzx	eax, word ptr [rcx + 6]
        add	eax, dword ptr [rcx]
        pop	rbx
        ret

; --- called functions ---

"ram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_harness.multi_ram_erds))[0..3]).publish":
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
        add	rdi, 8
        jmp	system_data.publishOnChange

