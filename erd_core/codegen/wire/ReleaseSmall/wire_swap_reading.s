; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
; Tagged union: swap the active variant payload based on the runtime tag.
;
wire_swap_reading:
        push	8
        pop	rsi
        jmp	".Lerd_swap.SwapRules(codegen_wire_publisher.Reading).applyToBig"

; --- called functions ---

".Lerd_swap.SwapRules(codegen_wire_publisher.Reading).applyToBig":
        test	rsi, rsi
        je	.L0
        movzx	eax, byte ptr [rdi]
        cmp	eax, 1
        je	.L1
        test	eax, eax
        jne	.L0
        cmp	rsi, 8
        jb	.L0
        mov	eax, dword ptr [rdi + 4]
        bswap	eax
        mov	dword ptr [rdi + 4], eax
        ret
.L1:
        cmp	rsi, 6
        jb	.L0
        rol	word ptr [rdi + 4], 8
.L0:
        ret

