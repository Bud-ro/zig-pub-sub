; snapshot_comments.zig
; Speed: Optimal | Local Size: Optimal | Global Size: Optimal
;
tiny_read_all:
        movzx	eax, byte ptr [rdi + 4]
        and	eax, 1
        add	eax, dword ptr [rdi]
        ret

