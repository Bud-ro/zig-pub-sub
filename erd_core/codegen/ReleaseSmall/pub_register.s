; snapshot_comments.zig
; Speed: Near-optimal | Size: Optimal
;
pub_register:
        push	r14
        push	rbx
        push	rax
        mov	rbx, rsi
        mov	r14, rdi
        mov	qword ptr [rsi], offset .Lcodegen_harness.pubSendShim
        add	r14, 64
        mov	ecx, offset ".Lexternal_data_component.ExternalDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..6]).makeCallback__anon_0__struct_1.cb"
        mov	rdi, r14
        xor	esi, esi
        mov	rdx, rbx
        call	".Ldata_component_subscription.DataComponentSubscription(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..6]).subscribeInner"
        push	1
        pop	rsi
        mov	ecx, offset ".Lexternal_data_component.ExternalDataComponent(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..6]).makeCallback__anon_2__struct_3.cb"
        mov	rdi, r14
        mov	rdx, rbx
        add	rsp, 8
        pop	rbx
        pop	r14
        jmp	".Ldata_component_subscription.DataComponentSubscription(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..6]).subscribeInner"

; --- called functions ---

".Ldata_component_subscription.DataComponentSubscription(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..6]).subscribeInner":
        shl	rsi, 4
        add	rdi, rsi
        mov	esi, 1
        jmp	.LSubscription.subscribe

