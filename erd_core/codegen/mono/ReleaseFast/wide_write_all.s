; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 2 calls)
;
wide_write_all:
        push	rbx
        sub	rsp, 16
        mov	rbx, rdi
        mov	byte ptr [rsp], 1
        cmp	byte ptr [rdi], 1
        mov	byte ptr [rdi], 1
        je	.L0
        mov	rdx, rsp
        mov	rdi, rbx
        xor	esi, esi
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.L0:
        mov	word ptr [rbx + 1], 2
        mov	dword ptr [rsp], 3
        cmp	dword ptr [rbx + 3], 3
        mov	dword ptr [rbx + 3], 3
        je	.L1
        mov	rdx, rsp
        mov	rdi, rbx
        mov	esi, 2
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.L1:
        mov	qword ptr [rbx + 7], 4
        mov	byte ptr [rbx + 15], 5
        mov	word ptr [rsp], 6
        cmp	word ptr [rbx + 16], 6
        mov	word ptr [rbx + 16], 6
        je	.L2
        mov	rdx, rsp
        mov	rdi, rbx
        mov	esi, 5
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.L2:
        mov	dword ptr [rbx + 18], 7
        mov	qword ptr [rsp], 8
        cmp	qword ptr [rbx + 22], 8
        mov	qword ptr [rbx + 22], 8
        je	.L3
        mov	rdx, rsp
        mov	rdi, rbx
        mov	esi, 7
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.L3:
        mov	byte ptr [rbx + 30], 1
        mov	byte ptr [rsp], 9
        cmp	byte ptr [rbx + 31], 9
        mov	byte ptr [rbx + 31], 9
        je	.L4
        mov	rdx, rsp
        mov	rdi, rbx
        mov	esi, 9
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.L4:
        mov	word ptr [rbx + 32], 10
        mov	dword ptr [rsp], 11
        cmp	dword ptr [rbx + 34], 11
        mov	dword ptr [rbx + 34], 11
        je	.L5
        mov	rdx, rsp
        mov	rdi, rbx
        mov	esi, 11
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.L5:
        mov	qword ptr [rbx + 38], 12
        mov	dword ptr [rsp], 13
        cmp	dword ptr [rbx + 46], 13
        mov	dword ptr [rbx + 46], 13
        je	.L6
        mov	rdx, rsp
        mov	rdi, rbx
        mov	esi, 13
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.L6:
        mov	byte ptr [rbx + 50], 0
        mov	dword ptr [rsp], 14
        cmp	dword ptr [rbx + 51], 14
        mov	dword ptr [rbx + 51], 14
        je	.L7
        mov	rdx, rsp
        mov	rdi, rbx
        mov	esi, 15
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.L7:
        add	rsp, 16
        pop	rbx
        ret

; --- called functions ---

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish":
        mov	r8, rcx
        mov	rcx, rdx
        movzx	eax, si
        mov	rdx, qword ptr [8*rax + __anon_8]
        movzx	esi, byte ptr [rax + __anon_9]
        shl	rdx, 4
        add	rdi, rdx
        add	rdi, 64
        movzx	edx, word ptr [rax + rax + __anon_10]
        jmp	Subscription.publish

