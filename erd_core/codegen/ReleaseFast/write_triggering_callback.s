; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal (until 2 calls)
; NOINLINE-PUB. PER-ERD: 36 bytes inlined.
;
write_triggering_callback:
        cmp	byte ptr [rdi + 4], 1
        mov	byte ptr [rdi + 4], 1
        je	.L0
        mov	esi, 1
        mov	rdx, rdi
        jmp	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish.2"
.L0:
        ret

; --- called functions ---

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish.2":
        mov	r8, rdx
        movzx	eax, si
        movzx	esi, byte ptr [rax + __anon_0]
        movzx	edx, word ptr [rax + rax + __anon_1]
        shl	eax, 3
        mov	r9, qword ptr [rax + __anon_2]
        mov	rcx, qword ptr [rax + __anon_3]
        add	rcx, rdi
        shl	r9, 4
        add	rdi, r9
        add	rdi, 16
        jmp	system_data.publishOnChange

