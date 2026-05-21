; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
dual_write:
        mov	dword ptr [rdi], 42
        or	dword ptr [rsi + 4], -1
        ret

