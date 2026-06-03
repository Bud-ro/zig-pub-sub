; snapshot_comments.zig
; Speed: Optimal | Size: Optimal (until 6 calls)
;
wide_unsubscribe:
        add	rdi, 72
        jmp	"data_component_subscription.DataComponentSubscription(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).unsubscribeInner"

; --- called functions ---

"data_component_subscription.DataComponentSubscription(&.{ .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... }, .{ ... } }[0..17]).unsubscribeInner":
        add	rdi, 16
        mov	esi, 2
        jmp	Subscription.unsubscribe

