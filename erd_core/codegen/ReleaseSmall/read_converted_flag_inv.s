; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 2 calls)
;
read_converted_flag_inv:
        mov	rax, qword ptr [rdi + 168]
        mov	al, byte ptr [rax + 4]
        xor	al, 1
        ret

