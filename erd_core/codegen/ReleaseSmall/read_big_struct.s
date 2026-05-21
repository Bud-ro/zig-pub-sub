; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 2 calls)
;
read_big_struct:
        mov	rax, rdi
        mov	ecx, 256
        rep movsb es:[rdi], [rsi]
        ret

