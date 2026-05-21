; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
triple_read_same_erd:
        mov	eax, dword ptr [rdi]
        lea	eax, [rax + 2*rax]
        ret

