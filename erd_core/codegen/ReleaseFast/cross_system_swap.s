; snapshot_comments.zig
; Speed: Optimal | Local Size: Optimal | Global Size: Optimal
;
cross_system_swap:
        push	rax
        mov	eax, dword ptr [rdi]
        mov	ecx, dword ptr [rsi]
        mov	dword ptr [rdi], ecx
        mov	dword ptr [rsp + 4], eax
        mov	dword ptr [rsi], eax
        cmp	ecx, eax
        je	.L0
        mov	rdx, rsi
        lea	rsi, [rsp + 4]
        mov	rdi, rdx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
.L0:
        pop	rax
        ret

; --- called functions ---

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish":
        mov	r8, rdx
        mov	rcx, rsi
        add	rdi, 16
        mov	esi, 1
        xor	edx, edx
        jmp	Subscription.publish

