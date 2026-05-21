; snapshot_comments.zig
; Speed: Optimal | Local Size: Optimal | Global Size: Optimal
;
read_big_struct:
        push	rbx
        mov	rbx, rdi
        mov	edx, 256
        call	memcpy@PLT
        mov	rax, rbx
        pop	rbx
        ret

