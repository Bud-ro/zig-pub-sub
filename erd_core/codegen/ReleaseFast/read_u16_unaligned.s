; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
read_u16_unaligned:
        movzx	eax, word ptr [rdi + 6]
        ret

