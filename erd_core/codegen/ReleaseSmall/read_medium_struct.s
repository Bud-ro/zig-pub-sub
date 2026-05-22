; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 2 calls)
; PER-ERD: 24-byte copy. runtimeRead would share the logic.
;
read_medium_struct:
        mov	rax, rdi
        mov	rcx, qword ptr [rsi + 272]
        mov	qword ptr [rdi + 16], rcx
        movups	xmm0, xmmword ptr [rsi + 256]
        movups	xmmword ptr [rdi], xmm0
        ret

