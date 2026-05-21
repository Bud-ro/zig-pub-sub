; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 4 calls)
;
read_write_read:
        mov	eax, dword ptr [rdi]
        inc	eax
        mov	dword ptr [rdi], eax
        ret

