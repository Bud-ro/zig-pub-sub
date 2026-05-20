wide_write_all:
        push	rbx
        sub	rsp, 16
        mov	rbx, rdi
        mov	byte ptr [rsp], 1
        cmp	byte ptr [rdi], 1
        mov	byte ptr [rdi], 1
        je	.LBB302_2
        mov	rdx, rsp
        mov	rdi, rbx
        xor	esi, esi
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.LBB302_2:
        mov	word ptr [rbx + 1], 2
        mov	dword ptr [rsp], 3
        cmp	dword ptr [rbx + 3], 3
        mov	dword ptr [rbx + 3], 3
        je	.LBB302_4
        mov	rdx, rsp
        mov	rdi, rbx
        mov	esi, 2
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.LBB302_4:
        mov	qword ptr [rbx + 7], 4
        mov	byte ptr [rbx + 15], 5
        mov	word ptr [rsp], 6
        cmp	word ptr [rbx + 16], 6
        mov	word ptr [rbx + 16], 6
        je	.LBB302_6
        mov	rdx, rsp
        mov	rdi, rbx
        mov	esi, 5
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.LBB302_6:
        mov	dword ptr [rbx + 18], 7
        mov	qword ptr [rsp], 8
        cmp	qword ptr [rbx + 22], 8
        mov	qword ptr [rbx + 22], 8
        je	.LBB302_8
        mov	rdx, rsp
        mov	rdi, rbx
        mov	esi, 7
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.LBB302_8:
        mov	byte ptr [rbx + 30], 1
        mov	byte ptr [rsp], 9
        cmp	byte ptr [rbx + 31], 9
        mov	byte ptr [rbx + 31], 9
        je	.LBB302_10
        mov	rdx, rsp
        mov	rdi, rbx
        mov	esi, 9
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.LBB302_10:
        mov	word ptr [rbx + 32], 10
        mov	dword ptr [rsp], 11
        cmp	dword ptr [rbx + 34], 11
        mov	dword ptr [rbx + 34], 11
        je	.LBB302_12
        mov	rdx, rsp
        mov	rdi, rbx
        mov	esi, 11
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.LBB302_12:
        mov	qword ptr [rbx + 38], 12
        mov	dword ptr [rsp], 13
        cmp	dword ptr [rbx + 46], 13
        mov	dword ptr [rbx + 46], 13
        je	.LBB302_14
        mov	rdx, rsp
        mov	rdi, rbx
        mov	esi, 13
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.LBB302_14:
        mov	byte ptr [rbx + 50], 0
        mov	dword ptr [rsp], 14
        cmp	dword ptr [rbx + 51], 14
        mov	dword ptr [rbx + 51], 14
        je	.LBB302_16
        mov	rdx, rsp
        mov	rdi, rbx
        mov	esi, 15
        mov	rcx, rbx
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.LBB302_16:
        add	rsp, 16
        pop	rbx
        ret

; --- called functions ---

"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish":
        mov	r8, rcx
        mov	rcx, rdx
        movzx	eax, si
        mov	rdx, qword ptr [8*rax + __anon_0]
        movzx	esi, byte ptr [rax + __anon_1]
        shl	rdx, 4
        add	rdi, rdx
        add	rdi, 64
        movzx	edx, word ptr [rax + rax + __anon_2]
        jmp	Subscription.publish

