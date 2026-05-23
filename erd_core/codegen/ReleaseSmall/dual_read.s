; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 3 calls)
;
dual_read:
        mov	ecx, dword ptr [rdi]
        movsxd	rax, dword ptr [rsi]
        add	rax, rcx
        ret

