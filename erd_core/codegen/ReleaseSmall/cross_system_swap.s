; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal (until 2 calls)
; NOINLINE-PUB. PER-ERD: 35 bytes for the subscribable write.
;
cross_system_swap:
        mov	eax, dword ptr [rdi]
        mov	ecx, dword ptr [rsi]
        mov	dword ptr [rdi], ecx
        mov	dword ptr [rsi], eax
        cmp	ecx, eax
        je	.L0
        mov	rdi, rsi
        jmp	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
.L0:
        ret

; --- called functions ---

".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish":
        mov	r8, rsi
        mov	rcx, rdi
        add	rdi, 16
        mov	esi, 1
        xor	edx, edx
        jmp	.Lsystem_data.publishOnChange

