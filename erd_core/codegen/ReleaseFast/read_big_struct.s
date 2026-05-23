; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 2 calls)
; PER-ERD: 256-byte copy. runtimeRead would share the logic.
;
read_big_struct:
        push	rbx
        mov	rbx, rdi
        mov	edx, 256
        call	memcpy@PLT
        mov	rax, rbx
        pop	rbx
        ret

