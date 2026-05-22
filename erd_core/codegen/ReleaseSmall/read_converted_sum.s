; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 2 calls)
; PER-ERD: compute function inlined (two loads + add).
; Cannot be per-type shared since each converted ERD has
; a unique compute function. runtimeRead is the shared
; alternative (indirect call through function pointer table).
;
read_converted_sum:
        mov	rcx, qword ptr [rdi + 168]
        movzx	eax, word ptr [rcx + 5]
        add	eax, dword ptr [rcx]
        ret

