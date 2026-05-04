write_medium_with_subs:
        push	rbp
        mov	rbp, rsp
        pop	rbp
        jmp	"system_data.SystemData(codegen_harness.HugeSystem__struct_3758,meta.FieldEnum(codegen_harness.HugeSystem__struct_3758),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },system_data_test_double.create.Components).write__anon_4041"

; --- called functions ---

"system_data.SystemData(codegen_harness.HugeSystem__struct_3758,meta.FieldEnum(codegen_harness.HugeSystem__struct_3758),.{ .big = .{ ... }, .medium = .{ ... }, .small_after_big = .{ ... } },system_data_test_double.create.Components).write__anon_4041":
        push	rbp
        mov	rbp, rsp
        sub	rsp, 32
        mov	rax, qword ptr [rsi + 16]
        mov	qword ptr [rbp - 16], rax
        movups	xmm0, xmmword ptr [rsi]
        movaps	xmmword ptr [rbp - 32], xmm0
        mov	r10, qword ptr [rdi + 256]
        mov	r9, qword ptr [rdi + 264]
        mov	r8d, dword ptr [rdi + 272]
        movzx	edx, word ptr [rdi + 276]
        movzx	ecx, byte ptr [rdi + 278]
        movzx	eax, byte ptr [rdi + 279]
        movups	xmm0, xmmword ptr [rsi]
        mov	r11, qword ptr [rsi + 16]
        mov	qword ptr [rdi + 272], r11
        movups	xmmword ptr [rdi + 256], xmm0
        cmp	r10, qword ptr [rsi]
        jne	.LBB30_6
        cmp	r9, qword ptr [rsi + 8]
        jne	.LBB30_6
        cmp	r8d, dword ptr [rsi + 16]
        jne	.LBB30_6
        cmp	dx, word ptr [rsi + 20]
        jne	.LBB30_6
        cmp	cl, byte ptr [rsi + 22]
        jne	.LBB30_6
        and	al, 1
        cmp	byte ptr [rsi + 23], al
        je	.LBB30_7
.LBB30_6:
        lea	rsi, [rbp - 32]
        mov	rdx, rdi
        call	"ram_data_component.RamDataComponent(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).publish"
.LBB30_7:
        add	rsp, 32
        pop	rbp
        ret

