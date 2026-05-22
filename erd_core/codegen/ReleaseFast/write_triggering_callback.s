; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 2 calls)
; PER-ERD: 36 bytes inlined (writes constant true to a bool
; ERD). Would share body with write_bool_with_subs if per-type.
;
write_triggering_callback:
        push	rax
        mov	byte ptr [rsp + 6], 1
        cmp	byte ptr [rdi + 4], 1
        mov	byte ptr [rdi + 4], 1
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
        mov	rdx, qword ptr [8*rax + __anon_1]
        movzx	esi, byte ptr [rax + __anon_2]
        shl	rdx, 4
        add	rdi, rdx
        add	rdi, 16
        movzx	edx, word ptr [rax + rax + __anon_3]
        jmp	Subscription.publish

