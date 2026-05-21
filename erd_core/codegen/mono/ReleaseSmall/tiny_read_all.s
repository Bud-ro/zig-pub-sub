; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
tiny_read_all:
        movzx	eax, byte ptr [rdi + 4]
        and	eax, 1
        add	eax, dword ptr [rdi]
        ret

