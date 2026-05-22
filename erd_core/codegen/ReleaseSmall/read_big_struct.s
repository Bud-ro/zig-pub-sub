; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 2 calls)
; PER-ERD: copies 256 bytes from a hardcoded offset via
; memcpy/rep movsb. runtimeRead would share the copy logic.
;
read_big_struct:
        mov	rax, rdi
        mov	ecx, 256
        rep movsb es:[rdi], [rsi]
        ret

