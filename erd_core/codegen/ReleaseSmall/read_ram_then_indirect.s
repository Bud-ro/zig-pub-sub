; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 3 calls)
;
read_ram_then_indirect:
        mov	eax, 51966
        add	eax, dword ptr [rdi]
        ret

