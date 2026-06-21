; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
; @byteSwap -> single bswap (was a 26-byte SSE shuffle).
;
wire_swap_u32:
        mov	eax, dword ptr [rdi]
        bswap	eax
        mov	dword ptr [rdi], eax
        ret

