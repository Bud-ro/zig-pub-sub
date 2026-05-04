cross_system_swap:
        push	rax
        mov	eax, dword ptr [rdi]
        mov	ecx, dword ptr [rsi]
        mov	dword ptr [rdi], ecx
        mov	dword ptr [rsp + 4], eax
        mov	dword ptr [rsi], eax
        cmp	ecx, eax
        je	.LBB12_2
        mov	rdx, rsi
        lea	rsi, [rsp + 4]
        mov	rdi, rdx
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish.2"
.LBB12_2:
        pop	rax
        ret

; --- called functions ---

".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish.2":
        mov	rax, qword ptr [rdi + 24]
        test	rax, rax
        je	.LBB13_2
        sub	rsp, 24
        mov	rdi, qword ptr [rdi + 16]
        mov	word ptr [rsp + 16], 0
        mov	qword ptr [rsp + 8], rsi
        lea	rsi, [rsp + 8]
        call	rax
        add	rsp, 24
.LBB13_2:
        ret

