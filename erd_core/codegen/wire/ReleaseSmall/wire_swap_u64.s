; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
; @byteSwap -> single bswap (was a 36-byte SSE shuffle).
;
wire_swap_u64:
        mov	rax, qword ptr [rdi]
        bswap	rax
        mov	qword ptr [rdi], rax
        ret

