wide_write_all:
        push	rbx
        sub	rsp, 16
        mov	rbx, rdi
        mov	al, 1
        mov	byte ptr [rsp], al
        cmp	byte ptr [rdi], al
        mov	byte ptr [rdi], al
        je	.LBB292_2
        mov	rdx, rsp
        mov	rdi, rbx
        xor	esi, esi
        mov	rcx, rbx
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.LBB292_2:
        mov	word ptr [rbx + 1], 2
        push	3
        pop	rax
        mov	dword ptr [rsp], eax
        cmp	dword ptr [rbx + 3], eax
        mov	dword ptr [rbx + 3], eax
        je	.LBB292_4
        push	2
        pop	rsi
        mov	rdx, rsp
        mov	rdi, rbx
        mov	rcx, rbx
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.LBB292_4:
        mov	qword ptr [rbx + 7], 4
        mov	byte ptr [rbx + 15], 5
        mov	ax, 6
        mov	word ptr [rsp], ax
        cmp	word ptr [rbx + 16], ax
        mov	word ptr [rbx + 16], ax
        je	.LBB292_6
        push	5
        pop	rsi
        mov	rdx, rsp
        mov	rdi, rbx
        mov	rcx, rbx
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.LBB292_6:
        mov	dword ptr [rbx + 18], 7
        push	8
        pop	rax
        mov	qword ptr [rsp], rax
        cmp	qword ptr [rbx + 22], rax
        mov	qword ptr [rbx + 22], rax
        je	.LBB292_8
        push	7
        pop	rsi
        mov	rdx, rsp
        mov	rdi, rbx
        mov	rcx, rbx
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.LBB292_8:
        mov	byte ptr [rbx + 30], 1
        mov	al, 9
        mov	byte ptr [rsp], al
        cmp	byte ptr [rbx + 31], al
        mov	byte ptr [rbx + 31], al
        je	.LBB292_10
        push	9
        pop	rsi
        mov	rdx, rsp
        mov	rdi, rbx
        mov	rcx, rbx
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.LBB292_10:
        mov	word ptr [rbx + 32], 10
        push	11
        pop	rax
        mov	dword ptr [rsp], eax
        cmp	dword ptr [rbx + 34], eax
        mov	dword ptr [rbx + 34], eax
        je	.LBB292_12
        push	11
        pop	rsi
        mov	rdx, rsp
        mov	rdi, rbx
        mov	rcx, rbx
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.LBB292_12:
        mov	qword ptr [rbx + 38], 12
        push	13
        pop	rax
        mov	dword ptr [rsp], eax
        cmp	dword ptr [rbx + 46], eax
        mov	dword ptr [rbx + 46], eax
        je	.LBB292_14
        push	13
        pop	rsi
        mov	rdx, rsp
        mov	rdi, rbx
        mov	rcx, rbx
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.LBB292_14:
        mov	byte ptr [rbx + 50], 0
        push	14
        pop	rax
        mov	dword ptr [rsp], eax
        cmp	dword ptr [rbx + 51], eax
        mov	dword ptr [rbx + 51], eax
        je	.LBB292_16
        push	15
        pop	rsi
        mov	rdx, rsp
        mov	rdi, rbx
        mov	rcx, rbx
        call	".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish"
.LBB292_16:
        add	rsp, 16
        pop	rbx
        ret

; --- called functions ---

".Lram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).publish":
        mov	r8, rcx
        mov	rcx, rdx
        movzx	eax, si
        mov	rdx, qword ptr [8*rax + .L__anon_0]
        movzx	esi, byte ptr [rax + .L__anon_1]
        shl	rdx, 4
        add	rdi, rdx
        add	rdi, 64
        movzx	edx, word ptr [rax + rax + .L__anon_2]
        jmp	.LSubscription.publish

