; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal (until 2 calls)
; NOINLINE-PUB. PER-ERD: 40 bytes inlined.
;
write_bool_with_subs:
        push	rax
        and	sil, 1
        mov	byte ptr [rsp + 6], sil
        cmp	byte ptr [rdi + 4], sil
        mov	byte ptr [rdi + 4], sil
        je	.L0
        lea	rdx, [rsp + 6]
        mov	esi, 1
        mov	rcx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish.2"
.L0:
        pop	rax
        ret

; --- called functions ---

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish.2":
        mov	r8, rcx
        mov	rcx, rdx
        movzx	eax, si
        mov	rdx, qword ptr [8*rax + __anon_0]
        movzx	esi, byte ptr [rax + __anon_1]
        shl	rdx, 4
        add	rdi, rdx
        add	rdi, 16
        movzx	edx, word ptr [rax + rax + __anon_2]
        jmp	Subscription.publish

