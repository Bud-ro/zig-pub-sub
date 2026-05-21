; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 3 calls)
;
read_write_read:
        mov	eax, dword ptr [rdi]
        add	eax, 1
        mov	dword ptr [rdi], eax
        ret

