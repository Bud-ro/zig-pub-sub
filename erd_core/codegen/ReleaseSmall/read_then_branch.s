; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 2 calls)
;
read_then_branch:
        mov	eax, dword ptr [rdi]
        mov	ecx, eax
        imul	ecx, eax
        add	eax, eax
        test	sil, 1
        cmove	eax, ecx
        ret

