; snapshot_comments.zig
; Speed: Optimal | Local Size: Optimal | Global Size: Optimal
;
write_ram_flag_with_converted_dep:
        push	rax
        and	sil, 1
        mov	byte ptr [rsp + 6], sil
        cmp	byte ptr [rdi + 4], sil
        mov	byte ptr [rdi + 4], sil
        je	.L0
        lea	rdx, [rsp + 6]
        mov	esi, 1
        mov	rcx, rdi
        call	"ram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_harness.ram_defs))[0..3]).publish"
.L0:
        pop	rax
        ret

; --- called functions ---

"ram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_harness.ram_defs))[0..3]).publish":
        mov	r8, rcx
        mov	rcx, rdx
        movzx	eax, si
        mov	rdx, qword ptr [8*rax + __anon_1]
        movzx	esi, byte ptr [rax + __anon_2]
        shl	rdx, 4
        add	rdi, rdx
        add	rdi, 8
        movzx	edx, word ptr [rax + rax + __anon_3]
        jmp	Subscription.publish

