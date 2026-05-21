; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
write_ram_with_converted_deps:
        push	rax
        mov	dword ptr [rsp + 4], esi
        cmp	dword ptr [rdi], esi
        mov	dword ptr [rdi], esi
        je	.L0
        lea	rdx, [rsp + 4]
        xor	esi, esi
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

