; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
read_across_two_erds:
        mov	eax, dword ptr [rdi]
        movzx	ecx, word ptr [rdi + 5]
        lea	eax, [rcx + 2*rax]
        ret

