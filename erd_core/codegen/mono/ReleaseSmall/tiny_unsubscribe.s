; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 6 calls)
;
tiny_unsubscribe:
        add	rdi, 16
        jmp	".Ldata_component_subscription.DataComponentSubscription(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).unsubscribeInner"

; --- called functions ---

".Ldata_component_subscription.DataComponentSubscription(&.{ .{ ... }, .{ ... }, .{ ... } }[0..3]).unsubscribeInner":
        mov	esi, 1
        jmp	.LSubscription.unsubscribe

