; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
; After the first write's publish call, LLVM reloads the stored
; flag value before comparing for the second write. It cannot
; prove publish did not mutate the flag through the opaque
; publisher pointer. Same root cause as double_write_same_value.
;
double_write_diff_values:
        push	rbx
        sub	rsp, 16
        mov	rbx, rdi
        mov	byte ptr [rsp + 12], 1
        mov	al, 1
        cmp	byte ptr [rdi + 4], 1
        mov	byte ptr [rdi + 4], 1
        jne	.L0
        mov	byte ptr [rsp + 13], 0
        mov	byte ptr [rbx + 4], 0
        cmp	al, 0
        jne	.L1
.L2:
        add	rsp, 16
        pop	rbx
        ret
.L0:
        lea	rdx, [rsp + 12]
        mov	rdi, rbx
        mov	esi, 1
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish.2"
        movzx	eax, byte ptr [rbx + 4]
        mov	byte ptr [rsp + 13], 0
        mov	byte ptr [rbx + 4], 0
        cmp	al, 0
        je	.L2
.L1:
        lea	rdx, [rsp + 13]
        mov	rdi, rbx
        mov	esi, 1
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish.2"
        add	rsp, 16
        pop	rbx
        ret

; --- called functions ---

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).publish.2":
        mov	r8, rcx
        mov	rcx, rdx
        movzx	eax, si
        mov	rdx, qword ptr [8*rax + __anon_3]
        movzx	esi, byte ptr [rax + __anon_4]
        shl	rdx, 4
        add	rdi, rdx
        add	rdi, 16
        movzx	edx, word ptr [rax + rax + __anon_5]
        jmp	Subscription.publish

