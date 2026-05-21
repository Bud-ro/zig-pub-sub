; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 2 calls)
;
read_converted_sum:
        mov	rcx, qword ptr [rdi + 168]
        movzx	eax, word ptr [rcx + 5]
        add	eax, dword ptr [rcx]
        ret

