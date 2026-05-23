; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 2 calls)
; PER-ERD: 256-byte copy. runtimeRead would share the logic.
;
read_big_struct:
        mov	rax, rdi
        mov	ecx, 256
        rep movsb es:[rdi], [rsi]
        ret

