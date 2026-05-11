subscribe_callback:
        add	rdi, 16
        jmp	"data_component_subscription.DataComponentSubscription(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).subscribeInner"

; --- called functions ---

"data_component_subscription.DataComponentSubscription(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..4]).subscribeInner":
        mov	rax, qword ptr [rdi + 8]
        cmp	rax, offset codegen_harness.accumulate_callback
        je	.LBB315_3
        test	rax, rax
        jne	.LBB315_4
        mov	qword ptr [rdi], 0
        mov	qword ptr [rdi + 8], offset codegen_harness.accumulate_callback
.LBB315_3:
        ret
.LBB315_4:
        push	rax
        mov	edi, offset __anon_0
        mov	esi, 19
        call	debug.defaultPanic

