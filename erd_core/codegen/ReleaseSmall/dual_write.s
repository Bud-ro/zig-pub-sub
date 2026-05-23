; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 2 calls)
;
dual_write:
        mov	dword ptr [rdi], 42
        or	dword ptr [rsi + 4], -1
        ret

