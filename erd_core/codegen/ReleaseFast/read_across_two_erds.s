; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 2 calls)
;
read_across_two_erds:
        mov	eax, dword ptr [rdi]
        movzx	ecx, word ptr [rdi + 6]
        lea	eax, [rcx + 2*rax]
        ret

