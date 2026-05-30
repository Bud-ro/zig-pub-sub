; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal (until 2 calls)
; NOINLINE-PUB. PER-ERD: 40 bytes inlined.
;
write_ram_flag_with_converted_dep:
        and	esi, 1
        cmp	byte ptr [rdi + 4], sil
        mov	byte ptr [rdi + 4], sil
        je	.L0
        mov	esi, 1
        mov	rdx, rdi
        jmp	"ram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_harness.multi_ram_erds))[0..3]).publish"
.L0:
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

