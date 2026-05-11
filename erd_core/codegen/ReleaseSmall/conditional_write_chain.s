conditional_write_chain:
        test	byte ptr [rdi + 4], 1
        je	.LBB303_1
        add	dword ptr [rdi], 10
.LBB303_1:
        cmp	word ptr [rdi + 5], 100
        jbe	.LBB303_3
        add	dword ptr [rdi], 20
.LBB303_3:
        ret

