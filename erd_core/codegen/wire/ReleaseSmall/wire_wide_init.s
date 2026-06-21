; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
;
wire_wide_init:
        xorps	xmm0, xmm0
        movups	xmmword ptr [rdi + 32], xmm0
        movups	xmmword ptr [rdi + 16], xmm0
        movups	xmmword ptr [rdi], xmm0
        ret

