; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
; Tagged union: swap the active variant payload based on the runtime tag.
;
wire_swap_reading:
        movzx	eax, byte ptr [rdi]
        cmp	eax, 1
        je	.L0
        test	eax, eax
        jne	.L1
        mov	eax, dword ptr [rdi + 4]
        bswap	eax
        mov	dword ptr [rdi + 4], eax
        ret
.L0:
        rol	word ptr [rdi + 4], 8
.L1:
        ret

