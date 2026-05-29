; snapshot_comments.zig
; Speed: Optimal | Size: Optimal
; extern struct: bswap u32 field + rol u16 field; u8 field untouched.
;
wire_swap_sample:
        mov	eax, dword ptr [rdi]
        bswap	eax
        mov	dword ptr [rdi], eax
        rol	word ptr [rdi + 4], 8
        ret

