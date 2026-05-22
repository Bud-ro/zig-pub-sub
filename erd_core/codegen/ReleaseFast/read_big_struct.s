; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 2 calls)
; PER-ERD: copies 256 bytes from a hardcoded offset via
; memcpy/rep movsb. runtimeRead would share the copy logic.
;
read_big_struct:
        push	rbx
        mov	rbx, rdi
        mov	edx, 256
        call	memcpy@PLT
        mov	rax, rbx
        pop	rbx
        ret

