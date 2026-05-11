subscribe_callback:
        add	rdi, 16
        jmp	".Ldata_component_subscription.DataComponentSubscription(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).subscribeInner"

; --- called functions ---

".Ldata_component_subscription.DataComponentSubscription(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).subscribeInner":
        mov	rax, qword ptr [rdi + 8]
        cmp	rax, offset .Lcodegen_harness.accumulate_callback
        je	.LBB308_3
        test	rax, rax
        jne	.LBB308_4
        mov	qword ptr [rdi], 0
        mov	qword ptr [rdi + 8], offset .Lcodegen_harness.accumulate_callback
.LBB308_3:
        ret
.LBB308_4:
        push	rax
        mov	edi, offset .L__anon_0
        mov	esi, 19
        call	.Ldebug.defaultPanic

