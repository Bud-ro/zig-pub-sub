tiny_subscribe:
        add	rdi, 16
        jmp	".Ldata_component_subscription.DataComponentSubscription(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).subscribeInner"

; --- called functions ---

".Ldata_component_subscription.DataComponentSubscription(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).subscribeInner":
        mov	esi, 1
        jmp	.LSubscription.subscribe

