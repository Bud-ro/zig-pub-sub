; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 2 calls)
; PER-ERD: two conditional writes to different ERDs, both
; inlined with hardcoded offsets.
;
conditional_write_chain:
        test	byte ptr [rdi + 4], 1
        je	.L0
        add	dword ptr [rdi], 10
.L0:
        cmp	word ptr [rdi + 5], 100
        jbe	.L1
        add	dword ptr [rdi], 20
.L1:
        ret

