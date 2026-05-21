; snapshot_comments.zig
; Speed: Optimal | Local Size: Optimal | Global Size: Optimal
;
read_write_read:
        mov	eax, dword ptr [rdi]
        inc	eax
        mov	dword ptr [rdi], eax
        ret

