; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal (until 2 calls)
; NOINLINE-PUB. Writes a RAM dep that recomputes/republishes a watched converted ERD.
;
wire_write_converted_dep:
        push	rax
        mov	dword ptr [rsp + 4], esi
        cmp	dword ptr [rdi + 35], esi
        mov	dword ptr [rdi + 35], esi
        je	.L0
        push	7
        pop	rsi
        lea	rdx, [rsp + 4]
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

