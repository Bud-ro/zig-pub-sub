; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 2 calls)
;
conditional_write_chain:
        test	byte ptr [rdi + 4], 1
        je	.L0
        add	dword ptr [rdi], 10
.L0:
        cmp	word ptr [rdi + 6], 100
        jbe	.L1
        add	dword ptr [rdi], 20
.L1:
        ret

