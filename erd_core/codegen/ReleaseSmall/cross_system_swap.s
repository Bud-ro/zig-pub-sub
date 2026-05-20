cross_system_swap:
        push	rax
        mov	eax, dword ptr [rdi]
        mov	ecx, dword ptr [rsi]
        mov	dword ptr [rdi], ecx
        mov	dword ptr [rsp + 4], eax
        mov	dword ptr [rsi], eax
        cmp	ecx, eax
        je	.LBB305_2
        mov	rdx, rsi
        lea	rsi, [rsp + 4]
        mov	rdi, rdx
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
.LBB305_2:
        pop	rax
        ret

; --- called functions ---

".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish":
        mov	r8, rdx
        mov	rcx, rsi
        add	rdi, 16
        mov	esi, 1
        xor	edx, edx
        jmp	.LSubscription.publish

