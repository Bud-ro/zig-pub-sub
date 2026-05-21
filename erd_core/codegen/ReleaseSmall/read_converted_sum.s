; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
read_converted_sum:
        mov	rcx, qword ptr [rdi + 168]
        movzx	eax, word ptr [rcx + 5]
        add	eax, dword ptr [rcx]
        ret

