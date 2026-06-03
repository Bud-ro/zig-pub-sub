; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 6 calls)
;
wide_subscribe:
        add	rdi, 72
        jmp	".Ldata_component_subscription.DataComponentSubscription(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).subscribeInner"

; --- called functions ---

".Ldata_component_subscription.DataComponentSubscription(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).subscribeInner":
        add	rdi, 16
        mov	esi, 2
        jmp	.LSubscription.subscribe

