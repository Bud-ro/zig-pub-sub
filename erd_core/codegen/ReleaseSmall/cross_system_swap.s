cross_system_swap:
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	eax, dword ptr [rdi]
        mov	ecx, dword ptr [rsi]
        mov	dword ptr [rdi], ecx
        mov	dword ptr [rbp - 4], eax
        mov	dword ptr [rsi], eax
        cmp	ecx, eax
        je	.LBB12_2
        mov	rdx, rsi
        lea	rsi, [rbp - 4]
        mov	rdi, rdx
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish.2"
.LBB12_2:
        add	rsp, 16
        pop	rbp
        ret

; --- called functions ---

".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish.2":
        mov	rax, qword ptr [rdi + 24]
        test	rax, rax
        je	.LBB13_2
        push	rbp
        mov	rbp, rsp
        sub	rsp, 16
        mov	rdi, qword ptr [rdi + 16]
        mov	word ptr [rbp - 8], 0
        mov	qword ptr [rbp - 16], rsi
        lea	rsi, [rbp - 16]
        call	rax
        add	rsp, 16
        pop	rbp
.LBB13_2:
        ret

