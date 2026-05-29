; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal (until 2 calls)
; NOINLINE-PUB. PER-ERD store + publish into the wire handler (indirect).
;
wire_write_ram:
        push	rax
        mov	word ptr [rsp + 6], si
        cmp	word ptr [rdi], si
        mov	word ptr [rdi], si
        je	.L0
        lea	rdx, [rsp + 6]
        xor	esi, esi
        mov	rcx, rdi
        call	".Lram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_ram_erds))[0..9]).publish"
.L0:
        pop	rax
        ret

; --- called functions ---

".Lram_data_component.RamDataComponent(@as([*]const Erd, @ptrCast(&codegen_wire_publisher.wire_ram_erds))[0..9]).publish":
        mov	r8, rcx
        mov	rcx, rdx
        movzx	eax, si
        mov	rdx, qword ptr [8*rax + .L__anon_0]
        movzx	esi, byte ptr [rax + .L__anon_1]
        shl	rdx, 4
        add	rdi, rdx
        add	rdi, 48
        movzx	edx, word ptr [rax + rax + .L__anon_2]
        jmp	.Lsystem_data.publishOnChange

